import 'package:flutter/material.dart';

class PulsingLogoLoadingScreen extends StatefulWidget {
  const PulsingLogoLoadingScreen({super.key});

  @override
  State<PulsingLogoLoadingScreen> createState() =>
      _PulsingLogoLoadingScreenState();
}

class _PulsingLogoLoadingScreenState extends State<PulsingLogoLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1230),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              'assets/icon.png',
              width: 128,
              height: 128,
            ),
          ),
        ),
      ),
    );
  }
}