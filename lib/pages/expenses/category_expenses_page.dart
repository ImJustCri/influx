import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/models/group_member.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:intl/intl.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../models/expense_data.dart';
import '../../providers/expenses/expenses_provider.dart';
import '../../widgets/expenses/expense_item.dart';
import '../../widgets/status_container.dart';

class CategoryExpensesPage extends ConsumerStatefulWidget {
  final String categoryId;
  final String? categoryName;
  final List<GroupMember>? groupMembers;
  final String? groupId;
  final bool? isLatestInactive;

  const CategoryExpensesPage({
    super.key,
    required this.categoryId,
    this.categoryName,
    this.groupMembers,
    this.groupId,
    this.isLatestInactive,
  });

  @override
  ConsumerState<CategoryExpensesPage> createState() =>
      _CategoryExpensesPageState();
}

class _CategoryExpensesPageState
    extends ConsumerState<CategoryExpensesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Helper function to group expenses by formatted date string
  Map<String, List<ExpenseData>> _groupExpensesByDate(
      List<ExpenseData> expenses) {
    final Map<String, List<ExpenseData>> grouped = {};

    for (final expense in expenses) {
      final DateTime date = expense.purchaseDate;
      final String dateHeader =
      DateFormat('dd MMMM yyyy', 'it_IT').format(date);

      grouped.putIfAbsent(dateHeader, () => []).add(expense);
    }

    return grouped;
  }

  /// Helper function to find a member by profileId
  GroupMember? _findMember(String? profileId) {
    if (widget.groupMembers == null || profileId == null) return null;

    for (final member in widget.groupMembers!) {
      if (member.id == profileId) {
        return member;
      }
    }
    return null;
  }

  /// Filters expenses by title OR category name, case-insensitive
  List<ExpenseData> _filterExpenses(List<ExpenseData> expenses) {
    if (_searchQuery.trim().isEmpty) return expenses;

    final query = _searchQuery.trim().toLowerCase();

    return expenses.where((expense) {
      final titleMatch = expense.title.toLowerCase().contains(query);
      final categoryMatch = expense.categoryName.toLowerCase().contains(query);
      return titleMatch || categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ExpenseData>> expensesAsync;

    if (widget.groupId != null) {
      expensesAsync = ref.watch(fetchExpensesByCategoryGroupProvider(
          (widget.groupId!, widget.categoryId)));
    } else if (widget.isLatestInactive == true) {
      expensesAsync = ref.watch(
          fetchInactivePeriodExpensesByCategory(widget.categoryId));
    } else {
      expensesAsync =
          ref.watch(fetchExpensesByCategory(widget.categoryId));
    }

    Future<void> refreshExpenses() async {
      if (widget.groupId != null) {
        ref.invalidate(fetchExpensesByCategoryGroupProvider(
            (widget.groupId!, widget.categoryId)));
      } else if (widget.isLatestInactive == true) {
        ref.invalidate(
            fetchInactivePeriodExpensesByCategory(widget.categoryId));
      } else {
        ref.invalidate(fetchExpensesByCategory(widget.categoryId));
      }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: refreshExpenses,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: PagePadding(
            child: expensesAsync.when(
              data: (expenses) {
                if (expenses.isEmpty) {
                  return StatusContainer(
                    icon: LucideIcons.book_search,
                    title: "Niente da vedere qui",
                    description: "Nessuna spesa trovata per questa categoria.",
                  );
                }

                // Apply search filter (by title or category) before splitting
                final filteredExpenses = _filterExpenses(expenses);

                // Separate recurring and non-recurring expenses
                final recurringExpenses =
                filteredExpenses.where((e) => e.isRecurring).toList();
                final nonRecurringExpenses =
                filteredExpenses.where((e) => !e.isRecurring).toList();

                final groupedExpenses =
                _groupExpensesByDate(nonRecurringExpenses);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.categoryName ?? 'Altro',
                        style: AppTypography.pageTitle),
                    Text('Spese di questo periodo',
                        style: AppTypography.pageSubtitle),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cerca per titolo o categoria',
                        prefixIcon: const Icon(LucideIcons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (filteredExpenses.isEmpty)
                      StatusContainer(
                        icon: LucideIcons.book_search,
                        title: "Nessun risultato",
                        description: "Nessuna spesa corrisponde alla ricerca.",
                      ),

                    if (recurringExpenses.isNotEmpty) ...[
                      AppContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Spese ricorrenti",
                                style: AppTypography.containerTitle,
                              ),
                            ),
                            ...recurringExpenses.map((expense) {
                              final matchingMember =
                              _findMember(expense.profileId);

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
                                categoryId: widget.categoryId,
                                userName: matchingMember?.name,
                                userPfp: matchingMember?.avatarImageUrl,
                                profileId: expense.profileId,
                                isGroupView:
                                (widget.groupId != null) ? true : false,
                                isRecurring: expense.isRecurring,
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.containerBorder),
                      const SizedBox(height: 16),
                    ],

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
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    dateLabel,
                                    style: AppTypography.containerTitle,
                                  ),
                                ),
                                ...dayExpenses.map((expense) {
                                  final matchingMember =
                                  _findMember(expense.profileId);

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
                                    categoryId: widget.categoryId,
                                    userName: matchingMember?.name,
                                    userPfp: matchingMember?.avatarImageUrl,
                                    profileId: expense.profileId,
                                    isGroupView:
                                    (widget.groupId != null) ? true : false,
                                    isRecurring: expense.isRecurring,
                                  );
                                }),
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
      ),
    );
  }
}