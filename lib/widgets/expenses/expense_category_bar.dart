import 'package:flutter/material.dart';
import '../../theme.dart';
import '../round_linear_progress_bar.dart';
import 'expense_item.dart';
import 'expense_type_helpers.dart';

class ExpenseCategoryBar extends StatelessWidget {
  final ExpenseType type;
  final double amount;
  final double percentage;

  const ExpenseCategoryBar({
    super.key,
    required this.type,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(type.subtitle, style: AppTypography.expenseTitle),
            Row(
              children: [
                Text('${amount.toStringAsFixed(0)}€',
                    style: AppTypography.expenseTitle),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: type.baseColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${(percentage * 100).round()}%',
                    style: TextStyle(
                      color: type.iconColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        RoundedLinearProgressBar(
          value: percentage,
          minHeight: 14,
          backgroundColor: AppColors.backgroundAccent,
          valueColor: type.baseColor,
        ),
      ],
    );
  }
}
