import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../models/expense_data.dart';
import '../expenses/all_expenses_page.dart';
import '../expenses/expense_item.dart';
import '../settings_tile.dart';
import '../status_container.dart';

class RecentExpensesSection extends StatefulWidget {
  final List<ExpenseData> expenses;

  const RecentExpensesSection({
    super.key,
    required this.expenses,
  });

  @override
  State<RecentExpensesSection> createState() => _RecentExpensesSectionState();
}

class _RecentExpensesSectionState extends State<RecentExpensesSection> {
  int _limit = 3;

  /// Helper function to group expenses by formatted date string
  Map<String, List<ExpenseData>> _groupExpensesByDate(List<ExpenseData> expenses) {
    final Map<String, List<ExpenseData>> grouped = {};

    for (final expense in expenses) {
      final DateTime date = expense.purchaseDate;
      final String dateHeader = DateFormat('dd MMMM yyyy', 'it_IT').format(date);

      grouped.putIfAbsent(dateHeader, () => []).add(expense);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    // Separate recurring expenses from one-time expenses
    final recurringExpenses = widget.expenses.where((e) => e.isRecurring).toList();
    final nonRecurringExpenses = widget.expenses.where((e) => !e.isRecurring).toList();

    // Limit only the non-recurring recent expenses
    final limitedExpenses = nonRecurringExpenses.take(_limit).toList();
    final groupedExpenses = _groupExpensesByDate(limitedExpenses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.expenses.isEmpty)
          StatusContainer(
            icon: LucideIcons.book_search,
            title: "Niente da vedere qui",
            description: "Che ne dici di aggiungere una nuova spesa?",
          )
        else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ultime spese", style: AppTypography.containerTitle),
              Row(
                spacing: 8,
                children: [3, 5].map((count) {
                  final isSelected = _limit == count;
                  return ChoiceChip(
                    label: Text('$count'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _limit = count;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...groupedExpenses.entries.map((entry) {
            final dateLabel = entry.key;
            final dayExpenses = entry.value;

            return Column(
              children: [
                AppContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          dateLabel,
                          style: AppTypography.containerTitle,
                        ),
                      ),
                      ...dayExpenses.map(
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
                          profileId: Supabase.instance.client.auth.currentUser!.id,
                          isGroupView: false,
                          isRecurring: expense.isRecurring,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),

          if (recurringExpenses.isNotEmpty) ...[
            AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Spese ricorrenti",
                      style: AppTypography.containerTitle,
                    ),
                  ),
                  ...recurringExpenses.map(
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
                      profileId: Supabase.instance.client.auth.currentUser!.id,
                      isGroupView: false,
                      isRecurring: expense.isRecurring,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          SettingsTile(
            icon: LucideIcons.list_collapse,
            title: "Vedi di più",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllExpensesPage(isGroupView: false),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}