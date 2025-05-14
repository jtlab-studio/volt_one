// lib/core/theme/color_palettes.dart

import 'package:flutter/material.dart';

/// Represents a complete color palette for the app
class AppColorPalette {
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color errorColor;
  final Color successColor;
  final Color warningColor;

  // UI element colors
  final Color backgroundColorLight;
  final Color backgroundColorDark;
  final Color cardColorLight;
  final Color cardColorDark;
  final Color textColorLight;
  final Color textColorDark;

  // Navigation colors
  final Color navBarBackgroundLight;
  final Color navBarBackgroundDark;
  final Color navSelectedTextColor;
  final Color navUnselectedTextColor;

  // App bar colors
  final Color appBarBackgroundLight;
  final Color appBarBackgroundDark;
  final Color appBarTextLight;
  final Color appBarTextDark;

  // Button colors
  final Color buttonBackgroundColor;
  final Color buttonTextColor;

  // Icon colors
  final Color iconActiveColor;
  final Color iconInactiveColor;

  const AppColorPalette({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.errorColor,
    required this.successColor,
    required this.warningColor,
    required this.backgroundColorLight,
    required this.backgroundColorDark,
    required this.cardColorLight,
    required this.cardColorDark,
    required this.textColorLight,
    required this.textColorDark,
    required this.navBarBackgroundLight,
    required this.navBarBackgroundDark,
    required this.navSelectedTextColor,
    required this.navUnselectedTextColor,
    required this.appBarBackgroundLight,
    required this.appBarBackgroundDark,
    required this.appBarTextLight,
    required this.appBarTextDark,
    required this.buttonBackgroundColor,
    required this.buttonTextColor,
    required this.iconActiveColor,
    required this.iconInactiveColor,
  });
}

/// Collection of predefined color palettes
class ColorPalettes {
  // Blue palette (default)
  static const AppColorPalette blue = AppColorPalette(
    name: "Blue Ocean",
    description: "A calming blue theme with high contrast",
    primaryColor: Color(0xFF2196F3), // Blue
    secondaryColor: Color(0xFFFF9800), // Orange
    accentColor: Color(0xFF00BCD4), // Cyan
    errorColor: Color(0xFFF44336), // Red
    successColor: Color(0xFF4CAF50), // Green
    warningColor: Color(0xFFFFEB3B), // Yellow
    backgroundColorLight: Colors.white,
    backgroundColorDark: Color(0xFF121212),
    cardColorLight: Colors.white,
    cardColorDark: Color(0xFF2C2C2C),
    textColorLight: Colors.black87,
    textColorDark: Colors.white,
    navBarBackgroundLight: Colors.white,
    navBarBackgroundDark: Color(0xFF1E1E1E),
    navSelectedTextColor: Color(0xFF2196F3),
    navUnselectedTextColor: Colors.grey,
    appBarBackgroundLight: Color(0xFF2196F3),
    appBarBackgroundDark: Color(0xFF1E1E1E),
    appBarTextLight: Colors.white,
    appBarTextDark: Colors.white,
    buttonBackgroundColor: Color(0xFF2196F3),
    buttonTextColor: Colors.white,
    iconActiveColor: Color(0xFF2196F3),
    iconInactiveColor: Colors.grey,
  );

  // Green palette
  static const AppColorPalette green = AppColorPalette(
    name: "Verdant Forest",
    description: "A refreshing green nature-inspired theme",
    primaryColor: Color(0xFF4CAF50), // Green
    secondaryColor: Color(0xFFFF9800), // Orange
    accentColor: Color(0xFF8BC34A), // Light Green
    errorColor: Color(0xFFF44336), // Red
    successColor: Color(0xFF009688), // Teal
    warningColor: Color(0xFFFFEB3B), // Yellow
    backgroundColorLight: Color(0xFFF5F9F5),
    backgroundColorDark: Color(0xFF0F1A0F),
    cardColorLight: Colors.white,
    cardColorDark: Color(0xFF263226),
    textColorLight: Color(0xFF212121),
    textColorDark: Colors.white,
    navBarBackgroundLight: Colors.white,
    navBarBackgroundDark: Color(0xFF1A291A),
    navSelectedTextColor: Color(0xFF4CAF50),
    navUnselectedTextColor: Color(0xFF757575),
    appBarBackgroundLight: Color(0xFF4CAF50),
    appBarBackgroundDark: Color(0xFF1A291A),
    appBarTextLight: Colors.white,
    appBarTextDark: Colors.white,
    buttonBackgroundColor: Color(0xFF4CAF50),
    buttonTextColor: Colors.white,
    iconActiveColor: Color(0xFF4CAF50),
    iconInactiveColor: Color(0xFF757575),
  );

  // Purple palette
  static const AppColorPalette purple = AppColorPalette(
    name: "Royal Purple",
    description: "An elegant and rich purple theme",
    primaryColor: Color(0xFF673AB7), // Deep Purple
    secondaryColor: Color(0xFFE91E63), // Pink
    accentColor: Color(0xFF3F51B5), // Indigo
    errorColor: Color(0xFFF44336), // Red
    successColor: Color(0xFF4CAF50), // Green
    warningColor: Color(0xFFFFEB3B), // Yellow
    backgroundColorLight: Color(0xFFF8F5FC),
    backgroundColorDark: Color(0xFF120B1A),
    cardColorLight: Colors.white,
    cardColorDark: Color(0xFF25192E),
    textColorLight: Color(0xFF212121),
    textColorDark: Colors.white,
    navBarBackgroundLight: Colors.white,
    navBarBackgroundDark: Color(0xFF1F162A),
    navSelectedTextColor: Color(0xFF673AB7),
    navUnselectedTextColor: Color(0xFF757575),
    appBarBackgroundLight: Color(0xFF673AB7),
    appBarBackgroundDark: Color(0xFF1F162A),
    appBarTextLight: Colors.white,
    appBarTextDark: Colors.white,
    buttonBackgroundColor: Color(0xFF673AB7),
    buttonTextColor: Colors.white,
    iconActiveColor: Color(0xFF673AB7),
    iconInactiveColor: Color(0xFF757575),
  );

  // Orange palette
  static const AppColorPalette orange = AppColorPalette(
    name: "Sunset Orange",
    description: "A warm and energetic orange theme",
    primaryColor: Color(0xFFFF5722), // Deep Orange
    secondaryColor: Color(0xFF2196F3), // Blue
    accentColor: Color(0xFFFF9800), // Orange
    errorColor: Color(0xFFD32F2F), // Dark Red
    successColor: Color(0xFF4CAF50), // Green
    warningColor: Color(0xFFFFEB3B), // Yellow
    backgroundColorLight: Color(0xFFFFF8F5),
    backgroundColorDark: Color(0xFF1A0F0B),
    cardColorLight: Colors.white,
    cardColorDark: Color(0xFF2E2118),
    textColorLight: Color(0xFF212121),
    textColorDark: Colors.white,
    navBarBackgroundLight: Colors.white,
    navBarBackgroundDark: Color(0xFF261A14),
    navSelectedTextColor: Color(0xFFFF5722),
    navUnselectedTextColor: Color(0xFF757575),
    appBarBackgroundLight: Color(0xFFFF5722),
    appBarBackgroundDark: Color(0xFF261A14),
    appBarTextLight: Colors.white,
    appBarTextDark: Colors.white,
    buttonBackgroundColor: Color(0xFFFF5722),
    buttonTextColor: Colors.white,
    iconActiveColor: Color(0xFFFF5722),
    iconInactiveColor: Color(0xFF757575),
  );

  // Dark mode palette
  static const AppColorPalette dark = AppColorPalette(
    name: "Midnight",
    description: "A sleek dark theme with blue accents",
    primaryColor: Color(0xFF64B5F6), // Light Blue
    secondaryColor: Color(0xFFE91E63), // Pink
    accentColor: Color(0xFF26A69A), // Teal
    errorColor: Color(0xFFEF5350), // Light Red
    successColor: Color(0xFF66BB6A), // Light Green
    warningColor: Color(0xFFFFEE58), // Light Yellow
    backgroundColorLight: Color(0xFF121212),
    backgroundColorDark: Color(0xFF121212),
    cardColorLight: Color(0xFF1E1E1E),
    cardColorDark: Color(0xFF1E1E1E),
    textColorLight: Colors.white,
    textColorDark: Colors.white,
    navBarBackgroundLight: Color(0xFF1E1E1E),
    navBarBackgroundDark: Color(0xFF1E1E1E),
    navSelectedTextColor: Color(0xFF64B5F6),
    navUnselectedTextColor: Color(0xFFAAAAAA),
    appBarBackgroundLight: Color(0xFF1E1E1E),
    appBarBackgroundDark: Color(0xFF1E1E1E),
    appBarTextLight: Colors.white,
    appBarTextDark: Colors.white,
    buttonBackgroundColor: Color(0xFF64B5F6),
    buttonTextColor: Colors.white,
    iconActiveColor: Color(0xFF64B5F6),
    iconInactiveColor: Color(0xFFAAAAAA),
  );

  // Collected palettes for easy access
  static const List<AppColorPalette> allPalettes = [
    blue,
    green,
    purple,
    orange,
    dark
  ];
}
