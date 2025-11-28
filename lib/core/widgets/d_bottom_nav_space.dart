// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_scaffold.dart';

/// Widget that adds bottom padding equal to bottom navigation bar height + padding
/// Only applies on mobile layout
/// Use this to wrap content that should be offset by the bottom navigation bar
class DBottomNavSpace extends StatelessWidget {
  final Widget child;

  const DBottomNavSpace({super.key, required this.child});

  /// Get the total height of the bottom navigation bar including padding and safe area
  static double getTotalHeight(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Pill height (60)
    const pillContentHeight = 60.0;
    // Container padding (4 top + 4 bottom = 8)
    const pillContainerPadding = AppConstants.spacing4 * 2;
    // Bottom Nav vertical padding (top padding only as bottom is safe area)
    const bottomNavVerticalPadding = AppConstants.bottomNavPaddingVertical;

    return pillContentHeight +
        pillContainerPadding +
        bottomNavVerticalPadding +
        bottomPadding;
  }

  @override
  Widget build(BuildContext context) {
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);

    if (useDesktopLayout) {
      return child;
    }

    final bottomSpace = getTotalHeight(context);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpace),
      child: child,
    );
  }
}

/// FloatingActionButtonLocation that positions the FAB above the custom bottom navigation bar
class DBottomNavFabLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;

  // Height of the bottom nav content (pill + padding + margin)
  // 60 (pill) + 8 (pill padding) + 8 (nav vertical padding) = 76
  static const double _bottomNavHeight = 76.0;

  const DBottomNavFabLocation([
    this.location = FloatingActionButtonLocation.endFloat,
  ]);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Get the original offset from the wrapped location
    final Offset offset = location.getOffset(scaffoldGeometry);

    // Shift the FAB up by the height of the bottom navigation bar
    // We don't add safe area here because the original offset already accounts for it
    // (assuming the wrapped location is standard and respects safe area)
    return Offset(offset.dx, offset.dy - _bottomNavHeight);
  }

  @override
  String toString() => 'DBottomNavFabLocation(location: $location)';
}
