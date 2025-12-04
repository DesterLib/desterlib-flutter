// External packages
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Core
import 'package:dester/core/widgets/d_skeleton.dart';

/// Reusable cached image widget with consistent styling and animations
/// Wraps CachedNetworkImage with fade-in animation and standard placeholders
class DCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final BorderRadius? borderRadius;

  const DCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.borderRadius,
  });

  /// Factory constructor for logo images
  factory DCachedImage.logo({
    required String imageUrl,
    double height = 60,
    Key? key,
  }) {
    return DCachedImage(
      key: key,
      imageUrl: imageUrl,
      height: height,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: SizedBox(height: height), // Transparent, just reserves space
      errorWidget: SizedBox(
        height: height,
        child: const Center(
          child: Icon(Icons.error, color: Colors.white54, size: 32),
        ),
      ),
    );
  }

  /// Factory constructor for backdrop/poster images
  factory DCachedImage.backdrop({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Key? key,
  }) {
    return DCachedImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: const DSkeleton(),
      errorWidget: Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.error, color: Colors.white54, size: 48),
        ),
      ),
    );
  }

  /// Factory constructor for media cards (thumbnails)
  factory DCachedImage.card({
    required String imageUrl,
    required IconData fallbackIcon,
    double width = 278,
    double height = 160,
    BoxFit fit = BoxFit.cover,
    Key? key,
  }) {
    return DCachedImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: DSkeleton(width: width, height: height),
      errorWidget: Container(
        width: width,
        height: height,
        color: Colors.grey[800],
        child: Center(child: Icon(fallbackIcon, size: 48, color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      placeholder: placeholder != null
          ? (context, url) => placeholder!
          : (context, url) => DSkeleton(width: width, height: height),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!
          : (context, url, error) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.error, color: Colors.white54),
              ),
            ),
    );

    // Apply border radius if provided
    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}
