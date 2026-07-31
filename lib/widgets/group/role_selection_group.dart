import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/group/role_option_type.dart';
import '../app_container.dart';

enum RoleType { admin, member }

class RoleSelectionGroup extends StatefulWidget {
  final RoleType? initialSelection;
  final bool isAdmin;
  final ValueChanged<RoleType>? onRoleSelected;

  const RoleSelectionGroup({
    super.key,
    this.initialSelection,
    required this.isAdmin,
    this.onRoleSelected,
  });

  @override
  State<RoleSelectionGroup> createState() => _RoleSelectionGroupState();
}

class _RoleSelectionGroupState extends State<RoleSelectionGroup> {
  late RoleType selectedRole;

  @override
  void initState() {
    super.initState();
    // Logic: If initialSelection is provided, use it.
    // Otherwise, select admin if isAdmin is true, else select member.
    selectedRole = widget.initialSelection ??
        (widget.isAdmin ? RoleType.admin : RoleType.member);
  }

  @override
  void didUpdateWidget(covariant RoleSelectionGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected role if the parent passes a new `isAdmin` value
    if (oldWidget.isAdmin != widget.isAdmin) {
      setState(() {
        selectedRole = widget.isAdmin ? RoleType.admin : RoleType.member;
      });
    }
  }

  void _selectRole(RoleType role) {
    setState(() {
      selectedRole = role;
    });
    if (widget.onRoleSelected != null) {
      widget.onRoleSelected!(role);
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
            isSelected: selectedRole == RoleType.member,
            onTap: () => _selectRole(RoleType.member),
          ),
        ],
      ),
    );
  }
}