// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/widgets/d_media_image_card.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Trailer data model
class Trailer {
  final String id;
  final String name;
  final String? thumbnailUrl;
  final String? videoUrl;
  final String? site; // e.g., "YouTube", "Vimeo"
  final String? key; // Video key for embedding

  const Trailer({
    required this.id,
    required this.name,
    this.thumbnailUrl,
    this.videoUrl,
    this.site,
    this.key,
  });
}

/// Card widget for displaying a trailer
class TrailerCard extends StatelessWidget {
  final Trailer trailer;
  final VoidCallback? onTap;

  const TrailerCard({super.key, required this.trailer, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DMediaImageCard(
      imageUrl: trailer.thumbnailUrl,
      width: 320,
      height: 180,
      fallbackIcon: LucideIcons.film,
      onTap: onTap,
      overlay: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
          ),
        ),
        child: Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.play, color: Colors.black, size: 24),
          ),
        ),
      ),
      bottomOverlay: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
          ),
        ),
        child: Text(
          trailer.name,
          style: AppTypography.inter(
            fontSize: AppTypography.fontSizeSm,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
