import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTypography.containerBody,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

