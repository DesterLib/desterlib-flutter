// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Media type enum for card display
enum MediaType { movie, tvShow }

/// Base class for MediaItemCard with common functionality
abstract class MediaItemCard extends StatelessWidget {
  final int? number;
  final String title;
  final String? year;
  final MediaType mediaType;
  final String? imageUrl;

  const MediaItemCard({
    super.key,
    this.number,
    required this.title,
    this.year,
    required this.mediaType,
    this.imageUrl,
  });

  /// Builds the image widget with superellipse styling
  Widget _buildImage() {
    final icon = switch (mediaType) {
      MediaType.movie => LucideIcons.film,
      MediaType.tvShow => LucideIcons.tv,
    };

    return Container(
      width: 278,
      height: 160,
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                width: 278,
                height: 160,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 278,
                  height: 160,
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    width: 278,
                    height: 160,
                    color: Colors.grey[800],
                    child: Center(
                      child: Icon(icon, size: 48, color: Colors.grey),
                    ),
                  );
                },
              )
            : Container(
                width: 278,
                height: 160,
                color: Colors.grey[800],
                child: Center(child: Icon(icon, size: 48, color: Colors.grey)),
              ),
      ),
    );
  }
}

/// Vertical variant of MediaItemCard
class MediaItemCardVertical extends MediaItemCard {
  const MediaItemCardVertical({
    super.key,
    super.number,
    required super.title,
    super.year,
    required super.mediaType,
    super.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 278,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(),
          AppConstants.spacingY(AppConstants.spacing8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (number != null) ...[
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withValues(alpha: 0.07),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: Text(
                        number.toString(),
                        style: AppTypography.inter(
                          fontSize: 36,
                          fontWeight: AppTypography.weightBold,
                          color: Colors.white,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                AppConstants.spacingX(AppConstants.spacing8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall(
                        color: Colors.white,
                      ).copyWith(height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (year != null) ...[
                      AppConstants.spacingY(AppConstants.spacing2),
                      Text(
                        year!,
                        style: AppTypography.bodySmall(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Horizontal variant of MediaItemCard
class MediaItemCardHorizontal extends MediaItemCard {
  const MediaItemCardHorizontal({
    super.key,
    super.number,
    required super.title,
    super.year,
    required super.mediaType,
    super.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        AppConstants.spacingX(AppConstants.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (number != null) ...[
                Text(
                  number.toString(),
                  style: AppTypography.labelSmall(color: Colors.grey),
                ),
                AppConstants.spacingY(AppConstants.spacing4),
              ],
              Text(
                title,
                style: AppTypography.titleMedium(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (year != null) ...[
                AppConstants.spacingY(AppConstants.spacing4),
                Text(year!, style: AppTypography.bodySmall(color: Colors.grey)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
