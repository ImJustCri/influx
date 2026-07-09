import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/constants.dart';

import '../../theme.dart';

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
        return Colors.red;
      case ExpenseType.onlineServices:
        return Colors.yellow;
      case ExpenseType.electronics:
        return Colors.purpleAccent;
    }
  }

  Color get backgroundColor => baseColor.withOpacity(0.18);

  Color get iconColor {
    return HSLColor.fromColor(baseColor)
        .withLightness(
      (HSLColor.fromColor(baseColor).lightness - 0.25).clamp(0.0, 1.0),
    )
        .toColor();
  }
}

class ExpenseItem extends StatelessWidget {
  final ExpenseType type;
  final String title;
  final String amount;

  const ExpenseItem({
    super.key,
    required this.type,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: type.backgroundColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(type.icon, color: type.iconColor, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.expenseTitle),
                      Text(type.subtitle, style: AppTypography.expenseDescription),
                    ],
                  ),
                ],
              ),
              Text(amount + currency, style: AppTypography.expenseTitle),
            ],
          ),
        ),
        const Divider(
          color: AppColors.containerBorder,
          height: .5,
        ),
      ],
    );
  }
}

