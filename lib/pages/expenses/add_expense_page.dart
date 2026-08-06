import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/models/category.dart';
import 'package:influx/services/ocr_service.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../widgets/expenses/add/group_selection_section.dart';
import '../../widgets/expenses/expense_type_helpers.dart';
import '../../widgets/page_padding.dart';

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
  final OcrService _ocrService = OcrService();

  late bool isGroup;
  String? selectedGroupId;
  bool _isLoading = false;

  List<CategoryModel> categories = [];

  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    isGroup = widget.initialIsGroup;
    loadCategoty();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> loadCategoty() async{
    final result= await Supabase.instance.client.from('category').select();

    setState(() {
      categories= result.map((item)=>CategoryModel.fromJson(item)).toList();
    });
  }

  Future<void> _handleOcrScan() async {
    final result = await _ocrService.ocrMethod();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Risultato OCR",
                style: AppTypography.containerBody,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    result ?? "Nessun testo rilevato",
                    style: AppTypography.budgetIndicator.copyWith(
                      fontSize: 24
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Chiudi"),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
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
        'profile_id': user.id,
        'name': name,
        'description': descriptionController.text.trim(),
        'category_id': selectedCategory!.id,
        'group_id': isGroup ? selectedGroupId : null,
        'amount': amount,
        'created_at': DateTime.now().toIso8601String(),
      };

      await Supabase.instance.client.from('expense').insert(expenseData);

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
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.qr_code),
            onPressed: _handleOcrScan,
          ),
          const SizedBox(width: 8),
        ],
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
                              fillColor: Colors.transparent,
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
                              fillColor: Colors.transparent,
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
                              child: DropdownButton<CategoryModel>(
                                value: selectedCategory,
                                borderRadius: BorderRadius.circular(32),
                                dropdownColor: AppColors.backgroundAccent,
                                hint: Text(
                                  'Seleziona Categoria',
                                  style: AppTypography.containerTitle.copyWith(
                                    color: AppColors.white
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  LucideIcons.chevron_down,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                                items: categories.map((category) {
                                  return DropdownMenuItem<CategoryModel>(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Icon(getIconFromName(category.icon), color: Color(int.parse(category.color, radix: 16))),
                                        SizedBox(width: 12),
                                        Text(
                                          category.name,
                                          style: AppTypography.containerTitle.copyWith(
                                            color: AppColors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (CategoryModel? newValue) {
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