
import 'package:flutter/material.dart';
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


  Future<String?> loginInWithEmail(String email_, String password_) async{
    try{
      final AuthResponse response= await Supabase.instance.client.auth.signInWithPassword(
          email: email_,
          password: password_
      );
      return null;
    }on AuthException catch(a){
        switch(a.message) {
          case 'missing email or phone':
            return 'Compila tutti i campi';
          case 'Invalid login credentials':
            return 'Credenziali di accesso non valide';
            default:
              return 'Si è verificato un errore del server. Riprova più tardi';
        }
    }
  }

  Future<String?> SignUpWithEmail(String email_, String password_) async {
    try {
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
          email: email_,
          password: password_
      );
      return null;
    } on AuthException catch (a) {
      switch (a.message) {
        case "Anonymous sign-ins are disabled":
          return "Compila i campi.";
        case "Signup requires a valid password":
          return "Inserisci la password";
        case 'Password should be at least 8 characters. Password should contain at least one character of each: abcdefghijklmnopqrstuvwxyz, ABCDEFGHIJKLMNOPQRSTUVWXYZ, 0123456789, !@#\$%^&*()_+-=[]{};:"|<>?,./`~.':
          return "Password non valida!\n La password deve contenere almeno 8 caratteri.\nUn carattere minuscolo.\nUn carattere maiuscolo.\nUn numero.\nUn carattere speciale (es: !@#]\$%^&)";
        case "Unable to validate email address: invalid format":
          return "Inserisci una email valida";
        default:
          return 'Si è verificato un errore del server. Riprova più tardi';
      }
    }
  }

  bool testPassword(String password_){
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password_);
  }





}

