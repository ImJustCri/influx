import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../providers/periods/user_period_providers.dart';
import '../../theme.dart';
import '../../widgets/periods/period_overview_card.dart';
import '../../widgets/status_container.dart';

class PeriodsOverviewPage extends ConsumerWidget {
  const PeriodsOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodsAsync = ref.watch(allUserPeriodsProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: PagePadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Storico dei periodi", style: AppTypography.pageTitle),
              const SizedBox(height: 24),

              periodsAsync.when(
                data: (periods) {
                  final inactivePeriods = periods.where((p) => !p.isActive).toList();

                  if (inactivePeriods.isEmpty) {
                    return StatusContainer(
                      icon: LucideIcons.folder_open,
                      title: "Nessun periodo trovato",
                      description: "Non ci sono periodi passati salvati al momento.",
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: inactivePeriods.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final period = inactivePeriods[index];

                      final startDateFormatted = DateFormat('dd MMMM yyyy', 'it').format(period.createdAt);
                      final endDateFormatted = DateFormat('dd MMMM yyyy', 'it').format(period.endDate);

                      return PeriodOverviewCard(
                        periodStartDate: startDateFormatted,
                        periodEndDate: endDateFormatted,
                        spent: period.spent.toDouble(),
                        budget: period.budget.toDouble(),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    "Si è verificato un errore durante il caricamento.",
                    style: AppTypography.containerBody.copyWith(color: Colors.redAccent),
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