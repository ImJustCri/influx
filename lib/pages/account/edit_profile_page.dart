import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';

class EditProfilePage extends StatefulWidget {
  final String userUuid;
  final String initialName;

  const EditProfilePage({
    super.key,
    required this.userUuid,
    required this.initialName,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _nameController.addListener(_checkModified);
  }

  void _checkModified() {
    setState(() {
      _isModified = _nameController.text != widget.initialName;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profilo aggiornato con successo')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica profilo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Column(
            spacing: 64,
            children: [
              Column(
                spacing: 24,
                children: [
                  Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome completo',
                        style: AppTypography.containerTitle,
                      ),
                      TextField(
                        controller: _nameController,
                        style: AppTypography.containerBody,
                        decoration: InputDecoration(
                          hintText: 'Inserisci il tuo nome',
                          hintStyle: AppTypography.containerBody.copyWith(
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.btnBackground,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isModified ? _saveChanges : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnBackground,
                    disabledBackgroundColor: AppColors.btnBackground.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.btnBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Salva modifiche',
                    style: AppTypography.containerTitle.copyWith(
                      color: _isModified
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}