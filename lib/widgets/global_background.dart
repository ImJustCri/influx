import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

class GlobalBackground extends StatelessWidget {
  const GlobalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundColor.withValues(alpha: 1.0),
            AppColors.backgroundColor.withValues(alpha: 0.9),
            AppColors.backgroundColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: _GlowDot(color: const Color(0xFF5B2C83), size: 400),
          ),
          Positioned(
            top: 120,
            right: -70,
            child: _GlowDot(color: const Color(0xFF3A245F), size: 400),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: _GlowDot(color: const Color(0xFF1E2A6A), size: 400),
          ),
        ],
      ),
    );
  }
}

class _GlowDot extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowDot({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
      child: Opacity(
        opacity: 0.45,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}