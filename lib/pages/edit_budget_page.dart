import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/pages/periods/period_ended_page.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/settings_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../widgets/page_padding.dart';

class EditBudgetPage extends StatefulWidget {
  final double totalExpenses;
  final double initialBudget;
  final bool isGroup;

  const EditBudgetPage({
    super.key,
    required this.initialBudget,
    this.isGroup = false,
    required this.totalExpenses,
  });

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  late TextEditingController budgetController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final formattedInitial = widget.initialBudget % 1 == 0
        ? widget.initialBudget.toInt().toString()
        : widget.initialBudget.toStringAsFixed(2);

    budgetController = TextEditingController(text: formattedInitial);
  }

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  /// Updates only the budget amount
  Future<void> _saveBudget(double newBudget) async {
    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('Utente non autenticato');

      await Supabase.instance.client
          .from('userPeriod')
          .update({'budget': newBudget})
          .eq('profile_id', user.id)
          .eq('isActive', true);

      if (!mounted) return;

      Navigator.pop(context, {
        'action': 'update_amount',
        'budget': newBudget,
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante il salvataggio: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Sets isActive to false and clears navigation tree
  Future<void> _endPeriod() async {
    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('Utente non autenticato');

      await Supabase.instance.client
          .from('userPeriod')
          .update({'isActive': false, 'spent': widget.totalExpenses, 'endDate': DateTime.now().toIso8601String()})
          .eq('profile_id', user.id)
          .eq('isActive', true);

      if (!mounted) return;

      // Clears the entire navigation stack and navigates to PeriodEndedPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PeriodEndedPage()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante la chiusura del periodo: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Dialog confirmation for ending the active period
  void _showEndPeriodConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma chiusura'),
          content: const Text(
            'Sei sicuro di voler terminare il periodo corrente? Questa azione non può essere annullata.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _endPeriod();
              },
              child: const Text(
                'Continua',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Submits budget updates
  void _onSubmitBudget() {
    final cleanText = budgetController.text.replaceAll(',', '.');
    final newBudget = double.tryParse(cleanText);

    if (newBudget == null || newBudget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci un budget valido'),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    _saveBudget(newBudget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica Budget'),
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PagePadding(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                controller: budgetController,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                style: AppTypography.budgetIndicator,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle:
                                  AppTypography.budgetIndicator.copyWith(
                                    color:
                                    AppColors.white.withValues(alpha: 0.3),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSubmitBudget,
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
                        'Salva budget',
                        style: AppTypography.containerTitle.copyWith(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                  const SizedBox(height: 24),

                  SettingsTile(
                    icon: LucideIcons.trash_2,
                    title: 'Termina periodo',
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    onTap: _isLoading ? () {} : _showEndPeriodConfirmation,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}