import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_version.dart';

final latestAppVersionProvider = FutureProvider<AppVersion?>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('app_versions')
      .select()
      .eq('isLatest', true)
      .maybeSingle();

  if (response == null) return null;
  return AppVersion.fromJson(response);
});