import 'package:flutter/material.dart';

class AppColors {
  static const Color seedColor = Colors.deepPurple;
  static const Color primaryColor = seedColor;
  static const Color secondaryColor = Color(0xFF6200EE);
  static const Color errorColor = Color(0xFFB00020);

  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightOnBackground = Colors.black;

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnBackground = Colors.white;
}

class AppTypography {
  static const String primaryFont = 'Poppins';

  static TextStyle get _baseTextStyle => TextStyle(
        fontFamily: primaryFont,
        fontWeight: FontWeight.normal,
      );

  static TextStyle headline1 = _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headline2 = _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bodyLarge = _baseTextStyle.copyWith(
    fontSize: 16,
  );

  static TextStyle bodyMedium = _baseTextStyle.copyWith(
    fontSize: 14,
  );

  static TextStyle bodySmall = _baseTextStyle.copyWith(
    fontSize: 12,
    color: Colors.grey,
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.primaryFont,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.errorColor,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      onBackground: AppColors.lightOnBackground,
    ),

    textTheme: TextTheme(
      displayLarge:
          AppTypography.headline1.copyWith(color: AppColors.lightOnBackground),
      displayMedium:
          AppTypography.headline2.copyWith(color: AppColors.lightOnBackground),
      bodyLarge:
          AppTypography.bodyLarge.copyWith(color: AppColors.lightOnBackground),
      bodyMedium:
          AppTypography.bodyMedium.copyWith(color: AppColors.lightOnBackground),
      bodySmall: AppTypography.bodySmall,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: Colors.grey.shade600),
      prefixIconColor: Colors.grey.shade700,
      suffixIconColor: Colors.grey.shade700,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.lightOnBackground,
      size: 24,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.primaryFont,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.errorColor,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onBackground: AppColors.darkOnBackground,
    ),

    textTheme: TextTheme(
      displayLarge:
          AppTypography.headline1.copyWith(color: AppColors.darkOnBackground),
      displayMedium:
          AppTypography.headline2.copyWith(color: AppColors.darkOnBackground),
      bodyLarge:
          AppTypography.bodyLarge.copyWith(color: AppColors.darkOnBackground),
      bodyMedium:
          AppTypography.bodyMedium.copyWith(color: AppColors.darkOnBackground),
      bodySmall: AppTypography.bodySmall,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      prefixIconColor: Colors.grey.shade400,
      suffixIconColor: Colors.grey.shade400,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    iconTheme: IconThemeData(
      color: AppColors.darkOnBackground,
      size: 24,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
