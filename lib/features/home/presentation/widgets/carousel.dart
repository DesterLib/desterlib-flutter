import 'dart:async';
import 'package:dester/features/home/domain/entities/media_item.dart';
import 'package:flutter/material.dart';
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_skeleton.dart';
import 'package:dester/features/home/presentation/widgets/hero.dart';

/// A carousel widget that displays multiple hero items with auto-advance
/// and swipe gestures. Uses [HeroWidget] for each item.
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({
    super.key,
    required this.mediaItems,
    this.autoAdvanceDuration = AppConstants.duration5s,
    this.transitionDuration = AppConstants.durationSlower,
  });

  final List<MediaItem> mediaItems;
  final Duration autoAdvanceDuration;
  final Duration transitionDuration;

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  int _currentIndex = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  @override
  void didUpdateWidget(HeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset index if out of bounds or empty
    if (widget.mediaItems.isEmpty) {
      _currentIndex = 0;
    } else if (_currentIndex >= widget.mediaItems.length) {
      _currentIndex = 0;
    }

    // Restart auto advance if items changed
    if (widget.mediaItems != oldWidget.mediaItems) {
      _startAutoAdvance();
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    if (widget.mediaItems.length <= 1) return;

    _autoAdvanceTimer = Timer.periodic(widget.autoAdvanceDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_currentIndex + 1 == widget.mediaItems.length) {
          _currentIndex = 0;
        } else {
          _currentIndex = _currentIndex + 1;
        }
      });
    });
  }

  String? _getImagePath(MediaItem item, BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    if (isMobile) {
      // On mobile, prefer null poster, fallback to poster, then backdrop
      return item.nullPosterUrl ?? item.posterPath ?? item.backdropPath;
    } else {
      // On desktop, prefer backdrop, fallback to null poster, then poster
      return item.nullBackdropUrl ?? item.nullBackdropUrl ?? item.backdropPath;
    }
  }

  void _goToNext() {
    setState(() {
      if (_currentIndex + 1 == widget.mediaItems.length) {
        _currentIndex = 0;
      } else {
        _currentIndex = _currentIndex + 1;
      }
    });
  }

  void _goToPrevious() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = widget.mediaItems.length - 1;
      } else {
        _currentIndex = _currentIndex - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate height based on TMDB aspect ratios
    // Mobile: Poster aspect ratio (2:3)
    // Desktop: Backdrop aspect ratio (16:9) at 60% width
    final placeholderHeight = isMobile
        ? 600.0 // Fixed mobile height
        : (screenWidth * 0.6) / (16 / 9); // Desktop: 60% width with 16:9 ratio

    return AnimatedSwitcher(
      duration: widget.transitionDuration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: widget.mediaItems.isEmpty
          ? DSkeleton(
              key: const ValueKey('placeholder'),
              width: double.infinity,
              height: placeholderHeight,
              enableShaderMask: true,
              isMobile: isMobile,
            )
          : Builder(
              key: ValueKey('content-${widget.mediaItems.length}'),
              builder: (context) {
                final currentItem = widget.mediaItems[_currentIndex];
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity == null) return;

                    if (details.primaryVelocity! > 0) {
                      // Swipe right - go to previous
                      _goToPrevious();
                    } else {
                      // Swipe left - go to next
                      _goToNext();
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: widget.transitionDuration,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: HeroWidget(
                      key: ValueKey(
                        _getImagePath(currentItem, context) ?? _currentIndex,
                      ),
                      item: currentItem,
                      height: isMobile ? 600 : placeholderHeight,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
