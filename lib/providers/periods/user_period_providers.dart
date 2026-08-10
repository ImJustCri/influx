import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_period.dart';

/// Active period provider for the user
final activeUserPeriodProvider =
FutureProvider<UserPeriod?>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('userPeriod')
      .select()
      .eq('isActive', true)
      .maybeSingle();

  if (response == null) return null;

  return UserPeriod.fromJson(response);
});

/// Latest 2 inactive periods provider for the user
final userPeriodProvider = FutureProvider<List<UserPeriod>>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('userPeriod')
      .select()
      .eq('isActive', false)
      .order('created_at', ascending: false)
      .limit(2);

  return (response as List)
      .map((item) => UserPeriod.fromJson(item as Map<String, dynamic>))
      .toList();
});


/// Latest inactive period provider for the user
final latestInactiveUserPeriodProvider =
FutureProvider<UserPeriod?>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('userPeriod')
      .select()
      .eq('isActive', false)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (response == null) return null;

  return UserPeriod.fromJson(response);
});

/// All periods provider
final allUserPeriodsProvider = FutureProvider<List<UserPeriod>>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('userPeriod')
      .select()
      .order('created_at', ascending: false);

  return (response as List)
      .map((json) => UserPeriod.fromJson(json))
      .toList();
});