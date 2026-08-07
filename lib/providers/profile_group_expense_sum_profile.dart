import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final profileGroupExpenseSumProvider = FutureProvider.family<
    double,
    ({String profileId, String groupId})
>((ref, params) async {
  final supabase = Supabase.instance.client;

  // Fetch only the amount field for the filtered profile & group
  final List<dynamic> response = await supabase
      .from('expense')
      .select('amount')
      .eq('profile_id', params.profileId)
      .eq('group_id', params.groupId);

  // Sum up all amounts
  return response.fold<double>(
    0.0,
        (sum, row) => sum + ((row['amount'] as num?)?.toDouble() ?? 0.0),
  );
});