import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/notifications_page.dart';
import '../../providers/profile_provider.dart';
import '../../theme.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(profileProvider);

    return AppBar(
      toolbarHeight: 72,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
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
          tooltip: 'Il tuo account',
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
          icon: userProfileAsyncValue.maybeWhen(
            data: (profile) {
              final avatarUrl = profile?.avatarUrl;
              if (avatarUrl != null && avatarUrl.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.purple,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.backgroundAccent,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                  ),
                );
              }
              return const Icon(
                LucideIcons.circle_user,
                color: AppColors.white,
              );
            },
            orElse: () => const Icon(
              LucideIcons.circle_user,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}