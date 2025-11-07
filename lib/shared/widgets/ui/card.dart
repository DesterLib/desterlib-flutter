import 'package:flutter/material.dart';
import '../../utils/platform_icons.dart';
import 'cached_image.dart';

class DCard extends StatefulWidget {
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
  State<DCard> createState() => _DCardState();
}

class _DCardState extends State<DCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    final titleSize = widget.isCompact || isSmallScreen ? 14.0 : 16.0;
    final yearSize = widget.isCompact || isSmallScreen ? 12.0 : 14.0;
    final spacing = widget.isCompact || isSmallScreen ? 6.0 : 8.0;

    Widget buildImage() {
      final imageContent = widget.width != null && widget.height != null
          ? SizedBox(
              width: widget.width,
              height: widget.height,
              child: _buildCardContent(),
            )
          : AspectRatio(aspectRatio: 16 / 10, child: _buildCardContent());

      // Add scale animation to image using TweenAnimationBuilder to avoid layout shift
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 1.0,
          end: _isPressed
              ? 0.98
              : _isHovered
              ? 1.02
              : 1.0,
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: imageContent,
      );
    }

    Widget buildText({bool flexible = false}) {
      final textContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
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
          SizedBox(height: spacing - 2), // Small gap between title and year
          Text(
            widget.year,
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

      // Add slight downward shift animation to text using Transform to avoid layout shift
      final animatedText = TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: _isHovered ? 4.0 : 0.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        builder: (context, offset, child) {
          return Transform.translate(offset: Offset(0, offset), child: child);
        },
        child: textContent,
      );

      return flexible ? Flexible(child: animatedText) : animatedText;
    }

    final content = widget.isInGrid
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildImage(),
              SizedBox(height: spacing),
              buildText(flexible: true),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImage(),
              SizedBox(height: spacing + 4),
              // Constrain text area to prevent overflow
              if (widget.width != null)
                SizedBox(width: widget.width, child: buildText())
              else
                buildText(),
              // Extra bottom padding to prevent overflow
              const SizedBox(height: 4),
            ],
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: content,
      ),
    );
  }

  Widget _buildCardContent() {
    final hasImage = widget.imageUrl != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background color (always present)
          Container(color: const Color(0xFF1a1a1a)),

          // Image filling the card
          if (hasImage)
            DCachedImage(
              imageUrl: widget.imageUrl!,
              fit: BoxFit.cover, // Fill the card while maintaining aspect ratio
              // Landscape aspect ratio cache for backdrop images (16:9)
              // High resolution for 2x-3x retina displays
              cacheWidth: 1600,
              cacheHeight: 900,
              showLoadingIndicator: false,
              errorWidget: Container(color: const Color(0xFF1a1a1a)),
            ),

          // Subtle overlay for better contrast (only if there's an image)
          if (hasImage)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),

          // Icon (when no image available)
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
