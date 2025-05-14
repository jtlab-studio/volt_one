// lib/shared/widgets/consistent_bottom_navigation.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';

/// A reusable bottom navigation bar component that maintains consistent styling across the app
class ConsistentBottomNavigationBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? backgroundColor;
  final double? elevation;
  final double iconSize;
  final bool showLabels;

  const ConsistentBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.backgroundColor,
    this.elevation = 8.0,
    this.iconSize = 24.0,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width >= 768;
    final palette = ref.watch(colorPaletteProvider);

    // Use the standard Flutter BottomNavigationBar for consistent behavior
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items, // Uses translated strings from the parent widget
      type: BottomNavigationBarType.fixed,
      selectedItemColor: selectedItemColor ?? palette.navSelectedTextColor,
      unselectedItemColor:
          unselectedItemColor ?? palette.navUnselectedTextColor,
      backgroundColor:
          backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
      elevation: elevation,
      iconSize: isLargeScreen ? iconSize * 1.2 : iconSize,
      showUnselectedLabels: showLabels,
      selectedLabelStyle: TextStyle(
        fontSize: isLargeScreen ? 12.0 : 10.0,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: isLargeScreen ? 12.0 : 10.0,
      ),
    );
  }
}
