import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../global.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';
import '../../widgets/settings_tile.dart';
import 'edit_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  final double budget;

  const ProfilePage({super.key, required this.budget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Il tuo profilo"),
      ),
      body: userProfileAsyncValue.when(
        loading: () => _buildLoadingScreen(context),
        error: (error, stackTrace) => _buildErrorScreen(context, error),
        data: (userProfile) => _buildProfileContent(
          context,
          ref,
          userProfile,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return PagePadding(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            const CircularProgressIndicator(),
            Text(
              "Caricamento profilo...",
              style: AppTypography.containerBody,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, Object error) {
    return PagePadding(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            Icon(LucideIcons.badge_alert, size: 48, color: AppColors.white),
            Text(
              "Errore nel caricamento del profilo",
              style: AppTypography.containerTitle,
              textAlign: TextAlign.center,
            ),
            Text(
              error.toString(),
              style: AppTypography.containerBody,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Indietro"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context,
      WidgetRef ref,
      UserProfile userProfile,
      ) {
    return PagePadding(
      child: Center(
        child: Column(
          spacing: 40,
          children: [
            Column(
              spacing: 24,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/f9/b6/ee/f9b6ee085996dee0e22ddc52dda03ac2.jpg',
                  ),
                ),
                Column(
                  spacing: 8,
                  children: [
                    Text(userProfile.displayName, style: AppTypography.username, textAlign: TextAlign.center),
                    Text(userProfile.email, style: AppTypography.userEmailSubtitle, textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
            Column(
              spacing: 16,
              children: [
                // budget
                AppContainer(
                  width: double.infinity,
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.banknote, color: AppColors.white),
                          const SizedBox(width: 10),
                          Text(
                            "Budget",
                            style: AppTypography.containerTitle,
                          ),
                        ],
                      ),
                      SelectableText(
                        "$budget$currency",
                        style: AppTypography.budgetIndicator,
                      ),
                    ],
                  ),
                ),

                // UUID
                AppContainer(
                  width: double.infinity,
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 16,
                        children: [
                          const Icon(LucideIcons.fingerprint_pattern, color: AppColors.white),
                          Expanded(
                            child: Column(
                              spacing: 2,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ID utente",
                                  style: AppTypography.containerTitle,
                                ),
                                Text(
                                  "Clicca per copiare",
                                  style: AppTypography.containerBody,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: userProfile.id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("ID copiato negli appunti")),
                              );
                            },
                            icon: const Icon(LucideIcons.copy),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // settings
                AppContainer(
                  width: double.infinity,
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingsTile(
                        icon: LucideIcons.pencil,
                        title: "Modifica profilo",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                userUuid: userProfile.id,
                                initialName: userProfile.displayName,
                              ),
                            ),
                          );
                        },
                      ),
                      SettingsTile(
                        icon: LucideIcons.lock,
                        title: "Sicurezza Account",
                        onTap: () {},
                      ),
                      SettingsTile(
                        icon: LucideIcons.log_out,
                        title: "Logout",
                        onTap: () async {
                          await Supabase.instance.client.auth.signOut();
                          if (!context.mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const AuthService()),
                                (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
