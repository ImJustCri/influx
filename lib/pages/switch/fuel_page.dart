import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../models/switch/station_model.dart';
import '../../providers/preferences/comune_provider.dart';
import '../../widgets/switch/Fuel/fuel_search_bar.dart';
import '../../widgets/switch/Fuel/station_card.dart';
import '../../widgets/app_container.dart';

const _kCacheMaxAge = Duration(hours: 3);

/// Runs entirely in a background isolate via compute() — never touches
/// the UI thread. Must be top-level (or static) so it can be sent to
/// the isolate as a function pointer. Uses the same csv.decode(...) call
/// the original file used — just relocated off the main isolate.
Map<String, Station> _parseStationsIsolate(Map<String, String> csvData) {
  final List<List<dynamic>> stationRows = csv.decode(csvData['stations']!);
  final List<List<dynamic>> priceRows = csv.decode(csvData['prices']!);

  final Map<String, Station> stationsMap = {};

  for (int i = 1; i < stationRows.length; i++) {
    final row = stationRows[i];
    if (row.length < 7) continue;

    final id = row[0].toString().trim();
    if (id.isEmpty) continue;

    stationsMap[id] = Station(
      id: id,
      gestore: row[1].toString(),
      bandiera: row[2].toString(),
      nome: row[4].toString(),
      indirizzo: row[5].toString(),
      comune: row[6].toString(),
      provincia: row.length > 7 ? row[7].toString() : '',
    );
  }

  for (int i = 1; i < priceRows.length; i++) {
    final row = priceRows[i];
    if (row.length < 4) continue;

    final id = row[0].toString().trim();
    final station = stationsMap[id];
    if (station == null) continue;

    final fuelType = row[1].toString().toLowerCase();
    final price = row[2].toString();
    final isSelf = row[3].toString() == '1';

    if (fuelType.contains('benzina')) {
      if (isSelf) {
        station.petrolPriceSelf = price;
      } else {
        station.petrolPriceServ = price;
      }
    } else if (fuelType.contains('gasolio')) {
      if (isSelf) {
        station.dieselPriceSelf = price;
      } else {
        station.dieselPriceServ = price;
      }
    }
  }

  return stationsMap;
}

class FuelPage extends ConsumerStatefulWidget {
  const FuelPage({super.key});

  @override
  ConsumerState<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends ConsumerState<FuelPage> {
  final Map<String, Station> _stationsMap = {};
  List<Station> _filteredStations = [];
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  int _resultCount = 0;
  bool _hasInitialComuneApplied = false;

  final http.Client _httpClient = http.Client();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _httpClient.close();
    super.dispose();
  }

  Future<void> _launchMimitUrl() async {
    final Uri url = Uri.parse('https://www.mimit.gov.it');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _applyFilter(_searchController.text);
    });
  }

  Future<Directory> _cacheDir() => getApplicationSupportDirectory();

  Future<Map<String, String>?> _readCache() async {
    try {
      final dir = await _cacheDir();
      final pricesFile = File('${dir.path}/fuel_prices_cache.csv');
      final stationsFile = File('${dir.path}/fuel_stations_cache.csv');

      if (!await pricesFile.exists() || !await stationsFile.exists()) return null;

      final age = DateTime.now().difference(await pricesFile.lastModified());
      final prices = await pricesFile.readAsString();
      final stations = await stationsFile.readAsString();

      return {
        'prices': prices,
        'stations': stations,
        'stale': (age > _kCacheMaxAge).toString(),
      };
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(String prices, String stations) async {
    try {
      final dir = await _cacheDir();
      await File('${dir.path}/fuel_prices_cache.csv').writeAsString(prices);
      await File('${dir.path}/fuel_stations_cache.csv').writeAsString(stations);
    } catch (_) {
    }
  }

  Future<void> _loadData() async {
    final cached = await _readCache();

    if (cached != null) {
      await _applyParsedData(cached, showSpinner: false);
      if (cached['stale'] == 'true') {
        unawaited(_fetchAndProcessData(showSpinner: false));
      }
    } else {
      await _fetchAndProcessData(showSpinner: true);
    }
  }

  Future<void> _applyParsedData(Map<String, String> csvData, {required bool showSpinner}) async {
    if (showSpinner && mounted) {
      setState(() => _isLoading = true);
    }

    final stationsMap = await compute(_parseStationsIsolate, csvData);

    if (!mounted) return;
    setState(() {
      _stationsMap
        ..clear()
        ..addAll(stationsMap);
      _isLoading = false;
      _errorMessage = null;
    });

    _applyDefaultComune();
    _applyFilter(_searchController.text);
  }

  Future<void> _fetchAndProcessData({required bool showSpinner}) async {
    if (showSpinner && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final pricesUrl = Uri.parse("https://www.mimit.gov.it/images/exportCSV/prezzo_alle_8.csv");
      final stationUrl = Uri.parse("https://www.mimit.gov.it/images/exportCSV/anagrafica_impianti_attivi.csv");

      final responses = await Future.wait([
        _httpClient.get(pricesUrl).timeout(const Duration(seconds: 15)),
        _httpClient.get(stationUrl).timeout(const Duration(seconds: 15)),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final priceCsvRaw = utf8.decode(responses[0].bodyBytes);
        final stationCsvRaw = utf8.decode(responses[1].bodyBytes);

        final csvData = {'prices': priceCsvRaw, 'stations': stationCsvRaw};
        await _applyParsedData(csvData, showSpinner: showSpinner);
        unawaited(_writeCache(priceCsvRaw, stationCsvRaw));
      } else if (showSpinner && mounted) {
        setState(() {
          _errorMessage = "Impossibile caricare i dati dal server.";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (showSpinner && mounted) {
        setState(() {
          _errorMessage = "Errore: ${e.toString()}";
          _isLoading = false;
        });
      }
    }
  }

  void _applyDefaultComune() {
    if (_hasInitialComuneApplied) return;
    final savedComune = ref.read(comuneProvider).value;
    if (savedComune != null && savedComune != 'Non selezionato' && _searchController.text.isEmpty) {
      _searchController.text = savedComune;
      _hasInitialComuneApplied = true;
    }
  }

  void _applyFilter(String query) {
    final cleanQuery = query.trim().toLowerCase();
    setState(() {
      if (cleanQuery.isEmpty) {
        _filteredStations = [];
        _resultCount = 0;
      } else {
        _filteredStations = _stationsMap.values.where((station) {
          return station.comune.toLowerCase().contains(cleanQuery) ||
              station.indirizzo.toLowerCase().contains(cleanQuery);
        }).toList();

        _filteredStations.sort((a, b) {
          final priceA = double.tryParse(a.petrolPriceSelf ?? a.petrolPriceServ ?? '');
          final priceB = double.tryParse(b.petrolPriceSelf ?? b.petrolPriceServ ?? '');

          if (priceA == null && priceB == null) return 0;
          if (priceA == null) return 1;
          if (priceB == null) return -1;

          return priceA.compareTo(priceB);
        });

        _resultCount = _filteredStations.length;
      }
    });
  }

  double? get _lowestPetrolPrice {
    double? lowest;
    for (final station in _filteredStations) {
      final value = double.tryParse(station.petrolPriceSelf ?? station.petrolPriceServ ?? '');
      if (value != null && (lowest == null || value < lowest)) {
        lowest = value;
      }
    }
    return lowest;
  }

  @override
  Widget build(BuildContext context) {
    final lowestPrice = _lowestPetrolPrice;

    ref.listen(comuneProvider, (previous, next) {
      final comune = next.value;
      if (comune != null && comune != 'Non selezionato' && !_hasInitialComuneApplied && _searchController.text.isEmpty) {
        _searchController.text = comune;
        _hasInitialComuneApplied = true;
        _applyFilter(comune);
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: PagePadding(
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
            FuelSearchBar(
              controller: _searchController,
              onClear: () {
                _searchController.clear();
                _applyFilter('');
              },
            ),
            const SizedBox(height: 16),
            AppContainer(
              width: double.infinity,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.containerBody.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(text: 'Dati forniti da  '),
                    TextSpan(
                      text: 'MIMIT',
                      style: TextStyle(
                        color: AppColors.btnBackground,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _launchMimitUrl,
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 8), DO NOT UNCOMMENT THESE
            // const ComuneInfoBanner(), DO NOT UNCOMMENT THESE
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_searchController.text.trim().isNotEmpty)
                  Text(
                    '$_resultCount risultat${_resultCount != 1 ? 'i' : 'o'}',
                    style: const TextStyle(fontSize: 12, color: AppColors.whiteDim),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : _searchController.text.trim().isEmpty
                  ? const SizedBox.shrink()
                  : _filteredStations.isEmpty
                  ? const Center(
                child: Text("Nessun distributore trovato."),
              )
                  : ListView.separated(
                itemCount: _filteredStations.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final station = _filteredStations[index];
                  final petrol = station.petrolPriceSelf ??
                      station.petrolPriceServ ??
                      'N/D';
                  final diesel = station.dieselPriceSelf ??
                      station.dieselPriceServ ??
                      'N/D';
                  final petrolValue = double.tryParse(
                      station.petrolPriceSelf ?? station.petrolPriceServ ?? '');
                  final isBestPrice = lowestPrice != null &&
                      petrolValue != null &&
                      petrolValue == lowestPrice;

                  return StationCard(
                    station: station,
                    petrol: petrol,
                    diesel: diesel,
                    isBestPrice: isBestPrice,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}