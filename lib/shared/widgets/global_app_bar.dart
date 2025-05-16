// lib/shared/widgets/global_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_style_toggle.dart';
import '../../modules/settings/settings_module.dart';

class GlobalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showSettingsMenu;
  final double height;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showSettingsMenu = true,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Combined actions: theme style toggle + custom actions + the settings icon if enabled
    final List<Widget> combinedActions = [
      // Add theme style toggle button
      const ThemeStyleToggle(),

      // Then add any custom actions
      ...(actions ?? []),

      // Finally add settings menu if enabled
      if (showSettingsMenu)
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {
            // Navigate to settings screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingsModule.createRootScreen(),
              ),
            );
          },
        ),
    ];

    return AppBar(
      title: Text(title),
      actions: combinedActions,
      automaticallyImplyLeading: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
