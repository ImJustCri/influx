


import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/pages/auth/login.dart';
import 'package:influx/pages/main_shell_screen.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';
import '../../services/auth_service.dart';

class Signup extends  StatefulWidget {
  const Signup ({super.key});

  State<Signup> createState()=>SingUpPageState();
}

class SingUpPageState extends State<Signup>{

  final emailContent= TextEditingController();
  final passwordContent= TextEditingController();

  bool isPasswordVisibile = true;

  bool isChecked=false;

  AuthService auth=AuthService();

  Widget build(BuildContext context) {
    return Scaffold(
        body: PagePadding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Center(
                      //Logo
                      child:
                      Image.asset(
                        'assets/logo/logo.png',
                      ),
                    ),
                ]
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sezione Email

                    Text(
                      'Email',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),

                    SizedBox(height: 8),

                    SizedBox(
                      height: 52,
                      child: TextFormField(
                        controller: emailContent,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.inputBorder,
                                    width: 1
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.inputBorder,
                                  width: 2,
                                )
                            )
                        ),
                      ),
                    ),

                    // Sezione Password

                    SizedBox( height: 24),

                    Text(
                      "Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),

                    SizedBox( height: 8),

                    SizedBox(
                      height: 52,
                      child: TextFormField(
                          obscureText: isPasswordVisibile,
                          controller: passwordContent,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              suffixIcon: IconButton(
                                icon: Icon(
                                    isPasswordVisibile ? LucideIcons.eye : LucideIcons.eye_off
                                ),
                                onPressed: (){
                                  setState(() {
                                    isPasswordVisibile= !isPasswordVisibile;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.inputBorder,
                                    width: 1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: AppColors.inputBorder,
                                      width: 2
                                  )
                              )
                          )
                      ),
                    ),

                    SizedBox(height: 16),

                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value){
                            setState(() {
                              isChecked=value!;
                            });
                          },
                        ),
                        Text("Accetto i "),
                        TextButton(
                          onPressed: (){
                            // riferimento al sito
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero
                          ),
                          child: Text(
                              "Termini e condizioni",
                              style: TextStyle(
                                color: AppColors.white,
                                decoration: TextDecoration.underline,
                              )
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 25),

                    Center(
                        child: SizedBox(
                          width: 364,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: isChecked ? () async {
                                final email=emailContent.text.trim().toLowerCase();
                                final password = passwordContent.text;

                                String? result= await auth.SignUpWithEmail(email, password);

                                if(result==null){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const MainShellScreen()));
                                }else{
                                  showDialog(
                                      context: context,
                                      barrierColor: AppColors.backgroundAccent.withValues(alpha: 0.2),
                                      builder: (context){
                                        return AlertDialog(
                                          backgroundColor: AppColors.inputBackground,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(32),
                                              side: BorderSide(
                                                  color: AppColors.inputBorder,
                                                  width: 2
                                              )
                                          ),
                                          title: Text("Qualcosa è andato storto"),
                                          content: Text(result),
                                          actions: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: ()=> Navigator.pop(context),
                                                child: Text("Chiudi"),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.btnBackground,
                                                    side: BorderSide(
                                                      color: AppColors.btnBorder,
                                                      width: 1,
                                                    )
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                  );
                                }
                              }: null,
                              child: Text(
                                "Registrati",
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.btnBackground,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(
                                        color: AppColors.inputBorder,
                                        width: isChecked ? 1 : 0,
                                      )
                                  )
                              )
                          ),
                        )
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
                          child: Text(
                              "Oppure"
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.white,
                          ),
                        )
                      ],
                    ),


                    SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 100,
                          child: IconButton(
                            onPressed: (){
                              //Logica
                            },
                            icon: Image.asset('assets/icon/iconGoogle.png',
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
                                    width: 1
                                )

                            ),

                          ),
                        ),

                        Padding(padding: EdgeInsets.symmetric(horizontal: 16)),

                        SizedBox(
                          width: 100,
                          height: 60,
                          child:  IconButton(
                            onPressed: (){
                              //logica
                            },
                            icon: Image.asset('assets/icon/iconFacebook.png',
                              width: 36,
                              height: 36,
                            ),
                            style: IconButton.styleFrom(
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
                        )

                      ],

                    ),
                  ],
                ),
                Column(
                  children: [
                    Center(
                      child: TextButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: Text(
                            "Hai un account?",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          )
                      ),
                    )
                  ],
                )

              ],
            )
        )
    );
  }
}

