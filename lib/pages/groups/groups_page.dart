import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/pages/groups/create_group.dart';
import 'package:influx/pages/groups/group_detail_page.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../providers/group_member_count_provider.dart';
import '../../providers/groups_provider.dart';
import '../../theme.dart';
import '../../widgets/group_tile.dart';
import '../../widgets/settings_tile.dart';
import 'enter_group.dart';
import 'group_not_started_page.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({super.key});

  @override
  ConsumerState<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends ConsumerState<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);
    final userId = supabase.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text('I miei gruppi', style: AppTypography.pageTitle),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: PagePadding(
        child: Column(
          spacing: 24,
          children: [
            AppContainer(
              padding: const EdgeInsets.all(0),
              child: groupsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) {
                  debugPrint("Groups Provider Error: $error");
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Errore nel caricamento dei gruppi',
                        style: AppTypography.containerBody,
                      ),
                    ),
                  );
                },
                data: (groups) {
                  if (groups.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          "Nessun gruppo trovato",
                          style: AppTypography.containerBody,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: groups.map((group) {
                      return Consumer(
                        builder: (context, ref, child) {
                          final countAsync = ref.watch(groupMemberCountProvider(group.id));

                          final memberCount = countAsync.maybeWhen(
                            data: (count) => count,
                            orElse: () => 0,
                          );

                          return GroupTile(
                            icon: LucideIcons.users,
                            title: group.name,
                            members: memberCount,
                            isUserGroupOwner: (group.creatorId == userId),
                            onTap: () async {
                              if (group.status == "active") {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupDetailPage(
                                      group: group,
                                      isUserGroupOwner: (group.creatorId == userId),
                                      currentUserId: userId!,
                                      memberCount: memberCount,
                                    ),
                                  ),
                                );
                              } else {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupNotStartedPage(
                                      group: group,
                                      isUserGroupOwner: (group.creatorId == userId),
                                    ),
                                  ),
                                );
                              }

                              // refresh the group list upon returning from either page
                              if (context.mounted) {
                                ref.invalidate(groupsProvider);
                                print("invalidated");
                              }
                            },
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: SettingsTile(
                    icon: LucideIcons.plus,
                    title: "Crea",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateGroupPage(),
                        ),
                      );
                      ref.invalidate(groupsProvider);
                    },
                  ),
                ),
                Expanded(
                  child: SettingsTile(
                    icon: LucideIcons.door_open,
                    title: "Entra",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnterGroupPage(),
                        ),
                      );
                      ref.invalidate(groupsProvider);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}