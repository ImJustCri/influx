import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Amounts Row
          Row(
            spacing: 8,
            children: [
              Text(
                spent.toStringAsFixed(0),
                style: AppTypography.budgetIndicator.copyWith(
                  color: isOverBudget ? Colors.red : AppColors.white
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

          Column(
            children: [
              AppContainer(
                customBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.btnBackground.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.calendar,
                        size: 20,
                        color: AppColors.btnBackground,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          'Inizio del periodo',
                          style: AppTypography.containerBody.copyWith(
                            fontSize: 12,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          periodStartDate,
                          style: AppTypography.containerTitle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // End Date Container
              AppContainer(
                customBorderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.btnBackground.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.calendar,
                        size: 20,
                        color: AppColors.btnBackground,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          'Fine del periodo',
                          style: AppTypography.containerBody.copyWith(
                            fontSize: 12,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          periodEndDate,
                          style: AppTypography.containerTitle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}