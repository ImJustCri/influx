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
      child: const Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: _GlowDot(color: Color(0xFF5B2C83), size: 600),
          ),
          Positioned(
            top: 120,
            right: -70,
            child: _GlowDot(color: Color(0xFF3A245F), size: 800),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: _GlowDot(color: Color(0xFF1E2A6A), size: 400),
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0.20),
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}