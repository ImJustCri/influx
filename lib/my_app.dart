import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:influx/pages/initial_page.dart';
import 'package:influx/pages/account/profile.dart';
import 'package:influx/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'INFLUX',
        theme: darkTheme,
        home: const InitialPage(),
        routes: {
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}