import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import 'auth/login.dart';
import 'main_shell_screen.dart';
import 'periods/create_period_page.dart';
import 'periods/period_ended_page.dart';
import '../providers/user_period_providers.dart';

class InitialPage extends ConsumerWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const LoginPage();
    }

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
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            body: Center(
              child: Text('Errore nel caricamento dei periodi: $error'),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Errore nel caricamento del periodo attivo: $error'),
        ),
      ),
    );
  }
}