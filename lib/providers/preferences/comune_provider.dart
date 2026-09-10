import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/preferences/interface_settings_page.dart';

final comuneProvider =
AsyncNotifierProvider<ComuneNotifier, String>(() {
  return ComuneNotifier();
});

class ComuneNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedComuneKey) ?? 'Non selezionato';
  }

  Future<void> updateComune(String value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(selectedComuneKey, value);
      return value;
    });
  }
}
