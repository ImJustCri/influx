import 'package:flutter/material.dart';
import 'package:influx/theme.dart';
import '../../../../models/permission_item.dart';
import 'permission_status_badge.dart';

class PermissionRow extends StatelessWidget {
  final PermissionItem item;

  const PermissionRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.iconBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: AppTypography.containerBody.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            PermissionStatusBadge(isAllowed: item.isAdminAllowed),
            const SizedBox(width: 16),
            PermissionStatusBadge(isAllowed: item.isMemberAllowed),
          ],
        ),
      ),
    );
  }
}