import 'package:flutter/material.dart';
import 'package:influx/global.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/app_container.dart';

class GroupExpenseSummary extends StatelessWidget {
  final double spent;
  final double remaining;
  final double total;
  final double percentageChange;

  const GroupExpenseSummary({
    super.key,
    required this.spent,
    required this.remaining,
    required this.total,
    required this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsetsGeometry.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Spese', style: AppTypography.containerBody),
                  const SizedBox(height: 4),
                  Text(
                    '$spent$currency',
                    style: AppTypography.budgetIndicator.copyWith(
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rimanenti', style: AppTypography.containerBody),
                  const SizedBox(height: 4),
                  Text(
                    '$remaining$currency',
                    style: AppTypography.budgetIndicator.copyWith(
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Totale', style: AppTypography.containerBody),
                  const SizedBox(height: 4),
                  Text(
                    '$total$currency',
                    style: AppTypography.budgetIndicator.copyWith(
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFF1B2C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_drop_up,
                      color: AppColors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+${percentageChange.toStringAsFixed(1)}%',
                      style: AppTypography.containerTitle,
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
