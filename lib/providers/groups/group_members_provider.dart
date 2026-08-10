import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/group_member.dart';

final fetchGroupMembersProvider =
FutureProvider.autoDispose.family<List<GroupMember>, String>(
      (ref, groupId) async {
    final response = await Supabase.instance.client
        .from('profile_group')
        .select('*, profilo(*)')
        .eq('group_id', groupId);

    return (response as List<dynamic>)
        .map((json) => GroupMember.fromJson(json as Map<String, dynamic>))
        .toList();
  },
);