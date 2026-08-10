import 'package:flutter/material.dart';
import '../../global.dart';
import '../../theme.dart';
import '../app_container.dart';
import '../round_linear_progress_bar.dart';

class GroupTotalBudgetCard extends StatelessWidget {
  final double groupBudget;
  final double totalGroupExpenses;
  final DateTime resetDate;

  const GroupTotalBudgetCard({
    super.key,
    required this.groupBudget,
    required this.totalGroupExpenses,
    required this.resetDate,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverBudget = totalGroupExpenses > groupBudget;

    final progressValue = groupBudget > 0
        ? (totalGroupExpenses / groupBudget).clamp(0.0, 1.0)
        : 0.0;

    final Color progressColor =
    isOverBudget ? Colors.red : AppColors.btnBackground;

    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Totale Gruppo",
            style: AppTypography.containerBody.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          RoundedLinearProgressBar(
            value: progressValue,
            backgroundColor: AppColors.backgroundAccent,
            valueColor: progressColor,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${totalGroupExpenses.toStringAsFixed(2)}$currency",
                style: AppTypography.containerBody.copyWith(
                  color: isOverBudget ? Colors.red : null,
                  fontWeight: isOverBudget ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                "${groupBudget.toStringAsFixed(2)}$currency",
                style: AppTypography.containerBody,
              ),
            ],
          ),
        ],
      ),
    );
  }
}