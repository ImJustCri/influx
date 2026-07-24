import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class PermissionStatusBadge extends StatelessWidget {
  final bool isAllowed;

  const PermissionStatusBadge({
    super.key,
    required this.isAllowed,
  });

  @override
  Widget build(BuildContext context) {
    if (isAllowed) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Color(0xFF22C55E),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          LucideIcons.check,
          color: Colors.white,
          size: 18,
        ),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 2,
        ),
      ),
    );
  }
}