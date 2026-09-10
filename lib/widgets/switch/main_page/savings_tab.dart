import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'product_category_card.dart';

class SavingsTab extends StatelessWidget {
  final VoidCallback onFuelTap;

  const SavingsTab({
    super.key,
    required this.onFuelTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ProductCategoryCard(
          title: "Carburante",
          description: "Trova i distributori più convenienti vicino a te",
          icon: LucideIcons.fuel,
          color: const Color(0xFFFF9800),
          onTap: onFuelTap,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}