import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/group/role_option_type.dart';
import '../app_container.dart';

enum RoleType { admin, user }

class RoleSelectionGroup extends StatefulWidget {
  final String groupId;
  final String memberId;
  final bool isAdmin;
  final bool isCurrentUserGroupOwner;
  final ValueChanged<RoleType>? onRoleChanged;

  const RoleSelectionGroup({
    super.key,
    required this.groupId,
    required this.memberId,
    required this.isAdmin,
    required this.isCurrentUserGroupOwner,
    this.onRoleChanged,
  });

  @override
  State<RoleSelectionGroup> createState() => _RoleSelectionGroupState();
}

class _RoleSelectionGroupState extends State<RoleSelectionGroup> {
  late RoleType selectedRole;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.isAdmin ? RoleType.admin : RoleType.user;
  }

  @override
  void didUpdateWidget(covariant RoleSelectionGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isAdmin != widget.isAdmin) {
      setState(() {
        selectedRole = widget.isAdmin ? RoleType.admin : RoleType.user;
      });
    }
  }

  /// Handles role change and updates Supabase database
  Future<void> _selectRole(RoleType newRole) async {
    // Return early if role hasn't changed or an update is already in progress
    if (selectedRole == newRole || _isLoading) return;

    // Permission Check: Prevent non-owners from modifying another admin's role
    if (widget.isAdmin && !widget.isCurrentUserGroupOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Non puoi modificare il ruolo di un altro admin."),
        ),
      );
      return;
    }

    final previousRole = selectedRole;

    // Optimistically update the UI
    setState(() {
      selectedRole = newRole;
      _isLoading = true;
    });

    final roleString = newRole == RoleType.admin ? 'admin' : 'user';

    try {
      await Supabase.instance.client
          .from('profile_group')
          .update({'role': roleString})
          .eq('group_id', widget.groupId)
          .eq('profile_id', widget.memberId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ruolo aggiornato con successo.")),
      );

      // Notify parent widget if callback exists
      if (widget.onRoleChanged != null) {
        widget.onRoleChanged!(newRole);
      }
    } on PostgrestException catch (error) {
      if (!mounted) return;

      // Revert local state on error
      setState(() {
        selectedRole = previousRole;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Errore durante l'aggiornamento: ${error.message}"),
          backgroundColor: AppColors.btnBackground,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      // Revert local state on error
      setState(() {
        selectedRole = previousRole;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Si è verificato un errore imprevisto."),
          backgroundColor: AppColors.btnBackground,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoleOptionTile(
            title: 'Admin',
            subtitle: 'Accesso completo',
            icon: LucideIcons.eye,
            iconBackgroundColor: Colors.red,
            isSelected: selectedRole == RoleType.admin,
            onTap: () => _selectRole(RoleType.admin),
          ),
          RoleOptionTile(
            title: 'Membro',
            subtitle: 'Accesso parziale',
            icon: LucideIcons.user,
            iconBackgroundColor: Colors.indigoAccent,
            isSelected: selectedRole == RoleType.user,
            onTap: () => _selectRole(RoleType.user),
          ),
        ],
      ),
    );
  }
}