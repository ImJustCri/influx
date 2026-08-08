import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/group/role_selection_group.dart';
import 'package:influx/widgets/page_padding.dart';

import '../../../models/group_member.dart';
import '../../../widgets/settings_tile.dart';

class GroupMemberEdit extends StatelessWidget {
  final String groupId;
  final GroupMember member;
  final bool isCurrentUserGroupOwner;
  const GroupMemberEdit({super.key, required this.member, required this.groupId, required this.isCurrentUserGroupOwner});

  /// Function to remove member from database
  Future<void> _removeMember(BuildContext context) async {
    // Optional: Show confirmation dialog before deleting
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Rimuovi membro"),
        content: Text("Sei sicuro di voler rimuovere ${member.name} dal gruppo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.btnBackground),
            child: const Text("Rimuovi"),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    try {
      await Supabase.instance.client
          .from('profile_group')
          .delete()
          .eq('group_id', groupId)
          .eq('profile_id', member.id);

      if (!context.mounted) return;

      if (member.isAdmin && !isCurrentUserGroupOwner) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Che fai, provi a rimuovere un altro admin?")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Membro rimosso con successo.")),
      );

      Navigator.pop(context, true);

    } on PostgrestException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Errore durante la rimozione: ${error.message}"),
          backgroundColor: AppColors.btnBackground,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Si è verificato un errore imprevisto."),
          backgroundColor: AppColors.btnBackground,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifica membro"),
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Column(
            spacing: 24,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: member.avatarImageUrl != null
                          ? NetworkImage(member.avatarImageUrl!)
                          : null,
                      child: member.avatarImageUrl == null
                          ? const Icon(LucideIcons.user, size: 48)
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Text(member.name, style: AppTypography.pageTitle),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              RoleSelectionGroup(isAdmin: member.isAdmin),
              SettingsTile(
                icon: LucideIcons.x,
                title: "Rimuovi dal gruppo",
                onTap: () => _removeMember(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}