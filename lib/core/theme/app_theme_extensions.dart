// lib/core/theme/app_theme_extensions.dart

import 'package:flutter/material.dart';
import 'theme_provider.dart';

/// Extension to make it easier to access theme colors throughout the app
extension ThemeExtensions on ThemeData {
  /// Get custom theme extensions
  CustomColorTheme? get customColors => extension<CustomColorTheme>();

  /// Get success color
  Color get successColor => customColors?.success ?? Colors.green;

  /// Get warning color
  Color get warningColor => customColors?.warning ?? Colors.yellow;

  /// Get error color
  Color get errorColor => colorScheme.error;

  /// Get active icon color
  Color get activeIconColor => customColors?.iconActive ?? colorScheme.primary;

  /// Get inactive icon color
  Color get inactiveIconColor => customColors?.iconInactive ?? Colors.grey;

  /// Get card background based on brightness
  Color get cardBackgroundColor => brightness == Brightness.light
      ? colorScheme.surface
      : colorScheme.surface;

  /// Get text color based on brightness
  Color get textColor =>
      brightness == Brightness.light ? Colors.black87 : Colors.white;

  /// Get primary color with opacity
  Color primaryWithOpacity(double opacity) =>
      colorScheme.primary.withOpacity(opacity);

  /// Get secondary color with opacity
  Color secondaryWithOpacity(double opacity) =>
      colorScheme.secondary.withOpacity(opacity);
}

/// Extension to make it easier to access theme context in widgets
extension ThemeContextExtension on BuildContext {
  /// Get current theme
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get custom colors
  CustomColorTheme? get customColors =>
      Theme.of(this).extension<CustomColorTheme>();

  /// Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get suitable background color based on theme brightness
  Color get backgroundColor =>
      isDarkMode ? colorScheme.background : colorScheme.background;

  /// Get app bar color
  Color get appBarColor => isDarkMode
      ? Theme.of(this).appBarTheme.backgroundColor ?? Colors.grey.shade900
      : Theme.of(this).appBarTheme.backgroundColor ?? colorScheme.primary;

  /// Get bottom nav bar color
  Color get bottomNavBarColor => isDarkMode
      ? Theme.of(this).bottomNavigationBarTheme.backgroundColor ??
          Colors.grey.shade900
      : Theme.of(this).bottomNavigationBarTheme.backgroundColor ?? Colors.white;

  /// Get selected tab color
  Color get selectedTabColor =>
      Theme.of(this).bottomNavigationBarTheme.selectedItemColor ??
      colorScheme.primary;

  /// Get unselected tab color
  Color get unselectedTabColor =>
      Theme.of(this).bottomNavigationBarTheme.unselectedItemColor ??
      Colors.grey;
}
