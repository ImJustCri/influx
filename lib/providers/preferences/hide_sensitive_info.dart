import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String hideSensitiveInfoKey = 'hide_sensitive_info';

final hideSensitiveInfoProvider =
AsyncNotifierProvider<HideSensitiveInfoNotifier, bool>(() {
  return HideSensitiveInfoNotifier();
});

class HideSensitiveInfoNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    // defaulted to false
    return prefs.getBool(hideSensitiveInfoKey) ?? false;
  }

  Future<void> toggle(bool value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(hideSensitiveInfoKey, value);
      return value;
    });
  }
}