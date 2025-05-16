import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Define ThemeStyle enum with only the needed options
enum ThemeStyle {
  standard,
  glassmorphic,
}

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

// The CupertinoThemeData remains unchanged
final cupertinoThemeData = CupertinoThemeData(
  primaryColor: Colors.blue,
  barBackgroundColor: Colors.blue,
  scaffoldBackgroundColor: CupertinoColors.systemBackground,
);
