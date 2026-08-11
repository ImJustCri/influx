import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';

class DeleteAccountBottomSheet extends StatelessWidget {
  const DeleteAccountBottomSheet({super.key});

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
            'Sei sicuro di voler eliminare il tuo account? Questa azione è irreversibile e rimuoverà i tuoi dati.',
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
                    backgroundColor: WidgetStatePropertyAll(AppColors.containerBackground),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Annulla',
                    style: AppTypography.containerTitle,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                  ),
                  child: const Text(
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