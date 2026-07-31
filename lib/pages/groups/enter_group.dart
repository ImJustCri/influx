import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';

class EnterGroupPage extends ConsumerStatefulWidget {
  const EnterGroupPage({super.key});

  @override
  ConsumerState<EnterGroupPage> createState() => _EnterGroupPageState();
}

class _EnterGroupPageState extends ConsumerState<EnterGroupPage> {
  late TextEditingController groupCodeController;
  bool _isModified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    groupCodeController = TextEditingController();

    groupCodeController.addListener(() {
      setState(() {
        _isModified = groupCodeController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    groupCodeController.dispose();
    super.dispose();
  }

  void _openQrScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height: MediaQuery.of(bottomSheetContext).size.height * 0.5,
            child: Column(
              children: [
                Text(
                  'Scansiona il codice QR',
                  style: AppTypography.containerTitle,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: MobileScanner(
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null) {
                            final String code = barcode.rawValue!;
                            setState(() {
                              groupCodeController.text = code;
                            });

                            // Close the bottom sheet popup upon successful scan
                            if (Navigator.of(bottomSheetContext).canPop()) {
                              Navigator.of(bottomSheetContext).pop();
                            }
                            break;
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _joinGroup() async {
    final code = groupCodeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.functions.invoke(
        'join-group-by-code',
        body: {
          'code': code
        },
      );

      if (response.status == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sei entrato nel gruppo con successo!'),
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        final errorMessage =
            response.data?['error'] ?? 'Errore durante l\'accesso al gruppo.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage.toString())),
          );
        }
      }
    } on FunctionException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.reasonPhrase ?? 'Errore della funzione.'),
          ),
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
                    LucideIcons.door_open,
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
                      "Entra in un gruppo",
                      style: AppTypography.pageTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      textAlign: TextAlign.center,
                      "Per entrare a far parte di un gruppo, ti serve un codice di ingresso.",
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
                controller: groupCodeController,
                decoration: InputDecoration(
                  hintText: "Inserisci il codice",
                  hintStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      LucideIcons.qr_code,
                      color: AppColors.white,
                    ),
                    onPressed: _openQrScanner,
                  ),
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isModified && !_isLoading) ? _joinGroup : null,
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
                    'Entra',
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