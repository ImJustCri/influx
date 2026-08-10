import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:intl/intl.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../models/expense_data.dart';
import '../../providers/expenses/expenses_provider.dart';
import '../../widgets/expenses/expense_item.dart';
import '../../widgets/status_container.dart';

class UserGroupExpensesPage extends ConsumerWidget {
  final String userId;
  final String groupId;
  final String groupName;
  final String userName;
  final String? userPfp;
  final bool isCurrentUserGroupAdmin;

  const UserGroupExpensesPage({
    super.key,
    required this.userId,
    required this.groupId,
    required this.userName,
    this.userPfp,
    required this.groupName,
    required this.isCurrentUserGroupAdmin,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(
      fetchExpensesByUserAndGroupProvider((userId, groupId)),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: PagePadding(
          child: expensesAsync.when(
            data: (expenses) {
              // if (expenses.isEmpty) {
              //   return const StatusContainer(
              //     icon: LucideIcons.sparkles,
              //     title: "Niente da dichiarare!",
              //     description: "O non ha speso un centesimo, o sta nascondendo le ricevute.",
              //   );
              // }

              final groupedExpenses = _groupExpensesByDate(expenses);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    spacing: 24,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                          userPfp!
                        ),
                      ),
                      Column(
                        spacing: 8,
                        children: [
                          Text(userName, style: AppTypography.username, textAlign: TextAlign.center),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Icon(LucideIcons.users, size: 16),
                              Text(groupName, style: AppTypography.userEmailSubtitle, textAlign: TextAlign.center),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 48),

                  if (expenses.isNotEmpty) ...groupedExpenses.entries.map((entry) {
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
                                    (expense) {
                                  return ExpenseItem(
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
                                    userName: userName,
                                    userPfp: userPfp,
                                    isCurrentUserGroupAdmin: isCurrentUserGroupAdmin,
                                    isGroupView: true,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  })
                  else StatusContainer(
                    icon: LucideIcons.sparkles,
                    title: "Niente da vedere qui",
                    description: "O $userName non ha speso un centesimo, o sta nascondendo le ricevute.",
                  ),
                ],
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
      ),
    );
  }
}