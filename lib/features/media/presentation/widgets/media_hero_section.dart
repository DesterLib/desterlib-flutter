import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/widgets/ui/badge.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/layout/respect_sidebar.dart';
import 'package:dester/shared/widgets/modals/modals.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:progressive_blur/progressive_blur.dart';
import 'media_data.dart';

class MediaHeroSection extends StatelessWidget {
  final MediaData mediaData;
  final bool isMobile;
  final VoidCallback onPlayTapped;
  final double scrollOffset;

  const MediaHeroSection({
    super.key,
    required this.mediaData,
    required this.isMobile,
    required this.onPlayTapped,
    this.scrollOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isMobile ? _buildMobileHero() : _buildDesktopHero(),
    );
  }

  /// Builds mobile hero with poster image and simple gradient
  Widget _buildMobileHero() {
    final imageUrl = mediaData.posterUrl ?? mediaData.backdropUrl;
    final hasImage = imageUrl != null;

    // Calculate corner radius for overscroll (negative scroll)
    final overscrollAmount = scrollOffset < 0 ? -scrollOffset : 0.0;
    final cornerRadius = (overscrollAmount / 100 * 32).clamp(0.0, 32.0);

    return AspectRatio(
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
            decoration: ShapeDecoration(
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(cornerRadius),
              ),
            ),
            child: Stack(
              children: [
                // Combined background and gradient in single layer
                Positioned.fill(
                  child: _buildMobileBackground(hasImage, imageUrl),
                ),
                // Content positioned at the bottom with proper padding
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: AppSpacing.sm,
                  child: RespectSidebar(child: _buildContent()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds desktop hero with backdrop image, mesh gradient, and progressive blur
  Widget _buildDesktopHero() {
    final imageUrl = mediaData.backdropUrl ?? mediaData.posterUrl;

    // Calculate corner radius for overscroll
    final overscrollAmount = scrollOffset < 0 ? -scrollOffset : 0.0;
    final cornerRadius = (overscrollAmount / 100 * 32).clamp(0.0, 32.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate height to match actual image 16:9 aspect ratio
        final availableWidth = constraints.maxWidth - AppLayout.sidebarWidth;
        final naturalImageHeight = availableWidth * 9 / 16;
        final heroHeight = naturalImageHeight.clamp(400.0, 800.0);

        return SizedBox(
          height: heroHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Full-width hero background with blur and mesh
              Positioned.fill(
                child: ClipPath(
                  clipper: _HeroClipper(cornerRadius: cornerRadius),
                  child: imageUrl != null
                      ? _DynamicMeshHero(imageUrl: imageUrl)
                      : _buildDefaultMeshGradient(),
                ),
              ),
              // Content positioned at the bottom with RespectSidebar
              Positioned(
                left: 0,
                right: 0,
                bottom: AppLayout.extraLargePadding,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate available width (excluding sidebar)
                    final availableWidth =
                        constraints.maxWidth - AppLayout.sidebarWidth;
                    // Max content width is 40% of available width
                    final maxContentWidth = availableWidth * 0.4;

                    return RespectSidebar(
                      leftPadding: AppLayout.extraLargePadding,
                      rightPadding: AppLayout.extraLargePadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxContentWidth,
                          ),
                          child: _buildContent(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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

        // Description (desktop only)
        if (!isMobile && mediaData.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _buildDescriptionSection(),
        ],

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
          leftIcon: PlatformIcons.playArrow,
          variant: DButtonVariant.primary,
          onTap: onPlayTapped,
        ),
        const SizedBox(height: AppSpacing.sm),

        // DButton(
        //   label: 'Add to List',
        //   leftIcon: PlatformIcons.add,
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
          leftIcon: PlatformIcons.playArrow,
          variant: DButtonVariant.primary,
          onTap: onPlayTapped,
        ),
        const SizedBox(width: AppSpacing.md),

        // DButton(
        //   leftIcon: PlatformIcons.add,
        //   variant: DButtonVariant.secondary,
        //   onTap: () {
        //     // TODO: Implement add to list functionality
        //   },
        // ),
      ],
    );
  }

  /// Builds description section with max 3 lines and "More" button
  Widget _buildDescriptionSection() {
    return Builder(
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Description text with right padding to make space for button
            Padding(
              padding: const EdgeInsets.only(right: 80),
              child: Text(
                mediaData.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  letterSpacing: 0.1,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
            // More button positioned at bottom right
            Positioned(
              right: 0,
              bottom: -0,
              child: _MoreButton(
                onTap: () => _showFullDescriptionModal(context),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows modal/drawer with full description
  void _showFullDescriptionModal(BuildContext context) {
    showDModal(
      context: context,
      title: 'Overview',
      builder: (context) => Text(
        mediaData.description,
        style: TextStyle(
          color: AppColors.textPrimary.withValues(alpha: 0.8),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.6,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  /// Builds mobile background with gradient mask applied directly to the image
  Widget _buildMobileBackground(bool hasImage, String? imageUrl) {
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

  /// Builds default grayscale mesh gradient when no image is available
  Widget _buildDefaultMeshGradient() {
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

    // Wrap entire hero (mesh + image) with progressive blur on left only
    return ProgressiveBlurWidget(
      sigma: 40.0, // Maximum blur strength for horizontal fade
      linearGradientBlur: const LinearGradientBlur(
        values: [1, 0.8, 0.5, 0.2, 0], // Full blur left, no blur right
        stops: [0, 0.15, 0.4, 0.65, 0.85],
        start: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Stack(
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

          // Image positioned after sidebar with gradient mask
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
                  // Horizontal gradient mask for left fade
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.15, 0.4, 0.7, 1.0],
                      colors: [
                        Colors.white.withValues(alpha: 0.0), // Transparent left
                        Colors.white.withValues(alpha: 0.3), // Gradual fade
                        Colors.white.withValues(alpha: 0.6), // Continue
                        Colors.white.withValues(alpha: 0.9), // Almost visible
                        Colors.white.withValues(alpha: 1.0), // Fully visible
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ShaderMask(
                    // Vertical gradient mask for bottom fade
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.5, 0.75, 0.9, 1.0],
                        colors: [
                          Colors.white.withValues(
                            alpha: 1.0,
                          ), // Fully visible top
                          Colors.white.withValues(alpha: 0.9), // Stay strong
                          Colors.white.withValues(alpha: 0.6), // Start fade
                          Colors.white.withValues(alpha: 0.3), // Continue fade
                          Colors.white.withValues(
                            alpha: 0.0,
                          ), // Transparent bottom
                        ],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover, // Fill the aspect ratio box
                      alignment:
                          Alignment.centerRight, // Align image to the right
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
      ),
    );
  }
}

/// Custom clipper for the hero section with optional rounded top corners
class _HeroClipper extends CustomClipper<Path> {
  final double cornerRadius;

  const _HeroClipper({this.cornerRadius = 0.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (cornerRadius > 0) {
      // Rectangle with rounded top corners
      path.moveTo(0, cornerRadius);
      path.quadraticBezierTo(0, 0, cornerRadius, 0);
      path.lineTo(size.width - cornerRadius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    } else {
      // Simple rectangle with no rounded corners
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(covariant _HeroClipper oldClipper) =>
      oldClipper.cornerRadius != cornerRadius;
}

/// "More" button to expand description in modal
class _MoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const _MoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DButton(
      label: 'MORE',
      rightIcon: PlatformIcons.chevronDown,
      variant: DButtonVariant.secondary,
      size: DButtonSize.xs,
      onTap: onTap,
    );
  }
}
