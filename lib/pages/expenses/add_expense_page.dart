import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../widgets/page_padding.dart';
import '../../widgets/expenses/add/group_selection_section.dart';

class AddExpensePage extends ConsumerStatefulWidget {
  final bool initialIsGroup;

  const AddExpensePage({
    super.key,
    this.initialIsGroup = false,
  });

  @override
  ConsumerState<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends ConsumerState<AddExpensePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  late bool isGroup;
  String? selectedCategory;
  String? selectedGroupId;
  bool _isLoading = false;

  final List<String> _categories = [
    'Spesa',
    'Trasporti',
    'Ristorazione',
    'Svago',
    'Casa',
    'Salute',
    'Altro',
  ];

  @override
  void initState() {
    super.initState();
    isGroup = widget.initialIsGroup;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    final name = nameController.text.trim();
    final cleanAmountText = amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(cleanAmountText);

    if (name.isEmpty) {
      _showSnackBar('Inserisci un nome per la spesa');
      return;
    }

    if (amount == null || amount <= 0) {
      _showSnackBar('Inserisci un importo valido');
      return;
    }

    if (selectedCategory == null) {
      _showSnackBar('Seleziona una categoria');
      return;
    }

    if (isGroup && selectedGroupId == null) {
      _showSnackBar('Seleziona un gruppo per la spesa');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('Utente non autenticato');

      final expenseData = {
        'user_id': user.id,
        'nome': name,
        'descrizione': descriptionController.text.trim(),
        'categoria': selectedCategory,
        'is_group': isGroup,
        'group_id': isGroup ? selectedGroupId : null,
        'importo': amount,
        'created_at': DateTime.now().toIso8601String(),
      };

      await Supabase.instance.client.from('spese').insert(expenseData);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Errore durante il salvataggio: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Spesa'),
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PagePadding(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount Input
                    AppContainer(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Text(
                            'Importo spesa',
                            style: AppTypography.containerBody,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: amountController,
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  style: AppTypography.budgetIndicator,
                                  decoration: InputDecoration(
                                    hintText: '0,00',
                                    hintStyle: AppTypography.budgetIndicator
                                        .copyWith(
                                      color: AppColors.white
                                          .withValues(alpha: 0.3),
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

                    // Name
                    AppContainer(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            'Nome',
                            style: AppTypography.containerTitle.copyWith(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            style: AppTypography.containerBody,
                            decoration: InputDecoration(
                              hintText: 'Es. Pranzo, Benzina...',
                              hintStyle: AppTypography.containerBody.copyWith(
                                color: AppColors.white.withValues(alpha: 0.3),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Description
                    AppContainer(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            'Descrizione',
                            style: AppTypography.containerTitle.copyWith(
                              fontSize: 12,
                              color: AppColors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          TextField(
                            controller: descriptionController,
                            style: AppTypography.containerTitle,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Aggiungi note...',
                              hintStyle: AppTypography.containerBody.copyWith(
                                color: AppColors.white.withValues(alpha: 0.3),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Category Selection
                    AppContainer(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.btnBackground
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              LucideIcons.tag,
                              size: 20,
                              color: AppColors.btnBackground,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedCategory,
                                hint: Text(
                                  'Seleziona Categoria',
                                  style: AppTypography.containerTitle.copyWith(
                                    color: AppColors.white
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                isExpanded: true,
                                dropdownColor: AppColors.inputBackground,
                                icon: const Icon(
                                  LucideIcons.chevron_down,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                                items: _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: AppTypography.containerTitle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategory = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Group Toggle + Selection
                    GroupSelectionSection(
                      isGroup: isGroup,
                      selectedGroupId: selectedGroupId,
                      onToggleChanged: (value) {
                        setState(() {
                          isGroup = value;
                          if (!isGroup) {
                            selectedGroupId = null;
                          }
                        });
                      },
                      onGroupSelected: (groupId) {
                        setState(() {
                          selectedGroupId = groupId;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveExpense,
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
                  'Aggiungi spesa',
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
}