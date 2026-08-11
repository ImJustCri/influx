import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';

class ChangeEmailBottomSheet extends StatefulWidget {
  const ChangeEmailBottomSheet({super.key});

  @override
  State<ChangeEmailBottomSheet> createState() => _ChangeEmailBottomSheetState();
}

class _ChangeEmailBottomSheetState extends State<ChangeEmailBottomSheet> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'utente@example.com');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
            'Riceverai una mail con un link per modificare il tuo indirizzo email.',
            textAlign: TextAlign.center,
            style: AppTypography.pageSubtitle,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annulla', style: AppTypography.containerBody),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email inviata'),
                      ),
                    );
                  },
                  child: const Text('Invia Email', style: AppTypography.containerTitle),
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