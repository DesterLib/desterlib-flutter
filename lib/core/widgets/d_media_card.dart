// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/widgets/d_media_image_card.dart';
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Media type enum for card display
enum DMediaType { movie, tvShow }

/// Base class for DMediaItemCard with common functionality
abstract class DMediaItemCard extends StatelessWidget {
  final int? number;
  final String title;
  final String? year;
  final DMediaType mediaType;
  final String? imageUrl;
  final VoidCallback? onTap;

  const DMediaItemCard({
    super.key,
    this.number,
    required this.title,
    this.year,
    required this.mediaType,
    this.imageUrl,
    this.onTap,
  });

  /// Builds the image widget with superellipse styling
  Widget _buildImage() {
    final icon = switch (mediaType) {
      DMediaType.movie => LucideIcons.film,
      DMediaType.tvShow => LucideIcons.tv,
    };

    return DMediaImageCard(
      imageUrl: imageUrl,
      width: 278,
      height: 160,
      fallbackIcon: icon,
    );
  }
}

/// Vertical variant of DMediaItemCard
class DMediaItemCardVertical extends DMediaItemCard {
  const DMediaItemCardVertical({
    super.key,
    super.number,
    required super.title,
    super.year,
    required super.mediaType,
    super.imageUrl,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
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
                          fontSize: AppTypography.fontSizeNumberLarge,
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

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}

/// Horizontal variant of DMediaItemCard
class DMediaItemCardHorizontal extends DMediaItemCard {
  const DMediaItemCardHorizontal({
    super.key,
    super.number,
    required super.title,
    super.year,
    required super.mediaType,
    super.imageUrl,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
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

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
