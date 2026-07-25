import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';

import '../../../models/group_member.dart';
import '../../pages/groups/settings/group_member_edit.dart';

class MemberTileAdminView extends StatelessWidget {
  final GroupMember member;

  const MemberTileAdminView({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => GroupMemberEdit()
            )
          );
        },
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
                        Text(
                          'member.email', // todo
                          style: AppTypography.containerBody.copyWith(
                            color: Color(0xFF6B7280),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Icon(
                  LucideIcons.chevron_right,
                  color: Color(0xFFD1D5DB),
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
