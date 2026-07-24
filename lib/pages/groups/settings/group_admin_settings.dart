import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/pages/groups/settings/permissions_page.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';
import '../../../models/group_member.dart';
import '../../../theme.dart';
import '../../../widgets/group/member_tile_admin_view.dart';

class GroupAdminSettings extends StatefulWidget {
  final List<GroupMember> members;
  const GroupAdminSettings({super.key, required this.members});

  @override
  State<GroupAdminSettings> createState() => _GroupAdminSettingsState();
}

class _GroupAdminSettingsState extends State<GroupAdminSettings> {
  @override
  Widget build(BuildContext context) {
    final adminMembers = widget.members.where((m) => m.isAdmin).toList();
    final regularMembers = widget.members.where((m) => !m.isAdmin).toList();

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
                  Text('Famiglia Rossi', style: AppTypography.pageTitle),
                  Text('${widget.members.length} membri - budget condiviso',
                      style: AppTypography.pageSubtitle),
                ],
              ),
            ),
            PagePadding(
              child: Column(
                spacing: 32,
                children: [
                  _buildMemberSection(
                    title: "Admin",
                    badgeColor: Colors.red,
                    members: adminMembers,
                  ),
                  if (regularMembers.isNotEmpty)
                    _buildMemberSection(
                      title: "Membro",
                      badgeColor: Colors.indigoAccent,
                      members: regularMembers,
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
    required Color badgeColor,
    required List<GroupMember> members,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            style: AppTypography.containerTitle
          ),
        ),
        AppContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(
              members.length,
                  (index) => MemberTileAdminView(
                member: members[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
