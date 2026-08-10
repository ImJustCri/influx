import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/pages/groups/settings/permissions_page.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/group_member.dart';
import '../../../providers/expenses/total_expenses_provider.dart';
import '../../../providers/groups/groups_provider.dart';
import '../../../providers/periods/group_period_providers.dart';
import '../../../theme.dart';
import '../../../widgets/group/member_tile_admin_view.dart';

class GroupAdminSettings extends ConsumerStatefulWidget {
  final String name;
  final String groupId;
  final String groupCreator;
  final bool isCurrentUserAdmin;
  final List<GroupMember> members;

  const GroupAdminSettings({
    super.key,
    required this.members,
    required this.name,
    required this.groupId,
    required this.groupCreator,
    required this.isCurrentUserAdmin,
  });

  @override
  ConsumerState<GroupAdminSettings> createState() => _GroupAdminSettingsState();
}

class _GroupAdminSettingsState extends ConsumerState<GroupAdminSettings> {
  @override
  Widget build(BuildContext context) {

    final groupOwner = widget.members.where((m) => m.id == widget.groupCreator).toList();
    final adminMembers = widget.members.where((m) => m.isAdmin && m.id != widget.groupCreator).toList();
    final regularMembers = widget.members.where((m) => !m.isAdmin && m.id != widget.groupCreator).toList();
    final userId = Supabase.instance.client.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Impostazioni admin", style: AppTypography.pageTitle),
                  Text(
                    "${widget.name} - ${widget.members.length} membri",
                    style: AppTypography.pageSubtitle,
                  ),
                ],
              ),
            ),
            PagePadding(
              child: Column(
                spacing: 32,
                children: [
                  if (groupOwner.isNotEmpty)
                    _buildMemberSection(
                      title: "Proprietario",
                      badgeColor: Colors.deepPurple,
                      members: groupOwner,
                      userId: userId,
                      isOwnerSection: true,
                    ),
                  if (adminMembers.isNotEmpty)
                    _buildMemberSection(
                      title: "Admin",
                      badgeColor: Colors.red,
                      members: adminMembers,
                      userId: userId,
                    ),
                  if (regularMembers.isNotEmpty)
                    _buildMemberSection(
                      title: "Membro",
                      badgeColor: Colors.indigoAccent,
                      members: regularMembers,
                      userId: userId,
                    ),
                  SettingsTile(
                    icon: LucideIcons.info,
                    title: "Informazioni sui permessi",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PermissionsPage(),
                        ),
                      );
                    },
                  ),
                  Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Operazioni", style: AppTypography.containerTitle),
                      SettingsTile(
                        icon: LucideIcons.clock,
                        title: "Torna allo stato di creazione",
                        onTap: () async {
                          String message;
                          bool isSuccess = false;

                          try {
                            final totalSpent = await ref.read(
                              totalGroupExpensesProvider(widget.groupId).future,
                            );

                            await supabase
                                .from('groupPeriod')
                                .update({
                                  'spent': totalSpent,
                                  'isActive': false,
                            })
                                .eq('group_id', widget.groupId)
                                .eq('isActive', true);

                            await supabase
                                .from('group')
                                .update({'status': 'creation'})
                                .eq('id', widget.groupId);

                            ref.invalidate(totalGroupExpensesProvider(widget.groupId));
                            ref.invalidate(activeGroupPeriodProvider(widget.groupId));

                            message = "Stato aggiornato con successo.";
                            isSuccess = true;
                          } catch (error) {
                            message = "Errore: $error";
                          }

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text("Risultato"),
                                  content: Text(message),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();

                                        if (isSuccess && context.mounted) {
                                          int count = 0;
                                          Navigator.of(context).popUntil((_) => count++ >= 2);
                                        }
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                      SettingsTile(
                        icon: LucideIcons.trash,
                        title: "Elimina gruppo",
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Elimina gruppo"),
                              content: const Text(
                                "Sei sicuro di voler eliminare questo gruppo?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Annulla"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    "Elimina",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm != true) return;

                          if (context.mounted && !(userId == widget.groupCreator)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Solo il creatore del gruppo può eliminarlo",
                                ),
                              ),
                            );
                            return;
                          }

                          try {
                            await Supabase.instance.client
                                .from('group')
                                .delete()
                                .eq('id', widget.groupId);

                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } catch (error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Errore: $error"),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberSection({
    required String title,
    required String userId,
    required Color badgeColor,
    required List<GroupMember> members,
    bool isOwnerSection = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            style: AppTypography.containerTitle,
          ),
        ),
        AppContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(
              members.length,
                  (index) => MemberTileAdminView(
                member: members[index],
                groupId: widget.groupId,
                isOwner: isOwnerSection,
                isCurrentUserGroupOwner: (userId == widget.groupCreator),
              ),
            ),
          ),
        ),
      ],
    );
  }
}