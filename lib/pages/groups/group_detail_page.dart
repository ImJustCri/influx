import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/models/group.dart';
import 'package:influx/pages/groups/settings/group_admin_settings.dart';
import 'package:influx/pages/groups/user_group_expenses.page.dart';
import 'package:influx/widgets/group/group_total_budget_card.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../providers/get_group_role_provider.dart';
import '../../providers/group_members_provider.dart';
import '../../providers/profile_group_expense_sum_profile.dart';
import '../../theme.dart';
import '../../widgets/expenses/all_expenses_page.dart';
import '../../widgets/group/group_budget_card.dart';
import '../../widgets/group/members_expense_list.dart';
import '../../widgets/settings_tile.dart';
import 'group_expenses_page.dart';

class GroupDetailPage extends ConsumerWidget {
  final Group group;
  final bool isUserGroupOwner;
  final String currentUserId;
  final int memberCount;

  const GroupDetailPage({
    super.key,
    required this.group,
    required this.isUserGroupOwner,
    required this.currentUserId,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(fetchGroupMembersProvider(group.id));

    final profileGroupAsync = ref.watch(
      fetchProfileGroupDetailsProvider(
        (groupId: group.id, profileId: currentUserId),
      ),
    );

    // Watch the profile group expense sum
    final profileExpenseSumAsync = ref.watch(
      profileGroupExpenseSumProvider(
        (profileId: currentUserId, groupId: group.id),
      ),
    );

    void refresh() {
      ref.invalidate(fetchGroupMembersProvider);
      ref.invalidate(fetchProfileGroupDetailsProvider);
      ref.invalidate(profileGroupExpenseSumProvider);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: membersAsync.when(
        data: (members) => RefreshIndicator(
          onRefresh: () async {
            refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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

                          return Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GroupExpensesPage(
                                        groupId: group.id,
                                        groupName: group.name,
                                        members: members,
                                      ),
                                    ),
                                  );

                                  if (context.mounted) {
                                    refresh();
                                  }
                                },
                                icon: const Icon(LucideIcons.chart_column),
                              ),
                              isAdmin
                                  ? IconButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GroupAdminSettings(
                                        members: members,
                                        name: group.name,
                                        groupId: group.id,
                                      ),
                                    ),
                                  );

                                  if (context.mounted) {
                                    refresh();
                                  }
                                },
                                icon: const Icon(LucideIcons.settings_2),
                              )
                                  : const SizedBox.shrink(),
                            ],
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
                      GroupBudgetCard(
                        totalExpenses: profileExpenseSumAsync.when(
                          data: (sum) => sum,
                          loading: () => 0.0,
                          error: (_, _) => 0.0,
                        ),
                        resetDate: group.startedAt ?? DateTime.now(),
                        isGroup: true,
                        groupBudget: group.totalBudget,
                        perCapitaBudget: group.perCapitaBudget,
                      ),
                      GroupTotalBudgetCard(
                        resetDate: group.startedAt ?? DateTime.now(),
                        groupBudget: group.totalBudget,
                        totalGroupExpenses: 10,
                      ),
                      SettingsTile(
                        icon: LucideIcons.list_collapse,
                        title: "Vedi tutte le spese del periodo",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllExpensesPage(
                                members: members,
                                groupId: group.id,
                              ),
                            ),
                          );
                        },
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Text('Spese per membro', style: AppTypography.containerBody),
                          MembersExpenseList(
                            members: members,
                            groupId: group.id,
                            perCapitaBudget: group.perCapitaBudget,
                            groupName: group.name,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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