import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';

class EditProfilePage extends StatefulWidget {
  final String userUuid;
  final String initialName;
  final String? initialAvatarUrl;

  const EditProfilePage({
    super.key,
    required this.userUuid,
    required this.initialName,
    this.initialAvatarUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _avatarUrlController;

  static const String _defaultAvatarUrl =
      'https://i.pinimg.com/736x/f9/b6/ee/f9b6ee085996dee0e22ddc52dda03ac2.jpg';

  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _avatarUrlController = TextEditingController(
      text: widget.initialAvatarUrl ?? '',
    );

    _nameController.addListener(_checkModified);
    _avatarUrlController.addListener(_checkModified);
  }

  void _checkModified() {
    final nameChanged = _nameController.text != widget.initialName;
    final avatarChanged =
        _avatarUrlController.text != (widget.initialAvatarUrl ?? '');

    setState(() {
      _isModified = nameChanged || avatarChanged;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarUrlController.dispose();
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
    final currentAvatarUrl = _avatarUrlController.text.isNotEmpty
        ? _avatarUrlController.text
        : (widget.initialAvatarUrl ?? _defaultAvatarUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica profilo'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Column(
            spacing: 40,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(currentAvatarUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.btnBackground,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.camera,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 8,
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

                  Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'URL Immagine Profilo',
                        style: AppTypography.containerTitle,
                      ),
                      TextField(
                        controller: _avatarUrlController,
                        style: AppTypography.containerBody,
                        decoration: InputDecoration(
                          hintText: 'Inserisci URL immagine',
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