  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
  import 'package:intl/intl.dart';
  import 'package:influx/theme.dart';
  import 'package:influx/widgets/page_padding.dart';
  import '../../models/expense_data.dart';
  import '../../providers/expenses_provider.dart';
  import '../../widgets/expenses/expense_item.dart';

  class CategoryExpensesPage extends ConsumerWidget {
    final String categoryId;
    final String? categoryName;

    const CategoryExpensesPage({
      super.key,
      required this.categoryId,
      this.categoryName,
    });

    /// helper function to group expenses by formatted date string
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
    Widget build(BuildContext context, WidgetRef ref) {
      final expensesAsync = ref.watch(fetchExpensesByCategory(categoryId));

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: PagePadding(
          child: expensesAsync.when(
            data: (expenses) {
              if (expenses.isEmpty) {
                return const Center(
                  child: Text('Nessuna spesa trovata.'),
                );
              }


              final groupedExpenses = _groupExpensesByDate(expenses);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(categoryName ?? 'Altro', style: AppTypography.pageTitle),
                    Text('Spese di questo periodo', style: AppTypography.pageSubtitle),
                    const SizedBox(height: 24),

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
                                    style: AppTypography.containerTitle
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
                                    categoryId: categoryId,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      );
    }
  }