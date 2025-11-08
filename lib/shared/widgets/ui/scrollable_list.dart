import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:flutter/material.dart';

class DScrollableList extends StatefulWidget {
  final String? title;
  final List<DCardData> items;
  final double spacing;
  final EdgeInsets padding;

  const DScrollableList({
    super.key,
    this.title,
    required this.items,
    this.spacing = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  State<DScrollableList> createState() => _DScrollableListState();
}

class _DScrollableListState extends State<DScrollableList> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showLeftFade = ValueNotifier(false);
  final ValueNotifier<bool> _showRightFade = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateFadeVisibility);

    // Check initial scroll state after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFadeVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateFadeVisibility);
    _scrollController.dispose();
    _showLeftFade.dispose();
    _showRightFade.dispose();
    super.dispose();
  }

  void _updateFadeVisibility() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final offset = _scrollController.offset;
    final maxScroll = position.maxScrollExtent;

    // If list doesn't scroll, don't show any fades
    if (maxScroll <= 0) {
      _showLeftFade.value = false;
      _showRightFade.value = false;
      return;
    }

    // Show left fade after scrolling ~20px
    _showLeftFade.value = offset > 20;

    // Show right fade until we're ~20px from the end
    _showRightFade.value = offset < maxScroll - 20;
  }

  void _scrollLeft() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final targetOffset = (offset - 400).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollRight() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetOffset = (offset + 400).clamp(0.0, maxScroll);

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  double _getResponsiveCardWidth(double containerWidth) {
    // Responsive card widths based on container width
    if (containerWidth < 600) {
      return containerWidth * 0.5; // Mobile: 70% of container width
    } else if (containerWidth < 900) {
      return 280.0; // Tablet
    } else if (containerWidth < 1200) {
      return 300.0; // Desktop
    } else {
      return 320.0; // Large Desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = _getResponsiveCardWidth(constraints.maxWidth);
        final cardHeight = cardWidth * 10 / 16; // 16:10 aspect ratio

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null)
              Padding(
                padding: widget.padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                      ),
                    ),
                    // Scroll control buttons (always show both to avoid layout shift)
                    ValueListenableBuilder<bool>(
                      valueListenable: _showLeftFade,
                      builder: (context, showLeft, child) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: _showRightFade,
                          builder: (context, showRight, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Opacity(
                                  opacity: showLeft ? 1.0 : 0.3,
                                  child: IgnorePointer(
                                    ignoring: !showLeft,
                                    child: DButton(
                                      icon: PlatformIcons.chevronLeft,
                                      variant: DButtonVariant.ghost,
                                      size: DButtonSize.sm,
                                      onTap: _scrollLeft,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Opacity(
                                  opacity: showRight ? 1.0 : 0.3,
                                  child: IgnorePointer(
                                    ignoring: !showRight,
                                    child: DButton(
                                      icon: PlatformIcons.chevronRight,
                                      variant: DButtonVariant.ghost,
                                      size: DButtonSize.sm,
                                      onTap: _scrollRight,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            if (widget.title != null) const SizedBox(height: 16),
            SizedBox(
              height:
                  cardHeight +
                  100, // Card height + text area + extra space for hover scaling
              child: ValueListenableBuilder<bool>(
                valueListenable: _showLeftFade,
                builder: (context, showLeft, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _showRightFade,
                    builder: (context, showRight, _) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              showLeft ? Colors.transparent : Colors.white,
                              Colors.white,
                              Colors.white,
                              showRight ? Colors.transparent : Colors.white,
                            ],
                            stops: const [0.0, 0.05, 0.95, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: child!,
                      );
                    },
                  );
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: cardHeight + 90,
                    child: ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: widget.padding,
                      clipBehavior: Clip.none,
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: cardWidth * 2, // Cache 2 cards ahead
                      itemCount: widget.items.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: widget.spacing),
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return RepaintBoundary(
                          child: DCard(
                            title: item.title,
                            year: item.year,
                            imageUrl: item.imageUrl,
                            onTap: item.onTap,
                            width: cardWidth,
                            height: cardHeight,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
