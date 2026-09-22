import 'package:flutter/material.dart';
import '../../../theme.dart';

class SwitchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SwitchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      title: const Column(
        children: [
          Text(
            "Switch",
            style: AppTypography.pageTitle,
          ),
        ],
      ),
      centerTitle: true,
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}