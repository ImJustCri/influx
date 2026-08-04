import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/group_member.dart';
import '../../pages/groups/settings/group_member_edit.dart';

class MemberTileAdminView extends StatelessWidget {
  final GroupMember member;
  final String groupId;

  const MemberTileAdminView({
    super.key,
    required this.member,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final isSelf = userId == member.id ? true : false;

    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: !isSelf ? () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => GroupMemberEdit(member: member, groupId: groupId,)
            )
          );
        }: null,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFE5E7EB),
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
                isSelf ? Icon(
                  LucideIcons.users_round,
                  color: AppColors.white,
                  size: 20,
                ) : Icon(
                  LucideIcons.chevron_right,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
