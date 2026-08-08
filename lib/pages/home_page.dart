import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/providers/expenses_provider.dart';
import 'package:influx/services/ocr_service.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/home/home_app_bar.dart';
import 'package:influx/widgets/page_padding.dart';
import '../providers/total_expenses_provider.dart';
import '../widgets/home/budget_card.dart';
import '../widgets/home/recent_expenses_section.dart';
import '../widgets/status_container.dart';
import 'expenses/add_expense_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  Future<void> _refreshData() async {
    // invalidate both providers so the total and recent expenses refresh together
    ref.invalidate(fetchLatestExpenses);
    ref.invalidate(totalExpensesProvider);

    await ref.read(fetchLatestExpenses(3).future);
  }

  @override
  Widget build(BuildContext context) {
    final OcrService s = OcrService();
    final expensesAsync = ref.watch(fetchLatestExpenses(5));
    final totalExpensesAsync = ref.watch(totalExpensesProvider);

    return Scaffold(
      // Pull to refresh
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.purple,
        backgroundColor: AppColors.backgroundAccent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: 128
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                PagePadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BudgetCard(
                        totalExpenses: totalExpensesAsync.maybeWhen(
                          data: (total) => total,
                          orElse: () => 0.0,
                        ),
                      ),
                      const SizedBox(height: 24),

                      expensesAsync.when(
                        loading: () => StatusContainer(),
                        data: (expenses) {
                          return RecentExpensesSection(expenses: expenses);
                        },
                        error: (error, stack) => Text(error.toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 136),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddExpensePage(),
              ),
            );

            // Refresh both when returning from adding an expense
            ref.invalidate(fetchLatestExpenses);
            ref.invalidate(totalExpensesProvider);
          },
          backgroundColor: AppColors.backgroundAccent,
          icon: const Icon(LucideIcons.circle_plus, color: AppColors.purple),
          label: const Text("Aggiungi", style: TextStyle(color: AppColors.white)),
        ),
      ),
    );
  }
}