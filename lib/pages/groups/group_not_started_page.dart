import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/models/group.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/groups_provider.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../providers/group_members_provider.dart';
import '../../widgets/group/members_tile_view.dart';
import '../../widgets/settings_tile.dart';

class GroupNotStartedPage extends ConsumerWidget {
  final Group group;
  final bool isUserGroupOwner;

  const GroupNotStartedPage({
    super.key,
    required this.group,
    required this.isUserGroupOwner,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(fetchGroupMembersProvider(group.id));

    final String subtitle = isUserGroupOwner
        ? "Il gruppo non è ancora attivo. \n Prima di attivarlo, controlla che tutto sia stato impostato correttamente"
        : "Il gruppo non è ancora attivo. \n Ti invieremo una notifica quando il proprietario lo avvierà";


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
                                  child: Icon(
                                    LucideIcons.clock,
                                    color: AppColors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                group.name,
                                style: AppTypography.pageTitle,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                textAlign: TextAlign.center,
                                subtitle,
                                style: AppTypography.pageSubtitle.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (isUserGroupOwner) ...[
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
                                          "${group.inviteCode}",
                                          style: AppTypography.budgetIndicator.copyWith(
                                            color: Colors.white
                                          ),
                                        ),
                                        QrImageView(
                                          data: "${group.inviteCode}",
                                          eyeStyle: QrEyeStyle(
                                              eyeShape: QrEyeShape.square,
                                              color: Colors.white
                                          ),
                                          dataModuleStyle: QrDataModuleStyle(
                                              dataModuleShape: QrDataModuleShape.square,
                                              color: Colors.white
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
                            onTap: () {},
                          ),

                          SettingsTile(
                            icon: LucideIcons.circle_power,
                            title: "Attiva il gruppo",
                            onTap: () async {
                              String message;
                              bool isSuccess = false;

                              try {
                                await supabase
                                    .from('group')
                                    .update({'status': 'active'})
                                    .eq('id', group.id);

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
                                            // pop the dialog
                                            Navigator.of(dialogContext).pop();

                                            // pop the current page if successful
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
                                member: members[index], groupId: group.id, creatorId: group.creatorId,
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