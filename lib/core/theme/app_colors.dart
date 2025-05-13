// File to update: lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

class AppColors {
  // Primary palette - CHANGED TO ORANGE
  static const Color primary =
      Color.fromRGBO(255, 152, 0, 1.0); // Changed from blue to orange
  static const Color primaryDark =
      Color.fromRGBO(235, 132, 0, 1.0); // Darker orange

  // Secondary palette
  static const Color secondary =
      Color.fromRGBO(255, 152, 0, 1.0); // Now matches primary (orange)

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFEB3B);
  static const Color info = Color(0xFF2196F3);

  // Platform-adaptive colors
  static Color get background =>
      Platform.isIOS ? CupertinoColors.systemBackground : Colors.white;

  static Color get textPrimary =>
      Platform.isIOS ? CupertinoColors.label : Colors.black87;

  // Metric card colors
  static const Color paceCardColor = Color(0xFFE3F2FD);
  static const Color heartRateCardColor = Color(0xFFFFEBEE);
  static const Color powerCardColor = Color(0xFFFFF3E0);
  static const Color cadenceCardColor = Color(0xFFE8F5E9);
  static const Color elevationCardColor = Color(0xFFEDE7F6);
}
