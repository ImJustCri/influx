import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../theme.dart';

class MainBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddPressed;

  const MainBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.backgroundAccent,
            borderRadius: BorderRadius.circular(128),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, LucideIcons.house, 'Home'),
              _buildNavItem(1, LucideIcons.arrow_left_right, 'Switch'),

              Material(
                color: AppColors.purple,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onAddPressed,
                  child: const SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      LucideIcons.plus,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),

              _buildNavItem(2, LucideIcons.banknote, 'Spese'),
              _buildNavItem(3, LucideIcons.users, 'Gruppi'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    final activeFgColor = AppColors.white;
    final inactiveFgColor = const Color(0xFF6D678D);

    final contentColor = isSelected ? activeFgColor : inactiveFgColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onDestinationSelected(index),
        borderRadius: BorderRadius.circular(128),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: contentColor, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}