
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:influx/pages/auth/login.dart';
import 'package:influx/pages/main_shell_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends StatelessWidget {
  const AuthService({super.key});


  @override
  Widget build(BuildContext context) {

     final session= Supabase.instance.client.auth.currentSession;

     if(session!=null){
       return const MainShellScreen();
     }else{
       return const LoginPage();
     }
  }

  Future<String?> loginWithEmail(String email_) async{
    try{
      await Supabase.instance.client.auth.signInWithOtp(
        email: email_
      );
      return null;
    } on AuthException catch(e){
      switch(e.message){
        case "Unable to validate email address: invalid format":
          return "Formato email non valido";
        case "One of email or phone must be set":
          return "Inserisci l'email";
          default:
            return "Errore con il server. Riprova più tardi";
      }
    }
  }

  Future<String?> verifyEmailWithOtp(String otp_, String email_) async{
    try{
      await Supabase.instance.client.auth.verifyOTP(
        email: email_,
        token: otp_,
        type: OtpType.email
      );
      return null;
    } on AuthException catch(e){
      switch(e.message){
        case "Verify requires either a token or a token hash":
          return "Inserisci il codice OTP";
        case "Token has expired or is invalid":
          return "Codice OTP non valido o scaduto";
        default:
          return "Errore con il server. Riprova più tardi";
      }
    }

  }





}

