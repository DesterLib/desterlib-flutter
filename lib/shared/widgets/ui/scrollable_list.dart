import 'package:dester/shared/widgets/ui/card.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';

class DScrollableList extends StatefulWidget {
  final String? title;
  final List<DCardData> items;
  final double spacing;
  final EdgeInsets padding;

  final double? cacheExtent;

  const DScrollableList({
    super.key,
    this.title,
    required this.items,
    this.spacing = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.cacheExtent = 1200,
  });

  @override
  State<DScrollableList> createState() => _DScrollableListState();
}

class _DScrollableListState extends State<DScrollableList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Widget _buildScrollableContent(
    double cardWidth,
    double cardHeight,
    double itemSpacing,
    bool isDesktop,
  ) {
    // Calculate cache extent: use provided value or default to 3x card width
    final effectiveCacheExtent = widget.cacheExtent ?? (cardWidth * 3);

    // Calculate the left padding to respect sidebar on desktop
    final leftPadding = isDesktop
        ? AppLayout.sidebarWidth + AppLayout.desktopHorizontalPadding
        : AppLayout.mobileHorizontalPadding;

    final rightPadding = isDesktop
        ? AppLayout.desktopHorizontalPadding
        : AppLayout.mobileHorizontalPadding;

    // ListView takes full width - viewport includes the entire screen width
    // This keeps more items mounted even when they overflow beyond padding
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: cardHeight + 90,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          cacheExtent: effectiveCacheExtent,
          itemCount: widget.items.length,
          separatorBuilder: (context, index) => SizedBox(width: itemSpacing),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = AppBreakpoints.isDesktop(screenWidth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = isDesktop
            ? AppCardSize.desktopWidth
            : AppCardSize.mobileWidth;
        final cardHeight = AppCardSize.getHeight(cardWidth);
        final itemSpacing = isDesktop ? AppSpacing.xl : widget.spacing;

        // Calculate padding for title to respect sidebar
        final titlePadding = isDesktop
            ? EdgeInsets.only(
                left:
                    AppLayout.sidebarWidth + AppLayout.desktopHorizontalPadding,
                right: AppLayout.desktopHorizontalPadding,
              )
            : EdgeInsets.symmetric(
                horizontal: AppLayout.mobileHorizontalPadding,
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null)
              Padding(
                padding: titlePadding,
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
                    // Scroll control buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DButton(
                          icon: PlatformIcons.chevronLeft,
                          variant: DButtonVariant.ghost,
                          size: DButtonSize.sm,
                          onTap: _scrollLeft,
                        ),
                        const SizedBox(width: 4),
                        DButton(
                          icon: PlatformIcons.chevronRight,
                          variant: DButtonVariant.ghost,
                          size: DButtonSize.sm,
                          onTap: _scrollRight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (widget.title != null) const SizedBox(height: 16),
            SizedBox(
              height:
                  cardHeight +
                  100, // Card height + text area + extra space for hover scaling
              child: _buildScrollableContent(
                cardWidth,
                cardHeight,
                itemSpacing,
                isDesktop,
              ),
            ),
          ],
        );
      },
    );
  }
}
