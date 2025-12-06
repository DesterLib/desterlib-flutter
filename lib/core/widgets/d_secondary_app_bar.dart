// External packages
import 'dart:ui';
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_scaffold.dart';
import 'package:dester/core/widgets/d_sidebar.dart';
import 'package:dester/core/widgets/d_icon_button.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// Secondary AppBar - plain and simple
///
/// Features:
/// - Small title (14px) always centered
/// - Blur background (no animation)
/// - Fixed height (48px)
/// - Supports right-aligned actions
///
/// Note: This widget MUST be used inside [CustomScrollView.slivers]
class DSecondaryAppBar extends StatefulWidget {
  /// The title text
  final String title;

  /// Optional leading widget (e.g., back button)
  final Widget? leading;

  /// Optional action widgets (right-aligned)
  final List<Widget>? actions;

  /// Whether to remove the sidebar spacing
  final bool withoutSidebarSpacing;

  /// Background color of the AppBar
  final Color? backgroundColor;

  /// Whether to automatically imply leading widget
  final bool automaticallyImplyLeading;

  const DSecondaryAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.withoutSidebarSpacing = false,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  @override
  State<DSecondaryAppBar> createState() => _DSecondaryAppBarState();
}

class _DSecondaryAppBarState extends State<DSecondaryAppBar> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DSecondaryAppBarDelegate(
        title: widget.title,
        leading: widget.leading,
        actions: widget.actions,
        scrolledBackgroundColor: widget.backgroundColor,
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        topPadding: topPadding,
        withoutSidebarSpacing: widget.withoutSidebarSpacing,
      ),
    );
  }
}

class _DSecondaryAppBarDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? scrolledBackgroundColor;
  final bool automaticallyImplyLeading;
  final double topPadding;
  final bool withoutSidebarSpacing;

  // Constants
  static const double _appBarHeight = 48.0;
  static const double _fontSize = 14.0;
  static const double _blurSigma = 40.0;

  _DSecondaryAppBarDelegate({
    required this.title,
    this.leading,
    this.actions,
    this.scrolledBackgroundColor,
    required this.automaticallyImplyLeading,
    required this.topPadding,
    this.withoutSidebarSpacing = false,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Fixed height - no animation
    final double currentExtent = _appBarHeight + topPadding;

    // Fixed blur and background (no animation)
    final Color currentBackgroundColor =
        scrolledBackgroundColor ?? Colors.black.withValues(alpha: 0.4);

    // Determine Leading Widget
    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && automaticallyImplyLeading) {
      final navigator = Navigator.maybeOf(context);
      if (navigator != null && navigator.canPop()) {
        effectiveLeading = ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: kToolbarHeight,
            maxWidth: kToolbarHeight,
            minHeight: kToolbarHeight,
            maxHeight: kToolbarHeight,
          ),
          child: Center(
            child: DIconButton(
              icon: DIconName.chevronLeft,
              variant: DIconButtonVariant.plain,
              size: DIconButtonSize.sm,
              onPressed: () {
                final nav = Navigator.maybeOf(context);
                if (nav != null && nav.canPop()) {
                  nav.pop();
                }
              },
            ),
          ),
        );
      }
    }

    // Simple centered title
    final Widget titleWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppTypography.inter(
        fontSize: _fontSize,
        fontWeight: AppTypography.weightSemiBold,
        color: Colors.white,
      ),
    );

    // Check if we should apply sidebar spacing
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);
    final sidebarTotalWidth = useDesktopLayout ? DSidebar.getTotalWidth() : 0.0;

    // Apply border radius only on desktop
    final borderRadius = useDesktopLayout
        ? BorderRadius.only(bottomLeft: Radius.circular(AppConstants.radius2xl))
        : null;

    Widget content = SizedBox(
      height: currentExtent,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
          child: Container(
            color: currentBackgroundColor,
            padding: EdgeInsets.only(
              top: topPadding,
              left: AppConstants.spacing4,
              right: AppConstants.spacing4,
            ),
            child: SizedBox(
              height: _appBarHeight,
              child: NavigationToolbar(
                leading: effectiveLeading,
                middle: titleWidget,
                trailing: actions != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [...actions!, const SizedBox(width: 8.0)],
                      )
                    : null,
                centerMiddle: true, // Always centered
                middleSpacing: NavigationToolbar.kMiddleSpacing,
              ),
            ),
          ),
        ),
      ),
    );

    // Wrap the entire AppBar with sidebar spacing
    if (sidebarTotalWidth > 0.0 && !withoutSidebarSpacing) {
      return Padding(
        padding: EdgeInsets.only(left: sidebarTotalWidth),
        child: content,
      );
    }

    return content;
  }

  @override
  double get maxExtent => _appBarHeight + topPadding;

  @override
  double get minExtent => _appBarHeight + topPadding;

  @override
  bool shouldRebuild(covariant _DSecondaryAppBarDelegate oldDelegate) {
    return title != oldDelegate.title ||
        leading != oldDelegate.leading ||
        actions != oldDelegate.actions ||
        scrolledBackgroundColor != oldDelegate.scrolledBackgroundColor ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        topPadding != oldDelegate.topPadding ||
        withoutSidebarSpacing != oldDelegate.withoutSidebarSpacing;
  }
}
