class GroceryProduct {
  final String barcode;
  final String name;
  final String brand;
  final String imageUrl;
  final double? price;
  final double? nutriscore; // 0-100, lower is better
  final String? ecoscore; // 'a', 'b', 'c', 'd', 'e'
  final String? category;
  final List<String>? categoriesTags;
  final List<GroceryProduct> alternatives;
  final List<GroceryProduct> ecoAlternatives;

  GroceryProduct({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.imageUrl,
    this.price,
    this.nutriscore,
    this.ecoscore,
    this.category,
    this.categoriesTags,
    this.alternatives = const [],
    this.ecoAlternatives = const [],
  });

  factory GroceryProduct.fromJson(Map<String, dynamic> json) {
    return GroceryProduct(
      barcode: _asString(json['code']),
      name: _asString(json['product_name'], fallback: 'Unknown Product'),
      brand: _asString(json['brands'], fallback: 'Unknown Brand'),
      imageUrl: _asString(json['image_url']),
      price: _parsePrice(json['prices']),
      nutriscore: _parseNutriscore(_asString(json['nutrition_grades'])),
      ecoscore: _parseEcoscore(json['ecoscore_grade']),
      category: _asString(json['categories']),
      categoriesTags: _parseCategoriesTags(json['categories_tags']),
    );
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    if (value is String) return value;

    // if value is list join all values with commas
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).join(', ');
    }
    // then turn it to string
    return value.toString();
  }

  static double? _parsePrice(dynamic prices) {
    if (prices == null) return null;
    try {
      return double.parse(prices.toString());
    } catch (_) {
      return null;
    }
  }

  static double? _parseNutriscore(String grade) {
    if (grade.isEmpty) return null;
    final gradeMap = {'a': 20, 'b': 40, 'c': 60, 'd': 80, 'e': 100};
    return gradeMap[grade.toLowerCase()]?.toDouble();
  }

  static String? _parseEcoscore(dynamic grade) {
    if (grade == null || grade.toString().isEmpty) return null;
    final cleanGrade = _asString(grade).toLowerCase().trim();
    if (['a', 'b', 'c', 'd', 'e'].contains(cleanGrade)) {
      return cleanGrade;
    }
    return null;
  }

  static List<String>? _parseCategoriesTags(dynamic tags) {
    if (tags == null) return null;
    if (tags is! List) return null;
    final parsed = tags.map((t) => t.toString()).where((t) => t.isNotEmpty).toList();
    return parsed.isEmpty ? null : parsed;
  }

  /// Returns numeric rank for eco comparison (Higher is eco-friendlier)
  int get ecoRank {
    switch (ecoscore?.toLowerCase()) {
      case 'a':
        return 5;
      case 'b':
        return 4;
      case 'c':
        return 3;
      case 'd':
        return 2;
      case 'e':
        return 1;
      default:
        return 0;
    }
  }
}