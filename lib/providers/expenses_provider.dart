import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/expense_data.dart';

/// Fetch latest three expenses
final fetchLatestExpenses = FutureProvider.family<List<ExpenseData>, int>((ref, limit) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .order('created_at', ascending: false)
      .limit(limit);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});

/// Fetch all expenses
final fetchExpenses = FutureProvider<List<ExpenseData>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;

  final response = await Supabase.instance.client
      .from('expense')
      .select('*, category(*), group(*)')
      .eq('profile_id', userId)
      .order('created_at', ascending: false);

  return response.map((item) => ExpenseData.convertJson(item)).toList();
});



