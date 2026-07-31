import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../theme.dart';

class UserQrDialog extends StatelessWidget {
  final String userId;

  const UserQrDialog({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "ID dell'utente",
            style: AppTypography.containerTitle,
          ),
          const SizedBox(height: 8),
          SelectableText(
            userId,
            style: AppTypography.containerBody,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Clean white QR Code
          QrImageView(
            data: userId,
            version: QrVersions.auto,
            size: 192,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.white,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: userId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("ID copiato negli appunti"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(LucideIcons.copy, size: 18, color: AppColors.white),
              label: const Text("Copia ID", style: TextStyle(color: AppColors.white)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}