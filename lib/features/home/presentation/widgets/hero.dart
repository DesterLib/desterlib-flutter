import 'dart:ui' as ui;
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mesh_gradient/mesh_gradient.dart' as mesh_gradient;
import 'package:dester/core/widgets/d_icon.dart';
import 'dart:io';

// Core
import 'package:dester/core/widgets/d_button.dart';
import 'package:dester/core/widgets/d_sidebar_space.dart';
import 'package:dester/core/widgets/d_icon_button.dart';
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

/// A reusable hero widget that displays a single media item.
/// Can be used standalone or within a carousel.
class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key, required this.item, this.height});

  final MediaItem item;
  final double? height;

  // Default mesh gradient colors
  static const List<String> _defaultMeshColors = [
    "#000000", // Top-left
    "#000000", // Top-right
    "#000000", // Bottom-left
    "#000000", // Bottom-right
  ];

  static List<String> _getMeshColorsForItem(MediaItem? item) {
    if (item is TVShowMediaItem) {
      final colors = item.meshGradientColors;
      if (colors != null && colors.length == 4) {
        return colors;
      }
    } else if (item is MovieMediaItem) {
      final colors = item.meshGradientColors;
      if (colors != null && colors.length == 4) {
        return colors;
      }
    }
    return _defaultMeshColors;
  }

  static String? _getImagePath(MediaItem item, BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    if (isMobile) {
      // On mobile, prefer null poster, fallback to poster, then backdrop
      return item.nullPosterUrl ?? item.posterPath ?? item.backdropPath;
    } else {
      // On desktop, prefer backdrop, fallback to null poster, then poster
      return item.backdropPath ?? item.nullPosterUrl ?? item.posterPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height, // Use the passed height (can be null for flexible sizing)
      child: Stack(
        fit: height == null ? StackFit.loose : StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Mesh Gradient
          _AnimatedMeshGradient(
            currentItem: item,
            getMeshColors: _getMeshColorsForItem,
            height: 1200,
            animationDuration: AppConstants.durationSlower,
          ),
          // Hero Image
          _HeroImage(imageUrl: _getImagePath(item, context) ?? '', item: item),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String imageUrl;
  final MediaItem item;

  const _HeroImage({required this.imageUrl, required this.item});

  String? _getOverview() {
    if (item is MovieMediaItem) {
      return (item as MovieMediaItem).movie.overview;
    } else if (item is TVShowMediaItem) {
      return (item as TVShowMediaItem).tvShow.overview;
    }
    return null;
  }

  List<String>? _getGenres() {
    if (item is MovieMediaItem) {
      return (item as MovieMediaItem).movie.genres;
    } else if (item is TVShowMediaItem) {
      return (item as TVShowMediaItem).tvShow.genres;
    }
    return null;
  }

  /// Helper method to add spacing between widgets in a column
  List<Widget> _buildSpacedChildren({
    required BuildContext context,
    required ThemeData theme,
    String? overview,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final children = <Widget>[];

    // Logo
    if (item.logoUrl != null) {
      children.add(
        CachedNetworkImage(
          imageUrl: item.logoUrl!,
          height: 60,
          fit: BoxFit.contain,
          placeholder: (context, url) => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => const SizedBox(
            height: 80,
            child: Icon(Icons.error, color: Colors.white54),
          ),
        ),
      );
    }

    // Genres
    final genres = _getGenres();
    if (genres != null && genres.isNotEmpty) {
      children.add(
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppConstants.spacingSm,
          runSpacing: AppConstants.spacingSm,
          children: genres.map((genre) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacing12,
                vertical: AppConstants.spacing4 + 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                genre,
                style: AppTypography.bodySmall(
                  color: Colors.white,
                ).copyWith(fontWeight: AppTypography.weightMedium),
              ),
            );
          }).toList(),
        ),
      );
    }

    // Action Buttons
    children.add(
      Row(
        mainAxisAlignment: isMobile
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          DButton(
            label: 'Watch Now',
            leadingIcon: DIconName.play,
            leadingIconFilled: true,
            variant: DButtonVariant.primary,
            size: DButtonSize.md,
            onPressed: () {
              // TODO: Implement play action
            },
          ),
          AppConstants.spacingX(AppConstants.spacingSm),
          DIconButton(
            icon: DIconName.heart,
            variant: DIconButtonVariant.secondary,
            blur: true,
            onPressed: () {
              // TODO: Implement more info action
            },
          ),
          AppConstants.spacingX(AppConstants.spacingSm),
          DIconButton(
            icon: DIconName.ellipsis,
            variant: DIconButtonVariant.secondary,
            blur: true,
            onPressed: () {
              // TODO: Implement more info action
            },
          ),
        ],
      ),
    );

    // Overview
    if (overview != null) {
      children.add(
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            overview,
            style: AppTypography.bodyMedium(
              color: Colors.white,
            ).copyWith(height: 1.4),
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    // Add spacing between widgets
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(AppConstants.spacingY(AppConstants.spacingMd));
      }
    }

    return spacedChildren;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isIos = Platform.isIOS;
    final overview = _getOverview();
    final theme = Theme.of(context);

    final stackContent = Stack(
      children: [
        // Image container with width constraint on desktop
        Align(
          alignment: Alignment.topRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile
                  ? double.infinity
                  : MediaQuery.of(context).size.width * 0.6,
            ),
            child: ClipRRect(
              borderRadius: isMobile
                  ? (isIos
                        ? BorderRadius.circular(AppConstants.spacing32)
                        : BorderRadius.circular(AppConstants.radiusXl))
                  : BorderRadius.zero,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return ui.Gradient.linear(
                    const Offset(0, 0),
                    Offset(0, bounds.height),
                    [
                      Colors.white, // Fully visible at top
                      Colors.white.withValues(alpha: 0.8),
                      Colors.white.withValues(alpha: 0.4),
                      Colors.transparent, // Fully transparent at bottom
                    ],
                    [0.0, 0.3, 0.7, 1.0],
                  );
                },
                blendMode: BlendMode.dstIn,
                child: isMobile
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.black26,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.white54),
                          ),
                        ),
                      )
                    : ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return ui.Gradient.linear(
                            const Offset(0, 0),
                            Offset(bounds.width, 0),
                            [
                              Colors.transparent, // Transparent at left
                              Colors.white.withValues(alpha: 0.4),
                              Colors.white, // Fully visible at right
                            ],
                            [0.0, 0.2, 0.4],
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            placeholder: (context, url) => Container(
                              color: Colors.black26,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black12,
                              child: const Center(
                                child: Icon(Icons.error, color: Colors.white54),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Bottom overlay with title and buttons
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DSidebarSpace(
            child: Container(
              padding: AppConstants.paddingOnly(
                left: AppConstants.spacingLg,
                right: AppConstants.spacingLg,
                bottom: AppConstants.spacingXl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: _buildSpacedChildren(
                  context: context,
                  theme: theme,
                  overview: overview,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // On mobile, expand to fill parent; on desktop, let content size naturally
    return isMobile ? SizedBox.expand(child: stackContent) : stackContent;
  }
}

class _AnimatedMeshGradient extends StatefulWidget {
  final MediaItem currentItem;
  final List<String> Function(MediaItem?) getMeshColors;
  final double height;
  final Duration animationDuration;

  const _AnimatedMeshGradient({
    required this.currentItem,
    required this.getMeshColors,
    required this.height,
    required this.animationDuration,
  });

  @override
  State<_AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<_AnimatedMeshGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Color?>> _colorAnimations;
  late List<Color> _previousColors;
  late List<Color> _currentColors;

  Color _parseColor(String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }

  void _setupTweens() {
    _colorAnimations = List.generate(
      4,
      (i) => ColorTween(
        begin: _previousColors[i],
        end: _currentColors[i],
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
    );
  }

  @override
  void initState() {
    super.initState();
    final colorStrings = widget.getMeshColors(widget.currentItem);
    _previousColors = colorStrings.map(_parseColor).toList();
    _currentColors = _previousColors;
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _setupTweens();
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedMeshGradient oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentItem != widget.currentItem) {
      _previousColors = _currentColors;
      final newColorStrings = widget.getMeshColors(widget.currentItem);
      _currentColors = newColorStrings.map(_parseColor).toList();
      _setupTweens();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorStrings = widget.getMeshColors(widget.currentItem);
    if (colorStrings.length != 4) {
      return const SizedBox.shrink();
    }

    final isMobile = MediaQuery.of(context).size.width < 768;
    final isIos = Platform.isIOS;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final animatedColors = _colorAnimations
              .map((animation) => animation.value ?? Colors.transparent)
              .toList();

          return ClipRRect(
            borderRadius: isMobile
                ? (isIos
                      ? BorderRadius.circular(AppConstants.spacing32)
                      : BorderRadius.circular(AppConstants.radiusXl))
                : BorderRadius.zero,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Animated mesh gradient with interpolated colors
                Positioned.fill(
                  child: mesh_gradient.MeshGradient(
                    points: [
                      mesh_gradient.MeshGradientPoint(
                        position: const Offset(0.0, 0.0), // Top-left
                        color: animatedColors[0],
                      ),
                      mesh_gradient.MeshGradientPoint(
                        position: const Offset(1.0, 0.0), // Top-right
                        color: animatedColors[1],
                      ),
                      mesh_gradient.MeshGradientPoint(
                        position: const Offset(0.0, 1.0), // Bottom-left
                        color: animatedColors[2],
                      ),
                      mesh_gradient.MeshGradientPoint(
                        position: const Offset(1.0, 1.0), // Bottom-right
                        color: animatedColors[3],
                      ),
                    ],
                    options: mesh_gradient.MeshGradientOptions(),
                  ),
                ),
                // Fade overlay from top to bottom
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
