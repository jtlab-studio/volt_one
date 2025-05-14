// lib/core/theme/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

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
          successColor: AppColors.success,
          warningColor: AppColors.warning,
          errorColor: AppColors.error,
          useMaterialYou: false,
        ));

  void updatePrimaryColor(Color color) {
    state = state.copyWith(primaryColor: color);
  }

  void updateSecondaryColor(Color color) {
    state = state.copyWith(secondaryColor: color);
  }

  void updateSuccessColor(Color color) {
    state = state.copyWith(successColor: color);
  }

  void updateWarningColor(Color color) {
    state = state.copyWith(warningColor: color);
  }

  void updateErrorColor(Color color) {
    state = state.copyWith(errorColor: color);
  }

  void toggleMaterialYou() {
    state = state.copyWith(useMaterialYou: !state.useMaterialYou);
  }

  void resetToDefaults() {
    state = ThemeSettings(
      primaryColor: AppColors.primary,
      secondaryColor: AppColors.secondary,
      successColor: AppColors.success,
      warningColor: AppColors.warning,
      errorColor: AppColors.error,
      useMaterialYou: false,
    );
  }
}

/// State provider for theme settings
final themeSettingsProvider =
    StateNotifierProvider<ThemeNotifier, ThemeSettings>((ref) {
  return ThemeNotifier();
});

/// Enhanced Theme settings model
class ThemeSettings {
  final Color primaryColor;
  final Color secondaryColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final bool useMaterialYou;

  ThemeSettings({
    required this.primaryColor,
    required this.secondaryColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.useMaterialYou,
  });

  ThemeSettings copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    bool? useMaterialYou,
  }) {
    return ThemeSettings(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
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

/// Helper method to darken a color (for dark theme derivation)
Color darkenColor(Color color, double factor) {
  assert(factor >= 0 && factor <= 1);

  int r = (color.red * (1 - factor)).round();
  int g = (color.green * (1 - factor)).round();
  int b = (color.blue * (1 - factor)).round();

  return Color.fromRGBO(r, g, b, 1.0);
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
        error: themeSettings.errorColor,
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
      // Apply other custom color settings
      extensions: [
        CustomColorTheme(
          success: themeSettings.successColor,
          warning: themeSettings.warningColor,
          error: themeSettings.errorColor,
        ),
      ],
    ),
    dark: ThemeData(
      useMaterial3: themeSettings.useMaterialYou,
      brightness: Brightness.dark,
      primaryColor: darkenColor(themeSettings.primaryColor, 0.2),
      primarySwatch: createMaterialColor(themeSettings.primaryColor),
      colorScheme: ColorScheme.dark(
        primary: themeSettings.primaryColor,
        secondary: darkenColor(themeSettings.secondaryColor, 0.1),
        surface: AppColors.darkSurface,
        error: darkenColor(themeSettings.errorColor, 0.1),
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
      // Apply other custom color settings with dark variants
      extensions: [
        CustomColorTheme(
          success: darkenColor(themeSettings.successColor, 0.2),
          warning: darkenColor(themeSettings.warningColor, 0.2),
          error: darkenColor(themeSettings.errorColor, 0.2),
        ),
      ],
    ),
  );
});

/// Custom color theme extension to store additional colors
class CustomColorTheme extends ThemeExtension<CustomColorTheme> {
  final Color success;
  final Color warning;
  final Color error;

  CustomColorTheme({
    required this.success,
    required this.warning,
    required this.error,
  });

  @override
  ThemeExtension<CustomColorTheme> copyWith({
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return CustomColorTheme(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  ThemeExtension<CustomColorTheme> lerp(
    ThemeExtension<CustomColorTheme>? other,
    double t,
  ) {
    if (other is! CustomColorTheme) {
      return this;
    }

    return CustomColorTheme(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

/// AppTheme class
class AppTheme {
  final ThemeData light;
  final ThemeData dark;

  AppTheme({required this.light, required this.dark});
}
