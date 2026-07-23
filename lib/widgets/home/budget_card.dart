import 'package:flutter/material.dart';
import 'package:influx/pages/edit_budget_page.dart';
import '../../global.dart';
import '../../theme.dart';
import '../app_container.dart';
import '../round_linear_progress_bar.dart';

class BudgetCard extends StatelessWidget {
  final double totalBudget;
  final double totalExpenses;
  final DateTime resetDate;
  final bool isNotAuthorized;
  final bool isGroup;

  const BudgetCard({
    super.key,
    required this.totalBudget,
    required this.totalExpenses,
    required this.resetDate,
    this.isNotAuthorized = false,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = totalBudget - totalExpenses;
    final progressValue = (totalExpenses / totalBudget).clamp(0.0, 1.0);
    final resetDateFormatted = "${resetDate.day} ${_getMonthName(resetDate.month)}";

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
              Text("Totale: $totalBudget$currency", style: AppTypography.containerBody),
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
              if (!isNotAuthorized)
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditBudgetPage(initialBudget: totalBudget, initialResetDate: resetDate)));
                  },
                  child: Text("Modifica ->", style: AppTypography.containerBody),
                ),
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
