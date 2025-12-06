// External packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Core
import 'package:dester/core/widgets/d_skeleton.dart';

/// Reusable cached image widget with smooth fade-in animation and pulsing skeleton placeholder
class DCachedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const DCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  /// Factory constructor for logo images
  factory DCachedImage.logo({
    required String imageUrl,
    double? width,
    double? height,
    Key? key,
  }) {
    return DCachedImage(
      key: key,
      imageUrl: imageUrl,
      height: height,
      fit: BoxFit.contain,
      placeholder: SizedBox(height: height),
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
  State<DCachedImage> createState() => _DCachedImageState();
}

class _DCachedImageState extends State<DCachedImage> {
  bool _canShowImage = false;
  bool _isCheckingCache = true;

  @override
  void initState() {
    super.initState();
    _checkCacheAndShowImage();
  }

  Future<void> _checkCacheAndShowImage() async {
    // Check if image is already cached
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(widget.imageUrl);

    if (mounted) {
      setState(() {
        _isCheckingCache = false;
        // If cached, show immediately; otherwise show after short delay for smooth transition
        _canShowImage = fileInfo != null;
      });

      // If not cached, add a small delay to prevent flicker
      if (fileInfo == null) {
        Timer(const Duration(milliseconds: 50), () {
          if (mounted) {
            setState(() {
              _canShowImage = true;
            });
          }
        });
      }
    }
  }

  Widget _applyBorderRadius(Widget child) {
    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final placeholderWidget =
        widget.placeholder ??
        DSkeleton(width: widget.width, height: widget.height);

    final errorWidget =
        widget.errorWidget ??
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[800],
          child: const Center(child: Icon(Icons.error, color: Colors.white54)),
        );

    final wrappedPlaceholder = _applyBorderRadius(placeholderWidget);

    // Don't show anything while checking cache (prevents flash)
    if (_isCheckingCache) {
      return wrappedPlaceholder;
    }

    return _applyBorderRadius(
      Stack(
        children: [
          // Only show skeleton if image is not cached and not yet ready
          if (!_canShowImage) wrappedPlaceholder,
          // Show image with fade animation
          AnimatedOpacity(
            opacity: _canShowImage ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 100),
              placeholder: (context, url) => const SizedBox.shrink(),
              errorWidget: (context, url, error) => errorWidget,
            ),
          ),
        ],
      ),
    );
  }
}
