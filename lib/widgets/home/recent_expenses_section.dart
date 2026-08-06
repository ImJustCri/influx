import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/app_container.dart';
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

        if (expenses.isEmpty)
          AppContainer(
            padding: EdgeInsetsGeometry.all(48),
            width: double.infinity,
            child: Column(
              children: [
                Icon(LucideIcons.book_search, size: 32),
                SizedBox(height: 24),
                Text("Niente da vedere quì", style: AppTypography.containerTitle, textAlign: TextAlign.center),
                SizedBox(height: 4),
                Text("Che ne dici di aggiungere una nuova spesa?", style: AppTypography.containerBody, textAlign: TextAlign.center),
              ],
            ),
          )
        else
          Text("Ultime spese", style: AppTypography.containerBody),
            ...expenses.map(
                (expense) => ExpenseItem(
                  categoryColor: expense.categoryColor,
                  categoryIcon: expense.categoryIcon,
                  categoryName: expense.categoryName,
                  title: expense.title,
                  amount: expense.amount,
                  purchaseDate: expense.purchaseDate,
                  description: expense.description,
                  groupName: expense.groupName,
                  expenseId: expense.id,
                  categoryId: expense.categoryId,
            ),
          ),
      ],
    );
  }
}
