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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 24),
              groupsAsync.when(
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
                    return const AppContainer(
                      padding: EdgeInsets.all(48.0),
                      child: Column(
                        children: [
                          Icon(LucideIcons.user_search, size: 32),
                          SizedBox(height: 24),
                          Text("Deserto totale...", style: AppTypography.containerTitle, textAlign: TextAlign.center),
                          SizedBox(height: 4),
                          Text("Dai un senso a questa schermata: crea un gruppo o entra in uno esistente.", style: AppTypography.containerBody, textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  }

                  // Split groups based on status
                  final activeGroups = groups.where((g) => g.status == 'active').toList();
                  final creationGroups = groups.where((g) => g.status == 'creation').toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (activeGroups.isNotEmpty) ...[
                        AppContainer(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Icon(LucideIcons.zap, size: 16),
                                    Text(
                                      'Attivi',
                                      style: AppTypography.containerTitle,
                                    ),
                                  ],
                                ),
                              ),
                              ...activeGroups.map((group) => _buildGroupTile(context, ref, group, userId)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (creationGroups.isNotEmpty) ...[
                        AppContainer(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Icon(LucideIcons.clock, size: 16),
                                    Text(
                                      'In attesa',
                                      style: AppTypography.containerTitle,
                                    ),
                                  ],
                                ),
                              ),
                              ...creationGroups.map((group) => _buildGroupTile(context, ref, group, userId)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// helper method to build individual group tiles while maintaining provider logic
  Widget _buildGroupTile(BuildContext context, WidgetRef ref, dynamic group, String? userId) {
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

            if (context.mounted) {
              ref.invalidate(groupsProvider);
              ref.invalidate(groupMemberCountProvider);
            }
          },
        );
      },
    );
  }
}