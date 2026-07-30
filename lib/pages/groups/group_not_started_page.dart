import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/models/group.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../providers/group_members_provider.dart';
import '../../widgets/group/members_tile_view.dart';

class GroupNotStartedPage extends ConsumerWidget {
  final Group group;

  const GroupNotStartedPage({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(fetchGroupMembersProvider(group.id));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: membersAsync.when(
        data: (members) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PagePadding(
                child: Column(
                  spacing: 24,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Center(
                                child: CircleAvatar(
                                  backgroundColor: AppColors.backgroundAccent,
                                  radius: 48,
                                  child: Icon(
                                    LucideIcons.clock,
                                    color: AppColors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                group.name,
                                style: AppTypography.pageTitle,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                textAlign: TextAlign.center,
                                "Il gruppo non è ancora attivo. Ti invieremo una notifica quando il proprietario lo avvierà",
                                style: AppTypography.pageSubtitle.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        AppContainer(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: List.generate(
                              members.length,
                                  (index) => MemberTileView(
                                member: members[index], groupId: group.id,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Errore durante il caricamento dei membri: $error',
              style: AppTypography.pageSubtitle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}