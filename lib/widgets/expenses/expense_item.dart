import 'package:flutter/material.dart';
import 'package:influx/constants.dart';
import '../../theme.dart';
import 'expense_type_helpers.dart';
import '../../pages/expense_detail_page.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseType type;
  final String title;
  final String amount;
  final String description;
  final DateTime purchaseDate;

  const ExpenseItem({
    super.key,
    required this.type,
    required this.title,
    required this.amount,
    this.description = '',
    required this.purchaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExpenseDetailPage(
              type: type,
              title: title,
              amount: amount,
              description: description,
              purchaseDate: purchaseDate,
            ),
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTypography.expenseTitle),
                        Text(type.subtitle, style: AppTypography.expenseDescription),
                      ],
                    ),
                  ],
                ),
                Text(amount + currency, style: AppTypography.expenseTitle),
              ],
            ),
          ),
          const Divider(
            color: AppColors.containerBorder,
            height: .5,
          ),
        ],
      ),
    );
  }
}
