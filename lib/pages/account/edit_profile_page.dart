import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';

class EditProfilePage extends ConsumerStatefulWidget {
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
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _avatarUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _avatarUrlController = TextEditingController(text: widget.initialAvatarUrl ?? '');

    _avatarUrlController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final newAvatarUrl = _avatarUrlController.text.trim();

      // Perform update via ProfileRepository static method
      await ProfileRepository.updateProfile(
        supabase: supabase,
        userUuid: widget.userUuid,
        fullName: _nameController.text.trim(),
        avatarUrl: newAvatarUrl.isEmpty ? null : newAvatarUrl,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profilo aggiornato con successo!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante l\'aggiornamento: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildAvatarPreview() {
    final url = _avatarUrlController.text.trim();
    final hasValidUrl = url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'));

    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.white.withValues(alpha: 0.1),
            backgroundImage: hasValidUrl ? NetworkImage(url) : null,
            child: !hasValidUrl
                ? const Icon(LucideIcons.user, size: 48, color: Colors.white)
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.pencil,
              size: 16,
              color: Colors.black,
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
        title: const Text("Modifica profilo"),
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 24,
              children: [
                _buildAvatarPreview(),
                SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Inserisci un nome valido';
                    }
                    if (value.trim().length >= 15) {
                      return 'Il nome deve essere inferiore a 15 caratteri';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _avatarUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL Immagine Avatar',
                    hintText: 'https://example.com/avatar.png',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: _isLoading
                      ? Text('Salvataggio...', style: AppTypography.containerTitle)
                      : Text('Salva Modifiche', style: AppTypography.containerTitle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}