import 'package:flutter/material.dart';
import '../../../theme.dart';

class TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(
            color: activeColor == const Color(0xFF4CAF50)
                ? const Color(0xFF4CAF50)
                : AppColors.containerBorder,
            width: 1,
          )
              : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTypography.containerTitle.copyWith(
            color: isSelected
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
          child: Text(label),
        ),
      ),
    );
  }
}