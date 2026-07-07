import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../theme.dart';

class MainBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const MainBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final items = const [
    ('Home', LucideIcons.house),
    ('Switch', LucideIcons.arrow_left_right),
    ('Spese', LucideIcons.banknote),
    ('Gruppo', LucideIcons.users),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.backgroundAccent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              height: 56,
              indicatorColor: AppColors.backgroundColor,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600);
                }
                return const TextStyle(color: Color(0xFF6D678D), fontSize: 12);
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: Colors.white, size: 20);
                }
                return const IconThemeData(color: Color(0xFF6D678D), size: 20);
              }),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                elevation: 0,
                destinations: items.map((item) {
                  return NavigationDestination(
                    icon: Icon(item.$2),
                    label: item.$1,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}