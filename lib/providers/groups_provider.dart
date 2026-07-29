import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group.dart';

final supabase = Supabase.instance.client;

    if (groupData == null) continue;

    if (groupData is Map<String, dynamic>) {
      groups.add(Group.fromJson(groupData));
    } 

    else if (groupData is List && groupData.isNotEmpty) {
      groups.add(Group.fromJson(groupData[0] as Map<String, dynamic>));
    }
  }

  return (response as List<dynamic>)
      .map((json) => Group.fromJson(json as Map<String, dynamic>))
      .toList();
});