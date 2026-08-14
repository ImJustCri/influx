import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/expense_data.dart';
import '../periods/group_period_providers.dart';
import '../periods/user_period_providers.dart';

/// Fetch latest expenses (includes active period range OR isRecurring = true)
final fetchLatestExpenses = FutureProvider.family<List<ExpenseData>, int>((ref, limit) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;
  final activePeriod = await ref.watch(activeUserPeriodProvider.future);

  if (activePeriod == null) {
    return [];
  }

  final start = activePeriod.createdAt.toIso8601String();
  final end = activePeriod.endDate.toIso8601String();

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
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

  final start = activePeriod.createdAt.toIso8601String();
  final end = activePeriod.endDate.toIso8601String();

  final response = await supabase
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
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

  final start = activePeriod.createdAt.toIso8601String();
  final end = activePeriod.endDate.toIso8601String();

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .eq('category_id', categoryId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
      .order('created_at', ascending: false);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});

/// Fetch expenses filtered by groupId within active group period
final fetchExpensesByGroupProvider =
FutureProvider.family<List<ExpenseData>, String>((ref, groupId) async {
  final activePeriod = await ref.watch(activeGroupPeriodProvider(groupId).future);

  if (activePeriod == null) {
    return [];
  }

  final start = activePeriod.createdAt.toIso8601String();
  final end = activePeriod.endDate.toIso8601String();

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('group_id', groupId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
      .order('created_at', ascending: false);

  return (response as List)
      .map((item) => ExpenseData.convertJson(item))
      .toList();
});

/// Fetch expenses filtered by category and groupId within active group period
final fetchExpensesByCategoryGroupProvider =
FutureProvider.family<List<ExpenseData>, (String, String)>((ref, arg) async {
  final (groupId, categoryId) = arg;

  final activePeriod = await ref.watch(activeGroupPeriodProvider(groupId).future);

  if (activePeriod == null) {
    return [];
  }

  final start = activePeriod.createdAt.toIso8601String();
  final end = activePeriod.endDate.toIso8601String();

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('category_id', categoryId)
      .eq('group_id', groupId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
      .order('created_at', ascending: false);

  return (response as List)
      .map((item) => ExpenseData.convertJson(item))
      .toList();
});

/// Fetch expenses filtered by groupId and profileId within active group period
final fetchExpensesByUserAndGroupProvider =
FutureProvider.family<List<ExpenseData>, (String, String)>((ref, args) async {
  final (userId, groupId) = args;

  final activePeriod = await ref.watch(activeGroupPeriodProvider(groupId).future);

  if (activePeriod == null) {
    return [];
  }

  final start = activePeriod.createdAt.toIso8601String();
  final end = activePeriod.endDate.toIso8601String();

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .eq('group_id', groupId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
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

  final start = inactivePeriod.createdAt.toIso8601String();
  final end = inactivePeriod.endDate.toIso8601String();

  final response = await supabase
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
      .order('created_at', ascending: false);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});

/// Fetch expenses from the latest inactive period by category
final fetchInactivePeriodExpensesByCategory = FutureProvider.family<List<ExpenseData>, String>((ref, categoryId) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser!.id;

  final inactivePeriod = await ref.watch(latestInactiveUserPeriodProvider.future);

  if (inactivePeriod == null) {
    return [];
  }

  final start = inactivePeriod.createdAt.toIso8601String();
  final end = inactivePeriod.endDate.toIso8601String();

  final response = await supabase
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .eq('category_id', categoryId)
      .or('and(created_at.gte.$start,created_at.lte.$end),isRecurring.eq.true')
      .order('created_at', ascending: false);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});