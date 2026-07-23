import 'package:flutter/material.dart';
import 'package:influx/global.dart';
import '../../theme.dart';
import 'expense_type_helpers.dart';
import 'expense_detail_page.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseType type;
  final String title;
  final String amount;
  final DateTime purchaseDate;
  final String? description;

  const ExpenseItem({
    super.key,
    required this.type,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpenseDetailPage(
                    type: type,
                    title: title,
                    amount: amount,
                    purchaseDate: purchaseDate,
                    description: description,
                  ),
                ),
              );
            },
            child: Container(
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
                          border: Border.all(
                            color: type.iconColor,
                            width: .5,
                          ),
                        ),
                        child: Icon(type.icon, color: type.iconColor, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTypography.expenseTitle),
                          Text(
                            type.subtitle,
                            style: AppTypography.expenseDescription,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(amount + currency, style: AppTypography.expenseTitle),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: AppColors.containerBorder,
          height: .5,
        ),
      ],
    );
  }
}