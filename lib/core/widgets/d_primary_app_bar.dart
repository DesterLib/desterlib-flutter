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

/// Primary AppBar with large title animation
///
/// Features:
/// - Large title (32px) left-aligned that animates to small title (14px) center-aligned on scroll
/// - Blur animation appears when small title becomes visible
/// - Height animates from 80px to 48px on scroll
/// - Supports right-aligned actions
///
/// Note: This widget MUST be used inside [CustomScrollView.slivers]
class DPrimaryAppBar extends StatefulWidget {
  /// The title text
  final String title;

  /// Optional leading widget (e.g., back button)
  final Widget? leading;

  /// Optional action widgets (right-aligned)
  final List<Widget>? actions;

  /// Whether to remove the sidebar spacing
  final bool withoutSidebarSpacing;

  /// Background color of the AppBar when scrolled
  final Color? backgroundColor;

  /// Whether to automatically imply leading widget
  final bool automaticallyImplyLeading;

  const DPrimaryAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.withoutSidebarSpacing = false,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
  });

  @override
  State<DPrimaryAppBar> createState() => _DPrimaryAppBarState();
}

class _DPrimaryAppBarState extends State<DPrimaryAppBar> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DPrimaryAppBarDelegate(
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

class _DPrimaryAppBarDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? scrolledBackgroundColor;
  final bool automaticallyImplyLeading;
  final double topPadding;
  final bool withoutSidebarSpacing;

  // Constants matching the Figma design
  static const double _expandedAppBarHeight = 80.0;
  static const double _collapsedAppBarHeight = 48.0;
  static const double _expandedFontSize = 32.0;
  static const double _collapsedFontSize = 14.0;

  _DPrimaryAppBarDelegate({
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
    final double shrinkDistance = maxExtent - minExtent;
    final double progress = shrinkDistance > 0
        ? ((maxExtent - currentExtent) / shrinkDistance).clamp(0.0, 1.0)
        : 0.0;

    // Calculate current height
    final double currentHeight = _lerpDouble(
      _expandedAppBarHeight,
      _collapsedAppBarHeight,
      progress,
    );

    // Blur and background - animate based on progress
    // Blur appears when small title becomes visible (progress > 0.5)
    final double blurProgress = progress.clamp(0.5, 1.0);
    final double normalizedBlurProgress = blurProgress > 0.5
        ? ((blurProgress - 0.5) * 2.0)
        : 0.0;
    final double blurSigma = normalizedBlurProgress * 40.0;
    final Color currentBackgroundColor = Colors.black.withValues(
      alpha: 0.4 * normalizedBlurProgress,
    );

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

    // Build title with fade animation
    // Large title (left-aligned) fades out, small title (center-aligned) fades in
    final Widget titleWidget = _buildAnimatedTitle(progress);

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
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            color: currentBackgroundColor,
            padding: EdgeInsets.only(
              top: topPadding,
              left: AppConstants.spacing4,
              right: AppConstants.spacing4,
            ),
            child: SizedBox(
              height: currentHeight,
              child: NavigationToolbar(
                leading: effectiveLeading,
                middle: titleWidget,
                trailing: actions != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [...actions!, const SizedBox(width: 8.0)],
                      )
                    : null,
                centerMiddle:
                    false, // Large title is left-aligned, small title handles its own centering
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

  Widget _buildAnimatedTitle(double progress) {
    // Sequential fade: large fades out in first half (0.0-0.5), small fades in second half (0.5-1.0)
    final double largeTitleOpacity = progress <= 0.5
        ? 1.0 - (progress * 2.0)
        : 0.0;
    final double smallTitleOpacity = progress >= 0.5
        ? (progress - 0.5) * 2.0
        : 0.0;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Large title (32px) - fades out first, left-aligned
        Opacity(
          opacity: largeTitleOpacity,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                AppTypography.inter(
                  fontSize: _expandedFontSize,
                  fontWeight: AppTypography.weightSemiBold,
                  color: Colors.white,
                ).copyWith(
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 24,
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                  ],
                ),
          ),
        ),
        // Small title (14px) - fades in after large fades out, centered
        Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: smallTitleOpacity,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.inter(
                fontSize: _collapsedFontSize,
                fontWeight: AppTypography.weightSemiBold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  double get maxExtent => _expandedAppBarHeight + topPadding;

  @override
  double get minExtent => _collapsedAppBarHeight + topPadding;

  @override
  bool shouldRebuild(covariant _DPrimaryAppBarDelegate oldDelegate) {
    return title != oldDelegate.title ||
        leading != oldDelegate.leading ||
        actions != oldDelegate.actions ||
        scrolledBackgroundColor != oldDelegate.scrolledBackgroundColor ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        topPadding != oldDelegate.topPadding ||
        withoutSidebarSpacing != oldDelegate.withoutSidebarSpacing;
  }
}
