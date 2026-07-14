import '../widgets/expenses/expense_type_helpers.dart';

class ExpenseData {
  final ExpenseType type;
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
}