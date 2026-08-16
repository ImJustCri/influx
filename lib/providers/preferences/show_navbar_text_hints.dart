import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _showNavbarTextHintsKey = 'show_navbar_text_hints';

final navbarTextHintsProvider =
AsyncNotifierProvider<NavbarTextHintsNotifier, bool>(() {
  return NavbarTextHintsNotifier();
});

class NavbarTextHintsNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_showNavbarTextHintsKey) ?? true;
  }

  Future<void> toggle(bool value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_showNavbarTextHintsKey, value);
      return value;
    });
  }
}