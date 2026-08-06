import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final totalExpensesProvider = FutureProvider<double>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;

  if (userId == null) return 0.0;

  final result = await Supabase.instance.client.rpc(
    'sum_expenses_for_user',
    params: {
      'p_user_id': userId,
    },
  );

  return (result as num?)?.toDouble() ?? 0.0;
});