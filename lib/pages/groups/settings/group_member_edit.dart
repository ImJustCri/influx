import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/group/role_option_type.dart';
import 'package:influx/widgets/group/role_selection_group.dart';
import 'package:influx/widgets/page_padding.dart';

import '../../../widgets/settings_tile.dart';

class GroupMemberEdit extends StatelessWidget {
  const GroupMemberEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifica membro"),
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
                    ),
                    SizedBox(height: 24),
                    Text("Mario Rossi", style: AppTypography.pageTitle,),
                    SizedBox(height: 4),
                    Text("user.email", style: AppTypography.pageSubtitle,),
                  ],
                ),
              ),
              RoleSelectionGroup(),
              SettingsTile(icon: LucideIcons.x, title: "Rimuovi dal gruppo", onTap: () {})
            ],
          ),
        ),
      ),
    );
  }
}
