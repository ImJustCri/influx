import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

IconData getIconFromName(String icon) {
  switch (icon) {
  // Original Categories
    case 'pill':
      return LucideIcons.pill;
    case 'shopping_basket':
      return LucideIcons.shopping_basket;
    case 'laptop':
      return LucideIcons.laptop;
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

  // New Categories
    case 'utensils':
      return LucideIcons.utensils;
    case 'home':
      return LucideIcons.house;
    case 'bus':
      return LucideIcons.bus;
    case 'activity':
      return LucideIcons.activity;
    case 'sparkles':
      return LucideIcons.sparkles;
    case 'graduation_cap':
      return LucideIcons.graduation_cap;
    case 'trending_up':
      return LucideIcons.trending_up;
    case 'receipt':
      return LucideIcons.receipt;
    case 'plane':
      return LucideIcons.plane;
    case 'gift':
      return LucideIcons.gift;

    default:
      return LucideIcons.circle;
  }
}