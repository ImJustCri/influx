import 'package:flutter/material.dart';
import 'package:influx/theme.dart';

class PriceTile extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const PriceTile({
    super.key,
    required this.label,
    required this.value,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.whiteDim,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "€$value",
          style: AppTypography.budgetIndicator.copyWith(
            fontSize: 20,
            color: highlight ? AppColors.btnBackground : AppColors.white,
          ),
        ),
      ],
    );
  }
}