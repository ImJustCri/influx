import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';




  IconData getIconFromName(String icon) {
    switch (icon) {
      case 'pill':
        return LucideIcons.pill;
      case 'shopping_basket':
        return LucideIcons.shopping_basket;
      case 'laptop':
        return Icons.laptop;
      case 'smartphone':
        return LucideIcons.smartphone;
      case 'shirt':
        return LucideIcons.shirt;
      case 'party_popper':
        return LucideIcons.party_popper;
      case 'fuel':
        return LucideIcons.fuel;
      case 'banknote':
        return LucideIcons.banknote;
      case 'bone':
        return LucideIcons.bone;
        default:
        return LucideIcons.a_large_small;
    }
  }

