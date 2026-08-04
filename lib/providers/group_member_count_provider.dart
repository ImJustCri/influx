import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final groupMemberCountProvider = FutureProvider.family<int, String>((ref, groupId) async {
  final count = await Supabase.instance.client
      .from('profile_group')
      .count(CountOption.exact)
      .eq('group_id', groupId);

  return count;
});