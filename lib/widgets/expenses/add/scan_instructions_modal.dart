import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';

import 'instructions_row.dart';

class ScanInstructionsModal extends StatelessWidget {
  const ScanInstructionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Scansione dello scontrino',
            style: AppTypography.containerTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          InstructionRow(
            icon: LucideIcons.file_check,
            title: 'Scontrino integro',
            subtitle: 'Assicurati che non sia stropicciato o piegato.',
          ),
          const SizedBox(height: 12),
          InstructionRow(
            icon: LucideIcons.ruler,
            title: 'Lunghezza contenuta',
            subtitle: 'Scontrini troppo lunghi potrebbero non venire letti correttamente.',
          ),
          const SizedBox(height: 12),
          InstructionRow(
            icon: LucideIcons.sun,
            title: 'Buona illuminazione',
            subtitle: 'Inquadra lo scontrino in un ambiente ben illuminato.',
          ),
          const SizedBox(height: 28),

          // Bottone d'azione
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Ho capito',
                style: AppTypography.containerTitle.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}