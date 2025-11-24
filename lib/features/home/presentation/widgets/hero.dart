import 'dart:async';
import 'dart:ui' as ui;
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mesh_gradient/mesh_gradient.dart' as mesh_gradient;
import 'dart:io';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key, this.mediaItems});
  final List<MediaItem>? mediaItems;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _currentIndex = 0;
  Timer? _autoAdvanceTimer;
  double _dragOffset = 0.0;

  // Default mesh gradient colors (vibrant purple-blue theme)
  static const List<String> _defaultMeshColors = [
    "#000000", // Top-left
    "#000000", // Top-right
    "#000000", // Bottom-left
    "#000000", // Bottom-right
  ];

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    if (widget.mediaItems == null || widget.mediaItems!.length <= 1) return;

    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_currentIndex + 1 == widget.mediaItems!.length) {
          _currentIndex = 0;
        } else {
          _currentIndex = _currentIndex + 1;
        }
      });
    });
  }

  List<String> _getMeshColorsForItem(MediaItem? item) {
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

  String? _getImagePath(MediaItem item, BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    if (isMobile) {
      // On mobile, prefer poster
      return item.plainPosterUrl ?? item.backdropPath;
    } else {
      // On desktop, prefer backdrop
      return item.backdropPath ?? item.plainPosterUrl;
    }
  }

  double _getHeroHeight(MediaItem item, BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    if (isMobile && item.plainPosterUrl != null) {
      return 720;
    }
    return 600;
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.mediaItems ?? [];
    if (items.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 600,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final currentItem = items[_currentIndex];
    final heroHeight = _getHeroHeight(currentItem, context);

    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Animated Mesh Gradient
          _AnimatedMeshGradient(
            currentItem: items[_currentIndex],
            getMeshColors: _getMeshColorsForItem,
            height: 1200,
            animationDuration: const Duration(milliseconds: 1000),
          ),
          // Image Carousel with fade transitions
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity == null) return;

              if (details.primaryVelocity! > 0) {
                // Swipe right - go to previous
                setState(() {
                  if (_currentIndex == 0) {
                    _currentIndex = items.length - 1;
                  } else {
                    _currentIndex = _currentIndex - 1;
                  }
                });
              } else {
                // Swipe left - go to next
                setState(() {
                  if (_currentIndex + 1 == items.length) {
                    _currentIndex = 0;
                  } else {
                    _currentIndex = _currentIndex + 1;
                  }
                });
              }
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _HeroImage(
                key: ValueKey(
                  _getImagePath(items[_currentIndex], context) ?? _currentIndex,
                ),
                imageUrl: _getImagePath(items[_currentIndex], context) ?? '',
                item: items[_currentIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String imageUrl;
  final MediaItem item;

  const _HeroImage({super.key, required this.imageUrl, required this.item});

  String? _getOverview() {
    if (item is MovieMediaItem) {
      return (item as MovieMediaItem).movie.overview;
    } else if (item is TVShowMediaItem) {
      return (item as TVShowMediaItem).tvShow.overview;
    }
    return null;
  }

  String? _getReleaseDate() {
    if (item is MovieMediaItem) {
      return (item as MovieMediaItem).movie.releaseDate;
    } else if (item is TVShowMediaItem) {
      return (item as TVShowMediaItem).tvShow.firstAirDate;
    }
    return null;
  }

  double? _getRating() {
    if (item is MovieMediaItem) {
      return (item as MovieMediaItem).movie.rating;
    } else if (item is TVShowMediaItem) {
      return (item as TVShowMediaItem).tvShow.rating;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    final overview = _getOverview();
    final releaseDate = _getReleaseDate();
    final rating = _getRating();
    final theme = Theme.of(context);

    return SizedBox.expand(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: isIos
                ? BorderRadius.circular(32)
                : BorderRadius.circular(16),
            child: ShaderMask(
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
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
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
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.4),
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
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Rating and Release Date
                  if (rating != null || releaseDate != null)
                    Row(
                      children: [
                        if (rating != null) ...[
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (releaseDate != null)
                          Text(
                            releaseDate,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  if (overview != null) ...[
                    const SizedBox(height: 12),
                    // Overview
                    Text(
                      overview,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    children: [
                      // Play Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement play action
                        },
                        icon: const Icon(Icons.play_arrow, size: 24),
                        label: const Text('Play'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // More Info Button
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement more info action
                        },
                        icon: const Icon(Icons.info_outline, size: 20),
                        label: const Text('More Info'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
            borderRadius: isIos
                ? BorderRadius.circular(32)
                : BorderRadius.circular(16),
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
