import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:influx/widgets/settings_tile.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  late TextEditingController _emailController;

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

  void _showChangeEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Cambia Indirizzo Email',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Text(
              'Riceverai un codice OTP di verifica sulla nuova email.',
            ),
            TextField(
              controller: _emailController,
              style: AppTypography.containerBody,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Nuova email',
                hintStyle: AppTypography.containerBody.copyWith(
                  color: AppColors.white.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.btnBackground, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annulla', style: AppTypography.containerBody),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.btnBackground,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Codice di verifica inviato alla nuova email'),
                ),
              );
            },
            child: Text(
              'Invia OTP',
            ),
          ),
        ],
      ),
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
                  Text(
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
                    'Dispositivi',
                    style: AppTypography.containerBody,
                  ),
                  const SizedBox(height: 4),
                  SettingsTile(
                    icon: LucideIcons.smartphone,
                    title: 'Sessioni attive',
                    onTap: () {
                      //todo
                    },
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
    return AppContainer(
      width: double.infinity,
      child: InkWell(
        onTap: () => _showDeleteConfirmationDialog(context),
        child: const Row(
          children: [
            Icon(LucideIcons.trash_2, color: Color(0xFFFF5252)),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Elimina account',
                style: TextStyle(
                  color: Color(0xFFFF5252),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(LucideIcons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Elimina account',
        ),
        content: Text(
          'Sei sicuro di voler eliminare il tuo account? Questa azione è irreversibile e rimuoverà i tuoi dati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Elimina',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}