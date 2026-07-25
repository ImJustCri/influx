import 'package:flutter/material.dart';
import 'package:influx/global.dart';
import 'package:influx/widgets/round_linear_progress_bar.dart';

import '../../theme.dart';

class GroupMemberExpenseTile extends StatelessWidget {
  final String memberName;
  final double amount;
  final String? avatarImageUrl;
  final double progressValue;
  final Color backgroundColor;
  final Color valueColor;

  const GroupMemberExpenseTile({
    super.key,
    required this.memberName,
    required this.amount,
    this.avatarImageUrl,
    required this.progressValue,
    this.backgroundColor = AppColors.backgroundAccent,
    this.valueColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

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
                      Text("$amount$currency", style: AppTypography.containerBody),
                    ],
                  ),
                  RoundedLinearProgressBar(
                    value: progressValue,
                    backgroundColor: backgroundColor,
                    valueColor: valueColor,
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
