// lib/shared/widgets/bottom_navigation_helper.dart

import 'package:flutter/material.dart';
import 'consistent_bottom_navigation.dart';

/// Utility class to help with creating consistent bottom navigation bars across screens
class BottomNavigationHelper {
  /// Creates a consistent bottom navigation bar for the main dashboard
  static Widget createMainBottomNavBar(BuildContext context, int currentIndex,
      List<BottomNavigationBarItem> items, ValueChanged<int> onTap,
      {Color? selectedItemColor}) {
    // The key to consistent navigation bars is to use the SAME class across the entire app
    return ConsistentBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      selectedItemColor: selectedItemColor,
      // These settings should be consistent across all uses
      elevation: 8.0,
      iconSize: 24.0,
      showLabels: true,
    );
  }

  /// Creates a consistent bottom navigation bar for any of the feature hubs
  static Widget createHubBottomNavBar(
    BuildContext context,
    int currentIndex,
    List<BottomNavigationBarItem> items,
    ValueChanged<int> onTap, {
    Color? selectedItemColor,
    Color? backgroundColor,
    Widget? centerButton,
  }) {
    // If there's a special center button, we'll create a Stack with both elements
    if (centerButton != null) {
      // Clone the items list to avoid modifying the original
      final List<BottomNavigationBarItem> modifiedItems = List.from(items);

      // Find the middle index (for any number of items)
      final middleIndex = modifiedItems.length ~/ 2;

      // Replace the middle item with one that has an empty label
      if (middleIndex < modifiedItems.length) {
        // Keep the icon but remove the label text
        modifiedItems[middleIndex] = BottomNavigationBarItem(
          icon: modifiedItems[middleIndex].icon,
          label: '', // Empty label to save vertical space
        );
      }

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The standard navigation bar with modified items
          ConsistentBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: modifiedItems,
            selectedItemColor: selectedItemColor,
            backgroundColor: backgroundColor,
            // Use IDENTICAL settings as above for consistency
            elevation: 8.0,
            iconSize: 24.0,
            showLabels: true,
          ),

          // The floating center button
          Positioned(
            bottom: 8, // Positioned closer to the bottom
            child: centerButton,
          ),
        ],
      );
    }

    // Standard navigation bar without center button - using same component
    return ConsistentBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      selectedItemColor: selectedItemColor,
      backgroundColor: backgroundColor,
      // Identical settings for consistency
      elevation: 8.0,
      iconSize: 24.0,
      showLabels: true,
    );
  }
}
