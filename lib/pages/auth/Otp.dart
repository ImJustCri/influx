
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:influx/pages/main_shell_screen.dart';
import 'package:influx/services/auth_service.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/page_padding.dart';

class OtpPage extends StatefulWidget {
  final email;
  const OtpPage({
    super.key,
    this.email
  });

  State<OtpPage> createState()=> OtpState();
}

class OtpState extends State<OtpPage>{

  final otpCodeContent= TextEditingController();
  AuthService auth= AuthService();

  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PagePadding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Ti abbiamo inviato un codice a:",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.email,
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1.5
                  ),
                ),
              ),
              SizedBox(height: 30),

              TextFormField(
                maxLength: 6,
                keyboardType: TextInputType.number,
                controller: otpCodeContent,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: "Inserisci il codice OTP",
                  hintStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  enabledBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: AppColors.inputBorder,
                          width: 1,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.inputBorder,
                        width: 2,
                      )
                  ),
                ),
              ),

              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child:  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)
                    )
                  ),
                  onPressed: () async{
                    String otpCode= otpCodeContent.text;

                    if(otpCode.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              "Inserisci il codice OTP",
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
                      String? result= await auth.verifyEmailWithOtp(otpCode, widget.email);

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
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainShellScreen()), (route)=>false);
                      }

                    }

                  },
                  child: Text(
                      "Accedi",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              )
            ],
          )
      ),

    );
  }
}
