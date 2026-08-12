import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:influx/theme.dart';

class ChangeEmailBottomSheet extends StatefulWidget {
  const ChangeEmailBottomSheet({super.key});

  @override
  State<ChangeEmailBottomSheet> createState() => _ChangeEmailBottomSheetState();
}

class _ChangeEmailBottomSheetState extends State<ChangeEmailBottomSheet> {
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final currentEmail = Supabase.instance.client.auth.currentUser?.email ?? '';
    _emailController = TextEditingController(text: currentEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail() async {
    final newEmail = _emailController.text.trim();

    if (newEmail.isEmpty || !newEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci un indirizzo email valido.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: newEmail),
      );

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email inviata! Controlla la tua casella di posta per confermare.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore: ${error.message}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Si è verificato un errore inaspettato.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.btnBackground,
            child: Icon(
              LucideIcons.mails,
              size: 32,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Cambia Indirizzo Email',
            textAlign: TextAlign.center,
            style: AppTypography.pageTitle,
          ),
          const SizedBox(height: 16),
          const Text(
            'Riceverai una mail con un link per confermare il tuo nuovo indirizzo email.',
            textAlign: TextAlign.center,
            style: AppTypography.pageSubtitle,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            decoration: const InputDecoration(
              hintText: 'Nuova email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.containerBackground),
                  ),
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Annulla', style: AppTypography.containerBody),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateEmail,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                      : const Text('Invia Email', style: AppTypography.containerTitle),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}