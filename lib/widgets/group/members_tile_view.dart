import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import '../../../models/group_member.dart';

class MemberTileView extends StatelessWidget {
  final GroupMember member;
  final String groupId;
  final String creatorId;

  const MemberTileView({
    super.key,
    required this.member,
    required this.groupId,
    required this.creatorId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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

              if (member.id == creatorId) CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(
                  LucideIcons.crown,
                  color: Colors.white,
                  size: 20,
                ),
              )
              else if (member.isAdmin) CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  LucideIcons.shield,
                  color: Colors.white,
                  size: 20,
                ),
              ) else CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Icon(
                  LucideIcons.user,
                  color: Colors.white,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
