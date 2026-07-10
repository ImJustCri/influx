import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:influx/global.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import 'expense_type_helpers.dart';

class ExpenseDetailPage extends StatelessWidget {
  final ExpenseType type;
  final String title;
  final String amount;
  final DateTime purchaseDate;
  final String? description;

  const ExpenseDetailPage({
    super.key,
    required this.type,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
  });

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Section
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: type.backgroundColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: type.iconColor,
                      width: .5,
                    ),
                  ),
                  child: Icon(
                    type.icon,
                    color: type.iconColor,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Amount Section
              Center(
                child: Column(
                  children: [
                    Text(
                      '$amount$currency',
                      style: AppTypography.budgetIndicator,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: AppTypography.pageTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.subtitle,
                      style: AppTypography.pageSubtitle.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // details

              // date
              AppContainer(
                width: double.infinity,
                child: Row(
                  spacing: 16,
                  children: [
                    Icon(LucideIcons.calendar, color: AppColors.white),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Data d'acquisto",
                            style: AppTypography.containerTitle
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(purchaseDate),
                          style: AppTypography.containerBody,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // time
              AppContainer(
                width: double.infinity,
                child: Row(
                  spacing: 16,
                  children: [
                    Icon(LucideIcons.clock, color: AppColors.white),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Orario d'acquisto",
                            style: AppTypography.containerTitle
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(purchaseDate),
                          style: AppTypography.containerBody,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // description (optional)
              if (description != null && description!.isNotEmpty) ...[
                AppContainer(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descrizione',
                        style: AppTypography.containerTitle,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        description!,
                        style: AppTypography.containerBody,
                      ),
                    ],
                  ),
                )
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
