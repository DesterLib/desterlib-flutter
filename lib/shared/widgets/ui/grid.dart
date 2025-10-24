import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/card.dart';

class DGrid extends StatelessWidget {
  final List<DCardData> items;
  final int? crossAxisCount;

  const DGrid({super.key, required this.items, this.crossAxisCount});

  int _getResponsiveCrossAxisCount(double screenWidth) {
    if (crossAxisCount != null) return crossAxisCount!;

    // Responsive breakpoints
    if (screenWidth < 600) {
      return 2; // Mobile: 2 columns
    } else if (screenWidth < 900) {
      return 3; // Tablet: 3 columns
    } else if (screenWidth < 1200) {
      return 4; // Desktop: 4 columns
    } else if (screenWidth < 1600) {
      return 5; // Large Desktop: 5 columns
    } else {
      return 6; // Extra Large: 6 columns
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final columns = _getResponsiveCrossAxisCount(containerWidth);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return DCard(
              title: item.title,
              year: item.year,
              imageUrl: item.imageUrl,
              onTap: item.onTap,
              isInGrid: true,
            );
          },
        );
      },
    );
  }
}
