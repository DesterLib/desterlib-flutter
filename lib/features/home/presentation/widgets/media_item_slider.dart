// External packages
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dester/core/widgets/d_icon.dart';
import 'package:dester/core/widgets/d_loading_wrapper.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_sidebar.dart';
import 'package:dester/core/widgets/d_scaffold.dart';

/// A reusable slider widget for displaying media items horizontally
class MediaItemSlider<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final bool isLoading;
  final String? error;
  final String emptyMessage;
  final VoidCallback onRetry;
  final String retryLabel;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const MediaItemSlider({
    super.key,
    required this.title,
    required this.items,
    required this.isLoading,
    this.error,
    required this.emptyMessage,
    required this.onRetry,
    required this.retryLabel,
    required this.itemBuilder,
  });

  @override
  State<MediaItemSlider<T>> createState() => _MediaItemSliderState<T>();
}

class _MediaItemSliderState<T> extends State<MediaItemSlider<T>> {
  late ScrollController _scrollController;
  bool _showLeftButton = false;
  bool _showRightButton = true;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateButtonVisibility);
    // Update button visibility after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateButtonVisibility();
    });
  }

  @override
  void didUpdateWidget(MediaItemSlider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      // Update button visibility when items change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateButtonVisibility();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateButtonVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateButtonVisibility() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    setState(() {
      _showLeftButton = position.pixels > 0;
      _showRightButton =
          position.pixels < position.maxScrollExtent - 1.0; // Small threshold
    });
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

    final targetOffset = (position.pixels - 400).clamp(
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

    final targetOffset = (position.pixels + 400).clamp(
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

  @override
  Widget build(BuildContext context) {
    final useDesktopLayout =
        DScaffold.isDesktop && DScaffold.isDesktopLayout(context);
    final sidebarTotalWidth = useDesktopLayout ? DSidebar.getTotalWidth() : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSidebarSpace(
          child: Padding(
            padding: AppConstants.padding(AppConstants.spacing16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: AppTypography.headlineLarge()),
                // Left/Right navigation buttons (desktop only)
                if (useDesktopLayout &&
                    !widget.isLoading &&
                    widget.items.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _NavigationButton(
                        icon: DIconName.chevronLeft,
                        onTap: _scrollLeft,
                        enabled: _showLeftButton,
                      ),
                      const SizedBox(width: AppConstants.spacing8),
                      _NavigationButton(
                        icon: DIconName.chevronRight,
                        onTap: _scrollRight,
                        enabled: _showRightButton,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        DLoadingWrapper(
          isLoading: widget.isLoading,
          loader: const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          ),
          child: widget.error != null
              ? SizedBox(
                  height: 280,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.error!,
                          style: AppTypography.bodyMedium(color: Colors.red),
                        ),
                        AppConstants.spacingY(AppConstants.spacing8),
                        ElevatedButton(
                          onPressed: widget.onRetry,
                          child: Text(widget.retryLabel),
                        ),
                      ],
                    ),
                  ),
                )
              : widget.items.isEmpty
              ? DSidebarSpace(
                  child: SizedBox(
                    height: 280,
                    child: Center(child: Text(widget.emptyMessage)),
                  ),
                )
              : SizedBox(
                  height: 280,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: AppConstants.spacing16 + sidebarTotalWidth,
                      right: AppConstants.spacing16,
                    ),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == widget.items.length - 1
                              ? 0
                              : AppConstants.spacing12,
                        ),
                        child: widget.itemBuilder(context, item, index),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final DIconName icon;
  final VoidCallback onTap;
  final bool enabled;

  const _NavigationButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          AppConstants.buttonBorderRadiusPill,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(
                AppConstants.buttonBorderRadiusPill,
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.07),
                    width: 1,
                  ),
                ),
                child: DIcon(icon: icon, size: 20.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
