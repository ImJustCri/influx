import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/expenses/all_expenses_page.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';
import '../../global.dart';
import '../../models/expense_data.dart';
import '../../providers/periods/user_period_providers.dart';
import '../../theme.dart';
import 'package:influx/providers/expenses/expenses_provider.dart';
import '../../widgets/app_container.dart';
import '../../widgets/expenses/expense_category_bar.dart';
import '../../widgets/round_linear_progress_bar.dart';

class LatestPeriodReport extends ConsumerStatefulWidget {
  const LatestPeriodReport({super.key});

  @override
  ConsumerState<LatestPeriodReport> createState() => _LatestPeriodReportState();
}

class _LatestPeriodReportState extends ConsumerState<LatestPeriodReport> {
  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(fetchLatestInactivePeriodExpenses);
    final periodAsync = ref.watch(latestInactiveUserPeriodProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(fetchLatestInactivePeriodExpenses);
          ref.invalidate(latestInactiveUserPeriodProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 124,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: PagePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report ultimo periodo',
                  style: AppTypography.pageTitle,
                ),
                SizedBox(height: 24),
                periodAsync.when(
                  loading: () => const AppContainer(
                    padding: EdgeInsets.all(24),
                    width: double.infinity,
                    height: 180,
                    child: SizedBox.shrink(),
                  ),
                  error: (err, stack) => AppContainer(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Errore nel caricamento del budget $err",
                        style: AppTypography.containerBody,
                      ),
                    ),
                  ),
                  data: (period) {
                    if (period == null) return const SizedBox.shrink();

                    final double totalBudget = period.budget;
                    final double actualSpent = period.spent;
                    final double remaining = totalBudget - actualSpent;
                    final double progressValue = totalBudget > 0
                        ? (actualSpent / totalBudget).clamp(0.0, 1.0)
                        : 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: AppContainer(
                        padding: const EdgeInsets.all(24),
                        width: double.infinity,
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Spesi",
                              style: AppTypography.containerBody,
                            ),
                            SelectableText(
                              "$actualSpent$currency",
                              style: AppTypography.budgetIndicator,
                            ),
                            const SizedBox(height: 8),
                            RoundedLinearProgressBar(
                              value: progressValue,
                              minHeight: 8,
                              backgroundColor: AppColors.backgroundAccent,
                              valueColor: AppColors.btnBackground,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rimanente: $remaining$currency",
                                  style: AppTypography.containerBody,
                                ),
                                Text(
                                  "Totale: $totalBudget$currency",
                                  style: AppTypography.containerBody,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Expenses Section
                expensesAsync.when(
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
                                  "Nessuna spesa registrata per questo periodo.",
                                  style: AppTypography.containerBody,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (expenses.isNotEmpty) ...[
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}