import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

class AppColors {
  // Primary palette
  static const Color primary = Color.fromRGBO(33, 150, 243, 1.0); // 0xFF2196F3
  static const Color primaryDark =
      Color.fromRGBO(25, 118, 210, 1.0); // 0xFF1976D2

  // Secondary palette
  static const Color secondary = Color.fromRGBO(255, 152, 0, 1.0); // 0xFFFF9800

  // Semantic colors
  static const Color success = Color.fromRGBO(76, 175, 80, 1.0); // 0xFF4CAF50
  static const Color error = Color.fromRGBO(244, 67, 54, 1.0); // 0xFFF44336
  static const Color warning = Color.fromRGBO(255, 235, 59, 1.0); // 0xFFFFEB3B
  static const Color info = Color.fromRGBO(33, 150, 243, 1.0); // 0xFF2196F3

  // Platform-adaptive colors
  static Color get background =>
      Platform.isIOS ? CupertinoColors.systemBackground : Colors.white;

  static Color get textPrimary =>
      Platform.isIOS ? CupertinoColors.label : Colors.black87;

  // Metric card colors
  static const Color paceCardColor =
      Color.fromRGBO(227, 242, 253, 1.0); // 0xFFE3F2FD
  static const Color heartRateCardColor =
      Color.fromRGBO(255, 235, 238, 1.0); // 0xFFFFEBEE
  static const Color powerCardColor =
      Color.fromRGBO(255, 243, 224, 1.0); // 0xFFFFF3E0
  static const Color cadenceCardColor =
      Color.fromRGBO(232, 245, 233, 1.0); // 0xFFE8F5E9
  static const Color elevationCardColor =
      Color.fromRGBO(237, 231, 246, 1.0); // 0xFFEDE7F6

  // Dark theme colors
  static const Color darkBackground =
      Color.fromRGBO(18, 18, 18, 1.0); // 0xFF121212
  static const Color darkSurface =
      Color.fromRGBO(30, 30, 30, 1.0); // 0xFF1E1E1E
  static const Color darkCard = Color.fromRGBO(44, 44, 44, 1.0); // 0xFF2C2C2C

  // Helper methods for applying opacity
  static Color withOpacity(Color color, double opacity) {
    return Color.fromRGBO(
        color.r.toInt(), color.g.toInt(), color.b.toInt(), opacity);
  }
}
