import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/preferences/comune_provider.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../widgets/page_padding.dart';
import '../../widgets/preferences/comune_modal.dart';

const String showNavbarTextHintsKey = 'show_navbar_text_hints';
const String selectedComuneKey = 'selected_comune';

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
    final comuneAsync = ref.watch(comuneProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferenze"),
        centerTitle: true,
      ),
      body: PagePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppContainer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.lock,
                    size: 16,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Tutte le impostazioni configurate in questa pagina vengono salvate unicamente sul tuo dispositivo e non sono sincronizzate con il tuo account.",
                      style: AppTypography.containerBody.copyWith(
                        color: AppColors.whiteDim
                      )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
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
            const SizedBox(height: 16),
            Text(
              "Posizione",
              style: AppTypography.containerBody,
            ),
            const SizedBox(height: 12),
            AppContainer(
              width: double.infinity,
              child: InkWell(
                onTap: comuneAsync.isLoading
                    ? null
                    : () async {
                  final selectedComune = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const ComuneSelectionModal(),
                  );

                  if (selectedComune != null) {
                    await ref
                        .read(comuneProvider.notifier)
                        .updateComune(selectedComune);
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.map_pin,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Comune",
                            style: AppTypography.containerBody.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            comuneAsync.value ?? 'Non selezionato',
                            style: AppTypography.containerBody.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      LucideIcons.chevron_right,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}