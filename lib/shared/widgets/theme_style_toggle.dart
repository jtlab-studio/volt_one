// lib/shared/widgets/theme_style_toggle.dart

import 'package:flutter/material.dart';
import '../../core/theme_manager.dart';
import '../../theme/app_theme.dart';

class ThemeStyleToggle extends StatelessWidget {
  const ThemeStyleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    // Try to get theme manager, but handle gracefully if not available
    ThemeManager? themeManager;
    ThemeStyle currentStyle = ThemeStyle.standard; // Default fallback

    try {
      themeManager = ThemeManagerProvider.of(context);
      currentStyle = themeManager.themeStyle;
    } catch (e) {
      debugPrint("ThemeStyleToggle: Could not access ThemeManagerProvider: $e");
      // Continue with default style
    }

    return PopupMenuButton<ThemeStyle>(
      icon: _getIconForStyle(currentStyle),
      tooltip: 'Change theme style',
      onSelected: (ThemeStyle style) {
        if (themeManager != null) {
          debugPrint("Setting theme style to: $style");
          themeManager.setThemeStyle(style);
        } else {
          debugPrint("Cannot change theme style: ThemeManager not available");
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeStyle.standard,
          child: Row(
            children: [
              Icon(
                Icons.crop_square,
                color: currentStyle == ThemeStyle.standard
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Standard',
                style: TextStyle(
                  fontWeight: currentStyle == ThemeStyle.standard
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeStyle.glassmorphic,
          child: Row(
            children: [
              Icon(
                Icons.blur_on,
                color: currentStyle == ThemeStyle.glassmorphic
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Glassmorphic',
                style: TextStyle(
                  fontWeight: currentStyle == ThemeStyle.glassmorphic
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeStyle.neumorphic,
          child: Row(
            children: [
              Icon(
                Icons.bubble_chart,
                color: currentStyle == ThemeStyle.neumorphic
                    ? Theme.of(context).primaryColor
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Neumorphic',
                style: TextStyle(
                  fontWeight: currentStyle == ThemeStyle.neumorphic
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to get the appropriate icon for the current style
  Widget _getIconForStyle(ThemeStyle style) {
    switch (style) {
      case ThemeStyle.glassmorphic:
        return const Icon(Icons.blur_on);
      case ThemeStyle.neumorphic:
        return const Icon(Icons.bubble_chart);
      case ThemeStyle.standard:
      default:
        return const Icon(Icons.crop_square);
    }
  }
}
