import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Include neumorphic temporarily to fix compilation errors
// TODO: Remove once all files are synced
enum ThemeStyle {
  standard,
  glassmorphic,
  neumorphic, // Keep temporarily for compatibility
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
