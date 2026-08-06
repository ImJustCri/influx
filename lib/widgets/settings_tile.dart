import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final Color? splashColor;
  final Color? highlightColor;
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
    this.iconColor,
    this.textColor,
    this.splashColor,
    this.highlightColor,
    this.borderRadius = 32,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? AppColors.containerBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ??
              Border.all(
                color: AppColors.containerBorder,
                width: 1,
              ),
          boxShadow: boxShadow,
        ),
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor,
          highlightColor: highlightColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: iconColor ?? AppColors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: AppTypography.containerBody.copyWith(
                    color: textColor ?? AppTypography.containerBody.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}