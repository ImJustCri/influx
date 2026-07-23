import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.transparent,
  fontFamily: 'Inter',
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0D1230),
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    titleTextStyle: AppTypography.pageTitle,
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.backgroundAccent.withValues(alpha: 0.25),
        foregroundColor: AppColors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.inputBackground,
    contentTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: AppColors.inputBorder,
        width: 2,
      ),
    ),
    behavior: SnackBarBehavior.floating,
  ),

  dialogTheme: DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
      side: BorderSide(
        color: AppColors.inputBorder,
        width: 1,
      ),
    ),
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    contentTextStyle: TextStyle(
      fontSize: 16,
      color: AppColors.white,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsetsGeometry.symmetric(vertical: 16),
      textStyle: TextStyle(
        color: AppColors.white,
      ),
      backgroundColor: AppColors.btnBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
    ),
  ),
);

class AppColors {
  static const Color backgroundColor = Color(0xFF0D1230);
  static const Color backgroundAccent = Color(0xFF010007);
  static const Color btnBackground = Color(0xE60091EA);
  static const Color btnBorder = Color(0xFF0064A3);
  static const Color containerBackground = Color(0x33010007);
  static const Color containerBorder = Color(0xFF333856);
  static const Color inputBorder = Color(0xFF333856);
  static const Color inputBackground = Color(0x33000000);
  static const Color white = Color(0xFFE8DEED);
  static const Color whiteDim = Color(0xFFD2CCDA);
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
    color: AppColors.white,
  );

  static const TextStyle userEmailSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );

  static const TextStyle settingsPageName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );

  // Container Styles
  static const TextStyle containerTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle containerBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.whiteDim,
  );

  // Expense Styles
  static const TextStyle expenseTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const TextStyle expenseDescription = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.whiteDim,
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

