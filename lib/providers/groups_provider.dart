import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/group.dart';

final supabase = Supabase.instance.client;

final groupsProvider = FutureProvider<List<Group>>((ref) async {
  // Query all rows from the 'group' table
  final response = await supabase.from('group').select();

  return (response as List<dynamic>)
      .map((json) => Group.fromJson(json as Map<String, dynamic>))
      .toList();
});