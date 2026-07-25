// lib/repositories/profile_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  // Add 'static' here
  static Future<void> updateProfile({
    required SupabaseClient supabase,
    required String userUuid,
    required String fullName,
    String? avatarUrl,
  }) async {
    await supabase.from('profilo').update({
      'full_name': fullName,
      'avatar_url': avatarUrl,
    }).eq('id', userUuid);
  }
}