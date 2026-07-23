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
    budgetController = TextEditingController(text: widget.initialBudget.toString());
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
    );
    if (picked != null) {
      setState(() {
        selectedResetDate = picked;
      });
    }
  }

  void _saveBudget() {
    final newBudget = double.tryParse(budgetController.text);
    if (newBudget != null && newBudget > 0) {
      Navigator.pop(context, {
        'budget': newBudget,
        'resetDate': selectedResetDate,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci un budget valido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Modifica Budget', style: AppTypography.pageTitle),
      ),
      body: PagePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 24,
              children: [
                AppContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text('Budget', style: AppTypography.containerBody),
                      TextField(
                        controller: budgetController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTypography.budgetIndicator,
                        decoration: InputDecoration(
                          hintText: '0,00',
                          hintStyle: AppTypography.budgetIndicator.copyWith(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                AppContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text('Data Reset', style: AppTypography.containerTitle),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Row(
                          children: [
                            Icon(LucideIcons.calendar, size: 20, color: Colors.white.withValues(alpha: 0.6)),
                            const SizedBox(width: 8),
                            Text(
                              '${selectedResetDate.day} ${_getMonthName(selectedResetDate.month)}',
                              style: AppTypography.containerBody,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveBudget,
                child: Text('Salva', style: AppTypography.containerTitle),
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
