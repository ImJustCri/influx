import 'package:flutter/material.dart';

class FuelSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const FuelSearchBar({
    super.key,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Cerca Comune (es. Catania)",
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: controller.text.isNotEmpty ? null : Colors.grey,
          ),
          onPressed: controller.text.isNotEmpty ? onClear : null,
        ),
      ),
    );
  }
}