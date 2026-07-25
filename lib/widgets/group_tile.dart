import 'package:flutter/material.dart';
import '../theme.dart';

class GroupTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int members;
  final VoidCallback onTap;
  final bool? isLast;

  const GroupTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.members,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Row(
              children: [
                CircleAvatar(
                  child: Icon(icon, color: AppColors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.containerTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$members membri",
                        style: AppTypography.containerBody,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast!)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(
              height: 1,
              color: AppColors.inputBorder,
            ),
          ),
      ],
    );
  }
}