// lib/shared/widgets/theme_style_toggle.dart

import 'package:flutter/material.dart';
import '../../core/theme_manager.dart';
import '../../theme/app_theme.dart';

class ThemeStyleToggle extends StatelessWidget {
  const ThemeStyleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme manager and current style
    final themeManager = ThemeManagerProvider.of(context);
    final currentStyle = themeManager.themeStyle;

    debugPrint("Building ThemeStyleToggle with current style: $currentStyle");

    return PopupMenuButton<ThemeStyle>(
      icon: _getIconForStyle(currentStyle),
      tooltip: 'Change theme style',
      onSelected: (ThemeStyle style) {
        debugPrint("Setting theme style to: $style");
        themeManager.setThemeStyle(style);
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
      ],
    );
  }

  // Helper to get the appropriate icon for the current style - using if/else instead of switch
  Widget _getIconForStyle(ThemeStyle style) {
    if (style == ThemeStyle.glassmorphic) {
      return const Icon(Icons.blur_on);
    } else {
      // Default to standard icon
      return const Icon(Icons.crop_square);
    }
  }
}
