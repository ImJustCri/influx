import 'package:flutter/material.dart';
import 'package:influx/constants.dart';
import '../theme.dart';
import '../widgets/app_container.dart';
import '../widgets/page_padding.dart';
import '../widgets/expenses/expense_type_helpers.dart';

class ExpenseDetailPage extends StatelessWidget {
  final ExpenseType type;
  final String title;
  final String amount;
  final String description;
  final DateTime purchaseDate;

  const ExpenseDetailPage({
    super.key,
    required this.type,
    required this.title,
    required this.amount,
    required this.description,
    required this.purchaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Dettaglio Spesa',
          style: AppTypography.pageTitle,
        ),
      ),
      body: PagePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: type.backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(type.icon, color: type.iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.pageTitle,
                    ),
                    Text(
                      type.subtitle,
                      style: AppTypography.pageSubtitle,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Importo',
                    style: AppTypography.containerTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount + currency,
                    style: AppTypography.budgetIndicator.copyWith(
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (description.isNotEmpty) ...[
              AppContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descrizione',
                      style: AppTypography.containerTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.containerBody,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data di Acquisto',
                    style: AppTypography.containerTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatFullDate(purchaseDate),
                    style: AppTypography.containerBody,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year alle $hour:$minute';
  }
}
