import 'dart:convert';

import 'package:influx/models/category.dart';

import '../widgets/expenses/expense_type_helpers.dart';

class ExpenseData {
  final CategoryModel type;
  final String title;
  final String amount;
  final DateTime purchaseDate;
  final String? description;

  double get numericAmount => double.tryParse(amount) ?? 0.0;

  const ExpenseData({
    required this.type,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
  });


  factory ExpenseData.convertJson(Map<String,dynamic> item){
    return ExpenseData(
        type: item['category_id'],
        title: item['name'],
        amount: item['amount'],
        purchaseDate: item['created_at']
    );
  }

}