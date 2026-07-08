import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0D1230),
      brightness: Brightness.dark,
    )
);

class AppColors {
  static const Color backgroundColor = Color(0xFF0D1230);
  static const Color backgroundAccent = Color(0xFF010007);
  static const Color btnBackground = Color(0xE60091EA);
  static const Color btnBorder = Color(0xFF0064A3);
  static const Color containerBackground = Color(0x33010007);
  static const Color containerBorder = Color(0xFF333856);
  static const Color inputBackground = Color(0x33010007);
  static const Color inputBorder = Color(0xFF6D678D);
  static const Color white = Color(0xFFE8DEED);
}

class AppTypography {

  // Page / User Header Styles
  static const TextStyle pageTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle username = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle pageSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.inputBorder,
  );

  static const TextStyle userEmailSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.inputBorder,
  );

  static const TextStyle settingsPageName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );

  // Container Styles
  static const TextStyle containerTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.white,
  );

  static const TextStyle containerBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.white,
  );

  // Expense Styles
  static const TextStyle expenseTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.white,
  );

  static const TextStyle expenseDescription = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.inputBorder,
  );

  // Navigation Styles
  static const TextStyle navbarTitles = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.white,
  );

  // Role Styles
  static const TextStyle roleTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Large Indicators
  static const TextStyle budgetIndicator = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}