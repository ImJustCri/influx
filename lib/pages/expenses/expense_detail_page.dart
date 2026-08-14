import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/status_container.dart';
import 'package:intl/intl.dart';
import 'package:influx/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../widgets/expenses/expense_type_helpers.dart';

class ExpenseDetailPage extends StatelessWidget {
  final String expenseId;
  final String categoryColor;
  final String categoryIcon;
  final String categoryName;
  final String title;
  final double amount;
  final DateTime purchaseDate;
  final String? description;
  final String? groupName;
  final String? expenseUserName;
  final String? expenseUserPfp;
  final String? expenseUserId;
  final bool? isCurrentUserGroupAdmin;
  final bool isGroupView;
  final bool isRecurring;

  const ExpenseDetailPage({
    super.key,
    required this.categoryIcon,
    required this.categoryName,
    required this.categoryColor,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
    required this.groupName,
    required this.expenseId,
    this.expenseUserName,
    this.expenseUserPfp,
    this.expenseUserId,
    this.isCurrentUserGroupAdmin,
    required this.isGroupView,
    required this.isRecurring,
  });

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = isCurrentUserGroupAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (groupName == null || isAdmin) ...[
            IconButton(
              icon: const Icon(LucideIcons.trash_2, color: Colors.redAccent),
              tooltip: 'Elimina spesa',
              onPressed: () async {
                Navigator.of(context).pop();

                try {
                  await Supabase.instance.client
                      .from('expense')
                      .delete()
                      .eq('id', expenseId);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Errore durante l\'eliminazione: $e')),
                    );
                  }
                }
              },
            ),
          ] else if (!isGroupView) ...[
            IconButton(
              icon: const Icon(LucideIcons.info),
              tooltip: 'Elimina spesa',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusContainer(
                            title: "Vuoi eliminare questa spesa?!",
                            icon: LucideIcons.shield_alert,
                            description:
                            "Se sei un admin di $groupName e vuoi rimuovere questa spesa, passa dalla sezione dedicata al gruppo.",
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(LucideIcons.trash_2, color: Colors.redAccent),
              tooltip: 'Elimina spesa',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusContainer(
                            title: "Alt! Zona riservata",
                            icon: LucideIcons.shield_alert,
                            description:
                            "Solo gli admin del gruppo possono eliminare le spese!",
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
          const SizedBox(width: 8),
        ],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Section
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(int.parse(categoryColor, radix: 16)).withAlpha(10),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Color(int.parse(categoryColor, radix: 16)),
                      width: .5,
                    ),
                  ),
                  child: Icon(
                    getIconFromName(categoryIcon),
                    color: Color(int.parse(categoryColor, radix: 16)),
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Amount & Title Section
              Center(
                child: Column(
                  children: [
                    Text(
                      '$amount$currency',
                      style: AppTypography.budgetIndicator,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: AppTypography.pageTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoryName,
                      style: AppTypography.pageSubtitle.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- MAIN DETAILS CONTAINER ---
              AppContainer(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Row
                    Row(
                      spacing: 16,
                      children: [
                        const Icon(LucideIcons.calendar, color: AppColors.white),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Data d'acquisto", style: AppTypography.containerTitle),
                            const SizedBox(height: 4),
                            Text(_formatDate(purchaseDate), style: AppTypography.containerBody),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32, color: AppColors.containerBorder),

                    // Time Row
                    Row(
                      spacing: 16,
                      children: [
                        const Icon(LucideIcons.clock, color: AppColors.white),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Orario d'acquisto", style: AppTypography.containerTitle),
                            const SizedBox(height: 4),
                            Text(_formatTime(purchaseDate), style: AppTypography.containerBody),
                          ],
                        ),
                      ],
                    ),

                    // Recurring Indicator (if active)
                    if (isRecurring) ...[
                      const Divider(height: 32, color: AppColors.containerBorder),
                      Row(
                        spacing: 16,
                        children: [
                          const Icon(LucideIcons.calendar_range, color: AppColors.white),
                          const Text("Spesa Ricorrente", style: AppTypography.containerTitle),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // --- DESCRIPTION CONTAINER ---
              if (description != null && description!.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                AppContainer(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.list_collapse,
                            size: 18,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 8),
                          const Text("Descrizione", style: AppTypography.containerTitle),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        description!,
                        style: AppTypography.containerBody,
                      ),
                    ],
                  ),
                ),
              ],

              // --- OWNERSHIP CONTAINER (USER & GROUP) ---
              if (expenseUserPfp != null || groupName != null) ...[
                const SizedBox(height: 16),
                AppContainer(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Profile (if present)
                      if (expenseUserPfp != null) ...[
                        Row(
                          spacing: 16,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(expenseUserPfp!),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(expenseUserName ?? '', style: AppTypography.containerTitle),
                              ],
                            ),
                          ],
                        ),
                      ],

                      // Divider if both User & Group are visible
                      if (expenseUserPfp != null && groupName != null)
                        const Divider(height: 32, color: AppColors.containerBorder),

                      // Group Info (if present)
                      if (groupName != null) ...[
                        Row(
                          spacing: 16,
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.backgroundAccent,
                              radius: 18,
                              child: Icon(LucideIcons.users_round, size: 18, color: AppColors.white),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(groupName!, style: AppTypography.containerTitle),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ) : SizedBox.shrink(),

              // group (optional)
              if (groupName != null) ...[
                Column(
                  children: [
                    const SizedBox(height: 16),
                    AppContainer(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.backgroundAccent,
                                radius: 24,
                                child: Icon(
                                  LucideIcons.users_round,
                                  size: 20,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                groupName!,
                                style: AppTypography.containerTitle
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}