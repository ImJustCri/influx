import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/expense_data.dart';
import 'user_period_providers.dart';

/// Fetch latest expenses
final fetchLatestExpenses = FutureProvider.family<List<ExpenseData>, int>((ref, limit) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;
  final activePeriod = await ref.watch(activeUserPeriodProvider.future);

  if (activePeriod == null) {
    return [];
  }

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .gte('created_at', activePeriod.createdAt.toIso8601String())
      .lte('created_at', activePeriod.endDate.toIso8601String())
      .order('created_at', ascending: false)
      .limit(limit);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});

/// Fetch all expenses
final fetchExpenses = FutureProvider<List<ExpenseData>>((ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser!.id;

  final activePeriod = await ref.watch(activeUserPeriodProvider.future);

  if (activePeriod == null) {
    return [];
  }

  final response = await supabase
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .gte('created_at', activePeriod.createdAt.toIso8601String())
      .lte('created_at', activePeriod.endDate.toIso8601String())
      .order('created_at', ascending: false);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});

/// Fetch expenses by category
final fetchExpensesByCategory = FutureProvider.family<List<ExpenseData>, String>((ref, categoryId) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;

  final activePeriod = await ref.watch(activeUserPeriodProvider.future);

  if (activePeriod == null) {
    return [];
  }

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .eq('category_id', categoryId)
      .gte('created_at', activePeriod.createdAt.toIso8601String())
      .lte('created_at', activePeriod.endDate.toIso8601String())
      .order('created_at', ascending: false);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});

/// Fetch expenses filtered by groupId
final fetchExpensesByGroupProvider =
FutureProvider.family<List<ExpenseData>, String>((ref, groupId) async {

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('group_id', groupId)
      .order('created_at', ascending: false);

  return (response as List)
      .map((item) => ExpenseData.convertJson(item))
      .toList();
});

/// Fetch expenses filtered by category and groupId
final fetchExpensesByCategoryGroupProvider =
FutureProvider.family<List<ExpenseData>, (String, String)>((ref, arg) async {
  final (groupId, categoryId) = arg;

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('category_id', categoryId)
      .eq('group_id', groupId)
      .order('created_at', ascending: false);

  return (response as List)
      .map((item) => ExpenseData.convertJson(item))
      .toList();
});

/// Fetch expenses filtered by groupId and profileId
final fetchExpensesByUserAndGroupProvider =
FutureProvider.family<List<ExpenseData>, (String, String)>((ref, args) async {
  final (userId, groupId) = args;

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .eq('group_id', groupId)
      .order('created_at', ascending: false);

  return (response as List)
      .map((item) => ExpenseData.convertJson(item))
      .toList();
});

/// Fetch all expenses from the latest inactive period
final fetchLatestInactivePeriodExpenses = FutureProvider<List<ExpenseData>>((ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser!.id;

  final inactivePeriod = await ref.watch(latestInactiveUserPeriodProvider.future);

  if (inactivePeriod == null) {
    return [];
  }

  final response = await supabase
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .gte('created_at', inactivePeriod.createdAt.toIso8601String())
      .lte('created_at', inactivePeriod.endDate.toIso8601String())
      .order('created_at', ascending: false);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});