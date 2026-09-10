import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/switch/station_model.dart';

const _kCacheMaxAge = Duration(hours: 3);

/// Runs entirely in a background isolate via compute() — never touches
/// the UI thread. Must be top-level (or static) so it can be sent to
/// the isolate as a function pointer.
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

class FuelService {
  final http.Client _httpClient = http.Client();

  void dispose() {
    _httpClient.close();
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

  Future<Map<String, Station>> loadData({
    required Function(Map<String, Station> stationsMap) onCacheLoaded,
  }) async {
    final cached = await _readCache();

    if (cached != null) {
      final stationsMap = await compute(_parseStationsIsolate, cached);
      onCacheLoaded(stationsMap);

      if (cached['stale'] == 'true') {
        return await fetchAndProcessData();
      }
      return stationsMap;
    } else {
      return await fetchAndProcessData();
    }
  }

  Future<Map<String, Station>> fetchAndProcessData() async {
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
      final stationsMap = await compute(_parseStationsIsolate, csvData);
      unawaited(_writeCache(priceCsvRaw, stationCsvRaw));
      return stationsMap;
    } else {
      throw Exception("Impossibile caricare i dati dal server.");
    }
  }

  List<Station> filterStations(Map<String, Station> stationsMap, String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return [];

    final filtered = stationsMap.values.where((station) {
      return station.comune.toLowerCase().contains(cleanQuery) ||
          station.indirizzo.toLowerCase().contains(cleanQuery);
    }).toList();

    filtered.sort((a, b) {
      final priceA = double.tryParse(a.petrolPriceSelf ?? a.petrolPriceServ ?? '');
      final priceB = double.tryParse(b.petrolPriceSelf ?? b.petrolPriceServ ?? '');

      if (priceA == null && priceB == null) return 0;
      if (priceA == null) return 1;
      if (priceB == null) return -1;

      return priceA.compareTo(priceB);
    });

    return filtered;
  }

  double? getLowestPetrolPrice(List<Station> stations) {
    double? lowest;
    for (final station in stations) {
      final value = double.tryParse(station.petrolPriceSelf ?? station.petrolPriceServ ?? '');
      if (value != null && (lowest == null || value < lowest)) {
        lowest = value;
      }
    }
    return lowest;
  }
}