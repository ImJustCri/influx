import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/models/group.dart';
import 'package:influx/pages/groups/settings/group_admin_settings.dart';
import 'package:influx/widgets/home/budget_card.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/get_group_role_provider.dart';
import '../../providers/group_members_provider.dart';
import '../../theme.dart';
import '../../widgets/group/members_expense_list.dart';

class GroupDetailPage extends ConsumerWidget {
  final Group group;
  final bool isUserGroupOwner;
  final String currentUserId;

  const GroupDetailPage({
    super.key,
    required this.group,
    required this.isUserGroupOwner, required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(fetchGroupMembersProvider(group.id));

    final profileGroupAsync = ref.watch(
      fetchProfileGroupDetailsProvider(
        (groupId: group.id, profileId: currentUserId),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: membersAsync.when(
        data: (members) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(group.name, style: AppTypography.pageTitle),
                        Text('Budget condiviso', style: AppTypography.pageSubtitle),
                      ],
                    ),

                    profileGroupAsync.maybeWhen(
                      data: (data) {
                        final isAdmin = data != null && data['role'] == 'admin';
                        if (!isAdmin) return const SizedBox.shrink();

                        return IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupAdminSettings(
                                  members: members,
                                  name: group.name,
                                  groupId: group.id,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(LucideIcons.settings_2),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              PagePadding(
                child: Column(
                  spacing: 24,
                  children: [
                    BudgetCard(
                      totalExpenses: 10,
                      resetDate: group.startedAt ?? DateTime.now(),
                      isNotAuthorized: true,
                      isGroup: true,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Text('Spese per membro', style: AppTypography.containerBody),
                        MembersExpenseList(members: members),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Errore durante il caricamento dei membri: $error',
              style: AppTypography.pageSubtitle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}