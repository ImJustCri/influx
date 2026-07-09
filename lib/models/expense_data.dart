import 'package:influx/widgets/expenses/expense_item.dart';

class ExpenseData {
  final ExpenseType type;
  final String title;
  final String amount;

  const ExpenseData({
    required this.type,
    required this.title,
    required this.amount,
  });
}
