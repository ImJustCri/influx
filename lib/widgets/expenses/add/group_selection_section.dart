import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import '../../../providers/groups_provider.dart';
import '../../../theme.dart';

class GroupSelectionSection extends ConsumerWidget {
  final bool isGroup;
  final String? selectedGroupId;
  final ValueChanged<bool> onToggleChanged;
  final ValueChanged<String?> onGroupSelected;

  const GroupSelectionSection({
    super.key,
    required this.isGroup,
    required this.selectedGroupId,
    required this.onToggleChanged,
    required this.onGroupSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);

    return Column(
      children: [
        // Group Expense Toggle Card
        AppContainer(
          customBorderRadius: isGroup
              ? const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          )
              : null, // default radius when toggle is off
          width: double.infinity,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.btnBackground.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.users_round,
                  size: 20,
                  color: AppColors.btnBackground,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Spesa di Gruppo',
                  style: AppTypography.containerTitle,
                ),
              ),
              Switch(
                value: isGroup,
                activeThumbColor: AppColors.btnBackground,
                onChanged: onToggleChanged,
              ),
            ],
          ),
        ),

        // Display Groups List if Toggle is Enabled
        if (isGroup)
          AppContainer(
            customBorderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
              topLeft: Radius.zero,
              topRight: Radius.zero,
            ),
            padding: const EdgeInsets.all(0),
            child: groupsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) {
                debugPrint("Groups Provider Error: $error");
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Errore nel caricamento dei gruppi',
                      style: AppTypography.containerBody,
                    ),
                  ),
                );
              },
              data: (groups) {
                if (groups.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        "Nessun gruppo trovato",
                        style: AppTypography.containerBody,
                      ),
                    ),
                  );
                }

                return Column(
                  children: groups.map((group) {
                    final isSelected = selectedGroupId == group.id;

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      tileColor: isSelected
                          ? AppColors.btnBackground.withValues(alpha: 0.1)
                          : Colors.transparent,
                      leading: const Icon(
                        LucideIcons.users,
                        color: AppColors.btnBackground,
                      ),
                      title: Text(
                        group.name,
                        style: AppTypography.containerTitle,
                      ),
                      subtitle: Text(
                        'Membri: ${group.maxMembers}',
                        style: AppTypography.containerBody.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                        LucideIcons.check,
                        color: AppColors.btnBackground,
                      )
                          : null,
                      onTap: () => onGroupSelected(group.id),
                    );
                  }).toList(),
                );
              },
            ),
          ),
      ],
    );
  }
}