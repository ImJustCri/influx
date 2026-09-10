import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../widgets/app_container.dart';
import 'tab_button.dart';

class TabNavigationBar extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabTapped;

  const TabNavigationBar({
    super.key,
    required this.selectedTabIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: TabButton(
              label: 'Risparmio',
              isSelected: selectedTabIndex == 0,
              activeColor: AppColors.containerBackground,
              onTap: () => onTabTapped(0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TabButton(
              label: 'ecoSwitch',
              isSelected: selectedTabIndex == 1,
              activeColor: const Color(0xFF4CAF50),
              onTap: () => onTabTapped(1),
            ),
          ),
        ],
      ),
    );
  }
}