// lib/shared/widgets/swipeable_bottom_navigation.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A swipeable bottom navigation container that allows switching between navigation bars
/// with left and right swipe gestures
class SwipeableBottomNavigation extends ConsumerStatefulWidget {
  /// List of bottom navigation widgets to switch between
  final List<Widget> navigationBars;

  /// Initial index to show
  final int initialIndex;

  /// Callback when the index changes through swiping
  final Function(int)? onIndexChanged;

  const SwipeableBottomNavigation({
    Key? key,
    required this.navigationBars,
    this.initialIndex = 0,
    this.onIndexChanged,
  }) : super(key: key);

  @override
  ConsumerState<SwipeableBottomNavigation> createState() =>
      _SwipeableBottomNavigationState();
}

class _SwipeableBottomNavigationState
    extends ConsumerState<SwipeableBottomNavigation> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SwipeableBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update page controller if initialIndex changes from parent
    if (widget.initialIndex != oldWidget.initialIndex &&
        widget.initialIndex != _currentIndex) {
      _currentIndex = widget.initialIndex;
      // Animate to the new index
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Exclude vertical gestures to not interfere with scrolling
      excludeFromSemantics: true,
      child: SizedBox(
        // Let the height be determined by the navigation bars
        height: null,
        child: PageView(
          controller: _pageController,
          physics: const PageScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Notify parent of index change
            if (widget.onIndexChanged != null) {
              widget.onIndexChanged!(index);
            }
          },
          children: widget.navigationBars,
        ),
      ),
    );
  }
}
