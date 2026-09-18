import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../models/switch/station_model.dart';
import '../../providers/preferences/comune_provider.dart';
import '../../services/fuel_service.dart';
import '../../widgets/switch/Fuel/fuel_search_bar.dart';
import '../../widgets/switch/Fuel/station_card.dart';
import '../../widgets/app_container.dart';

class FuelPage extends ConsumerStatefulWidget {
  const FuelPage({super.key});

  @override
  ConsumerState<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends ConsumerState<FuelPage> {
  final FuelService _fuelService = FuelService();
  final Map<String, Station> _stationsMap = {};
  List<Station> _filteredStations = [];
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  int _resultCount = 0;
  bool _hasInitialComuneApplied = false;
  DateTime? _lastUpdated;

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
    _fuelService.dispose();
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

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _fuelService.loadData(
        onCacheLoaded: (cachedResult) {
          if (!mounted) return;
          setState(() {
            _stationsMap
              ..clear()
              ..addAll(cachedResult.stationsMap);
            _isLoading = false;
            _errorMessage = null;
            _lastUpdated = cachedResult.lastUpdated;
          });
          _applyDefaultComune();
          _applyFilter(_searchController.text);
        },
      );

      if (!mounted) return;
      setState(() {
        _stationsMap
          ..clear()
          ..addAll(result.stationsMap);
        _isLoading = false;
        _errorMessage = null;
        _lastUpdated = result.lastUpdated;
      });

      _applyDefaultComune();
      _applyFilter(_searchController.text);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyDefaultComune() {
    if (_hasInitialComuneApplied) return;
    final savedComune = ref.read(comuneProvider).value;
    if (savedComune != null &&
        savedComune != 'Non selezionato' &&
        _searchController.text.isEmpty) {
      _searchController.text = savedComune;
      _hasInitialComuneApplied = true;
    }
  }

  void _applyFilter(String query) {
    setState(() {
      _filteredStations = _fuelService.filterStations(_stationsMap, query);
      _resultCount = _filteredStations.length;
    });
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final lowestPrice = _fuelService.getLowestPetrolPrice(_filteredStations);

    ref.listen(comuneProvider, (previous, next) {
      final comune = next.value;
      if (comune != null &&
          comune != 'Non selezionato' &&
          !_hasInitialComuneApplied &&
          _searchController.text.isEmpty) {
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_searchController.text.trim().isNotEmpty)
                  Text(
                    '$_resultCount risultat${_resultCount != 1 ? 'i' : 'o'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.whiteDim,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (_lastUpdated != null)
                  Text(
                    'Aggiornato: ${_formatDateTime(_lastUpdated!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.whiteDim,
                    ),
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
                separatorBuilder: (_, _) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final station = _filteredStations[index];
                  final petrol = station.petrolPriceSelf ??
                      station.petrolPriceServ ??
                      'N/D';
                  final diesel = station.dieselPriceSelf ??
                      station.dieselPriceServ ??
                      'N/D';
                  final petrolValue = double.tryParse(
                      station.petrolPriceSelf ??
                          station.petrolPriceServ ??
                          '');
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