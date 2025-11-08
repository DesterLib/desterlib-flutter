import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loading_indicator.dart';

/// A cached network image widget with consistent error and loading states
class DCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showLoadingIndicator;

  const DCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.placeholder,
    this.errorWidget,
    this.showLoadingIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      placeholder: placeholder != null
          ? (context, url) => placeholder!
          : (showLoadingIndicator
                ? (context, url) => Container(
                    color: const Color(0xFF1a1a1a),
                    child: const Center(child: DLoadingIndicator()),
                  )
                : (context, url) => Container(color: const Color(0xFF1a1a1a))),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!
          : (context, url, error) {
              debugPrint('Image load error: $error');
              debugPrint('Image URL: $url');
              return Container(
                color: const Color(0xFF1a1a1a),
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFF666666),
                    size: 32,
                  ),
                ),
              );
            },
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 150),
    );
  }
}
