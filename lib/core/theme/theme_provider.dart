// lib/core/theme/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';

/// Provider for storing the primary color
final primaryColorProvider = StateProvider<Color>((ref) => AppColors.primary);

/// Provider for storing the secondary color
final secondaryColorProvider =
    StateProvider<Color>((ref) => AppColors.secondary);

/// Provider to handle custom theme updating
class ThemeNotifier extends StateNotifier<ThemeSettings> {
  ThemeNotifier()
      : super(ThemeSettings(
          primaryColor: AppColors.primary,
          secondaryColor: AppColors.secondary,
          useMaterialYou: false,
        ));

  void updatePrimaryColor(Color color) {
    state = state.copyWith(primaryColor: color);
  }

  void updateSecondaryColor(Color color) {
    state = state.copyWith(secondaryColor: color);
  }

  void toggleMaterialYou() {
    state = state.copyWith(useMaterialYou: !state.useMaterialYou);
  }

  void resetToDefaults() {
    state = ThemeSettings(
      primaryColor: AppColors.primary,
      secondaryColor: AppColors.secondary,
      useMaterialYou: false,
    );
  }
}

/// State provider for theme settings
final themeSettingsProvider =
    StateNotifierProvider<ThemeNotifier, ThemeSettings>((ref) {
  return ThemeNotifier();
});

/// Theme settings model
class ThemeSettings {
  final Color primaryColor;
  final Color secondaryColor;
  final bool useMaterialYou;

  ThemeSettings({
    required this.primaryColor,
    required this.secondaryColor,
    required this.useMaterialYou,
  });

  ThemeSettings copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    bool? useMaterialYou,
  }) {
    return ThemeSettings(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      useMaterialYou: useMaterialYou ?? this.useMaterialYou,
    );
  }
}

/// Helper function to generate a MaterialColor from a Color
MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
  Map<int, Color> swatch = {};

  // Get RGB components directly as integers
  final int r = color.red;
  final int g = color.green;
  final int b = color.blue;

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  // Create the primary swatch
  return MaterialColor(color.hashCode, swatch);
}

/// Provider for dynamically updating the theme based on user selections
final dynamicThemeProvider = Provider<AppTheme>((ref) {
  final themeSettings = ref.watch(themeSettingsProvider);

  return AppTheme(
    light: ThemeData(
      useMaterial3: themeSettings.useMaterialYou,
      brightness: Brightness.light,
      primaryColor: themeSettings.primaryColor,
      primarySwatch: createMaterialColor(themeSettings.primaryColor),
      colorScheme: ColorScheme.light(
        primary: themeSettings.primaryColor,
        secondary: themeSettings.secondaryColor,
        surface: Colors.white,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: themeSettings.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: themeSettings.primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: themeSettings.primaryColor,
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
      useMaterial3: themeSettings.useMaterialYou,
      brightness: Brightness.dark,
      primaryColor: themeSettings.primaryColor,
      primarySwatch: createMaterialColor(themeSettings.primaryColor),
      colorScheme: ColorScheme.dark(
        primary: themeSettings.primaryColor,
        secondary: themeSettings.secondaryColor,
        surface: AppColors.darkSurface,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: themeSettings.primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: themeSettings.primaryColor,
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
});

/// AppTheme class
class AppTheme {
  final ThemeData light;
  final ThemeData dark;

  AppTheme({required this.light, required this.dark});
}
