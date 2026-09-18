import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/switch/station_model.dart';

class FuelDataResult {
  final Map<String, Station> stationsMap;
  final DateTime lastUpdated;

  FuelDataResult({
    required this.stationsMap,
    required this.lastUpdated,
  });
}

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

  /// Update time for the files is 8:00 AM (Italy / CET)
  /// Check if cache is stale
  bool _isCacheStale(DateTime lastModified) {
    final now = DateTime.now();

    final DateTime lastExpectedUpdate;
    if (now.hour >= 8) {
      // If it's 8:00 AM or above, the latest valid update is today, 8:00 AM
      lastExpectedUpdate = DateTime(now.year, now.month, now.day, 8, 0);
    } else {
      // If below 8:00 AM, the latest valid update is yesterday, 8:00 AM
      final yesterday = now.subtract(const Duration(days: 1));
      lastExpectedUpdate = DateTime(yesterday.year, yesterday.month, yesterday.day, 8, 0);
    }

    return lastModified.isBefore(lastExpectedUpdate);
  }

  Future<Map<String, dynamic>?> _readCache() async {
    try {
      final dir = await _cacheDir();
      final pricesFile = File('${dir.path}/fuel_prices_cache.csv');
      final stationsFile = File('${dir.path}/fuel_stations_cache.csv');

      if (!await pricesFile.exists() || !await stationsFile.exists()) return null;

      final lastModified = await pricesFile.lastModified();
      final prices = await pricesFile.readAsString();
      final stations = await stationsFile.readAsString();

      return {
        'prices': prices,
        'stations': stations,
        'stale': _isCacheStale(lastModified),
        'lastModified': lastModified,
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
    } catch (_) {}
  }

  Future<FuelDataResult> loadData({
    required Function(FuelDataResult cachedResult) onCacheLoaded,
  }) async {
    final cached = await _readCache();

    if (cached != null) {
      final Map<String, String> csvData = {
        'prices': cached['prices'] as String,
        'stations': cached['stations'] as String,
      };

      final stationsMap = await compute(_parseStationsIsolate, csvData);
      final lastModified = cached['lastModified'] as DateTime;

      final cachedResult = FuelDataResult(
        stationsMap: stationsMap,
        lastUpdated: lastModified,
      );

      onCacheLoaded(cachedResult);

      if (cached['stale'] == true) {
        return await fetchAndProcessData();
      }
      return cachedResult;
    } else {
      return await fetchAndProcessData();
    }
  }

  Future<FuelDataResult> fetchAndProcessData() async {
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

      final now = DateTime.now();
      await _writeCache(priceCsvRaw, stationCsvRaw);

      return FuelDataResult(
        stationsMap: stationsMap,
        lastUpdated: now,
      );
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