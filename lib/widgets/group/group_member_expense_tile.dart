import 'package:flutter/material.dart';
import 'package:influx/global.dart';
import 'package:influx/widgets/round_linear_progress_bar.dart';
import '../../pages/groups/user_group_expenses.page.dart';
import '../../theme.dart';

class GroupMemberExpenseTile extends StatelessWidget {
  final String memberId;
  final String memberName;
  final double amount;
  final String? avatarImageUrl;
  final double progressValue;
  final Color backgroundColor;
  final Color valueColor;
  final String groupId;
  final String groupName;
  final bool isCurrentUserGroupAdmin;

  const GroupMemberExpenseTile({
    super.key,
    required this.memberName,
    required this.amount,
    this.avatarImageUrl,
    required this.progressValue,
    this.backgroundColor = AppColors.backgroundAccent,
    this.valueColor = AppColors.white,
    required this.memberId,
    required this.groupId,
    required this.groupName, required this.isCurrentUserGroupAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverBudget = progressValue >= 1.0;
    final Color activeValueColor = isOverBudget ? Colors.red : valueColor;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserGroupExpensesPage(
              userId: memberId,
              groupId: groupId,
              userName: memberName,
              userPfp: avatarImageUrl,
              groupName: groupName,
              isCurrentUserGroupAdmin: isCurrentUserGroupAdmin,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 80,
        child: Row(
          spacing: 16,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: avatarImageUrl != null
                  ? NetworkImage(avatarImageUrl!)
                  : null,
            ),
            Expanded(
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(memberName, style: AppTypography.containerTitle),
                      Text(
                        "${amount.toStringAsFixed(2)}$currency",
                        style: AppTypography.containerBody.copyWith(
                          color: isOverBudget ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                  RoundedLinearProgressBar(
                    value: progressValue.clamp(0.0, 1.0),
                    backgroundColor: backgroundColor,
                    valueColor: activeValueColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}