import 'package:dester/shared/widgets/ui/card.dart';
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            if (widget.title != null) const SizedBox(height: 16),
            SizedBox(
              height: cardHeight + 60, // Card height + text area (60)
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
          ],
        );
      },
    );
  }
}
