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
    if (_themeStyle == ThemeStyle.glassmorphic) {
      return _createGlassmorphicTheme();
    } else if (_themeStyle == ThemeStyle.neumorphic) {
      return _createNeumorphicTheme();
    } else {
      // Default to standard
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

  // Glassmorphic theme definition
  AppTheme _createGlassmorphicTheme() {
    // Create frosted glass colors
    final lightGlassColor =
        Color.fromRGBO(255, 255, 255, 0.6); // Translucent white
    final darkGlassColor = Color.fromRGBO(0, 0, 0, 0.5); // Translucent black

    return AppTheme(
      style: ThemeStyle.glassmorphic,
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.light(
          primary: Color.fromRGBO(
              AppColors.primary.value >> 16 & 0xFF,
              AppColors.primary.value >> 8 & 0xFF,
              AppColors.primary.value & 0xFF,
              0.9), // Slightly translucent primary color
          secondary: Color.fromRGBO(
              AppColors.secondary.value >> 16 & 0xFF,
              AppColors.secondary.value >> 8 & 0xFF,
              AppColors.secondary.value & 0xFF,
              0.9), // Slightly translucent secondary
          surface: lightGlassColor,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor:
            Color.fromRGBO(255, 255, 255, 0.95), // Almost transparent white
        textTheme: appTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(
              AppColors.primary.value >> 16 & 0xFF,
              AppColors.primary.value >> 8 & 0xFF,
              AppColors.primary.value & 0xFF,
              0.6), // Very translucent
          foregroundColor: Colors.white,
          elevation: 0, // No elevation for glassmorphic
        ),
        cardTheme: CardTheme(
          elevation: 0, // No elevation for glassmorphic
          color: lightGlassColor, // Translucent card color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Very rounded corners
            side: BorderSide(
                color: Color.fromRGBO(255, 255, 255, 0.4),
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
            backgroundColor: Color.fromRGBO(
                AppColors.primary.value >> 16 & 0xFF,
                AppColors.primary.value >> 8 & 0xFF,
                AppColors.primary.value & 0xFF,
                0.7), // Translucent button
            elevation: 0, // No elevation for glassmorphic
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Pill-shaped buttons
              side: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  width: 1.5), // White border
            ),
          ),
        ),
        // Add blur effect to dialog backgrounds
        dialogTheme: DialogTheme(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        // Translucent inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(255, 255, 255, 0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Color.fromRGBO(255, 255, 255, 0.6), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Color.fromRGBO(255, 255, 255, 0.6), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Color.fromRGBO(
                    AppColors.primary.value >> 16 & 0xFF,
                    AppColors.primary.value >> 8 & 0xFF,
                    AppColors.primary.value & 0xFF,
                    0.9),
                width: 2),
          ),
        ),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(
              AppColors.primary.value >> 16 & 0xFF,
              AppColors.primary.value >> 8 & 0xFF,
              AppColors.primary.value & 0xFF,
              0.9), // Slightly translucent primary
          secondary: Color.fromRGBO(
              AppColors.secondary.value >> 16 & 0xFF,
              AppColors.secondary.value >> 8 & 0xFF,
              AppColors.secondary.value & 0xFF,
              0.9), // Slightly translucent secondary
          surface: darkGlassColor,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor:
            Color.fromRGBO(0, 0, 0, 0.95), // Almost transparent black
        textTheme: appTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(
              AppColors.darkSurface.value >> 16 & 0xFF,
              AppColors.darkSurface.value >> 8 & 0xFF,
              AppColors.darkSurface.value & 0xFF,
              0.6), // Very translucent
          foregroundColor: Colors.white,
          elevation: 0, // No elevation for glassmorphic
        ),
        cardTheme: CardTheme(
          elevation: 0, // No elevation for glassmorphic
          color: darkGlassColor, // Translucent card color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Very rounded corners
            side: BorderSide(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                width: 1.5), // Subtle border
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
            backgroundColor: Color.fromRGBO(
                AppColors.primary.value >> 16 & 0xFF,
                AppColors.primary.value >> 8 & 0xFF,
                AppColors.primary.value & 0xFF,
                0.7), // Translucent button
            elevation: 0, // No elevation for glassmorphic
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Pill-shaped buttons
              side: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.4),
                  width: 1.5), // White border
            ),
          ),
        ),
        // Add blur effect to dialog backgrounds
        dialogTheme: DialogTheme(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        // Translucent inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(0, 0, 0, 0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Color.fromRGBO(255, 255, 255, 0.4), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: Color.fromRGBO(255, 255, 255, 0.4), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Color.fromRGBO(
                    AppColors.primary.value >> 16 & 0xFF,
                    AppColors.primary.value >> 8 & 0xFF,
                    AppColors.primary.value & 0xFF,
                    0.9),
                width: 2),
          ),
        ),
      ),
    );
  }

  // Neumorphic theme definition
  AppTheme _createNeumorphicTheme() {
    // Simplified neumorphic theme
    return AppTheme(
      style: ThemeStyle.neumorphic,
      light: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: Color(0xFFE0E5EC),
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: const Color(0xFFE0E5EC),
        textTheme: appTextTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE0E5EC),
          foregroundColor: Color(0xFF303030),
          elevation: 0.0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFE0E5EC),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          elevation: 8.0,
        ),
        cardTheme: CardTheme(
          elevation: 8.0,
          shadowColor: Colors.grey[300],
          color: const Color(0xFFE0E5EC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primary,
            elevation: 8.0,
            shadowColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: Color(0xFF303030),
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: const Color(0xFF303030),
        textTheme: appTextTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF303030),
          foregroundColor: Colors.white,
          elevation: 0.0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF303030),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          elevation: 8.0,
        ),
        cardTheme: CardTheme(
          elevation: 8.0,
          shadowColor: Colors.black54,
          color: const Color(0xFF303030),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primary,
            elevation: 8.0,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

// InheritedWidget to provide ThemeManager down the widget tree
class ThemeManagerProvider extends InheritedNotifier<ThemeManager> {
  // Use super parameter syntax
  const ThemeManagerProvider({
    super.key,
    required super.child,
  }) : super(
          notifier: ThemeManager(),
        );

  static ThemeManager of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeManagerProvider>();
    if (provider == null) {
      throw Exception('ThemeManagerProvider not found in context');
    }
    return provider.notifier!;
  }
}
