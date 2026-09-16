import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:intl/intl.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../models/expense_data.dart';
import '../../models/group_member.dart';
import '../../providers/expenses/expenses_provider.dart';
import '../../widgets/expenses/expense_item.dart';
import '../status_container.dart';

class AllExpensesPage extends ConsumerStatefulWidget {
  final List<GroupMember>? members;
  final String? groupId;
  final bool? isCurrentUserGroupAdmin;
  final bool isGroupView;

  const AllExpensesPage({
    super.key,
    this.members,
    this.groupId,
    this.isCurrentUserGroupAdmin,
    required this.isGroupView,
  });

  @override
  ConsumerState<AllExpensesPage> createState() => _AllExpensesPageState();
}

class _AllExpensesPageState extends ConsumerState<AllExpensesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    if (widget.members == null || profileId == null) return null;

    for (final member in widget.members!) {
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
    final expensesAsync = widget.groupId != null
        ? ref.watch(fetchExpensesByGroupProvider(widget.groupId!))
        : ref.watch(fetchExpenses);

    Future<void> refreshExpenses() async {
      if (widget.groupId != null) {
        ref.invalidate(fetchExpensesByGroupProvider(widget.groupId!));
      } else {
        ref.invalidate(fetchExpenses);
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
                    description: "Che ne dici di aggiungere una nuova spesa?",
                  );
                }

                // Apply search filter (by title or category) before splitting
                final filteredExpenses = _filterExpenses(expenses);

                // Separate recurring and non-recurring expenses
                final recurringExpenses = filteredExpenses.where((e) => e.isRecurring).toList();
                final nonRecurringExpenses = filteredExpenses.where((e) => !e.isRecurring).toList();

                final groupedExpenses = _groupExpensesByDate(nonRecurringExpenses);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tutte le spese', style: AppTypography.pageTitle),
                    Text('Aggiunte in questo periodo', style: AppTypography.pageSubtitle),
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
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Spese ricorrenti",
                                style: AppTypography.containerTitle,
                              ),
                            ),
                            ...recurringExpenses.map(
                                  (expense) {
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
                                  isCurrentUserGroupAdmin: widget.isCurrentUserGroupAdmin,
                                  userName: matchingMember?.name,
                                  userPfp: matchingMember?.avatarImageUrl,
                                  isGroupView: widget.isGroupView,
                                  isRecurring: expense.isRecurring,
                                );
                              },
                            ),
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
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    dateLabel,
                                    style: AppTypography.containerTitle,
                                  ),
                                ),
                                ...dayExpenses.map(
                                      (expense) {
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
                                      isCurrentUserGroupAdmin: widget.isCurrentUserGroupAdmin,
                                      userName: matchingMember?.name,
                                      userPfp: matchingMember?.avatarImageUrl,
                                      isGroupView: widget.isGroupView,
                                      isRecurring: expense.isRecurring,
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
      ),
    );
  }
}