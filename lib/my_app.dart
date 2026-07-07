import 'package:flutter/material.dart';
import 'package:influx/pages/main_shell_screen.dart';
import 'package:influx/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INFLUX',
      theme: darkTheme,
      home: const MainShellScreen(),
    );
  }
}