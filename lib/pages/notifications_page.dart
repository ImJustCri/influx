import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: PagePadding(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.backgroundAccent,
                radius: 48,
                child: const Icon(
                  LucideIcons.bell,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Coming Soon",
                    style: AppTypography.pageTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Questa funzionalità è in via di sviluppo e verrà rilasciata nelle prossime versioni dell'app",
                      style: AppTypography.pageSubtitle.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}