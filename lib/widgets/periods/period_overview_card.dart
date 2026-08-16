import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/round_linear_progress_bar.dart';

import '../../global.dart';
import '../../theme.dart';
import '../app_container.dart';

class PeriodOverviewCard extends StatelessWidget {
  final String periodStartDate;
  final String periodEndDate;
  final double spent;
  final double budget;

  const PeriodOverviewCard({
    super.key,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.spent,
    required this.budget,
  });

  bool get isOverBudget => spent > budget;

  double get progress => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    final percentage = budget > 0 ? ((spent / budget) * 100).toInt() : 0;

    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                spacing: 8,
                children: [
                  Text(
                    spent.toStringAsFixed(0),
                    style: AppTypography.budgetIndicator.copyWith(
                      color: isOverBudget ? Colors.red : AppColors.white,
                    ),
                  ),
                  Text(
                    "/",
                    style: AppTypography.containerTitle.copyWith(
                      color: AppColors.white.withAlpha(128),
                    ),
                  ),
                  Text(
                    "${budget.toStringAsFixed(0)}$currency",
                    style: AppTypography.containerTitle.copyWith(
                      color: AppColors.white.withAlpha(128),
                    ),
                  ),
                ],
              ),
              // Percentage Badge
              Text(
                '$percentage%',
                style: AppTypography.containerTitle.copyWith(
                  color: isOverBudget
                      ? Colors.red
                      : AppColors.white.withAlpha(128),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Date Range
          AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            borderRadius: 16,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.btnBackground.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.calendar,
                    size: 16,
                    color: AppColors.btnBackground,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        periodStartDate,
                        style: AppTypography.containerTitle,
                      ),
                      Icon(
                        LucideIcons.arrow_right,
                        size: 16,
                        color: AppColors.white.withValues(alpha: 0.4),
                      ),
                      Text(
                        periodEndDate,
                        style: AppTypography.containerTitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}