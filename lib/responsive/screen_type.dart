import 'package:flutter/material.dart';

/// Enum defining different screen types based on width
enum ScreenType {
  mobile,
  tablet,
  desktop,
}

/// Helper function to determine screen type from BuildContext
ScreenType getScreenType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width >= 1024) {
    return ScreenType.desktop;
  } else if (width >= 600) {
    return ScreenType.tablet;
  } else {
    return ScreenType.mobile;
  }
}

/// Helper class for responsive breakpoints and utilities
class ResponsiveBreakpoints {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  /// Check if screen is mobile sized
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  /// Check if screen is tablet sized
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  /// Check if screen is desktop sized
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  /// Get appropriate edge insets based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(24.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(12.0);
    }
  }

  /// Get appropriate spacing value based on screen size
  static double getResponsiveSpacing(BuildContext context) {
    if (isDesktop(context)) {
      return 24.0;
    } else if (isTablet(context)) {
      return 16.0;
    } else {
      return 12.0;
    }
  }
}

/// A responsive layout widget that adapts to screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.desktop:
        return desktopLayout ?? tabletLayout ?? mobileLayout;
      case ScreenType.tablet:
        return tabletLayout ?? mobileLayout;
      case ScreenType.mobile:
        return mobileLayout;
    }
  }
}
