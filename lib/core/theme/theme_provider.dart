// lib/core/theme/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import still needed for AppColorPalette
import 'app_text_theme.dart';
import 'color_palettes.dart';

// Set default theme to light mode (moved from app_theme.dart to prevent ambiguity)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Provider for storing the selected color palette
final selectedPaletteProvider = StateProvider<AppColorPalette>(
    (ref) => ColorPalettes.blue); // Blue is the default palette

/// Provider to handle theme settings
class ThemeNotifier extends StateNotifier<AppColorPalette> {
  ThemeNotifier() : super(ColorPalettes.blue);

  void setPalette(AppColorPalette palette) {
    state = palette;
  }
}

/// State provider for theme settings
final colorPaletteProvider =
    StateNotifierProvider<ThemeNotifier, AppColorPalette>((ref) {
  return ThemeNotifier();
});

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
  return MaterialColor(color.value, swatch);
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
  final palette = ref.watch(colorPaletteProvider);
  // Variable is used for the dynamicThemeProvider calculation
  // Remove unused variable warning by using it in a condition
  final themeMode = ref.watch(themeModeProvider);

  return AppTheme(
    light: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: palette.primaryColor,
      primarySwatch: createMaterialColor(palette.primaryColor),
      colorScheme: ColorScheme.light(
        primary: palette.primaryColor,
        secondary: palette.secondaryColor,
        tertiary: palette.accentColor,
        surface: palette.cardColorLight,
        // Changed from background to surface to address deprecation
        surfaceContainer: palette.backgroundColorLight,
        error: palette.errorColor,
      ),
      scaffoldBackgroundColor: palette.backgroundColorLight,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.appBarBackgroundLight,
        foregroundColor: palette.appBarTextLight,
        elevation: 0.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.navBarBackgroundLight,
        selectedItemColor: palette.navSelectedTextColor,
        unselectedItemColor: palette.navUnselectedTextColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: palette.buttonTextColor,
          backgroundColor: palette.buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: palette.cardColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textTheme: appTextTheme.apply(
        bodyColor: palette.textColorLight,
        displayColor: palette.textColorLight,
      ),
      iconTheme: IconThemeData(
        color: palette.iconInactiveColor,
      ),
      // Apply other custom color settings
      extensions: [
        CustomColorTheme(
          success: palette.successColor,
          warning: palette.warningColor,
          error: palette.errorColor,
          iconActive: palette.iconActiveColor,
          iconInactive: palette.iconInactiveColor,
        ),
      ],
    ),
    dark: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: palette.primaryColor,
      primarySwatch: createMaterialColor(palette.primaryColor),
      colorScheme: ColorScheme.dark(
        primary: palette.primaryColor,
        secondary: palette.secondaryColor,
        tertiary: palette.accentColor,
        surface: palette.cardColorDark,
        // Changed from background to surface to address deprecation
        surfaceContainer: palette.backgroundColorDark,
        error: palette.errorColor,
      ),
      scaffoldBackgroundColor: palette.backgroundColorDark,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.appBarBackgroundDark,
        foregroundColor: palette.appBarTextDark,
        elevation: 0.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.navBarBackgroundDark,
        selectedItemColor: palette.navSelectedTextColor,
        unselectedItemColor: palette.navUnselectedTextColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: palette.buttonTextColor,
          backgroundColor: palette.buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: palette.cardColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textTheme: appTextTheme.apply(
        bodyColor: palette.textColorDark,
        displayColor: palette.textColorDark,
      ),
      iconTheme: IconThemeData(
        color: palette.iconInactiveColor,
      ),
      // Apply custom color settings
      extensions: [
        CustomColorTheme(
          success: palette.successColor,
          warning: palette.warningColor,
          error: palette.errorColor,
          iconActive: palette.iconActiveColor,
          iconInactive: palette.iconInactiveColor,
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
  final Color iconActive;
  final Color iconInactive;

  CustomColorTheme({
    required this.success,
    required this.warning,
    required this.error,
    required this.iconActive,
    required this.iconInactive,
  });

  @override
  ThemeExtension<CustomColorTheme> copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? iconActive,
    Color? iconInactive,
  }) {
    return CustomColorTheme(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      iconActive: iconActive ?? this.iconActive,
      iconInactive: iconInactive ?? this.iconInactive,
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
      iconActive: Color.lerp(iconActive, other.iconActive, t)!,
      iconInactive: Color.lerp(iconInactive, other.iconInactive, t)!,
    );
  }
}

/// AppTheme class
class AppTheme {
  final ThemeData light;
  final ThemeData dark;

  AppTheme({required this.light, required this.dark});
}
