import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/expenses/all_expenses_page.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';
import '../../models/expense_data.dart';
import '../../providers/periods/user_period_providers.dart';
import '../../theme.dart';
import 'package:influx/providers/expenses/expenses_provider.dart';
import '../../widgets/charts/simple_trend_chart.dart';
import '../../widgets/expenses/expense_category_bar.dart';
import '../../widgets/status_container.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => ExpensensState();
}

class ExpensensState extends ConsumerState<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(fetchExpenses);
    final userPeriodsAsync = ref.watch(userPeriodProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 72,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Le mie spese',
            style: AppTypography.pageTitle,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(fetchExpenses);
          ref.invalidate(userPeriodProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
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
                    if (expenses.isEmpty)
                      StatusContainer(
                        icon: LucideIcons.book_search,
                        title: "Niente da vedere qui",
                        description: "Che ne dici di aggiungere una nuova spesa?",
                      ),

                    if (expenses.isNotEmpty) ...[
                      userPeriodsAsync.when(
                        data: (periods) {
                          if (periods.isEmpty) {
                            return StatusContainer(
                              icon: LucideIcons.chart_column,
                              title: "Troppo presto per fare i conti",
                              description: "Per vedere quanto hai speso rispetto al periodo scorso, servono almeno due periodi registrati.",
                            );
                          }

                          final List<double> chartValues = [];

                          if (periods.length == 1) {
                            chartValues.add(periods[0].spent);
                            chartValues.add(totalSpent);
                          } else {
                            chartValues.add(periods[1].spent);
                            chartValues.add(periods[0].spent);
                            chartValues.add(totalSpent);
                          }

                          debugPrint(chartValues.toString());

                          return SimpleTrendChart(
                            values: chartValues,
                          );
                        },
                        loading: () => const SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (_, _) => StatusContainer(
                          icon: LucideIcons.cross,
                          title: "Errore",
                          description: "Qualcosa non è andato a buon fine durante il caricamento",
                        )
                      ),

                      const SizedBox(height: 24),
                      SettingsTile(
                        icon: LucideIcons.list_collapse,
                        title: "Vedi tutte le spese del periodo",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllExpensesPage(isGroupView: false),
                            ),
                          );
                        },
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