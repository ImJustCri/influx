import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final profileGroupExpenseSumProvider = FutureProvider.family<
    double,
    ({String profileId, String groupId})
>((ref, params) async {
  final supabase = Supabase.instance.client;

  final periodResponse = await supabase
      .from('groupPeriod')
      .select('created_at, endDate')
      .eq('group_id', params.groupId)
      .eq('isActive', true)
      .maybeSingle();

  if (periodResponse == null) return 0.0;

  final String createdAt = periodResponse['created_at'];
  final String endDate = periodResponse['endDate'];

  final List<dynamic> response = await supabase
      .from('expense')
      .select('amount')
      .eq('profile_id', params.profileId)
      .eq('group_id', params.groupId)
      .gte('created_at', createdAt)
      .lte('created_at', endDate);

  return response.fold<double>(
    0.0,
        (sum, row) => sum + ((row['amount'] as num?)?.toDouble() ?? 0.0),
  );
});