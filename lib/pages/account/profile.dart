import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/profile.dart';
import '../../providers/profile_provider.dart';
import '../../services/auth_service.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';
import '../../widgets/settings_tile.dart';
import '../../widgets/user_qr_dialog.dart';
import 'edit_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Il tuo profilo"),
      ),
      body: userProfileAsyncValue.when(
        loading: () => _buildLoadingScreen(context),
        error: (error, stackTrace) => _buildErrorScreen(context, error),
        data: (userProfile) {
          if (userProfile == null) {
            return const PagePadding(
              child: Center(
                child: Text("Profilo non trovato"),
              ),
            );
          }
          return _buildProfileContent(
            context,
            ref,
            userProfile,
          );
        },
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 24,
        children: [
          const Icon(LucideIcons.badge_alert, size: 48, color: AppColors.white),
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
        ],
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context,
      WidgetRef ref,
      Profile userProfile,
      ) {
    final userEmail = Supabase.instance.client.auth.currentUser?.email ?? 'Nessuna email';

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
                    userProfile.avatarUrl ?? 'https://i.pinimg.com/736x/f9/b6/ee/f9b6ee085996dee0e22ddc52dda03ac2.jpg',
                  ),
                ),
                Column(
                  spacing: 8,
                  children: [
                    Text(userProfile.fullName!, style: AppTypography.username, textAlign: TextAlign.center),
                    Text(userEmail, style: AppTypography.userEmailSubtitle, textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
            Column(
              spacing: 16,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => UserQrDialog(userId: userProfile.id),
                    );
                  },
                  child: AppContainer(
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
                                  const Text(
                                    "ID utente",
                                    style: AppTypography.containerTitle,
                                  ),
                                  Text(
                                    "Mostra QR Code",
                                    style: AppTypography.containerBody,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.chevron_right, color: Colors.white54),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Azioni", style: AppTypography.containerBody),
                    const SizedBox(height: 4),
                    SettingsTile(
                      icon: LucideIcons.pencil,
                      title: "Modifica profilo",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              userUuid: userProfile.id,
                              initialName: userProfile.fullName!,
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
              ],
            )
          ],
        ),
      ),
    );
  }
}