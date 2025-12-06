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

/// Media AppBar - minimal, shows title and blur when hero scrolls out of view
///
/// Features:
/// - Starts with just back button (no title, no blur)
/// - When hero scrolls out of view, shows centered title and blur animation
/// - Supports right-aligned actions
///
/// Note: This widget MUST be used inside [CustomScrollView.slivers]
class DMediaAppBar extends StatefulWidget {
  /// The title text
  final String title;

  /// Optional leading widget (e.g., back button)
  /// If null, a back button will be automatically added if Navigator.canPop() is true
  final Widget? leading;

  /// Optional action widgets (right-aligned)
  final List<Widget>? actions;

  /// Whether to remove the sidebar spacing
  final bool withoutSidebarSpacing;

  /// Background color of the AppBar when scrolled
  final Color? backgroundColor;

  /// Whether to automatically imply leading widget
  final bool automaticallyImplyLeading;

  const DMediaAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.withoutSidebarSpacing = false,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  @override
  State<DMediaAppBar> createState() => _DMediaAppBarState();
}

class _DMediaAppBarState extends State<DMediaAppBar> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DMediaAppBarDelegate(
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

class _DMediaAppBarDelegate extends SliverPersistentHeaderDelegate {
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
  static const double _maxBlurSigma = 40.0;
  // Use a small expanded height to enable shrinkOffset tracking
  // This allows us to detect scroll even with SliverStack
  static const double _expandedHeight = 80.0;

  _DMediaAppBarDelegate({
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
    // Calculate the actual current extent (what the sliver expects)
    final double currentExtent = (maxExtent - shrinkOffset).clamp(
      minExtent,
      maxExtent,
    );

    // Calculate progress (0.0 = expanded, 1.0 = collapsed) for animations
    // Use shrinkOffset to detect scroll, which works better with SliverStack
    final double shrinkDistance = maxExtent - minExtent;
    final double progress = shrinkDistance > 0
        ? ((maxExtent - currentExtent) / shrinkDistance).clamp(0.0, 1.0)
        : 0.0;

    // Show title and blur when scrolled (progress > 0.5)
    // This matches the behavior of DPrimaryAppBar
    final bool showTitleAndBlur = progress > 0.5;

    // Calculate blur progress - fade in over the second half of scroll
    final double blurProgress = progress.clamp(0.5, 1.0);
    final double normalizedBlurProgress = blurProgress > 0.5
        ? ((blurProgress - 0.5) * 2.0)
        : 0.0;
    final double blurSigma = normalizedBlurProgress * _maxBlurSigma;
    final Color currentBackgroundColor = showTitleAndBlur
        ? (scrolledBackgroundColor ??
              Colors.black.withValues(alpha: 0.4 * normalizedBlurProgress))
        : Colors.transparent;

    // Determine Leading Widget
    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && automaticallyImplyLeading) {
      final navigator = Navigator.maybeOf(context);
      if (navigator != null && navigator.canPop()) {
        effectiveLeading = Container(
          margin: EdgeInsets.only(left: AppConstants.spacing16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: kToolbarHeight,
              maxWidth: kToolbarHeight,
              minHeight: kToolbarHeight,
              maxHeight: kToolbarHeight,
            ),
            child: Center(
              child: DIconButton(
                icon: DIconName.arrowLeft,
                variant: showTitleAndBlur
                    ? DIconButtonVariant.plain
                    : DIconButtonVariant.secondaryDark,
                // Apply blur only when app bar doesn't have blur (hero is visible)
                // When app bar has blur, button inherits it, so no need for nested BackdropFilter
                blur: !showTitleAndBlur,
                onPressed: () {
                  final nav = Navigator.maybeOf(context);
                  if (nav != null && nav.canPop()) {
                    nav.pop();
                  }
                },
              ),
            ),
          ),
        );
      }
    }

    // Title only appears when hero is scrolled out of view
    // Fade in with smooth animation
    final Widget? titleWidget = showTitleAndBlur
        ? Opacity(
            opacity: normalizedBlurProgress,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.inter(
                fontSize: _fontSize,
                fontWeight: AppTypography.weightSemiBold,
                color: Colors.white,
              ),
            ),
          )
        : null;

    // Check if we should apply sidebar spacing
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);
    final sidebarTotalWidth = useDesktopLayout ? DSidebar.getTotalWidth() : 0.0;

    // Apply border radius only on desktop
    final borderRadius = useDesktopLayout
        ? BorderRadius.only(bottomLeft: Radius.circular(AppConstants.radius2xl))
        : null;

    // Container with the app bar content
    final appBarContent = Container(
      color: currentBackgroundColor,
      padding: EdgeInsets.only(
        top: topPadding,
        left: AppConstants.spacing4,
        right: AppConstants.spacing4,
      ),
      child: SizedBox(
        height: _appBarHeight, // Always use collapsed height for content
        child: NavigationToolbar(
          leading: effectiveLeading,
          middle: titleWidget,
          trailing: actions != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [...actions!, const SizedBox(width: 8.0)],
                )
              : null,
          centerMiddle: showTitleAndBlur, // Only center when title is shown
          middleSpacing: NavigationToolbar.kMiddleSpacing,
        ),
      ),
    );

    // Only apply BackdropFilter when blur is needed (when hero is scrolled out)
    // This allows the button's blur to work when hero is visible
    Widget content = SizedBox(
      height: currentExtent,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: blurSigma > 0
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: appBarContent,
              )
            : appBarContent,
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
  double get maxExtent => _expandedHeight + topPadding;

  @override
  double get minExtent => _appBarHeight + topPadding;

  @override
  bool shouldRebuild(covariant _DMediaAppBarDelegate oldDelegate) {
    return title != oldDelegate.title ||
        leading != oldDelegate.leading ||
        actions != oldDelegate.actions ||
        scrolledBackgroundColor != oldDelegate.scrolledBackgroundColor ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        topPadding != oldDelegate.topPadding ||
        withoutSidebarSpacing != oldDelegate.withoutSidebarSpacing;
  }
}
