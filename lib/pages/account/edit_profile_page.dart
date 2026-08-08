import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/repositories/profile_repository.dart';
import 'package:influx/widgets/app_container.dart';
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
  late final TextEditingController _customUrlController;
  bool _isLoading = false;

  final Map<String, List<String>> _avatarCategories = {
    'Pianeti': [
      'https://api.dicebear.com/10.x/planets/png?seed=767jctjk',
      'https://api.dicebear.com/10.x/planets/png?seed=ywdn3cf9',
      'https://api.dicebear.com/10.x/planets/png?seed=2hxz7h9l',
      'https://api.dicebear.com/10.x/planets/png?seed=0m8j8sj9',
      'https://api.dicebear.com/10.x/planets/png?seed=9z1trx08',
      'https://api.dicebear.com/10.x/planets/png?seed=fsjizwb3',
    ],
    'Pixelbot': [
      'https://api.dicebear.com/10.x/pixelbot/png?seed=Felix',
      'https://api.dicebear.com/10.x/pixelbot/png?seed=ur6k4ocy',
      'https://api.dicebear.com/10.x/pixelbot/png?seed=8tfpkslj',
      'https://api.dicebear.com/10.x/pixelbot/png?seed=vvr8z78k',
      'https://api.dicebear.com/10.x/pixelbot/png?seed=n3wm95ms',
      'https://api.dicebear.com/10.x/pixelbot/png?seed=rxzwpyqm',
    ],
    'Avataaars': [
      'https://api.dicebear.com/10.x/avataaars/png?seed=Alexander',
      'https://api.dicebear.com/10.x/avataaars/png?seed=Emery',
      'https://api.dicebear.com/10.x/avataaars/png?seed=Jordan',
      'https://api.dicebear.com/10.x/avataaars/png?seed=Taylor',
      'https://api.dicebear.com/10.x/avataaars/png?seed=Morgan',
      'https://api.dicebear.com/10.x/avataaars/png?seed=Riley',
    ],
    'Illustrazioni': [
      'https://api.dicebear.com/10.x/lorelei/png?seed=Sasha',
      'https://api.dicebear.com/10.x/lorelei/png?seed=Sam',
      'https://api.dicebear.com/10.x/lorelei/png?seed=Casey',
      'https://api.dicebear.com/10.x/lorelei/png?seed=Dakota',
      'https://api.dicebear.com/10.x/lorelei/png?seed=Alexis',
      'https://api.dicebear.com/10.x/lorelei/png?seed=Avery',
    ],
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _avatarUrlController = TextEditingController(text: widget.initialAvatarUrl ?? '');
    _customUrlController = TextEditingController(text: widget.initialAvatarUrl ?? '');

    _avatarUrlController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarUrlController.dispose();
    _customUrlController.dispose();
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

  /// Opens a BottomSheet allowing the user to select preset avatars or enter a custom web URL
  void _openAvatarPicker() {
    _customUrlController.text = _avatarUrlController.text;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ListView(
                controller: scrollController,
                children: [
                  const Text(
                    'Scegli un Avatar',
                    style: AppTypography.containerTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Custom Web Image URL Section
                  AppContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'URL Personalizzato',
                          style: AppTypography.containerTitle,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: TextField(
                                  controller: _customUrlController,
                                  decoration: InputDecoration(
                                    hintText: 'https://example.com/image.png',
                                    filled: true,
                                    fillColor: AppColors.inputBackground,
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
                                        color: AppColors.inputBorder,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              icon: const Icon(LucideIcons.check),
                              onPressed: () {
                                final text = _customUrlController.text.trim();
                                if (text.isNotEmpty && (text.startsWith('http://') || text.startsWith('https://'))) {
                                  _avatarUrlController.text = text;
                                  Navigator.pop(context);
                                }
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.btnBackground,
                                foregroundColor: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Preset Categories
                  ..._avatarCategories.entries.map((category) {
                    return Column(
                      children: [
                        AppContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  category.key,
                                  style: AppTypography.containerTitle,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: category.value.length,
                                itemBuilder: (context, index) {
                                  final avatarUrl = category.value[index];
                                  return GestureDetector(
                                    onTap: () {
                                      _avatarUrlController.text = avatarUrl;
                                      Navigator.pop(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 36,
                                      backgroundImage: NetworkImage(avatarUrl),
                                      backgroundColor: AppColors.white.withValues(alpha: 0.1),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatarPreview() {
    final url = _avatarUrlController.text.trim();
    final hasValidUrl = url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'));

    return Center(
      child: GestureDetector(
        onTap: _openAvatarPicker,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatarPreview(),
                const SizedBox(height: 24),

                const Text(
                  'Nome completo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller: _nameController,
                    // decoration: InputDecoration(
                    //   filled: true,
                    //   fillColor: AppColors.inputBackground,
                    //   enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //     borderSide: const BorderSide(
                    //       color: AppColors.inputBorder,
                    //       width: 1,
                    //     ),
                    //   ),
                    //   focusedBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //     borderSide: const BorderSide(
                    //       color: AppColors.inputBorder,
                    //       width: 2,
                    //     ),
                    //   ),
                    // ),
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
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
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