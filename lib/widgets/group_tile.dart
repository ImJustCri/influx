import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../theme.dart';

class GroupTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int members;
  final VoidCallback onTap;
  final bool isUserGroupOwner;

  const GroupTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.members,
    required this.isUserGroupOwner,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic text based on count
    final String memberText = members == 1 ? '$members membro' : '$members membri';

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.containerTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          memberText,
                          style: AppTypography.containerBody,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  isUserGroupOwner ? CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(
                      LucideIcons.crown,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                      : CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: Icon(
                      LucideIcons.user,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}