import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/switch/grocery_models.dart';

class GroceriesService {
  static const String _productBaseUrl = 'https://world.openfoodfacts.org/api/v3';

  static const Map<String, String> _headers = {
    'User-Agent': 'YourAppName - Android/iOS - Version 1.0.0 (contact@yourdomain.com)',
    'Accept': 'application/json',
  };

  /// Fetch a product directly by its barcode number
  static Future<GroceryProduct?> searchByBarcode(String barcode) async {
    final cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty) return null;

    try {
      final url = Uri.parse('$_productBaseUrl/product/$cleanBarcode');

      final response = await http.get(url, headers: _headers).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        final bool hasProduct = json['product'] != null;
        final bool hasNoErrors = (json['errors'] as List?)?.isEmpty ?? true;

        if (hasProduct && hasNoErrors) {
          return GroceryProduct.fromJson(json['product'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e, stackTrace) {
      print('Error searching barcode: $e');
      print('Stacktrace: $stackTrace');
      return null;
    }
  }

  /// Search for products by name or keyword
  static Future<List<GroceryProduct>> searchByKeyword(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/cgi/search.pl').replace(
          queryParameters: {
            'search_terms': cleanQuery,
            'json': '1',
            'page_size': '20',
          },
        ),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final products = (json['products'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        return products.map((p) => GroceryProduct.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching keyword: $e');
      return [];
    }
  }

  /// Fetch eco-friendlier alternatives for a product based on its category or name
  static Future<List<GroceryProduct>> getEcoFriendlyAlternatives(
      GroceryProduct product,
      ) async {
    try {
      final searchTerm = (product.category != null && product.category!.isNotEmpty)
          ? product.category!
          : product.name;

      if (searchTerm.isEmpty) return [];

      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/cgi/search.pl').replace(
          queryParameters: {
            'search_terms': searchTerm,
            'json': '1',
            'page_size': '25',
          },
        ),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final rawProducts = (json['products'] as List?)?.cast<Map<String, dynamic>>() ?? [];

        final currentEcoRank = product.ecoRank;

        final ecoAlternatives = rawProducts
            .map((p) => GroceryProduct.fromJson(p))
            .where((p) =>
        p.barcode != product.barcode &&
            p.ecoRank > currentEcoRank &&
            p.ecoscore != null)
            .toList();

        ecoAlternatives.sort((a, b) => b.ecoRank.compareTo(a.ecoRank));
        return ecoAlternatives;
      }
      return [];
    } catch (e) {
      print('Error getting eco-friendly alternatives: $e');
      return [];
    }
  }
}