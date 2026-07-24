import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/group/role_option_type.dart';
import '../app_container.dart';

enum RoleType { admin, member }

class RoleSelectionGroup extends StatefulWidget {
  final RoleType initialSelection;
  final ValueChanged<RoleType>? onRoleSelected;

  const RoleSelectionGroup({
    super.key,
    this.initialSelection = RoleType.admin,
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
    selectedRole = widget.initialSelection;
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
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoleOptionTile(
            title: 'Admin',
            subtitle: 'Accesso completo',
            icon: LucideIcons.eye,
            iconBackgroundColor: Colors.blue,
            isSelected: selectedRole == RoleType.admin,
            onTap: () => _selectRole(RoleType.admin),
          ),
          RoleOptionTile(
            title: 'Membro',
            subtitle: 'Accesso parziale',
            icon: LucideIcons.user,
            iconBackgroundColor: Colors.red,
            isSelected: selectedRole == RoleType.member,
            onTap: () => _selectRole(RoleType.member),
          ),
        ],
      ),
    );
  }
}