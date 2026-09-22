import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/switch/grocery_model.dart';

/// Thrown when Open Food Facts responds 429 (too many requests in a minute)
class OpenFoodFactsRateLimitException implements Exception {
  const OpenFoodFactsRateLimitException();
  @override
  String toString() => 'Troppe richieste a Open Food Facts. Riprova tra qualche istante.';
}

class OpenFoodFactsServiceException implements Exception {
  final String reason;
  const OpenFoodFactsServiceException(this.reason);
  @override
  String toString() => 'Richiesta ad Open Food Facts fallita: $reason';
}

class GroceriesService {
  static const Map<String, String> _headers = {
    'User-Agent': 'YourAppName - Android/iOS - Version 1.0.0 (contact@yourdomain.com)',
    'Accept': 'application/json',
  };

  static const String _productBaseUrl = 'https://world.openfoodfacts.org/api/v3';

  static const String _searchBaseUrl = 'https://search.openfoodfacts.org/search';

  static const String _searchFields =
      'code,product_name,brands,image_url,categories_tags,ecoscore_grade,'
      'ecoscore_score,nutrition_grades,quantity';

  // Barcodes are 8-14 digits. So this assesses if a string is a barcode
  static final RegExp _barcodePattern = RegExp(r'^\d{8,14}$');
  static bool looksLikeBarcode(String query) => _barcodePattern.hasMatch(query.trim());

  /// GET with a couple of retries for transient failures
  static Future<http.Response> _getWithRetry(
      Uri url, {
        int maxAttempts = 3,
      }) async {
    Object? lastError;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response =
        await http.get(url, headers: _headers).timeout(const Duration(seconds: 10));

        if (response.statusCode == 429) {
          throw const OpenFoodFactsRateLimitException();
        }
        if (response.statusCode == 200) {
          return response;
        }
        // 5xx (and anything else unexpected) — worth a retry.
        lastError = 'HTTP ${response.statusCode}';
      } on OpenFoodFactsRateLimitException {
        rethrow;
      } on TimeoutException catch (e) {
        lastError = e;
      } catch (e) {
        lastError = e;
      }

      if (attempt < maxAttempts) {
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      }
    }

    throw OpenFoodFactsServiceException(lastError.toString());
  }

  /// Fetch a product directly by its barcode number.
  static Future<GroceryProduct?> searchByBarcode(String barcode) async {
    final cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) return null;

    final url = Uri.parse('$_productBaseUrl/product/$cleanBarcode');
    final response = await _getWithRetry(url);

    final Map<String, dynamic> json = jsonDecode(response.body);
    final hasProduct = json['product'] != null;
    final hasNoErrors = (json['errors'] as List?)?.isEmpty ?? true;

    if (hasProduct && hasNoErrors) {
      return GroceryProduct.fromJson(json['product'] as Map<String, dynamic>);
    }
    return null;
  }

  /// Search for products by name or keyword, ranked by text relevance.
  static Future<List<GroceryProduct>> searchByKeyword(
      String query, {
        int pageSize = 20,
      }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    final url = Uri.parse(_searchBaseUrl).replace(queryParameters: {
      'q': cleanQuery,
      'page_size': '$pageSize',
      'fields': _searchFields,
      'boost_phrase': 'true',
    });

    final response = await _getWithRetry(url);
    final Map<String, dynamic> json = jsonDecode(response.body);
    final List hits = json['hits'] ?? [];
    return hits.map((p) => GroceryProduct.fromJson(p as Map<String, dynamic>)).toList();
  }

  /// Fetch eco-friendlier alternatives for a product
  static Future<List<GroceryProduct>> getEcoFriendlyAlternatives(
      GroceryProduct product, {
        int maxResults = 20,
      }) async {
    final categoryTag = _bestCategoryTag(product);
    if (categoryTag == null) return [];

    final query = 'categories_tags:"$categoryTag" ecoscore_score:[* TO *]';
    final url = Uri.parse(_searchBaseUrl).replace(queryParameters: {
      'q': query,
      'page_size': '${maxResults + 5}',
      'fields': _searchFields,
      'sort_by': '-ecoscore_score',
    });

    final response = await _getWithRetry(url);
    final Map<String, dynamic> json = jsonDecode(response.body);
    final List hits = json['hits'] ?? [];
    final rawProducts = hits.map((p) => GroceryProduct.fromJson(p as Map<String, dynamic>)).toList();

    final alternatives = rawProducts
        .where((p) =>
    p.barcode != product.barcode &&
        p.ecoscore != null &&
        p.ecoRank > product.ecoRank)
        .toList()
      ..sort((a, b) => b.ecoRank.compareTo(a.ecoRank));

    return alternatives.take(maxResults).toList();
  }

  static String? _bestCategoryTag(GroceryProduct product) {
    if (product.categoriesTags != null && product.categoriesTags!.isNotEmpty) {
      return product.categoriesTags!.last;
    }
    return null;
  }
}