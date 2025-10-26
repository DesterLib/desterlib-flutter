import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/platform_icons.dart';

class DCard extends StatelessWidget {
  final String title;
  final String year;
  final String? imageUrl;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isCompact;
  final bool isInGrid;

  const DCard({
    super.key,
    required this.title,
    required this.year,
    this.imageUrl,
    this.onTap,
    this.width,
    this.height,
    this.isCompact = false,
    this.isInGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    final titleSize = isCompact || isSmallScreen ? 14.0 : 16.0;
    final yearSize = isCompact || isSmallScreen ? 12.0 : 14.0;
    final spacing = isCompact || isSmallScreen ? 6.0 : 8.0;

    Widget buildImage() {
      if (width != null && height != null) {
        return SizedBox(
          width: width,
          height: height,
          child: _buildCardContent(),
        );
      }
      return AspectRatio(aspectRatio: 16 / 10, child: _buildCardContent());
    }

    Widget buildText({bool flexible = false}) {
      final textContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            year,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: yearSize,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
      return flexible ? Flexible(child: textContent) : textContent;
    }

    final content = isInGrid
        ? LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              height: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImage(),
                  SizedBox(height: spacing),
                  buildText(flexible: true),
                ],
              ),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImage(),
              SizedBox(height: spacing + 4),
              if (width != null)
                SizedBox(width: width, child: buildText())
              else
                buildText(),
            ],
          );

    return IntrinsicHeight(
      child: GestureDetector(onTap: onTap, child: content),
    );
  }

  Widget _buildCardContent() {
    final hasImage = imageUrl != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image or color
          if (hasImage)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1a1a1a)),
            )
          else
            Container(color: const Color(0xFF1a1a1a)),

          // Glassmorphism overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: ShapeDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // Icon (after blur, so it's not blurred)
          if (!hasImage)
            Center(
              child: Icon(
                PlatformIcons.movie,
                color: const Color(0xFF666666),
                size: 48,
              ),
            ),
        ],
      ),
    );
  }
}

class DCardData {
  final String title;
  final String year;
  final String? imageUrl;
  final VoidCallback? onTap;

  const DCardData({
    required this.title,
    required this.year,
    this.imageUrl,
    this.onTap,
  });
}
