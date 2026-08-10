import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../providers/groups/groups_provider.dart';
import '../../../providers/periods/group_period_providers.dart';
import '../../../theme.dart';

class EditGroupPage extends ConsumerStatefulWidget {
  final String groupId;
  final String initialName;
  final double? initialTotalBudget;
  final int memberCount;

  const EditGroupPage({
    super.key,
    required this.groupId,
    required this.initialName,
    required this.memberCount,
    this.initialTotalBudget,
  });

  @override
  ConsumerState<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends ConsumerState<EditGroupPage> {
  late TextEditingController groupNameController;
  late TextEditingController totalBudgetController;

  DateTime selectedEndDate = DateTime.now().add(const Duration(days: 30));
  double _perCapitaBudget = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    groupNameController = TextEditingController(text: widget.initialName);
    totalBudgetController = TextEditingController(
      text: widget.initialTotalBudget != null
          ? widget.initialTotalBudget.toString()
          : '',
    );

    _calculatePerCapita();
    totalBudgetController.addListener(_calculatePerCapita);
  }

  void _calculatePerCapita() {
    final total =
        double.tryParse(totalBudgetController.text.trim().replaceAll(',', '.')) ??
            0.0;
    setState(() {
      _perCapitaBudget = widget.memberCount > 0 ? total / widget.memberCount : 0.0;
    });
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.btnBackground,
              onPrimary: AppColors.white,
              surface: AppColors.inputBackground,
              onSurface: AppColors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.inputBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  @override
  void dispose() {
    totalBudgetController.removeListener(_calculatePerCapita);
    groupNameController.dispose();
    totalBudgetController.dispose();
    super.dispose();
  }

  Future<void> _updateGroup() async {
    final name = groupNameController.text.trim();
    final totalBudget =
    double.tryParse(totalBudgetController.text.trim().replaceAll(',', '.'));

    if (name.isEmpty || totalBudget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci valori validi per tutti i campi.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      await supabase.from('group').update({
        'name': name,
      }).eq('id', widget.groupId);

      ref.invalidate(groupsProvider);
      ref.invalidate(activeGroupPeriodProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gruppo aggiornato con successo!'),
          ),
        );

        Navigator.of(context).pop({
          'totalBudget': totalBudget,
          'perCapitaBudget': _perCapitaBudget,
          'endDate': selectedEndDate,
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante la modifica: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 72,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: PagePadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: AppColors.backgroundAccent,
                  radius: 48,
                  child: const Icon(
                    LucideIcons.pencil,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Modifica gruppo",
                      style: AppTypography.pageTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Aggiorna i dettagli del gruppo.",
                      textAlign: TextAlign.center,
                      style: AppTypography.pageSubtitle.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              TextFormField(
                keyboardType: TextInputType.text,
                controller: groupNameController,
                decoration: InputDecoration(
                  hintText: "Nome del gruppo",
                  hintStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
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
              const SizedBox(height: 16),

              AppContainer(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      'Budget disponibile',
                      style: AppTypography.containerBody,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: totalBudgetController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: AppTypography.budgetIndicator,
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: AppTypography.budgetIndicator.copyWith(
                                color: AppColors.white.withValues(alpha: 0.3),
                              ),
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ),
                        Text(
                          '€ ',
                          style: AppTypography.budgetIndicator.copyWith(
                            color: AppColors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.inputBorder, height: 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget Pro Capite (${widget.memberCount} membri):',
                          style: AppTypography.containerBody.copyWith(
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          '${_perCapitaBudget.toStringAsFixed(2)} €',
                          style: AppTypography.containerBody.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(24),
                child: AppContainer(
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
                          LucideIcons.calendar,
                          size: 20,
                          color: AppColors.btnBackground,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              'Fine del periodo',
                              style: AppTypography.containerBody.copyWith(
                                fontSize: 12,
                                color: AppColors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            Text(
                              DateFormat('d MMMM yyyy', 'it_IT')
                                  .format(selectedEndDate),
                              style: AppTypography.containerTitle,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        LucideIcons.chevron_right,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: !_isLoading ? _updateGroup : null,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                      : Text(
                    'Salva',
                    style: AppTypography.containerTitle.copyWith(
                      color: AppColors.white,
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