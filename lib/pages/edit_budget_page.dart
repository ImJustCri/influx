import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/app_container.dart';
import '../../theme.dart';
import '../widgets/page_padding.dart';

class EditBudgetPage extends StatefulWidget {
  final double initialBudget;
  final DateTime initialResetDate;
  final bool isGroup;

  const EditBudgetPage({
    super.key,
    required this.initialBudget,
    required this.initialResetDate,
    this.isGroup = false,
  });

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  late TextEditingController budgetController;
  late DateTime selectedResetDate;

  @override
  void initState() {
    super.initState();
    // Mostra 0 decimali se la cifra è tonda, altrimenti ne mostra 2
    final formattedInitial = widget.initialBudget % 1 == 0
        ? widget.initialBudget.toInt().toString()
        : widget.initialBudget.toStringAsFixed(2);

    budgetController = TextEditingController(text: formattedInitial);
    selectedResetDate = widget.initialResetDate;
  }

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedResetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.btnBackground,
              onPrimary: AppColors.white,
              surface: AppColors.inputBackground,
              onSurface: AppColors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: AppColors.inputBackground),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedResetDate = picked;
      });
    }
  }

  void _saveBudget() {
    final cleanText = budgetController.text.replaceAll(',', '.');
    final newBudget = double.tryParse(cleanText);

    if (newBudget != null && newBudget > 0) {
      Navigator.pop(context, {
        'budget': newBudget,
        'resetDate': selectedResetDate,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci un budget valido'),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
    }
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
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                spacing: 24,
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
                          style: AppTypography.containerBody
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        'Data Reset',
                        style: AppTypography.containerBody,
                      ),
                      InkWell(
                        onTap: _selectDate,
                        borderRadius: BorderRadius.circular(32),
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
                                      'Rinnovo ogni mese il',
                                      style: AppTypography.containerBody.copyWith(
                                        fontSize: 12,
                                        color: AppColors.white.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    Text(
                                      '${selectedResetDate.day} ${_getMonthName(selectedResetDate.month)}',
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveBudget,
                child: Text(
                  'Salva modifiche',
                  style: AppTypography.containerTitle.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
    return months[month - 1];
  }
}