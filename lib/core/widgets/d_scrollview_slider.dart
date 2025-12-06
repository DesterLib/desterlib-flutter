// External packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_icon_button.dart';
import 'package:dester/core/widgets/d_scaffold.dart';

/// A generic horizontal scrollable view with navigation buttons
///
/// This widget provides a reusable horizontal scrolling container with:
/// - Automatic navigation button visibility management
/// - Smooth scroll animations
/// - Desktop-specific navigation buttons
/// - Customizable scroll distance
///
/// Example usage:
/// ```dart
/// DScrollViewSlider(
///   builder: (context, controller) => ListView.builder(
///     controller: controller,
///     scrollDirection: Axis.horizontal,
///     itemCount: items.length,
///     itemBuilder: (context, index) => ItemWidget(items[index]),
///   ),
/// )
/// ```
class DScrollViewSlider extends StatefulWidget {
  /// Builder function that receives the ScrollController
  /// The returned widget should use the provided controller
  final Widget Function(BuildContext context, ScrollController controller)
  builder;

  /// Scroll distance per navigation button click (default: 400)
  final double scrollDistance;

  /// Whether to show navigation buttons on desktop (default: true)
  final bool showNavigationButtons;

  /// Custom ScrollController (optional, will create one if not provided)
  final ScrollController? controller;

  /// Callback when scroll position changes
  final void Function(double position)? onScrollChanged;

  const DScrollViewSlider({
    super.key,
    required this.builder,
    this.scrollDistance = 400.0,
    this.showNavigationButtons = true,
    this.controller,
    this.onScrollChanged,
  });

  @override
  State<DScrollViewSlider> createState() => _DScrollViewSliderState();
}

class _DScrollViewSliderState extends State<DScrollViewSlider> {
  late ScrollController _scrollController;
  bool _isControllerOwned = false;
  bool _showLeftButton = false;
  bool _showRightButton = true;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _isControllerOwned = widget.controller == null;
    _scrollController.addListener(_updateButtonVisibility);
    // Update button visibility after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateButtonVisibility();
    });
  }

  @override
  void didUpdateWidget(DScrollViewSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // If controller changed, dispose old one if we owned it
      if (_isControllerOwned) {
        _scrollController.removeListener(_updateButtonVisibility);
        _scrollController.dispose();
      }
      // Use new controller
      _scrollController = widget.controller ?? ScrollController();
      _isControllerOwned = widget.controller == null;
      _scrollController.addListener(_updateButtonVisibility);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateButtonVisibility();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateButtonVisibility);
    if (_isControllerOwned) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _updateButtonVisibility() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final newShowLeft = position.pixels > 0;
    final newShowRight =
        position.pixels < position.maxScrollExtent - 1.0; // Small threshold

    if (mounted &&
        (_showLeftButton != newShowLeft || _showRightButton != newShowRight)) {
      setState(() {
        _showLeftButton = newShowLeft;
        _showRightButton = newShowRight;
      });
    }

    // Call scroll changed callback
    widget.onScrollChanged?.call(position.pixels);
  }

  void _scrollLeft() {
    // Debounce: prevent rapid clicks
    if (_isScrolling) return;

    // Pre-check: ensure we're not at the start
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels <= 0) return;

    _isScrolling = true;
    HapticFeedback.lightImpact();

    final targetOffset = (position.pixels - widget.scrollDistance).clamp(
      0.0,
      position.maxScrollExtent,
    );

    _scrollController
        .animateTo(
          targetOffset,
          duration: AppConstants.durationNormal,
          curve: Curves.easeOut,
        )
        .then((_) {
          // Re-enable scrolling after animation completes
          if (mounted) {
            _isScrolling = false;
          }
        });
  }

  void _scrollRight() {
    // Debounce: prevent rapid clicks
    if (_isScrolling) return;

    // Pre-check: ensure we're not at the end
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    const threshold = 5.0; // Small threshold before the end
    if (position.pixels >= position.maxScrollExtent - threshold) return;

    _isScrolling = true;
    HapticFeedback.lightImpact();

    final targetOffset = (position.pixels + widget.scrollDistance).clamp(
      0.0,
      position.maxScrollExtent,
    );

    _scrollController
        .animateTo(
          targetOffset,
          duration: AppConstants.durationNormal,
          curve: Curves.easeOut,
        )
        .then((_) {
          // Re-enable scrolling after animation completes
          if (mounted) {
            _isScrolling = false;
          }
        });
  }

  /// Exposes the ScrollController for external use
  ScrollController get controller => _scrollController;

  @override
  Widget build(BuildContext context) {
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);

    // Build the scrollable content using the builder
    final scrollableChild = widget.builder(context, _scrollController);

    // If navigation buttons are enabled and we're on desktop, wrap with buttons
    if (widget.showNavigationButtons && useDesktopLayout) {
      return Stack(
        children: [
          scrollableChild,
          // Navigation buttons overlay
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left button
                if (_showLeftButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: AppConstants.spacing16),
                      child: DIconButton(
                        icon: DIconName.chevronLeft,
                        size: DIconButtonSize.sm,
                        onPressed: _scrollLeft,
                        variant: DIconButtonVariant.secondary,
                        blur: true,
                      ),
                    ),
                  ),
                // Right button
                if (_showRightButton)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: AppConstants.spacing16),
                      child: DIconButton(
                        icon: DIconName.chevronRight,
                        size: DIconButtonSize.sm,
                        onPressed: _scrollRight,
                        variant: DIconButtonVariant.secondary,
                        blur: true,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }

    return scrollableChild;
  }
}
