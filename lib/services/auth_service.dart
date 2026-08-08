import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/pages/auth/login.dart';
import 'package:influx/pages/main_shell_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/periods/period_ended_page.dart';
import '../providers/user_period_providers.dart';


class AuthService extends ConsumerWidget {
  const AuthService({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const LoginPage();
    }

    final activePeriodAsync = ref.watch(activeUserPeriodProvider);

    return activePeriodAsync.when(
      data: (period) {
        if (period == null) {
          return const PeriodEndedPage();
        }
        return const MainShellScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Errore nel caricamento del periodo: $error'),
        ),
      ),
    );
  }

  Future<String?> loginWithEmail(String email_) async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email_,
      );
      return null;
    } on AuthException catch (e) {
      switch (e.message) {
        case "Unable to validate email address: invalid format":
          return "Formato email non valido";
        case "One of email or phone must be set":
          return "Inserisci l'email";
        default:
          return "Errore con il server. Riprova più tardi";
      }
    }
  }

  Future<String?> verifyEmailWithOtp(String otp_, String email_) async {
    try {
      await Supabase.instance.client.auth.verifyOTP(
        email: email_,
        token: otp_,
        type: OtpType.email,
      );
      return null;
    } on AuthException catch (e) {
      switch (e.message) {
        case "Verify requires either a token or a token hash":
          return "Inserisci il codice OTP";
        case "Token has expired or is invalid":
          return "Codice OTP non valido o scaduto";
        default:
          return "Errore con il server. Riprova più tardi";
      }
    }
  }

  Future<void> loginWithGoogle() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: "io.supabase.flutter://login-callback",
    );
  }
}