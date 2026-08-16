import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../widgets/page_padding.dart';

const String showNavbarTextHintsKey = 'show_navbar_text_hints';

final navbarTextHintsProvider =
AsyncNotifierProvider<NavbarTextHintsNotifier, bool>(() {
  return NavbarTextHintsNotifier();
});

class NavbarTextHintsNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(showNavbarTextHintsKey) ?? true;
  }

  Future<void> toggle(bool value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(showNavbarTextHintsKey, value);
      return value;
    });
  }
}

class InterfaceSettingsPage extends ConsumerWidget {
  const InterfaceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showNavbarHintsAsync = ref.watch(navbarTextHintsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personalizza interfaccia"),
        centerTitle: true,
      ),
      body: PagePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Navigazione",
              style: AppTypography.containerBody,
            ),
            const SizedBox(height: 12),
            AppContainer(
              width: double.infinity,
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.type,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          "Mostra i testi sotto le icone della barra di navigazione",
                          style: AppTypography.containerBody.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Switch(
                    value: showNavbarHintsAsync.value ?? true,
                    onChanged: showNavbarHintsAsync.isLoading
                        ? null
                        : (bool value) {
                      ref
                          .read(navbarTextHintsProvider.notifier)
                          .toggle(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}