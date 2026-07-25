import 'package:flutter/material.dart';
import 'package:influx/theme.dart';

class PermissionsHeader extends StatelessWidget {
  const PermissionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Permessi',
            style: AppTypography.containerTitle.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 28,
          child: Center(
            child: Text(
              'A',
              style: TextStyle(
                color: Color(0xFFFF5252),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const SizedBox(
          width: 28,
          child: Center(
            child: Text(
              'M',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}