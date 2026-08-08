import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/app_container.dart';

import '../../theme.dart';

class StatusContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double iconSize;

  const StatusContainer({
    super.key,
    this.icon = LucideIcons.loader,
    this.title = "Caricamento...",
    this.description = "Nel frattempo che aspetti, caffè?",
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(48),
      width: double.infinity,
      child: Column(
        children: [
          Icon(
            icon,
            size: iconSize,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTypography.containerTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTypography.containerBody,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}