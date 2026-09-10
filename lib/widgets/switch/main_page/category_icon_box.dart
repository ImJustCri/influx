import 'package:flutter/material.dart';

class CategoryIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CategoryIconBox({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color,
          width: 0.5,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
    );
  }
}