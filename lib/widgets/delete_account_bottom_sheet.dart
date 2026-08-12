import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/pages/initial_page.dart';
import 'package:influx/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class DeleteAccountBottomSheet extends StatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  State<DeleteAccountBottomSheet> createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState extends State<DeleteAccountBottomSheet> {
  bool _isLoading = false;

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      final res = await supabase.functions.invoke(
        'delete-account',
        body: {'userId': supabase.auth.currentUser!.id},
      );

      if (res.status != 200) {
        throw Exception('Errore della funzione (${res.status})');
      }

      await supabase.auth.signOut();

      if (!mounted) return;

      RootApp.restartApp(context);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const InitialPage()),
            (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Errore durante l'eliminazione dell'account: $error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Colors.redAccent,
            child: Icon(
              LucideIcons.trash,
              size: 32,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Elimina account',
            style: AppTypography.pageTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Sei sicuro di voler eliminare il tuo account? Questa azione è irreversibile e rimuoverà tutti i tuoi dati.',
            textAlign: TextAlign.center,
            style: AppTypography.pageSubtitle,
          ),
          const SizedBox(height: 32),
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.containerBackground,
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text(
                    'Annulla',
                    style: AppTypography.containerTitle,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _deleteAccount,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                      : const Text(
                    'Elimina',
                    style: AppTypography.containerTitle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}