import 'package:flutter/material.dart';
import '../../global.dart';
import '../../models/periods/user_period.dart';
import '../../theme.dart';
import '../app_container.dart';
import '../round_linear_progress_bar.dart';

class InactiveBudgetCard extends StatelessWidget {
  final UserPeriod period;

  const InactiveBudgetCard({
    super.key,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final double totalBudget = period.budget;
    final double actualSpent = period.spent;
    final double remaining = totalBudget - actualSpent;
    final double progressValue = totalBudget > 0
        ? (actualSpent / totalBudget).clamp(0.0, 1.0)
        : 0.0;

    final bool isOverBudget = actualSpent > totalBudget;
    final Color alertColor = isOverBudget ? Colors.red : AppColors.btnBackground;

    return AppContainer(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Spesi",
            style: AppTypography.containerBody,
          ),
          SelectableText(
            "${actualSpent.toStringAsFixed(2)}$currency",
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
                "Rimanente: ${remaining.toStringAsFixed(2)}$currency",
                style: AppTypography.containerBody,
              ),
              Text(
                "Totale: ${totalBudget.toStringAsFixed(2)}$currency",
                style: AppTypography.containerBody,
              ),
            ],
          ),
        ],
      ),
    );
  }
}