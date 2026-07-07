import 'package:flutter/material.dart';
import 'package:influx/widgets/page_padding.dart';
import '../../theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagePadding(
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Center(
                child:
                  Image.asset(
                      'assets/logo/logo.png',
                  ),
              )
            ],
          )

      )
    );
  }
}
