import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';
import '../../theme.dart';
import 'create_period_page.dart';
import 'latest_period_report.dart';

class PeriodEndedPage extends ConsumerWidget {
  const PeriodEndedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: PagePadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Section
              Center(
                child: CircleAvatar(
                  backgroundColor: AppColors.backgroundAccent,
                  radius: 48,
                  child: const Icon(
                    LucideIcons.door_open,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Il periodo è finito!",
                      style: AppTypography.pageTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ecco cosa puoi fare ora:",
                      style: AppTypography.pageSubtitle.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SettingsTile(
                  icon: LucideIcons.chart_column,
                  title: "Statistiche periodo precedente",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LatestPeriodReport(),
                      ),
                    );
                  }
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePeriodPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Crea un nuovo periodo',
                    style: AppTypography.containerTitle.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}