import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'product_category_card.dart';

class EcoSwitchTab extends StatelessWidget {
  final VoidCallback onGroceriesTap;

  const EcoSwitchTab({
    super.key,
    required this.onGroceriesTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ProductCategoryCard(
          title: "Alimentari",
          description: "Scopri prodotti sostenibili ed ecologici",
          icon: LucideIcons.apple,
          color: const Color(0xFF4CAF50),
          onTap: onGroceriesTap,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}