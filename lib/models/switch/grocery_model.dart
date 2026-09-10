class GroceryProduct {
  final String barcode;
  final String name;
  final String brand;
  final String imageUrl;
  final double? price;
  final double? nutriscore; // 0-100, lower is better
  final String? ecoscore; // 'a', 'b', 'c', 'd', 'e'
  final String? category;
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
    this.alternatives = const [],
    this.ecoAlternatives = const [],
  });

  factory GroceryProduct.fromJson(Map<String, dynamic> json) {
    return GroceryProduct(
      barcode: json['code'] ?? '',
      name: json['product_name'] ?? 'Unknown Product',
      brand: json['brands'] ?? 'Unknown Brand',
      imageUrl: json['image_url'] ?? '',
      price: _parsePrice(json['prices']),
      nutriscore: _parseNutriscore(json['nutrition_grades']),
      ecoscore: _parseEcoscore(json['ecoscore_grade']),
      category: json['categories'] ?? '',
    );
  }

  static double? _parsePrice(dynamic prices) {
    if (prices == null) return null;
    try {
      return double.parse(prices.toString());
    } catch (_) {
      return null;
    }
  }

  static double? _parseNutriscore(String? grade) {
    if (grade == null) return null;
    final gradeMap = {'a': 20, 'b': 40, 'c': 60, 'd': 80, 'e': 100};
    return gradeMap[grade.toLowerCase()]?.toDouble();
  }

  static String? _parseEcoscore(dynamic grade) {
    if (grade == null || grade.toString().isEmpty) return null;
    final cleanGrade = grade.toString().toLowerCase().trim();
    if (['a', 'b', 'c', 'd', 'e'].contains(cleanGrade)) {
      return cleanGrade;
    }
    return null;
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