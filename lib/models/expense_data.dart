class ExpenseData {
  final String id;
  final String categoryId;
  final String profileId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final String title;
  final double amount;
  final DateTime purchaseDate;
  final String? description;
  final String? groupName;

  double get numericAmount => amount;

  const ExpenseData({
    required this.id,
    required this.categoryId,
    required this.categoryIcon,
    required this.categoryName,
    required this.categoryColor,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    required this.profileId,
    this.description,
    this.groupName,
  });

  factory ExpenseData.convertJson(Map<String, dynamic> item) {
    // Safely extract single object even if PostgREST returns a List
    final category = item['category'] is List
        ? (item['category'] as List).firstOrNull
        : item['category'];

    final group = item['group'] is List
        ? (item['group'] as List).firstOrNull
        : item['group'];

    final profilo = item['profilo'] is List
        ? (item['profilo'] as List).firstOrNull
        : item['profilo'];

    return ExpenseData(
      id: item['id'] as String,
      categoryId: category != null ? category['id'] as String : '',
      categoryName: category != null ? category['name'] as String : '',
      categoryColor: category != null ? category['color'] as String : '',
      categoryIcon: category != null ? category['icon'] as String : '',
      title: item['name'] as String? ?? '',
      amount: (item['amount'] as num?)?.toDouble() ?? 0.0,
      purchaseDate: DateTime.parse(item['created_at'] as String),
      description: item['description'] as String?,
      groupName: group != null ? group['name'] as String? : null,
      profileId: item['profile_id'],
    );
  }
}