import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/pages/auth/Otp.dart';
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
                        height: 55,
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
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.white,
                                          ),
                                      ),
                                      backgroundColor: AppColors.inputBackground,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: AppColors.inputBorder,
                                          width: 2
                                        ),
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(32),
                                            side: BorderSide(
                                              color: AppColors.inputBorder,
                                              width: 1
                                            )
                                          ),
                                          title: Text(
                                              "Qualcosa è andato storto",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              ),
                                          ),
                                          content: Text(
                                              result,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          actions: [
                                            SizedBox(
                                              width: double.infinity,
                                              height: 40,
                                              child:  ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.btnBackground,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  side: BorderSide(
                                                    color: AppColors.btnBorder,
                                                    width: 1
                                                  )
                                                ),
                                                  child: Text(
                                                      "Chiudi",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.white
                                                    ),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 64,
                            width: 100,
                            child: IconButton(
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
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          backgroundColor: AppColors.inputBackground,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: BorderSide(
                                                color: AppColors.inputBorder,
                                                width: 2
                                            ),
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
                                style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    backgroundColor: AppColors.inputBackground,
                                    side: BorderSide(
                                        color: AppColors.inputBorder,
                                        width:1
                                    ),
                                ),
                            ),
                          ),

                          SizedBox(width: 16),

                          SizedBox(
                            height: 64,
                            width: 100,
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/icon/iconFacebook.png',
                                height: 36,
                                width: 36,
                              ),
                              style: IconButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  backgroundColor: AppColors.inputBackground,
                                  side: BorderSide(
                                      color: AppColors.inputBorder,
                                      width:1
                                  )
                            ),
                          ),
                          ),
                        ],
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
