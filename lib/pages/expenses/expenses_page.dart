import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/expenses/all_expenses_page.dart';

import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';
import '../../models/expense_data.dart';
import '../../theme.dart';
import 'package:influx/providers/expenses_provider.dart';
import '../../widgets/app_container.dart';
import '../../widgets/charts/simple_trend_chart.dart';
import '../../widgets/expenses/expense_category_bar.dart';
import 'category_expenses_page.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => ExpensensState();
}

class ExpensensState extends ConsumerState<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(fetchExpenses);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Le mie spese',
            style: AppTypography.pageTitle,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(fetchExpenses);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: 124,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: PagePadding(
            child: expensesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text(error.toString()),
              ),
              data: (expenses) {
                final double totalSpent = expenses.fold(
                  0.0,
                      (sum, item) => sum + item.numericAmount,
                );

                // Group expenses by categories
                final Map<String, List<ExpenseData>> categories = {};
                for (final expense in expenses) {
                  categories.putIfAbsent(
                    expense.categoryName,
                        () => [],
                  ).add(expense);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (expenses.isEmpty) ...[
                      AppContainer(
                        padding: const EdgeInsets.all(48),
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Icon(LucideIcons.book_search, size: 32),
                            const SizedBox(height: 24),
                            Text(
                              "Niente da vedere qui",
                              style: AppTypography.containerTitle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Che ne dici di aggiungere una nuova spesa?",
                              style: AppTypography.containerBody,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (expenses.isNotEmpty) ...[
                      SimpleTrendChart(
                        firstValue: 200,
                        secondValue: 350,
                        thirdValue: totalSpent,
                      ),
                      const SizedBox(height: 24),
                      SettingsTile(
                          icon: LucideIcons.list_collapse,
                          title: "Vedi tutte le spese del periodo",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AllExpensesPage()));
                          }
                      ),

                      const SizedBox(height: 24),
                      Column(
                        spacing: 16,
                        children: categories.entries.map(
                              (entry) {
                            final categoryExpenses = entry.value;
                            final categoryInfo = categoryExpenses.first;
                            final double categorySpent = categoryExpenses.fold(
                              0.0,
                                  (sum, item) => sum + item.numericAmount,
                            );

                            return ExpenseCategoryBar(
                              categoryName: categoryInfo.categoryName,
                              categoryIcon: categoryInfo.categoryIcon,
                              categoryColor: categoryInfo.categoryColor,
                              amount: categorySpent,
                              percentage: totalSpent == 0
                                  ? 0
                                  : categorySpent / totalSpent,
                              categoryId: categoryInfo.categoryId,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}