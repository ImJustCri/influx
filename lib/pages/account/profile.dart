import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/app_container.dart';
import '../../constants.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';
import '../../widgets/settings_tile.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String userUuid;
  final double budget;

  const ProfilePage({super.key, required this.userUuid, required this.budget});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Il tuo profilo"),
      ),
      body: PagePadding(
        child: Center(
          child: Column(
            spacing: 40,
            children: [
              Column(
                spacing: 24,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage('https://i.pinimg.com/736x/f9/b6/ee/f9b6ee085996dee0e22ddc52dda03ac2.jpg'),
                  ),
                  Column(
                    spacing: 8,
                    children: [
                      Text("Mario Rossi", style: AppTypography.username),
                      Text("mariorossi@gmail.com", style: AppTypography.userEmailSubtitle),
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
                          "${widget.budget}$currency",
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
                            Column(
                              spacing: 2,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ID utente",
                                  style: AppTypography.containerTitle,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: widget.userUuid));
                                  },
                                  child: SelectableText(
                                    widget.userUuid,
                                    style: AppTypography.containerBody,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),

                      ],
                    ),
                  ),

                  Column(
                    spacing: 16,
                    children: [
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
                                      userUuid: 'user-uuid-here',
                                      initialName: 'Mario Rossi',
                                    ),
                                  ),
                                );
                              },
                            ),
                            SettingsTile(
                              icon: LucideIcons.lock,
                              title: "Sicurezza Account",
                              onTap: () {
                              },
                            ),
                            SettingsTile(
                              icon: LucideIcons.log_out,
                              title: "Logout",
                              onTap: () {
                                // logout action
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}