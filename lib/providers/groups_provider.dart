final groupsProvider = FutureProvider<List<Group>>((ref) async {
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return [];

  final response = await supabase
      .from('profile_group')
      .select('group:group_id(*)')
      .eq('profile_id', userId);

  final List<Group> groups = [];

  for (final item in response as List) {
    final groupData = item['group'];

    if (groupData == null) continue;

    if (groupData is Map<String, dynamic>) {
      groups.add(Group.fromJson(groupData));
    } 

    else if (groupData is List && groupData.isNotEmpty) {
      groups.add(Group.fromJson(groupData[0] as Map<String, dynamic>));
    }
  }

  return groups;
});