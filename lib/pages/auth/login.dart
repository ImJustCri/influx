import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}




  class LoginPageState extends State<LoginPage>{

    final emailContent = TextEditingController();
    final passwordContent = TextEditingController();

    bool isPasswordVisibile=true;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: PagePadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: 80,
                  ),

                  Center( //Logo
                    child:
                    Image.asset(
                      'assets/logo/logo.png',
                    ),
                  ),

                  SizedBox(
                    height: 119,
                  ),


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

                  Center(
                      child: TextButton(
                          onPressed: (){

                          },
                          child: Text(
                            "Hai dimenticato la password?",
                            style: AppTypography.containerBody
                            ),
                          )
                      ),

                  SizedBox(height: 55),

                  Center(
                    child: SizedBox(
                      width: 364,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: (){
                              //logica
                          },
                          child: Text(
                            "Accedi",
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.btnBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                              side: BorderSide(
                                color: AppColors.btnBorder,
                                width: 1
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








              )

          )
      );
    }
  }
