import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';

final supabase = Supabase.instance.client;

final profileProvider = FutureProvider<Profile?>((ref) async {
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    return null;
  }

  // query
  final response = await supabase
      .from('profilo')
      .select()
      .eq('id', userId)
      .single();


  return Profile.fromJson(response);
});