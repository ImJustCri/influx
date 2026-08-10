import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../models/expense_data.dart';
import '../../models/group_member.dart';
import '../../providers/expenses/expenses_provider.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../widgets/expenses/expense_category_bar.dart';

class GroupExpensesPage extends ConsumerStatefulWidget {
  final String groupId;
  final String groupName;
  final List<GroupMember> members;

  const GroupExpensesPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.members,
  });

  @override
  ConsumerState<GroupExpensesPage> createState() => _GroupExpensesPageState();
}

class _GroupExpensesPageState extends ConsumerState<GroupExpensesPage> {
  @override
  Widget build(BuildContext context) {
    // Watch group-filtered expenses
    final expensesAsync = ref.watch(fetchExpensesByGroupProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(fetchExpensesByGroupProvider(widget.groupId));
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
              error: (error, stackTrace) => Center(
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
                  categories
                      .putIfAbsent(
                    expense.categoryName,
                        () => [],
                  )
                      .add(expense);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistiche',
                      style: AppTypography.pageTitle,
                    ),
                    Text(
                      widget.groupName,
                      style: AppTypography.pageSubtitle,
                    ),
                    SizedBox(height: 24),
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
                              "Che ne dici di aggiungere una nuova spesa per questo gruppo?",
                              style: AppTypography.containerBody,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (expenses.isNotEmpty) ...[
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
                              groupMembers: widget.members,
                              groupId: widget.groupId,
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