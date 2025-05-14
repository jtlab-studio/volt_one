import 'package:flutter/material.dart';
import 'consistent_bottom_navigation.dart';

/// Utility class to help with creating consistent bottom navigation bars across screens
class BottomNavigationHelper {
  /// Creates a consistent bottom navigation bar for the main dashboard
  static Widget createMainBottomNavBar(BuildContext context, int currentIndex,
      List<BottomNavigationBarItem> items, ValueChanged<int> onTap,
      {Color? selectedItemColor}) {
    // Here, items should already contain translated labels
    return ConsistentBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      selectedItemColor: selectedItemColor,
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
        // Keep the icon but remove the label text and replace icon with empty container
        modifiedItems[middleIndex] = BottomNavigationBarItem(
          icon: Container(), // Empty container instead of an icon
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
          ),

          // The floating center button
          Positioned(
            bottom: 8, // Positioned closer to the bottom
            child: centerButton,
          ),
        ],
      );
    }

    // Standard navigation bar without center button
    return ConsistentBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      selectedItemColor: selectedItemColor,
      backgroundColor: backgroundColor,
    );
  }
}
