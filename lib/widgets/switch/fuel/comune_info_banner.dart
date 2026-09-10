import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/app_container.dart';

class ComuneInfoBanner extends StatelessWidget {
  const ComuneInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Row(
        children: [
          const Icon(
            LucideIcons.info,
            size: 14,
            color: AppColors.whiteDim,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Se vuoi cambiare il tuo comune predefinito, puoi farlo nelle impostazioni alla sezione \"Preferenze\".",
              style: AppTypography.containerBody.copyWith(
                color: AppColors.whiteDim,
              ),
            ),
          ),
        ],
      ),
    );
  }
}