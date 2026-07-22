import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/pages/auth/otp.dart';
import 'package:influx/pages/main_shell_screen.dart';
import 'package:influx/widgets/page_padding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme.dart';
import '../../services/auth_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

  class LoginPageState extends State<LoginPage>{

    final emailContent = TextEditingController();

    AuthService auth = AuthService();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PagePadding(
          child: Stack(
            children: [
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/logo/logo.png',
                  ),
                ),
              ),
              Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 8),

                      SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: emailContent,
                          decoration: InputDecoration(
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
                      ),

                      SizedBox(height: 25),

                      Center(
                        child: SizedBox(
                          width: 364,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              String email= emailContent.text.trim().toLowerCase();

                              if(email.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                          "Inserisci l'email",
                                      ),
                                  )
                                );
                              }else{
                                String? result= await auth.loginWithEmail(email);

                                if(result!=null){
                                  showDialog(
                                      context: context,
                                      builder: (builder){
                                        return AlertDialog(
                                          title: Text(
                                              "Qualcosa è andato storto",
                                          ),
                                          content: Text(
                                              result,
                                          ),
                                          actions: [
                                            SizedBox(
                                              width: double.infinity,
                                              height: 40,
                                              child:  ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                      "Chiudi",
                                                  ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                  );

                                }else{
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=> OtpPage(email: email,)));
                                }

                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.btnBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide(
                                  color: AppColors.btnBorder,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              "Continua",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("Oppure"),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      SizedBox(
                            height: 65,
                            width: double.infinity,
                            child: TextButton.icon(
                                onPressed: () async{
                                  await auth.loginWithGoogle();

                                  Supabase.instance.client.auth.onAuthStateChange.listen((data){
                                    final session=data.session;

                                    if(session!=null){
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const MainShellScreen()), (route)=>false);
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                              "Errore durante l'accesso. Riprova",
                                            ),
                                          )
                                      );
                                    }

                                  });
                                },
                                icon: Image.asset(
                                  'assets/icon/iconGoogle.png',
                                  height: 36,
                                  width: 36,
                                ),
                                label: Text("Google"),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                backgroundColor: AppColors.inputBackground,
                                side: BorderSide(
                                  color: AppColors.inputBorder,
                                  width: 1
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
            ],
          ),
        ),
      );
    }
  }
