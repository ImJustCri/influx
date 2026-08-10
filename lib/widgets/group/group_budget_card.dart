import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../global.dart';
import '../../providers/periods/group_period_providers.dart';
import '../../theme.dart';
import '../app_container.dart';
import '../round_linear_progress_bar.dart';

class GroupBudgetCard extends ConsumerWidget {
  final String groupId;
  final double totalExpenses;
  final bool isGroup;

  const GroupBudgetCard({
    super.key,
    required this.groupId,
    required this.totalExpenses,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncActiveGroupPeriod = ref.watch(activeGroupPeriodProvider(groupId));

    return asyncActiveGroupPeriod.when(
      data: (period) {
        final double perCapitaBudget = period?.perCapitaBudget ?? 0.0;
        final DateTime resetDate = period?.endDate ?? DateTime.now();

        final bool isOverBudget = totalExpenses > perCapitaBudget;
        final remaining = (perCapitaBudget - totalExpenses).toStringAsFixed(2);
        final progressValue = perCapitaBudget > 0
            ? (totalExpenses / perCapitaBudget).clamp(0.0, 1.0)
            : 0.0;

        final resetDateFormatted = DateFormat('d MMMM', 'it_IT').format(resetDate);

        final Color alertColor = isOverBudget ? Colors.red : AppColors.btnBackground;

        return AppContainer(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Il tuo budget rimanente",
                style: AppTypography.containerBody,
              ),
              SelectableText(
                "$remaining$currency",
                style: AppTypography.budgetIndicator.copyWith(
                  color: isOverBudget ? Colors.red : null,
                ),
              ),
              const SizedBox(height: 8),
              RoundedLinearProgressBar(
                value: progressValue,
                minHeight: 8,
                backgroundColor: AppColors.backgroundAccent,
                valueColor: alertColor,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Spesi: ${totalExpenses.toStringAsFixed(2)}$currency",
                    style: AppTypography.containerBody.copyWith(
                      color: isOverBudget ? Colors.red : null,
                    ),
                  ),
                  Text(
                    "Totale: ${perCapitaBudget.toStringAsFixed(2)}$currency",
                    style: AppTypography.containerBody,
                  ),
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
                  Text("Reset: $resetDateFormatted", style: AppTypography.containerBody),
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
}