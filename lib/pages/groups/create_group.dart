import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/app_container.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  late TextEditingController groupNameController;
  late TextEditingController totalBudgetController;

  bool _isModified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    groupNameController = TextEditingController();
    totalBudgetController = TextEditingController();

    groupNameController.addListener(_validateInputs);
    totalBudgetController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      _isModified = groupNameController.text.trim().isNotEmpty &&
          totalBudgetController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    groupNameController.dispose();
    totalBudgetController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final name = groupNameController.text.trim();
    final totalBudget = double.tryParse(totalBudgetController.text.trim().replaceAll(',', '.'));

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
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        throw const AuthException('Utente non autenticato.');
      }

      // database insert into the 'group' table
      await supabase.from('group').insert({
        'name': name,
        'total_budget': totalBudget,
        'status': 'creation',
        'created_by': userId,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gruppo creato con successo!'),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        final message = error.message.contains('Group limit reached')
            ? 'Hai raggiunto il limite massimo di 3 gruppi.'
            : 'Errore durante la creazione del gruppo: ${error.message}';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore imprevisto: $error')),
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
              // Icon Section
              Center(
                child: CircleAvatar(
                  backgroundColor: AppColors.backgroundAccent,
                  radius: 48,
                  child: Icon(
                    LucideIcons.users_round,
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
                      "Crea un gruppo",
                      style: AppTypography.pageTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Inserisci i dettagli del gruppo per iniziare.",
                      textAlign: TextAlign.center,
                      style: AppTypography.pageSubtitle.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Group Name Field
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

              // Total Budget Custom Container
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
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isModified && !_isLoading) ? _createGroup : null,
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
                    'Crea',
                    style: AppTypography.containerTitle.copyWith(
                      color: _isModified
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.5),
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