import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/pages/edit_budget_page.dart';
import '../../global.dart';
import '../../providers/user_period_providers.dart';
import '../../theme.dart';
import '../app_container.dart';
import '../round_linear_progress_bar.dart';

class BudgetCard extends ConsumerWidget {
  final double totalExpenses;
  final bool isNotAuthorized;
  final bool isGroup;

  const BudgetCard({
    super.key,
    required this.totalExpenses,
    this.isNotAuthorized = false,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncActivePeriod = ref.watch(activeUserPeriodProvider);

    return asyncActivePeriod.when(
      data: (period) {
        final double totalBudget = period?.budget ?? 0.0;
        final double actualSpent = totalExpenses;
        final DateTime resetDate = period!.endDate;

        final remaining = totalBudget - actualSpent;
        final progressValue = totalBudget > 0
            ? (actualSpent / totalBudget).clamp(0.0, 1.0)
            : 0.0;
        final resetDateFormatted =
            "${resetDate.day} ${_getMonthName(resetDate.month)}";

        return AppContainer(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Budget rimanente",
                style: AppTypography.containerBody,
              ),
              SelectableText(
                "$remaining$currency",
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
                  Text("Spesi: $actualSpent$currency",
                      style: AppTypography.containerBody),
                  Text("Totale: $totalBudget$currency",
                      style: AppTypography.containerBody),
                ],
              ),
              const Divider(
                thickness: 1,
                color: AppColors.containerBorder,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Reset: $resetDateFormatted",
                      style: AppTypography.containerBody),
                  if (!isNotAuthorized)
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBudgetPage(
                              initialBudget: totalBudget, totalExpenses: totalExpenses,
                            ),
                          ),
                        );

                        ref.invalidate(activeUserPeriodProvider);
                      },
                      child: Text("Modifica ->", style: AppTypography.containerBody),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const AppContainer(
        padding: EdgeInsets.all(24),
        width: double.infinity,
        height: 214,
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
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
    return months[month - 1];
  }
}