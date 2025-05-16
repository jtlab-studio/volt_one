// lib/shared/widgets/bottom_navigation_helper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'consistent_bottom_navigation.dart';
import '../../core/theme/app_colors.dart'; // Updated to correctly reference core/theme

/// Utility class to help with creating consistent bottom navigation bars across screens
class BottomNavigationHelper {
  /// Creates a consistent bottom navigation bar for the main dashboard
  static Widget createMainBottomNavBar(BuildContext context, int currentIndex,
      List<BottomNavigationBarItem> items, ValueChanged<int> onTap,
      {Color? selectedItemColor, Color? unselectedItemColor}) {
    // Items should already have translated labels from the parent calling widget
    return Consumer(
      builder: (context, ref, child) {
        // Use AppColors directly
        return ConsistentBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          selectedItemColor: selectedItemColor ?? AppColors.primary,
          unselectedItemColor: unselectedItemColor ?? Colors.grey,
        );
      },
    );
  }

  /// Creates a consistent bottom navigation bar for any of the feature hubs
  static Widget createHubBottomNavBar(
    BuildContext context,
    int currentIndex,
    List<BottomNavigationBarItem> items,
    ValueChanged<int> onTap, {
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? backgroundColor,
    Widget? centerButton,
  }) {
    return Consumer(
      builder: (context, ref, child) {
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
                selectedItemColor: selectedItemColor ?? Colors.blue,
                unselectedItemColor: unselectedItemColor ?? Colors.grey,
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
          selectedItemColor: selectedItemColor ?? AppColors.primary,
          unselectedItemColor: unselectedItemColor ?? Colors.grey,
          backgroundColor: backgroundColor,
        );
      },
    );
  }
}
