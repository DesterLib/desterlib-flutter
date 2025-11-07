import 'package:flutter/material.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/badge.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'media_data.dart';

class MediaHeroSection extends StatelessWidget {
  final MediaData mediaData;
  final bool isMobile;
  final VoidCallback onPlayTapped;

  const MediaHeroSection({
    super.key,
    required this.mediaData,
    required this.isMobile,
    required this.onPlayTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Use poster on mobile (portrait), backdrop on desktop (landscape)
    final imageUrl = isMobile
        ? (mediaData.posterUrl ?? mediaData.backdropUrl)
        : (mediaData.backdropUrl ?? mediaData.posterUrl);
    final hasImage = imageUrl != null;

    return SizedBox(
      width: double.infinity,
      child: isMobile
          ? AspectRatio(
              aspectRatio: 2 / 3, // Standard poster aspect ratio
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Force integer pixel dimensions to prevent subpixel rendering issues
                  final width = constraints.maxWidth.floorToDouble();
                  final height = constraints.maxHeight.floorToDouble();

                  return Container(
                    width: width,
                    height: height,
                    clipBehavior: Clip.hardEdge,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                      ),
                    ),
                child: Stack(
                  children: [
                        // Combined background and gradient in single layer
                        Positioned.fill(
                          child: _buildBackgroundWithGradient(
                            hasImage,
                            imageUrl,
                          ),
                        ),
                    // Content positioned at the bottom with proper padding
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 12,
                      child: _buildContent(),
                    ),
                  ],
                ),
                  );
                },
              ),
            )
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),
              child: AspectRatio(
                aspectRatio:
                    16 / 9, // Landscape aspect ratio for backdrop images
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Force integer pixel dimensions to prevent subpixel rendering issues
                    final width = constraints.maxWidth.floorToDouble();
                    final height = constraints.maxHeight.floorToDouble();

                    return Container(
                      width: width,
                      height: height,
                      clipBehavior: Clip.hardEdge,
                      decoration: const ShapeDecoration(
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                          ),
                        ),
                  ),
                  child: Stack(
                    children: [
                          // Combined background and gradient in single layer
                          Positioned.fill(
                            child: _buildBackgroundWithGradient(
                              hasImage,
                              imageUrl,
                            ),
                          ),
                      // Content positioned at the bottom with proper padding
                      Positioned(
                        left: 40,
                        right: 40,
                        bottom: 40,
                        child: _buildContent(),
                      ),
                    ],
                  ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          mediaData.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 28 : 48,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.0,
            shadows: [
              Shadow(
                offset: const Offset(0, 1),
                blurRadius: 4,
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),

        // Metadata row with icons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DBadge(
              icon: PlatformIcons.star,
              label: mediaData.rating,
              fontSize: isMobile ? 11 : 12,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 10,
                vertical: isMobile ? 5 : 6,
              ),
            ),
            DBadge(
              icon: PlatformIcons.calendar,
              label: mediaData.year,
              fontSize: isMobile ? 11 : 12,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 10,
                vertical: isMobile ? 5 : 6,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),

        // Genres
        Wrap(
          spacing: isMobile ? 6 : 8,
          runSpacing: 4,
          children: mediaData.genres
              .take(3)
              .map(
                (genre) => DBadge(
                  label: genre,
                  fontSize: isMobile ? 11 : 12,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 10,
                    vertical: isMobile ? 4 : 5,
                  ),
                ),
              )
              .toList(),
        ),

        SizedBox(height: isMobile ? 16 : 24),

        isMobile ? _buildMobileButtons() : _buildDesktopButtons(),
      ],
    );
  }

  Widget _buildMobileButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DButton(
          label: 'Play',
          icon: PlatformIcons.playArrow,
          variant: DButtonVariant.primary,
          onTap: onPlayTapped,
        ),
        const SizedBox(height: 12),

        DButton(
          label: 'Add to List',
          icon: PlatformIcons.add,
          variant: DButtonVariant.secondary,
          onTap: () {
            // TODO: Implement add to list functionality
          },
        ),
      ],
    );
  }

  Widget _buildDesktopButtons() {
    return Row(
      children: [
        DButton(
          label: 'Play',
          icon: PlatformIcons.playArrow,
          variant: DButtonVariant.primary,
          onTap: onPlayTapped,
        ),
        const SizedBox(width: 16),

        DButton(
          icon: PlatformIcons.add,
          variant: DButtonVariant.secondary,
          onTap: () {
            // TODO: Implement add to list functionality
          },
        ),
      ],
    );
  }

  /// Builds background with gradient mask applied directly to the image
  /// This eliminates separate layers and prevents pixel shift issues
  Widget _buildBackgroundWithGradient(bool hasImage, String? imageUrl) {
    if (hasImage && imageUrl != null) {
      // Use ShaderMask to apply gradient directly to the image
      return SizedBox.expand(
        child: ColoredBox(
          color: Colors.black, // Background color that shows through the mask
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 0.65, 0.85, 1.0],
                colors: [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                  Colors.white.withValues(alpha: 0.4),
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode
                .dstIn, // Makes the image transparent where mask is transparent
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      );
    }

    // No image - show gradient background only
    return SizedBox.expand(
      child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2a2a2a), Color(0xFF1a1a1a)],
        ),
        ),
      ),
    );
  }
}

class MediaMetadata extends StatelessWidget {
  final MediaData mediaData;

  const MediaMetadata({super.key, required this.mediaData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetadataItem(icon: PlatformIcons.star, text: mediaData.rating),
        const SizedBox(width: 16),
        _MetadataItem(icon: PlatformIcons.time, text: mediaData.duration),
        const SizedBox(width: 16),
        _MetadataItem(icon: PlatformIcons.calendar, text: mediaData.year),
      ],
    );
  }
}

class _MetadataItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetadataItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
