// lib/shared/widgets/global_app_bar.dart - Fixed implementation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_style_toggle.dart';

class GlobalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showSettingsMenu;
  final double height;
  final bool automaticallyImplyLeading;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showSettingsMenu = true,
    this.height = kToolbarHeight,
    this.automaticallyImplyLeading = true,
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
          icon: const AnimatedSettingsIcon(),
          tooltip: 'Settings',
          onPressed: () {
            // Open the end drawer to show settings options
            Scaffold.of(context).openEndDrawer();
          },
        ),
    ];

    return AppBar(
      title: Text(title),
      actions: combinedActions,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

// Animated settings icon component
class AnimatedSettingsIcon extends StatefulWidget {
  const AnimatedSettingsIcon({super.key});

  @override
  State<AnimatedSettingsIcon> createState() => _AnimatedSettingsIconState();
}

class _AnimatedSettingsIconState extends State<AnimatedSettingsIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 1/8 rotation when hovered
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _controller.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159, // Convert to radians
            child: const Icon(Icons.settings),
          );
        },
      ),
    );
  }
}
