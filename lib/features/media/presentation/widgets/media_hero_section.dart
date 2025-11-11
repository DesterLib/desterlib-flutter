import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/badge.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/layout/respect_sidebar.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:palette_generator/palette_generator.dart';
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
                          left: AppLayout.mobileHorizontalPadding,
                          right: AppLayout.mobileHorizontalPadding,
                          bottom: AppSpacing.sm,
                          child: _buildContent(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                // Calculate height to match actual image 16:9 aspect ratio
                final availableWidth =
                    constraints.maxWidth - AppLayout.sidebarWidth;
                // Image height based on 16:9 aspect ratio - this is the natural image size
                final naturalImageHeight = availableWidth * 9 / 16;
                // Hero matches image with only a minimum height constraint
                final heroHeight = naturalImageHeight.clamp(
                  400.0,
                  double.infinity,
                );

                return SizedBox(
                  height: heroHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Full-width hero background that extends under sidebar
                      Positioned.fill(
                        child: ClipPath(
                          clipper: _HeroClipper(),
                          child: _buildDesktopHeroWithReflection(
                            hasImage,
                            imageUrl,
                          ),
                        ),
                      ),
                      // Content positioned at the bottom with RespectSidebar
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: AppLayout.extraLargePadding,
                        child: RespectSidebar(
                          leftPadding: AppLayout.extraLargePadding,
                          rightPadding: AppLayout.extraLargePadding,
                          child: _buildContent(),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
        SizedBox(height: isMobile ? AppSpacing.sm : AppSpacing.md),

        // Metadata row with icons
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DBadge(
              icon: PlatformIcons.star,
              label: mediaData.rating,
              fontSize: isMobile ? 11 : 12,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppSpacing.xs : 10,
                vertical: isMobile ? 5 : 6,
              ),
            ),
            DBadge(
              icon: PlatformIcons.calendar,
              label: mediaData.year,
              fontSize: isMobile ? 11 : 12,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppSpacing.xs : 10,
                vertical: isMobile ? 5 : 6,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? AppSpacing.sm : AppSpacing.md),

        // Genres
        Wrap(
          spacing: isMobile ? 6 : AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: mediaData.genres
              .take(3)
              .map(
                (genre) => DBadge(
                  label: genre,
                  fontSize: isMobile ? 11 : 12,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? AppSpacing.xs : 10,
                    vertical: isMobile ? AppSpacing.xxs : 5,
                  ),
                ),
              )
              .toList(),
        ),

        SizedBox(height: isMobile ? AppSpacing.md : AppSpacing.xl),

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
        const SizedBox(height: AppSpacing.sm),

        // DButton(
        //   label: 'Add to List',
        //   icon: PlatformIcons.add,
        //   variant: DButtonVariant.secondary,
        //   onTap: () {
        //     // TODO: Implement add to list functionality
        //   },
        // ),
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
        const SizedBox(width: AppSpacing.md),

        // DButton(
        //   icon: PlatformIcons.add,
        //   variant: DButtonVariant.secondary,
        //   onTap: () {
        //     // TODO: Implement add to list functionality
        //   },
        // ),
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
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.black,
                child: const Center(child: DLoadingIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF1a1a1a),
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFF666666),
                    size: 48,
                  ),
                ),
              ),
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 150),
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

  /// Builds desktop hero with faded mask on left and bottom edges
  /// Image respects sidebar width with mesh gradient background extracted from image
  Widget _buildDesktopHeroWithReflection(bool hasImage, String? imageUrl) {
    if (hasImage && imageUrl != null) {
      return _DynamicMeshHero(imageUrl: imageUrl);
    }

    // No image - show default grayscale mesh gradient background
    return MeshGradient(
      points: [
        MeshGradientPoint(position: Offset(0, 0), color: Color(0xFF1a1a1a)),
        MeshGradientPoint(position: Offset(1, 0), color: Color(0xFF2a2a2a)),
        MeshGradientPoint(position: Offset(0, 1), color: Color(0xFF0a0a0a)),
        MeshGradientPoint(position: Offset(1, 1), color: Color(0xFF2a2a2a)),
      ],
      options: MeshGradientOptions(),
    );
  }
}

/// Dynamic hero widget that extracts colors from the image for mesh gradient
class _DynamicMeshHero extends StatefulWidget {
  final String imageUrl;

  const _DynamicMeshHero({required this.imageUrl});

  @override
  State<_DynamicMeshHero> createState() => _DynamicMeshHeroState();
}

class _DynamicMeshHeroState extends State<_DynamicMeshHero> {
  List<Color>? _extractedColors;
  bool _stopAnimation = false;

  @override
  void initState() {
    super.initState();
    _extractColors();
  }

  @override
  void didUpdateWidget(_DynamicMeshHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _stopAnimation = false;
      });
      _extractColors();
    }
  }

  /// Darkens a color by reducing its lightness and reduces saturation for grayscale-like colors
  Color _darkenColor(Color color, {double amount = 0.4}) {
    final hsl = HSLColor.fromColor(color);

    // If color is very low saturation (grayscale-ish), further reduce saturation
    final adjustedSaturation = hsl.saturation < 0.2
        ? hsl.saturation *
              0.3 // Make it even more grayscale
        : hsl.saturation;

    final darkened = hsl
        .withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0))
        .withSaturation(adjustedSaturation.clamp(0.0, 1.0));

    return darkened.toColor();
  }

  Future<void> _extractColors() async {
    try {
      final imageProvider = CachedNetworkImageProvider(widget.imageUrl);
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        imageProvider,
        maximumColorCount: 20,
      );

      if (!mounted) return;

      // Extract colors for the 4 corners
      // Prefer muted/dark colors over vibrant to avoid blue fallbacks on grayscale images
      final rawColors = <Color>[
        paletteGenerator.darkMutedColor?.color ??
            paletteGenerator.dominantColor?.color ??
            Color(0xFF1a1a1a), // Top-left - grayscale fallback
        paletteGenerator.mutedColor?.color ??
            paletteGenerator.dominantColor?.color ??
            Color(0xFF2a2a2a), // Top-right - grayscale fallback
        paletteGenerator.darkMutedColor?.color ??
            paletteGenerator.darkVibrantColor?.color ??
            paletteGenerator.dominantColor?.color ??
            Color(0xFF0a0a0a), // Bottom-left - grayscale fallback (not blue!)
        paletteGenerator.lightMutedColor?.color ??
            paletteGenerator.vibrantColor?.color ??
            paletteGenerator.dominantColor?.color ??
            Color(0xFF2a2a2a), // Bottom-right - grayscale fallback
      ];

      // Darken all extracted colors for better background appearance
      final darkenedColors = rawColors
          .map((color) => _darkenColor(color, amount: 0.5))
          .toList();

      setState(() {
        _extractedColors = darkenedColors;
      });

      // Wait for fade transition to complete (1000ms fade + 500ms buffer), then stop animation
      await Future.delayed(Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() {
        _stopAnimation = true;
      });
    } catch (e) {
      // Fallback to grayscale colors on error
      if (!mounted) return;
      setState(() {
        _extractedColors = [
          Color(0xFF1a1a1a),
          Color(0xFF2a2a2a),
          Color(0xFF0a0a0a),
          Color(0xFF2a2a2a),
        ];
      });

      // Stop animation after error fallback
      await Future.delayed(Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() {
        _stopAnimation = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default grayscale colors for initial animation
    final defaultColors = [
      Color(0xFF1a1a1a),
      Color(0xFF2a2a2a),
      Color(0xFF0a0a0a),
      Color(0xFF2a2a2a),
    ];

    final hasExtractedColors = _extractedColors != null;

    return Stack(
      children: [
        // Base animated mesh with default colors
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: hasExtractedColors ? 0.0 : 1.0,
            duration: Duration(milliseconds: 1000),
            child: AnimatedMeshGradient(
              colors: defaultColors,
              options: AnimatedMeshGradientOptions(speed: 2, frequency: 2),
            ),
          ),
        ),

        // Extracted colors mesh that fades in
        if (hasExtractedColors)
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 1000),
              child: AnimatedMeshGradient(
                colors: _extractedColors!,
                options: AnimatedMeshGradientOptions(
                  speed: _stopAnimation ? 0.01 : 2,
                  frequency: _stopAnimation ? 0.01 : 2,
                ),
              ),
            ),
          ),

        // Image positioned after sidebar with left + bottom fade masks
        Positioned(
          left: AppLayout.sidebarWidth,
          top: 0,
          right: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.centerRight,
            child: AspectRatio(
              aspectRatio: 16 / 9, // Standard backdrop aspect ratio
              child: ShaderMask(
                // Horizontal gradient for left fade
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.3, 1.0],
                    colors: [
                      Colors.white.withValues(
                        alpha: 0.0,
                      ), // Transparent on left edge
                      Colors.white.withValues(alpha: 0.7), // Fade in
                      Colors.white.withValues(
                        alpha: 1.0,
                      ), // Fully visible on right
                    ],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: ShaderMask(
                  // Vertical gradient for bottom fade
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 0.85, 1.0],
                      colors: [
                        Colors.white.withValues(
                          alpha: 1.0,
                        ), // Fully visible on top
                        Colors.white.withValues(alpha: 0.8),
                        Colors.white.withValues(alpha: 0.3), // Fade out
                        Colors.white.withValues(
                          alpha: 0.0,
                        ), // Transparent at bottom
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover, // Fill the aspect ratio box
                    alignment: Alignment.center,
                    placeholder: (context, url) =>
                        Container(color: Colors.black),
                    errorWidget: (context, url, error) =>
                        Container(color: const Color(0xFF1a1a1a)),
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 150),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom clipper for the hero section with rounded bottom-left corner
class _HeroClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Simple rectangle with no rounded corners
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
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
