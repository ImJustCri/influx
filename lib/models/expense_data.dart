import 'dart:convert';

import 'package:influx/models/category.dart';

import '../widgets/expenses/expense_type_helpers.dart';

class ExpenseData {
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final String title;
  final double amount;
  final DateTime purchaseDate;
  final String? description;

  double get numericAmount => amount;

  const ExpenseData({
    required this.categoryIcon,
    required this.categoryName,
    required this.categoryColor,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
  });


  factory ExpenseData.convertJson(Map<String,dynamic> item){
    return ExpenseData(
        categoryName: item['category']['name'],
        categoryColor: item['category']['color'],
        categoryIcon: item['category']['icon'],
        title: item['name'],
        amount: item['amount'],
        purchaseDate: DateTime.parse(item['created_at']),
    );
  }

}