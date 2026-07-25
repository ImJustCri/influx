import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final double borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.color,
    this.borderRadius = 32,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? AppColors.containerBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ?? Border.all(
            color: AppColors.containerBorder,
            width: 1,
          ),
          boxShadow: boxShadow,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppTypography.containerBody,
            ),
            // Icon(
            //   Icons.chevron_right,
            //   color: AppColors.white.withValues(alpha: 0.7),
            // ),
          ],
        ),
      ),
    );
  }
}
