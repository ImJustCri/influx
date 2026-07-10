import 'package:flutter/material.dart';
import '../../global.dart';
import '../../theme.dart';
import '../app_container.dart';
import '../round_linear_progress_bar.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {

    return AppContainer(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Budget mensile rimanente",
            style: AppTypography.containerBody,
          ),
          SelectableText(
            "$remaining$currency",
            style: AppTypography.budgetIndicator,
          ),
          const SizedBox(height: 8),
          RoundedLinearProgressBar(
            value: spent/budget,
            minHeight: 8,
            backgroundColor: AppColors.backgroundAccent,
            valueColor: AppColors.btnBackground,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Spesi: $spent$currency", style: AppTypography.containerBody),
              Text("Totale: $budget$currency", style: AppTypography.containerBody),
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
              Text("Reset: 1 Giugno", style: AppTypography.containerBody),
              Text("Modifica ->", style: AppTypography.containerBody),
            ],
          ),
        ],
      ),
    );
  }
}
