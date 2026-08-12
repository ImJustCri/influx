import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:influx/services/auth_service.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';
import '../initial_page.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({
    super.key,
    required this.email,
  });

  @override
  State<OtpPage> createState() => OtpState();
}

class OtpState extends State<OtpPage> {
  final otpCodeContent = TextEditingController();
  final AuthService auth = AuthService();

  @override
  void dispose() {
    otpCodeContent.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp(String otpCode) async {
    if (otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text("Inserisci il codice OTP completo"),
        ),
      );
      return;
    }

    String? result = await auth.verifyEmailWithOtp(otpCode, widget.email);

    if (!mounted) return;

    if (result != null) {
      showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Qualcosa è andato storto"),
            content: Text(result),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text("Chiudi"),
                ),
              )
            ],
          );
        },
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const InitialPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Styling the individual OTP boxes
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.inputBorder,
          width: 1,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: AppColors.btnBackground,
          width: 2,
        ),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: AppColors.inputBorder,
          width: 1.5,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PagePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Ti abbiamo inviato un codice a:",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                  decorationColor: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 36),

            Pinput(
              length: 6,
              controller: otpCodeContent,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              keyboardType: TextInputType.number,
              autofocus: true,
              separatorBuilder: (index) => const SizedBox(width: 8),
              onCompleted: (pin) => _verifyOtp(pin),
            ),

            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                    side: const BorderSide(
                      color: AppColors.btnBorder,
                      width: 1,
                    ),
                  ),
                ),
                onPressed: () => _verifyOtp(otpCodeContent.text),
                child: const Text(
                  "Continua",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}