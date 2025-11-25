// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/widgets/d_sidebar.dart';
import 'package:dester/core/widgets/d_scaffold.dart';

/// Widget that adds left padding equal to sidebar width + padding
/// Only applies on desktop layout
/// Use this to wrap content that should be offset by the sidebar
class DSidebarSpace extends StatelessWidget {
  final Widget child;

  const DSidebarSpace({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);

    if (!useDesktopLayout) {
      return child;
    }

    // Sidebar width (240) + left padding (8) + right padding (8) = 256
    final sidebarTotalWidth = DSidebar.getTotalWidth();

    return Padding(
      padding: EdgeInsets.only(left: sidebarTotalWidth),
      child: child,
    );
  }
}
