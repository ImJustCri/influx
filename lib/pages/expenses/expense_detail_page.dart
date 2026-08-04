import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:influx/global.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../widgets/expenses/expense_type_helpers.dart';

class ExpenseDetailPage extends StatelessWidget {
  final String categoryColor;
  final String categoryIcon;
  final String categoryName;
  final String title;
  final double amount;
  final DateTime purchaseDate;
  final String? description;
  final String? groupName;

  const ExpenseDetailPage({
    super.key,
    required this.categoryIcon,
    required this.categoryName,
    required this.categoryColor,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
    required this.groupName,
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
                    color: Color(int.parse(categoryColor, radix: 16)).withAlpha(10),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Color(int.parse(categoryColor, radix: 16)),
                      width: .5,
                    ),
                  ),
                  child: Icon(
                    getIconFromName(categoryIcon),
                    color: Color(int.parse(categoryColor, radix: 16)),
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
                      categoryName,
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
                Column(
                  children: [
                    AppContainer(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description!,
                            style: AppTypography.containerBody,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],

              // group (optional)
              if (groupName != null) ...[
                Column(
                  children: [
                    Text(
                      'Appartiene al gruppo:',
                      style: AppTypography.containerTitle,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    AppContainer(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.backgroundAccent,
                                radius: 24,
                                child: Icon(
                                  LucideIcons.users_round,
                                  size: 20,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                groupName!,
                                style: AppTypography.budgetIndicator.copyWith(
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
