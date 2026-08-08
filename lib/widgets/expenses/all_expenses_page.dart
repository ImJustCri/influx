import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:intl/intl.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../models/expense_data.dart';
import '../../models/group_member.dart';
import '../../providers/expenses_provider.dart';
import '../../widgets/expenses/expense_item.dart';
import '../status_container.dart';

class AllExpensesPage extends ConsumerWidget {
  final List<GroupMember>? members;
  final String? groupId;

  const AllExpensesPage({super.key, this.members, this.groupId});

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

  /// Helper function to find a member by profileId
  GroupMember? _findMember(String? profileId) {
    if (members == null || profileId == null) return null;

    for (final member in members!) {
      if (member.id == profileId) {
        return member;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = groupId != null ? ref.watch(fetchExpensesByGroupProvider(groupId!)) : ref.watch(fetchExpenses);

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
              if (expenses.isEmpty) {
                return StatusContainer(
                  icon: LucideIcons.book_search,
                  title: "Niente da vedere qui",
                  description: "Che ne dici di aggiungere una nuova spesa?",
                );
              }

              final groupedExpenses = _groupExpensesByDate(expenses);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tutte le spese', style: AppTypography.pageTitle),
                  Text('Aggiunte in questo periodo', style: AppTypography.pageSubtitle),
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
                                  style: AppTypography.containerTitle,
                                ),
                              ),

                              ...dayExpenses.map(
                                    (expense) {
                                  // Look up the member using the expense's profileId
                                  final matchingMember = _findMember(expense.profileId);

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

                                    // Pass properties safely using null-aware operators
                                    userName: matchingMember?.name,
                                    userPfp: matchingMember?.avatarImageUrl,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
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