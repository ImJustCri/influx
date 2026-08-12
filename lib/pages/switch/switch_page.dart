import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';

class SwitchPage extends StatelessWidget {
  const SwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PagePadding(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.backgroundAccent,
              radius: 48,
              child: const Icon(
                LucideIcons.arrow_left_right,
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
    );
  }
}