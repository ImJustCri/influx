import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';
import '../main_shell_screen.dart';

class CreatePeriodPage extends StatefulWidget {
  const CreatePeriodPage({super.key});

  @override
  State<CreatePeriodPage> createState() => _CreatePeriodPageState();
}

class _CreatePeriodPageState extends State<CreatePeriodPage> {
  final TextEditingController budgetController = TextEditingController();
  DateTime selectedEndDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
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

  Future<void> _createPeriod() async {
    final cleanText = budgetController.text.replaceAll(',', '.');
    final budget = double.tryParse(cleanText);

    if (budget == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci un budget valido'),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('Utente non autenticato');

      await Supabase.instance.client.from('userPeriod').insert({
        'profile_id': user.id,
        'budget': budget,
        'spent': 0,
        'isActive': true,
        'endDate': selectedEndDate.toIso8601String(),
      });

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainShellScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante la creazione: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuovo Periodo'),
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Input Section
              Text(
                'Importo budget',
                style: AppTypography.containerTitle,
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
                            controller: budgetController,
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
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // End Date Selection Section
              Text(
                'Periodo di calcolo',
                style: AppTypography.containerTitle,
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

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createPeriod,
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
                    'Crea un nuovo periodo',
                    style: AppTypography.containerTitle.copyWith(
                      fontSize: 14,
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