import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/providers/expenses/expenses_provider.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/home/home_app_bar.dart';
import 'package:influx/widgets/page_padding.dart';
import '../models/expense_data.dart';
import '../providers/expenses/total_expenses_provider.dart';
import '../widgets/home/budget_card.dart';
import '../widgets/home/recent_expenses_section.dart';
import '../widgets/status_container.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  // Single shared controller drives every section's entrance
  // this is what makes the stagger actually staggered.
  late final AnimationController _controller;
  int _refreshKey = 0;

  static const _totalDuration = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _totalDuration);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    ref.invalidate(fetchLatestExpenses);
    ref.invalidate(fetchRecurringExpenses);
    ref.invalidate(totalExpensesProvider);

    await ref.read(fetchLatestExpenses(3).future);

    if (mounted) {
      setState(() => _refreshKey++);
      _controller
        ..reset()
        ..forward();
    }
  }

  Widget _buildAnimatedSection({
    required Widget child,
    required double start,
    required double end,
    required Key key,
    Offset slideFrom = const Offset(0, 0.06),
  }) {
    final fade = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    final slide = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      key: key,
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: fade.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              slideFrom.dx * (1 - slide.value),
              slideFrom.dy * MediaQuery.of(context).size.height * (1 - slide.value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recurringExpensesAsync = ref.watch(fetchRecurringExpenses);
    final expensesAsync = ref.watch(fetchLatestExpenses(5));
    final totalExpensesAsync = ref.watch(totalExpensesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.purple,
        backgroundColor: AppColors.backgroundAccent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 128),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedSection(
                  key: ValueKey('app_bar_$_refreshKey'),
                  start: 0.0,
                  end: 0.55,
                  child: const HomeAppBar(),
                ),
                PagePadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnimatedSection(
                        key: ValueKey('budget_card_$_refreshKey'),
                        start: 0.15,
                        end: 0.7,
                        child: BudgetCard(
                          totalExpenses: totalExpensesAsync.maybeWhen(
                            data: (total) => total,
                            orElse: () => 0.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedSection(
                        key: ValueKey('expenses_section_$_refreshKey'),
                        start: 0.3,
                        end: 1.0,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: expensesAsync.when(
                            loading: () => const StatusContainer(
                              key: ValueKey('loading_status'),
                            ),
                            data: (expenses) {
                              final List<ExpenseData> recurringExpenses =
                              recurringExpensesAsync.maybeWhen(
                                data: (recurring) => recurring,
                                orElse: () => [],
                              );

                              return RecentExpensesSection(
                                key: ValueKey('recent_expenses_$_refreshKey'),
                                expenses: expenses,
                                recurringExpenses: recurringExpenses,
                              );
                            },
                            error: (error, stack) => Text(
                              error.toString(),
                              key: const ValueKey('error_status'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}