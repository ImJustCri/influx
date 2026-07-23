import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';

class EnterGroupPage extends StatefulWidget {
  const EnterGroupPage({super.key});

  @override
  State<EnterGroupPage> createState() => _EnterGroupPageState();
}

class _EnterGroupPageState extends State<EnterGroupPage> {
  // Declare the controller
  late TextEditingController groupCodeController;

  // Declare a boolean to track if the text is modified
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    groupCodeController = TextEditingController();

    // Listen to changes in the text field
    groupCodeController.addListener(() {
      setState(() {
        _isModified = groupCodeController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the controller to free resources
    groupCodeController.dispose();
    super.dispose();
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

              // Amount Section
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
                keyboardType: TextInputType.number,
                controller: groupCodeController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: "Inserisci il codice",
                  hintStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
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
                  onPressed: _isModified ? () {
                  } : null,
                  style: ElevatedButton.styleFrom(

                    backgroundColor: AppColors.btnBackground,
                    disabledBackgroundColor: AppColors.btnBackground.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: AppColors.btnBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Salva modifiche',
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