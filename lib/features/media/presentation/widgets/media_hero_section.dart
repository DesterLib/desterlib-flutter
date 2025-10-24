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
    final hasImage = mediaData.imageUrl != null;
    
    Widget heroContent = SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: isMobile ? const BoxConstraints() : const BoxConstraints(maxHeight: 600),
        child: AspectRatio(
          aspectRatio: isMobile ? 10 / 16 : 16 / 9,
          child: ClipRRect(
            borderRadius: isMobile 
                ? BorderRadius.zero 
                : const BorderRadius.only(bottomLeft: Radius.circular(24)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(hasImage),
                _buildGradientOverlay(),
                Positioned(
                  left: isMobile ? 24 : 40,
                  right: isMobile ? 24 : 40,
                  bottom: isMobile ? 12 : 40,
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return heroContent;
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mediaData.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 28 : 48,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.0,
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),

        Text(
          '${mediaData.year} • ${mediaData.duration} • ${mediaData.rating}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),

        Wrap(
          spacing: isMobile ? 6 : 8,
          runSpacing: 4,
          children: mediaData.genres
              .take(3)
              .map(
                (genre) => isMobile
                    ? DBadge(
                        label: genre,
                        fontSize: 12,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      )
                    : DBadge(label: genre),
              )
              .toList(),
        ),
        SizedBox(height: isMobile ? 16 : 32),

        isMobile ? _buildMobileButtons() : _buildDesktopButtons(),
      ],
    );
  }

  Widget _buildMobileButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onPlayTapped,
          child: DButton(
            label: 'Play',
            icon: PlatformIcons.playArrow,
            variant: DButtonVariant.primary,
          ),
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {
            // TODO: Implement add to list functionality
          },
          child: DButton(
            label: 'Add to List',
            icon: PlatformIcons.add,
            variant: DButtonVariant.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: onPlayTapped,
          child: DButton(
            label: 'Play',
            icon: PlatformIcons.playArrow,
            variant: DButtonVariant.primary,
          ),
        ),
        const SizedBox(width: 16),

        GestureDetector(
          onTap: () {
            // TODO: Implement add to list functionality
          },
          child: DButton(
            icon: PlatformIcons.add,
            variant: DButtonVariant.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(bool hasImage) {
    if (hasImage) {
      return Image.network(
        mediaData.imageUrl!,
        fit: BoxFit.cover,
        cacheWidth: isMobile ? 400 : 800,
        cacheHeight: isMobile ? 640 : 450,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: const Color(0xFF1a1a1a),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Image load error: $error');
          debugPrint('Image URL: ${mediaData.imageUrl}');
          debugPrint('Stack trace: $stackTrace');
          return Container(
            color: const Color(0xFF1a1a1a),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PlatformIcons.brokenImage,
                    color: Colors.white54,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load image',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2a2a2a), Color(0xFF1a1a1a)],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.3, 0.7, 1.0],
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.2),
            Colors.black.withValues(alpha: 0.6),
            Colors.black.withValues(alpha: 0.9),
          ],
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
        _MetadataItem(
          icon: PlatformIcons.time,
          text: mediaData.duration,
        ),
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
