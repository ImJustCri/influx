import 'package:flutter/material.dart';
import '../../global.dart';
import '../../theme.dart';
import '../app_container.dart';
import '../round_linear_progress_bar.dart';

class GroupBudgetCard extends StatelessWidget {
  final double groupBudget;
  final double perCapitaBudget;
  final double totalExpenses;
  final DateTime resetDate;
  final bool isGroup;

  const GroupBudgetCard({
    super.key,
    required this.groupBudget,
    required this.perCapitaBudget,
    required this.totalExpenses,
    required this.resetDate,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = perCapitaBudget - totalExpenses;
    final progressValue = perCapitaBudget > 0
        ? (totalExpenses / perCapitaBudget).clamp(0.0, 1.0)
        : 0.0;
    final resetDateFormatted = "${resetDate.day} ${_getMonthName(resetDate.month)}";

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
              Text("Spesi: $totalExpenses$currency", style: AppTypography.containerBody),
              Text("Totale: $perCapitaBudget$currency", style: AppTypography.containerBody),
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
  }

  String _getMonthName(int month) {
    const months = [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
    return months[month - 1];
  }
}