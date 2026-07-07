import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Image.asset(
          'assets/logo/logo.png',
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.bell),
          tooltip: 'Notifiche',
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(LucideIcons.circle_user),
          tooltip: 'Il tuo account',
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
