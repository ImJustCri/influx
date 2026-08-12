import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/app_version.dart';
import '../../theme.dart';

class UpdateAppPage extends ConsumerWidget {
  final AppVersion appVersion;

  const UpdateAppPage({
    super.key,
    required this.appVersion,
  });

  Future<void> _launchUpdateUrl(BuildContext context) async {
    final Uri url = Uri.parse(appVersion.downloadUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossibile aprire il link di aggiornamento.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: PagePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Icon Section
                Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.backgroundAccent,
                    radius: 48,
                    child: const Icon(
                      LucideIcons.download,
                      color: AppColors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Header Titles
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Aggiornamento richiesto",
                        style: AppTypography.pageTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "È disponibile una nuova versione dell'applicazione (${appVersion.versionName}). Per continuare ad utilizzare l'app, scarica l'ultimo aggiornamento.",
                        style: AppTypography.pageSubtitle.copyWith(
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Release Notes Card (if present)
                if (appVersion.releaseNotes != null &&
                    appVersion.releaseNotes!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.inputBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.sparkles,
                              size: 18,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Novità di questa versione',
                              style: AppTypography.containerTitle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          appVersion.releaseNotes!,
                          style: AppTypography.pageSubtitle.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _launchUpdateUrl(context),
                    child: Text(
                      'Aggiorna Ora',
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
      ),
    );
  }
}