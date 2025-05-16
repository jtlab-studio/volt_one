import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_theme.dart';

// Create a class to manage theme throughout the app
class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() => _instance;

  ThemeManager._internal();

  // Default theme settings
  ThemeStyle _themeStyle = ThemeStyle.standard;
  ThemeMode _themeMode = ThemeMode.dark;

  // Getters
  ThemeStyle get themeStyle => _themeStyle;
  ThemeMode get themeMode => _themeMode;

  // Setters with notifications
  void setThemeStyle(ThemeStyle style) {
    if (_themeStyle != style) {
      _themeStyle = style;
      notifyListeners();
      debugPrint("ThemeManager: Theme style changed to $_themeStyle");
    }
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      debugPrint("ThemeManager: Theme mode changed to $_themeMode");
    }
  }

  // Get current theme based on style
  AppTheme getCurrentTheme() {
    // Simple if/else instead of switch to avoid exhaustiveness checking issues
    if (_themeStyle == ThemeStyle.glassmorphic) {
      return _createGlassmorphicTheme();
    } else {
      // Default to standard for any other value
      return _createStandardTheme();
    }
  }

  // Standard theme definition
  AppTheme _createStandardTheme() {
    return AppTheme(
      style: ThemeStyle.standard,
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: Colors.white,
          error: AppColors.error,
        ),
        textTheme: appTextTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4.0, // Standard elevation
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          elevation: 8.0, // Standard elevation
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primary,
            elevation: 4.0, // Standard elevation
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Standard corners
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4.0, // Standard elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // Standard corners
          ),
        ),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkBackground,
          error: AppColors.error,
        ),
        textTheme: appTextTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: Colors.white,
          elevation: 4.0, // Standard elevation
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          elevation: 8.0, // Standard elevation
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primary,
            elevation: 4.0, // Standard elevation
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Standard corners
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4.0, // Standard elevation
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // Standard corners
          ),
        ),
      ),
    );
  }

  // Glassmorphic theme definition - Significantly enhanced
  AppTheme _createGlassmorphicTheme() {
    // Create frosted glass colors
    final lightGlassColor = Colors.white.withAlpha(150); // Translucent white
    final darkGlassColor = Colors.black.withAlpha(120); // Translucent black

    return AppTheme(
      style: ThemeStyle.glassmorphic,
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary
              .withAlpha(230), // Slightly translucent primary color
          secondary: AppColors.secondary
              .withAlpha(230), // Slightly translucent secondary
          surface: lightGlassColor,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor:
            Colors.white.withAlpha(240), // Almost transparent white
        textTheme: appTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary.withAlpha(150), // Very translucent
          foregroundColor: Colors.white,
          elevation: 0, // No elevation for glassmorphic
        ),
        cardTheme: CardTheme(
          elevation: 0, // No elevation for glassmorphic
          color: lightGlassColor, // Translucent card color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Very rounded corners
            side: BorderSide(
                color: Colors.white.withAlpha(100),
                width: 1.5), // Subtle border
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: lightGlassColor, // Translucent background
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade700,
          elevation: 0, // No elevation for glassmorphic
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                AppColors.primary.withAlpha(180), // Translucent button
            elevation: 0, // No elevation for glassmorphic
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Pill-shaped buttons
              side: BorderSide(
                  color: Colors.white.withAlpha(180),
                  width: 1.5), // White border
            ),
          ),
        ),
        // Add blur effect to dialog backgrounds
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white.withAlpha(200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        // Translucent inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withAlpha(180),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Colors.white.withAlpha(150), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Colors.white.withAlpha(150), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: AppColors.primary.withAlpha(230), width: 2),
          ),
        ),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.dark(
          primary:
              AppColors.primary.withAlpha(230), // Slightly translucent primary
          secondary: AppColors.secondary
              .withAlpha(230), // Slightly translucent secondary
          surface: darkGlassColor,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor:
            Colors.black.withAlpha(240), // Almost transparent black
        textTheme: appTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor:
              AppColors.darkSurface.withAlpha(150), // Very translucent
          foregroundColor: Colors.white,
          elevation: 0, // No elevation for glassmorphic
        ),
        cardTheme: CardTheme(
          elevation: 0, // No elevation for glassmorphic
          color: darkGlassColor, // Translucent card color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Very rounded corners
            side: BorderSide(
                color: Colors.white.withAlpha(50), width: 1.5), // Subtle border
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: darkGlassColor, // Translucent background
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade400,
          elevation: 0, // No elevation for glassmorphic
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                AppColors.primary.withAlpha(180), // Translucent button
            elevation: 0, // No elevation for glassmorphic
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Pill-shaped buttons
              side: BorderSide(
                  color: Colors.white.withAlpha(100),
                  width: 1.5), // White border
            ),
          ),
        ),
        // Add blur effect to dialog backgrounds
        dialogTheme: DialogTheme(
          backgroundColor: Colors.black.withAlpha(200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        // Translucent inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black.withAlpha(180),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Colors.white.withAlpha(100), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Colors.white.withAlpha(100), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: AppColors.primary.withAlpha(230), width: 2),
          ),
        ),
      ),
    );
  }
}

// InheritedWidget to provide ThemeManager down the widget tree
class ThemeManagerProvider extends InheritedNotifier<ThemeManager> {
  // Use super parameter syntax
  ThemeManagerProvider({
    super.key,
    required super.child,
  }) : super(
          notifier: ThemeManager(),
        );

  static ThemeManager of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeManagerProvider>();
    return provider!.notifier!;
  }
}
