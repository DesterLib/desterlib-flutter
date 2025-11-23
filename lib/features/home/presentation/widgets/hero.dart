import 'dart:ui' as ui;
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, this.mediaItems});
  final List<MediaItem>? mediaItems;

  @override
  Widget build(BuildContext context) {
    // Use the first media item if available
    final firstItem = mediaItems?.isNotEmpty == true ? mediaItems!.first : null;
    final posterPath = firstItem?.posterPath;

    return SizedBox(
      width: double.infinity,
      height: 600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return ui.Gradient.linear(
                const Offset(0, 0),
                Offset(0, bounds.height),
                [
                  Colors.white, // Fully visible at top
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.4),
                  Colors.transparent, // Fully transparent at bottom
                ],
                [0.0, 0.3, 0.7, 1.0],
              );
            },
            blendMode: BlendMode.dstIn,
            child: CachedNetworkImage(
              imageUrl: posterPath ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
