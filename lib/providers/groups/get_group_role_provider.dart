import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final fetchProfileGroupDetailsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>?, ({String groupId, String profileId})>((ref, arg) async {
  final response = await Supabase.instance.client
      .from('profile_group')
      .select('*')
      .eq('group_id', arg.groupId)
      .eq('profile_id', arg.profileId)
      .maybeSingle();

  return response;
});