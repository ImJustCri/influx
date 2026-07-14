import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/services/auth_service.dart';
import 'package:influx/pages/account/profile.dart';
import 'package:influx/theme.dart';
import 'package:influx/widgets/global_background.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'INFLUX',
        theme: darkTheme,
        builder: (context, child) {
          return Stack(
            children: [
              const Positioned.fill(child: GlobalBackground()),
              child!,
            ],
          );
        },
        home: const AuthService(),
        routes: {
          '/profile': (context) => ProfilePage(
            budget: 500,
          ),
        },
      ),
    );
  }
}
