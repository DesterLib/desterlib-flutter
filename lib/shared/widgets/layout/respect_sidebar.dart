import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';

/// A widget that automatically adds padding to respect the sidebar on desktop.
/// Content will be pushed to the right of the sidebar on desktop screens.
class RespectSidebar extends StatelessWidget {
  final Widget child;
  final EdgeInsets? customPadding;
  final double leftPadding; // Additional padding after sidebar
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  const RespectSidebar({
    super.key,
    required this.child,
    this.customPadding,
    this.leftPadding = AppLayout.desktopHorizontalPadding,
    this.rightPadding = AppLayout.desktopHorizontalPadding,
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
  });

  /// Convenience constructor for symmetric horizontal padding
  const RespectSidebar.symmetric({
    super.key,
    required this.child,
    this.customPadding,
    double horizontal = AppLayout.desktopHorizontalPadding,
    double vertical = 0.0,
  }) : leftPadding = horizontal,
       rightPadding = horizontal,
       topPadding = vertical,
       bottomPadding = vertical;

  /// Convenience constructor for only horizontal padding
  const RespectSidebar.horizontal({
    super.key,
    required this.child,
    this.customPadding,
    double left = AppLayout.desktopHorizontalPadding,
    double right = AppLayout.desktopHorizontalPadding,
  }) : leftPadding = left,
       rightPadding = right,
       topPadding = 0.0,
       bottomPadding = 0.0;

  /// Sidebar width constant (deprecated - use AppLayout.sidebarWidth instead)
  @Deprecated('Use AppLayout.sidebarWidth from core/constants.dart instead')
  static const double sidebarWidth = AppLayout.sidebarWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = AppBreakpoints.isDesktop(screenWidth);

    if (customPadding != null) {
      return Padding(padding: customPadding!, child: child);
    }

    final padding = isDesktop
        ? EdgeInsets.only(
            left: AppLayout.sidebarWidth + leftPadding,
            right: rightPadding,
            top: topPadding,
            bottom: bottomPadding,
          )
        : EdgeInsets.only(
            left: leftPadding > AppLayout.desktopHorizontalPadding
                ? AppLayout.mobileHorizontalPadding
                : leftPadding,
            right: rightPadding > AppLayout.desktopHorizontalPadding
                ? AppLayout.mobileHorizontalPadding
                : rightPadding,
            top: topPadding,
            bottom: bottomPadding,
          );

    return Padding(padding: padding, child: child);
  }
}
