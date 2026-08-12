import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../widgets/settings_tile.dart';

class EnterGroupPage extends ConsumerStatefulWidget {
  const EnterGroupPage({super.key});

  @override
  ConsumerState<EnterGroupPage> createState() => _EnterGroupPageState();
}

class _EnterGroupPageState extends ConsumerState<EnterGroupPage> {
  late TextEditingController groupCodeController;
  late FocusNode groupCodeFocusNode;
  bool _isModified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    groupCodeController = TextEditingController();
    groupCodeFocusNode = FocusNode();

    groupCodeController.addListener(() {
      setState(() {
        _isModified = groupCodeController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    groupCodeController.dispose();
    groupCodeFocusNode.dispose();
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

      await supabase.functions.invoke(
        'join-group-by-code',
        body: {'code': code},
      );

      // HTTP Status is 2xx if no exception was thrown
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sei entrato nel gruppo con successo!'),
          ),
        );
        Navigator.of(context).pop();
      }
    } on FunctionException catch (error) {
      if (mounted) {
        String message;

        if (error.status == 404) {
          message = 'Gruppo non trovato!';
        } else {
          message = error.reasonPhrase ?? 'Errore durante l\'accesso al gruppo.';
        }

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
    // Default Pin Theme
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
    );

    // Focused Pin Theme
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.inputBorder, width: 2),
      ),
    );

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Pinput(
                      length: 6,
                      controller: groupCodeController,
                      focusNode: groupCodeFocusNode,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      onCompleted: (pin) => _joinGroup(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              SettingsTile(icon: LucideIcons.qr_code, title: 'Scansiona Codice QR', onTap: _openQrScanner),
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