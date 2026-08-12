import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/pages/simple_loading_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../providers/app_version_providers.dart';
import '../providers/package_info_provider.dart';
import 'auth/login.dart';
import 'main_shell_screen.dart';
import 'periods/create_period_page.dart';
import 'periods/period_ended_page.dart';
import '../providers/periods/user_period_providers.dart';
import 'update_app_page.dart';

class InitialPage extends ConsumerWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfoAsync = ref.watch(packageInfoProvider);
    final latestVersionAsync = ref.watch(latestAppVersionProvider);

    return packageInfoAsync.when(
      data: (packageInfo) {
        final currentVersion = packageInfo.version;

        return latestVersionAsync.when(
          data: (latestVersion) {
            if (latestVersion != null && latestVersion.versionCode != currentVersion) {
              return UpdateAppPage(appVersion: latestVersion);
            }

            // 2. Check authentication
            final session = Supabase.instance.client.auth.currentSession;
            if (session == null) {
              return const LoginPage();
            }

            // 3. Check period state
            final activePeriodAsync = ref.watch(activeUserPeriodProvider);
            final allPeriodsAsync = ref.watch(allUserPeriodsProvider);

            return activePeriodAsync.when(
              data: (activePeriod) {
                if (activePeriod != null) {
                  return const MainShellScreen();
                }

                return allPeriodsAsync.when(
                  data: (periods) {
                    if (periods.isEmpty) {
                      return const CreatePeriodPage();
                    }
                    return const PeriodEndedPage();
                  },
                  loading: () => const PulsingLogoLoadingScreen(),
                  error: (error, stack) => Scaffold(
                    body: Center(
                      child: Text('Errore nel caricamento dei periodi: $error'),
                    ),
                  ),
                );
              },
              loading: () => const PulsingLogoLoadingScreen(),
              error: (error, stack) => Scaffold(
                body: Center(
                  child: Text('Errore nel caricamento del periodo attivo: $error'),
                ),
              ),
            );
          },
          loading: () => const PulsingLogoLoadingScreen(),
          error: (error, stack) => Scaffold(
            body: Center(
              child: Text('Errore nel controllo della versione dell\'app: $error'),
            ),
          ),
        );
      },
      loading: () => const PulsingLogoLoadingScreen(),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Errore nel recupero info pacchetto: $error'),
        ),
      ),
    );
  }
}