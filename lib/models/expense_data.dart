import '../widgets/expenses/expense_type_helpers.dart';

class ExpenseData {
  final ExpenseType type;
  final String title;
  final String amount;
  final String description;
  final DateTime purchaseDate;

  const ExpenseData({
    required this.type,
    required this.title,
    required this.amount,
    this.description = '',
    required this.purchaseDate,
  });
}
