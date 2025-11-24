// External packages
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core

/// Custom AppBar widget that implements a SliverPersistentHeader for precise animation control
///
/// Features:
/// - **Default**: Large title (32px) that collapses to small (14px) on scroll
/// - **Compact**: Fixed small title (14px)
/// - **Background**: Animates from transparent to surface color on scroll
/// - **Height**: Animates from 64px to 44px (or fixed 44px in compact mode)
/// - **Title**: Always centered (or left-aligned if specified)
///
/// Note: This widget MUST be used inside [CustomScrollView.slivers]
class CustomAppBar extends StatelessWidget {
  /// The title text
  final String title;

  /// Whether to use the compact variant (fixed 14px title)
  /// If false (default), title scales from 32px to 14px on scroll
  final bool isCompact;

  /// Optional leading widget (e.g., back button)
  final Widget? leading;

  /// Optional action widgets
  final List<Widget>? actions;

  /// Background color of the AppBar when scrolled
  final Color? backgroundColor;

  /// Whether to automatically imply leading widget
  final bool automaticallyImplyLeading;

  /// Whether to animate the blur and background opacity on scroll
  /// If false (default), the blur and opacity are fixed at their maximum values
  final bool animateBlur;

  /// Whether to align the title to the left
  /// If null (default), title is centered if there are no actions, and left-aligned otherwise
  final bool? leftAligned;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isCompact = false,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
    this.animateBlur = false,
    this.leftAligned,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CustomAppBarDelegate(
        title: title,
        isCompact: isCompact,
        leading: leading,
        actions: actions,
        scrolledBackgroundColor: backgroundColor,
        automaticallyImplyLeading: automaticallyImplyLeading,
        topPadding: MediaQuery.of(context).padding.top,
        animateBlur: animateBlur,
        leftAligned: leftAligned,
      ),
    );
  }
}

class _CustomAppBarDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final bool isCompact;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? scrolledBackgroundColor;
  final bool automaticallyImplyLeading;
  final double topPadding;
  final bool animateBlur;
  final bool? leftAligned;

  // Constants matching the Figma design
  static const double _expandedAppBarHeight = 80.0;
  static const double _collapsedAppBarHeight = 44.0;
  static const double _expandedFontSize = 32.0;
  static const double _collapsedFontSize = 14.0;
  static const double _scrollThreshold =
      100.0; // Scroll distance for full animation

  _CustomAppBarDelegate({
    required this.title,
    required this.isCompact,
    this.leading,
    this.actions,
    this.scrolledBackgroundColor,
    required this.automaticallyImplyLeading,
    required this.topPadding,
    required this.animateBlur,
    this.leftAligned,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    // Calculate progress (0.0 = expanded, 1.0 = collapsed)
    // Use shrinkOffset directly with a threshold for smooth animation
    final double progress = (shrinkOffset / _scrollThreshold).clamp(0.0, 1.0);

    // Calculate current height based on mode
    final double currentHeight = isCompact
        ? _collapsedAppBarHeight
        : _lerpDouble(_expandedAppBarHeight, _collapsedAppBarHeight, progress);

    // Blur and Background
    final double blurSigma = animateBlur ? progress * 12.0 : 12.0;
    final Color currentBackgroundColor = animateBlur
        ? Colors.black.withValues(alpha: 0.4 * progress)
        : Colors.black.withValues(alpha: 0.4);

    // Determine Leading Widget
    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && automaticallyImplyLeading) {
      if (Navigator.of(context).canPop()) {
        effectiveLeading = IconButton(
          icon: Icon(LucideIcons.chevronLeft300, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        );
      }
    }

    // Determine if title should be centered or left-aligned
    final bool effectiveCenterTitle = leftAligned != null
        ? !leftAligned!
        : true;

    // Build title widget based on alignment
    Widget titleWidget;
    if (!effectiveCenterTitle && !isCompact) {
      // Use fade transition for left-aligned titles
      titleWidget = _buildFadingTitle(theme, appBarTheme, progress);
    } else {
      // Use scaling transition for centered titles or compact mode
      final double currentFontSize = isCompact
          ? _collapsedFontSize
          : _lerpDouble(_expandedFontSize, _collapsedFontSize, progress);

      titleWidget = Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: currentFontSize,
          fontWeight: FontWeight.w600,
          color: appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
        ),
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          height: currentHeight + topPadding,
          color: currentBackgroundColor,
          padding: EdgeInsets.only(top: topPadding),
          child: SizedBox(
            height: currentHeight,
            child: NavigationToolbar(
              leading: effectiveLeading != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconTheme(
                        data: appBarTheme.iconTheme ?? theme.iconTheme,
                        child: effectiveLeading,
                      ),
                    )
                  : null,
              middle: titleWidget,
              trailing: actions != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [...actions!, const SizedBox(width: 8.0)],
                    )
                  : null,
              centerMiddle: effectiveCenterTitle,
              middleSpacing: NavigationToolbar.kMiddleSpacing,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFadingTitle(
    ThemeData theme,
    AppBarThemeData appBarTheme,
    double progress,
  ) {
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
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: _expandedFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: _collapsedFontSize,
                fontWeight: FontWeight.w600,
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
  double get maxExtent =>
      (isCompact ? _collapsedAppBarHeight : _expandedAppBarHeight) + topPadding;

  @override
  double get minExtent => _collapsedAppBarHeight + topPadding;

  @override
  bool shouldRebuild(covariant _CustomAppBarDelegate oldDelegate) {
    return title != oldDelegate.title ||
        isCompact != oldDelegate.isCompact ||
        leading != oldDelegate.leading ||
        actions != oldDelegate.actions ||
        scrolledBackgroundColor != oldDelegate.scrolledBackgroundColor ||
        automaticallyImplyLeading != oldDelegate.automaticallyImplyLeading ||
        topPadding != oldDelegate.topPadding ||
        animateBlur != oldDelegate.animateBlur ||
        leftAligned != oldDelegate.leftAligned;
  }
}
