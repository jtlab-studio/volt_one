import 'package:flutter/material.dart';

/// A reusable bottom navigation bar component that maintains consistent styling and height across the app
class ConsistentBottomNavigationBar extends StatelessWidget {
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
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.backgroundColor,
    this.elevation = 8.0,
    this.iconSize = 24.0,
    this.showLabels = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width >= 768;

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;

    // Calculate the navigation bar height, ensuring the total height including padding stays within bounds
    double navBarHeight =
        (screenHeight * 0.08).clamp(56.0, 64.0) - bottomPadding;

    return SafeArea(
      bottom: true,
      child: Material(
        elevation: elevation ?? 0,
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        child: Container(
          height: navBarHeight,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: selectedItemColor ?? theme.primaryColor,
            unselectedItemColor: unselectedItemColor ?? Colors.grey,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconSize: isLargeScreen ? iconSize * 1.2 : iconSize,
            showUnselectedLabels: showLabels,
            selectedLabelStyle: TextStyle(
              fontSize: isLargeScreen ? 12.0 : 10.0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: isLargeScreen ? 12.0 : 10.0,
            ),
          ),
        ),
      ),
    );
  }
}
