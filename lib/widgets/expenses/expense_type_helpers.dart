import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum ExpenseType {
  food,
  fuel,
  clothing,
  pharmacy,
  onlineServices,
  electronics,
}

extension ExpenseTypeData on ExpenseType {
  String get subtitle {
    switch (this) {
      case ExpenseType.food:
        return 'Alimentari';
      case ExpenseType.fuel:
        return 'Carburante';
      case ExpenseType.clothing:
        return 'Abbigliamento';
      case ExpenseType.pharmacy:
        return 'Farmaci';
      case ExpenseType.onlineServices:
        return 'Servizi online';
      case ExpenseType.electronics:
        return 'Elettronica';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseType.food:
        return LucideIcons.utensils;
      case ExpenseType.fuel:
        return LucideIcons.fuel;
      case ExpenseType.clothing:
        return LucideIcons.shirt;
      case ExpenseType.pharmacy:
        return LucideIcons.pill;
      case ExpenseType.onlineServices:
        return LucideIcons.globe;
      case ExpenseType.electronics:
        return Icons.devices;
    }
  }

  Color get baseColor {
    switch (this) {
      case ExpenseType.food:
        return Colors.redAccent;
      case ExpenseType.fuel:
        return Colors.green;
      case ExpenseType.clothing:
        return Colors.lightBlueAccent;
      case ExpenseType.pharmacy:
        return Colors.greenAccent;
      case ExpenseType.onlineServices:
        return Colors.yellow;
      case ExpenseType.electronics:
        return Colors.purpleAccent;
    }
  }

  Color get backgroundColor => baseColor.withAlpha(10);

  Color get iconColor {
    return HSLColor.fromColor(baseColor)
        .withLightness(
      (HSLColor.fromColor(baseColor).lightness - 0.25).clamp(0.0, 1.0),
    )
        .toColor();
  }
}

double amountFor(ExpenseType type, double categorySpent) {
  return categorySpent;
}

double percentageFor(ExpenseType type, double spent, double categorySpent) {
  return categorySpent / spent;
}
