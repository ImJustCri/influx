import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) throw Exception('User not authenticated');

  return UserProfile(
    displayName: user.userMetadata?['name'] as String? ?? 'User',
    email: user.email ?? '',
    id: user.id ?? 'Non trovato',

  );
});

class UserProfile {
  final String displayName;
  final String email;
  final String id;

  UserProfile({required this.displayName, required this.email, required this.id});
}
