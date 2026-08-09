import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/group_member.dart';
import '../../pages/groups/settings/group_member_edit.dart';

class MemberTileAdminView extends StatelessWidget {
  final GroupMember member;
  final String groupId;
  final bool isCurrentUserGroupOwner;
  final bool isOwner;

  const MemberTileAdminView({
    super.key,
    required this.member,
    required this.groupId,
    required this.isCurrentUserGroupOwner,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final isSelf = userId == member.id;

    final bool canEdit = !isSelf && !isOwner && (!member.isAdmin || isCurrentUserGroupOwner);

    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: canEdit
          ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupMemberEdit(
              member: member,
              groupId: groupId,
              isCurrentUserGroupOwner: isCurrentUserGroupOwner,
            ),
          ),
        );
      }
          : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFE5E7EB),
                      backgroundImage: member.avatarImageUrl != null
                          ? NetworkImage(member.avatarImageUrl!)
                          : null,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          member.name,
                          style: AppTypography.containerTitle,
                        ),
                      ],
                    )
                  ],
                ),
                // Show the chevron only if the profile is editable
                if (canEdit)
                  Icon(
                    LucideIcons.settings_2,
                    color: AppColors.white,
                    size: 20,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}