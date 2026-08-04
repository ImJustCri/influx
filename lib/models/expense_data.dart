class ExpenseData {
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
    required this.categoryIcon,
    required this.categoryName,
    required this.categoryColor,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
    this.groupName,
  });


  factory ExpenseData.convertJson(Map<String,dynamic> item){
    return ExpenseData(
      categoryName: item['category']['name'],
      categoryColor: item['category']['color'],
      categoryIcon: item['category']['icon'],
      title: item['name'],
      amount: item['amount'],
      purchaseDate: DateTime.parse(item['created_at']),
      description: item['description'],
      groupName: item['group'] != null ? item['group']['name'] : null,
    );
  }

}