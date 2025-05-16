// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

// Set default theme to dark mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

// Define theme style options
enum ThemeStyle {
  standard,
  glassmorphic,
  neumorphic,
}

// Provider to track the selected theme style
final themeStyleProvider = StateProvider<ThemeStyle>((ref) => ThemeStyle.standard);

class AppTheme {
  final ThemeData light;
  final ThemeData dark;
  final ThemeStyle style;

  AppTheme({
    required this.light,
    required this.dark,
    required this.style,
  });
}

final materialThemeProvider = Provider<AppTheme>((ref) {
  final themeStyle = ref.watch(themeStyleProvider);
  
  switch (themeStyle) {
    case ThemeStyle.glassmorphic:
      return _createGlassmorphicTheme();
    case ThemeStyle.neumorphic:
      return _createNeumorphicTheme();
    case ThemeStyle.standard:
    default:
      return _createStandardTheme();
  }
});

AppTheme _createStandardTheme() {
  return AppTheme(
    style: ThemeStyle.standard,
    light: ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white, // Changed from background to surface
        error: AppColors.error,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    dark: ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkBackground,
        error: AppColors.error,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}

AppTheme _createGlassmorphicTheme() {
  return AppTheme(
    style: ThemeStyle.glassmorphic,
    light: ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white.withOpacity(0.8),
        error: AppColors.error,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary.withOpacity(0.7),
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.7),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary.withOpacity(0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    dark: ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.black.withOpacity(0.6),
        error: AppColors.error,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface.withOpacity(0.7),
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.black87.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black.withOpacity(0.7),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary.withOpacity(0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}

AppTheme _createNeumorphicTheme() {
  return AppTheme(
    style: ThemeStyle.neumorphic,
    light: ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: const Color(0xFFE0E5EC),
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFFE0E5EC),
      textTheme: appTextTheme.apply(
        bodyColor: const Color(0xFF303030),
        displayColor: const Color(0xFF303030),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE0E5EC),
        foregroundColor: Color(0xFF303030),
        elevation: 0.0,
      ),
      cardTheme: CardTheme(
        elevation: 9,
        shadowColor: Colors.grey[500],
        color: const Color(0xFFE0E5EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFE0E5EC),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          elevation: 9,
          shadowColor: Colors.grey[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    dark: ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: const Color(0xFF303030),
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: const Color(0xFF303030),
      textTheme: appTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF303030),
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      cardTheme: CardTheme(
        elevation: 9,
        shadowColor: Colors.black,
        color: const Color(0xFF303030),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF303030),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          elevation: 9,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}

final cupertinoThemeProvider = Provider<CupertinoThemeData>((ref) {
  return const CupertinoThemeData(
    primaryColor: AppColors.primary,
    barBackgroundColor: AppColors.primary,
    scaffoldBackgroundColor: CupertinoColors.systemBackground,
  );
});
