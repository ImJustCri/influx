import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../models/expense_data.dart';
import '../expenses/expense_item.dart';

class RecentExpensesSection extends StatelessWidget {
  final List<ExpenseData> expenses;

  const RecentExpensesSection({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ultime spese", style: AppTypography.containerBody),
        ...expenses.map(
              (expense) => ExpenseItem(
                type: expense.type,
                title: expense.title,
                amount: expense.amount,
                purchaseDate: expense.purchaseDate,
                description: expense.description,
          ),
        ),
      ],
    );
  }
}
