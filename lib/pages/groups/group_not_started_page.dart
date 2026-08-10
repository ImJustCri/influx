import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/models/group.dart';
import 'package:influx/pages/groups/edit_group_page.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/groups/get_group_role_provider.dart';
import '../../providers/groups/group_members_provider.dart';
import '../../providers/groups/groups_provider.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../widgets/group/members_tile_view.dart';
import '../../widgets/settings_tile.dart';

class GroupNotStartedPage extends ConsumerStatefulWidget {
  final Group group;
  final bool isUserGroupOwner;
  final int memberCount;

  const GroupNotStartedPage({
    super.key,
    required this.group,
    required this.isUserGroupOwner,
    required this.memberCount,
  });

  @override
  ConsumerState<GroupNotStartedPage> createState() => _GroupNotStartedPageState();
}

class _GroupNotStartedPageState extends ConsumerState<GroupNotStartedPage> {
  double totalBudget = 0;
  double perCapitaBudget = 0;
  DateTime? selectedEndDate;

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    final profileGroupAsync = ref.watch(
      fetchProfileGroupDetailsProvider(
        (groupId: widget.group.id, profileId: currentUserId),
      ),
    );

    final membersAsync = ref.watch(fetchGroupMembersProvider(widget.group.id));

    final isAdmin = profileGroupAsync.maybeWhen(
      data: (data) => data != null && data['role'] == 'admin',
      orElse: () => false,
    );

    final bool canManageGroup = widget.isUserGroupOwner || isAdmin;

    final String subtitle = canManageGroup
        ? "Il gruppo non è ancora attivo. \n Prima di attivarlo, controlla che tutto sia stato impostato correttamente"
        : "Il gruppo non è ancora attivo. \n Ti invieremo una notifica quando verrà avviato";

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
              PagePadding(
                child: Column(
                  spacing: 24,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Center(
                                child: CircleAvatar(
                                  backgroundColor: AppColors.backgroundAccent,
                                  radius: 48,
                                  child: const Icon(
                                    LucideIcons.clock,
                                    color: AppColors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                widget.group.name,
                                style: AppTypography.pageTitle,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: AppTypography.pageSubtitle.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (canManageGroup) ...[
                          SettingsTile(
                            icon: LucideIcons.key,
                            title: "Vedi codice di ingresso",
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Codice di ingresso",
                                          style: AppTypography.containerTitle,
                                        ),
                                        Text(
                                          "${widget.group.inviteCode}",
                                          style: AppTypography.budgetIndicator.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        QrImageView(
                                          data: "${widget.group.inviteCode}",
                                          eyeStyle: const QrEyeStyle(
                                            eyeShape: QrEyeShape.square,
                                            color: Colors.white,
                                          ),
                                          dataModuleStyle: const QrDataModuleStyle(
                                            dataModuleShape: QrDataModuleShape.square,
                                            color: Colors.white,
                                          ),
                                          size: 192,
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text("Chiudi"),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          SettingsTile(
                            icon: LucideIcons.pencil,
                            title: "Modifica gruppo",
                            onTap: () async {
                              final result = await Navigator.push<Map<String, dynamic>>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditGroupPage(
                                    groupId: widget.group.id,
                                    initialName: widget.group.name,
                                    memberCount: widget.memberCount,
                                  ),
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  totalBudget = result['totalBudget'] ?? 0.0;
                                  perCapitaBudget = result['perCapitaBudget'] ?? 0.0;
                                  selectedEndDate = result['endDate'];
                                });
                              }
                            },
                          ),

                          SettingsTile(
                            icon: LucideIcons.circle_power,
                            title: "Attiva gruppo",
                            onTap: () async {
                              if (totalBudget <= 0 || perCapitaBudget <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Imposta un budget valido nella pagina "Modifica gruppo" prima di attivare.',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              if (selectedEndDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Seleziona la data di fine periodo nella pagina "Modifica gruppo".',
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              String message;
                              bool isSuccess = false;

                              try {
                                await supabase
                                    .from('group')
                                    .update({'status': 'active'})
                                    .eq('id', widget.group.id);

                                await supabase.from('groupPeriod').insert({
                                  'group_id': widget.group.id,
                                  'budget': totalBudget,
                                  'perCapitaBudget': perCapitaBudget,
                                  'endDate': selectedEndDate!.toIso8601String(),
                                  'isActive': true,
                                });

                                message = "Gruppo attivato con successo.";
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
                                              Navigator.of(context).pop();
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
                          const SizedBox(height: 8),
                        ],

                        AppContainer(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: List.generate(
                              members.length,
                                  (index) => MemberTileView(
                                member: members[index],
                                groupId: widget.group.id,
                                creatorId: widget.group.creatorId,
                              ),
                            ),
                          ),
                        ),
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