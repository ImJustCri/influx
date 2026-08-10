import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/group_period.dart';

/// Active period provider for a specific group
final activeGroupPeriodProvider =
FutureProvider.family<GroupPeriod?, String>((ref, groupId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('groupPeriod')
      .select()
      .eq('group_id', groupId)
      .eq('isActive', true)
      .maybeSingle();

  if (response == null) return null;

  return GroupPeriod.fromJson(response);
});

/// Latest 2 inactive periods provider for a specific group
final groupPeriodProvider =
FutureProvider.family<List<GroupPeriod>, String>((ref, groupId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('groupPeriod')
      .select()
      .eq('group_id', groupId)
      .eq('isActive', false)
      .order('created_at', ascending: false)
      .limit(2);

  return (response as List)
      .map((item) => GroupPeriod.fromJson(item as Map<String, dynamic>))
      .toList();
});

/// Latest inactive period provider for a specific group
final latestInactiveGroupPeriodProvider =
FutureProvider.family<GroupPeriod?, String>((ref, groupId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('groupPeriod')
      .select()
      .eq('group_id', groupId)
      .eq('isActive', false)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();

  if (response == null) return null;

  return GroupPeriod.fromJson(response);
});

/// All periods provider for a specific group
final allGroupPeriodsProvider =
FutureProvider.family<List<GroupPeriod>, String>((ref, groupId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('groupPeriod')
      .select()
      .eq('group_id', groupId)
      .order('created_at', ascending: false);

  return (response as List)
      .map((json) => GroupPeriod.fromJson(json as Map<String, dynamic>))
      .toList();
});