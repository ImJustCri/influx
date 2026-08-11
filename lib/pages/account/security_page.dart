import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/change_email_bottom_sheet.dart';
import 'package:influx/widgets/delete_account_bottom_sheet.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  void _showChangeEmailDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ChangeEmailBottomSheet(),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const DeleteAccountBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sicurezza Account'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Column(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Credenziali di accesso',
                    style: AppTypography.containerBody,
                  ),
                  const SizedBox(height: 4),
                  SettingsTile(
                    icon: LucideIcons.mail,
                    title: 'Cambia email',
                    onTap: () => _showChangeEmailDialog(context),
                  ),
                ],
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zona di pericolo',
                    style: AppTypography.containerBody.copyWith(
                      color: AppColors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildDeleteAccountTile(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountTile(BuildContext context) {
    return SettingsTile(
      icon: LucideIcons.trash,
      title: 'Elimina account',
      onTap: () => _showDeleteConfirmationDialog(context),
      iconColor: Colors.redAccent,
      textColor: Colors.redAccent,
      splashColor: Colors.redAccent.withValues(alpha: 0.15),
    );
  }
}