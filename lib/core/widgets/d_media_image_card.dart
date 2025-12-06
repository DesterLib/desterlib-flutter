// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/widgets/d_cached_image.dart';
import 'package:dester/core/constants/app_constants.dart';

/// Generic media card widget that can display any type of media content
/// Supports custom overlays, dimensions, and content
class DMediaImageCard extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final IconData? fallbackIcon;
  final Widget? overlay;
  final Widget? bottomOverlay;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const DMediaImageCard({
    super.key,
    this.imageUrl,
    this.width = 278,
    this.height = 160,
    this.fallbackIcon,
    this.overlay,
    this.bottomOverlay,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final icon = fallbackIcon ?? LucideIcons.film;

    final content = Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: ClipRSuperellipse(
        borderRadius: cardBorderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image or placeholder
            imageUrl != null
                ? DCachedImage.backdrop(
                    imageUrl: imageUrl!,
                    width: width,
                    height: height,
                  )
                : Container(
                    width: width,
                    height: height,
                    color: Colors.grey[900],
                    child: Center(
                      child: Icon(icon, size: 48, color: Colors.grey),
                    ),
                  ),
            // Overlay (e.g., play button)
            if (overlay != null) overlay!,
            // Bottom overlay (e.g., title text)
            if (bottomOverlay != null)
              Positioned(left: 0, right: 0, bottom: 0, child: bottomOverlay!),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
