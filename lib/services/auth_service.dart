
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
}
