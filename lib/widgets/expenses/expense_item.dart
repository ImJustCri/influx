import 'package:flutter/material.dart';
import 'package:influx/global.dart';
import '../../theme.dart';
import 'expense_type_helpers.dart';
import '../../pages/expenses/expense_detail_page.dart';

class ExpenseItem extends StatelessWidget {
  final String expenseId;
  final String categoryId;
  final String categoryIcon;
  final String categoryColor;
  final String categoryName;
  final String title;
  final double amount;
  final DateTime purchaseDate;
  final String? description;
  final String? groupName;
  final String? userName;
  final String? userPfp;
  final String? profileId;
  final bool? isCurrentUserGroupAdmin;
  final bool isGroupView;


  const ExpenseItem({
    super.key,
    required this.categoryIcon,
    required this.categoryColor,
    required this.categoryName,
    required this.title,
    required this.amount,
    required this.purchaseDate,
    this.description,
    required this.groupName,
    required this.expenseId,
    required this.categoryId,
    this.userName,
    this.userPfp,
    this.profileId, this.isCurrentUserGroupAdmin, required this.isGroupView
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpenseDetailPage(
                    expenseId: expenseId,
                    categoryIcon: categoryIcon,
                    categoryColor: categoryColor,
                    categoryName: categoryName,
                    title: title,
                    amount: amount,
                    purchaseDate: purchaseDate,
                    description: description,
                    groupName: groupName,
                    expenseUserName: userName,
                    expenseUserPfp: userPfp,
                    expenseUserId: profileId,
                    isCurrentUserGroupAdmin: isCurrentUserGroupAdmin,
                    isGroupView: isGroupView,
                  ),
                ),
              );
            },
            child: SizedBox(
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
                          color: Color(int.parse(categoryColor, radix: 16)).withAlpha(10),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Color(int.parse(categoryColor, radix: 16)),
                            width: .5,
                          ),
                        ),
                        child: Icon(getIconFromName(categoryIcon), color: Color(int.parse(categoryColor, radix: 16)), size: 22),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTypography.expenseTitle),
                          Text(
                            categoryName,
                            style: AppTypography.expenseDescription,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${amount.toStringAsFixed(2)}$currency',
                    style: AppTypography.expenseTitle,
                  ),
                ],
              ),
            ),
          ),
        ),
        // const Divider(
        //   color: AppColors.containerBorder,
        //   height: .5,
        // ),
      ],
    );
  }
}