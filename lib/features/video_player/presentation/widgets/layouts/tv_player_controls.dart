// External packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';

/// TV-optimized video player controls
/// Designed for remote control/D-pad navigation with large touch targets
class TvPlayerControls extends StatefulWidget {
  // Player state
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final Duration bufferedPosition;

  // Callbacks
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onAudioSettings;
  final VoidCallback onSubtitleSettings;
  final VoidCallback onSettings;
  final VoidCallback? onBack;

  const TvPlayerControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.bufferedPosition,
    required this.onPlayPause,
    required this.onSeek,
    required this.onAudioSettings,
    required this.onSubtitleSettings,
    required this.onSettings,
    this.onBack,
  });

  @override
  State<TvPlayerControls> createState() => _TvPlayerControlsState();
}

class _TvPlayerControlsState extends State<TvPlayerControls> {
  // Constants
  static const int _seekIncrementSeconds = 10;
  static const int _maxAutoSeekSpeed = 3;
  static const Duration _autoSeekInterval = Duration(milliseconds: 200);
  static const Duration _seekIconDuration = Duration(milliseconds: 500);
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Duration _opacityAnimationDuration = Duration(milliseconds: 200);

  // Auto-seek state
  Timer? _autoSeekTimer;
  int _autoSeekDirection = 0; // -1 for left, 1 for right, 0 for none
  int _autoSeekSpeed = 1; // 1x, 2x, or 3x

  // Slider indicator state
  DIconName? _sliderIcon;
  Timer? _sliderIconTimer;

  @override
  void dispose() {
    _autoSeekTimer?.cancel();
    _sliderIconTimer?.cancel();
    super.dispose();
  }

  void _showSliderIcon(
    DIconName icon, {
    Duration duration = const Duration(seconds: 1),
  }) {
    _sliderIconTimer?.cancel();
    setState(() {
      _sliderIcon = icon;
    });
    _sliderIconTimer = Timer(duration, () {
      if (mounted) {
        setState(() {
          // After action icon expires, show pause icon if video is paused
          _sliderIcon = widget.isPlaying ? null : DIconName.pause;
        });
      }
    });
  }

  void _handlePlayPauseToggle() {
    // Stop auto-seeking when play/pause is toggled
    _stopAutoSeek();
    widget.onPlayPause();
  }

  @override
  void didUpdateWidget(TvPlayerControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If paused, show pause icon only if no other action is happening
    if (!widget.isPlaying) {
      // Don't override if auto-seeking is active
      if (_autoSeekDirection == 0 &&
          (_sliderIconTimer == null || !_sliderIconTimer!.isActive)) {
        setState(() {
          _sliderIcon = DIconName.pause;
        });
      }
    } else if (oldWidget.isPlaying != widget.isPlaying) {
      // Just started playing - hide slider icon if it's the pause icon
      if (_sliderIcon == DIconName.pause) {
        setState(() {
          _sliderIcon = null;
        });
      }
    }
  }

  DIconName _getAutoSeekIcon(int direction, int speed) {
    if (direction < 0) {
      switch (speed) {
        case 1:
          return DIconName.autoBackward1x;
        case 2:
          return DIconName.autoBackward2x;
        case 3:
          return DIconName.autoBackward3x;
        default:
          return DIconName.autoBackward1x;
      }
    } else {
      switch (speed) {
        case 1:
          return DIconName.autoForward1x;
        case 2:
          return DIconName.autoForward2x;
        case 3:
          return DIconName.autoForward3x;
        default:
          return DIconName.autoForward1x;
      }
    }
  }

  void _handleSeekIncrement(int seconds) {
    final newPosition = Duration(
      milliseconds: (widget.currentPosition.inMilliseconds + (seconds * 1000))
          .clamp(0, widget.totalDuration.inMilliseconds),
    );
    widget.onSeek(newPosition);
  }

  void _handleArrowPress(int direction) {
    if (_autoSeekDirection == 0) {
      // Not auto-seeking - do single seek
      _handleSeekIncrement(direction * _seekIncrementSeconds);
      // Show seek icon
      _showSliderIcon(
        direction < 0 ? DIconName.skip10Backward : DIconName.skip10Forward,
        duration: _seekIconDuration,
      );
    } else if (_autoSeekDirection == direction) {
      // Already auto-seeking in same direction - increase speed
      if (_autoSeekSpeed < _maxAutoSeekSpeed) {
        setState(() {
          _autoSeekSpeed++;
          // Update icon to match new speed
          _sliderIcon = _getAutoSeekIcon(direction, _autoSeekSpeed);
        });
      }
    } else {
      // Auto-seeking in opposite direction
      if (_autoSeekSpeed > 1) {
        // Reduce speed first
        setState(() {
          _autoSeekSpeed--;
          // Update icon to match new speed
          _sliderIcon = _getAutoSeekIcon(_autoSeekDirection, _autoSeekSpeed);
        });
      } else {
        // Already at 1x - switch direction and reset to 1x
        _stopAutoSeek();
        _startAutoSeek(direction);
      }
    }
  }

  void _startAutoSeek(int direction) {
    setState(() {
      _autoSeekDirection = direction;
      _autoSeekSpeed = 1;
    });

    // Show auto-seek icon with speed indicator (doesn't auto-hide during auto-seek)
    _sliderIconTimer?.cancel();
    setState(() {
      _sliderIcon = _getAutoSeekIcon(direction, 1);
    });

    // Start continuous auto-seeking
    _autoSeekTimer = Timer.periodic(_autoSeekInterval, (timer) {
      _handleSeekIncrement(direction * 2 * _autoSeekSpeed);
    });
  }

  void _stopAutoSeek() {
    _autoSeekTimer?.cancel();
    _autoSeekTimer = null;
    setState(() {
      _autoSeekDirection = 0;
      _autoSeekSpeed = 1;
      _sliderIcon = widget.isPlaying ? null : DIconName.pause;
    });
  }

  Widget _buildCustomSeekBar() {
    final targetProgress = widget.totalDuration.inMilliseconds > 0
        ? widget.currentPosition.inMilliseconds /
              widget.totalDuration.inMilliseconds
        : 0.0;
    final buffered = widget.totalDuration.inMilliseconds > 0
        ? widget.bufferedPosition.inMilliseconds /
              widget.totalDuration.inMilliseconds
        : 0.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: targetProgress, end: targetProgress),
      duration: _animationDuration,
      curve: Curves.linear,
      builder: (context, animatedProgress, child) {
        return SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
          ),
          child: Stack(
            children: [
              // Buffer indicator
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 8,
                  trackShape: const RoundedRectSliderTrackShape(),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 0,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                  activeTrackColor: Colors.white.withOpacity(0.5),
                  inactiveTrackColor: Colors.transparent,
                ),
                child: Slider(value: buffered.clamp(0.0, 1.0), onChanged: null),
              ),
              // Progress slider with smooth animation
              Slider(
                value: animatedProgress.clamp(0.0, 1.0),
                onChanged: (value) {
                  final position = Duration(
                    milliseconds: (value * widget.totalDuration.inMilliseconds)
                        .round(),
                  );
                  widget.onSeek(position);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliderIndicator(double progress, double sliderWidth) {
    return AnimatedPositioned(
      duration: _animationDuration,
      curve: Curves.linear,
      left: progress * sliderWidth,
      child: Transform.translate(
        offset: const Offset(-20, 20),
        child: AnimatedOpacity(
          opacity: _sliderIcon != null ? 1.0 : 0.0,
          duration: _opacityAnimationDuration,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: AnimatedSwitcher(
              duration: _opacityAnimationDuration,
              child: _sliderIcon != null
                  ? DIcon(
                      icon: _sliderIcon!,
                      key: ValueKey(_sliderIcon),
                      color: Colors.white,
                      size: 20,
                      filled: true,
                      trueColor: true,
                    )
                  : const SizedBox(width: 20, height: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFocusableSeekBar() {
    return Focus(
      autofocus: true,
      canRequestFocus: true,
      onFocusChange: (hasFocus) {
        // Stop auto-seeking when focus is lost
        if (!hasFocus) {
          _stopAutoSeek();
        }
      },
      onKeyEvent: (node, event) {
        // Handle play/pause toggle on Enter/OK
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          _handlePlayPauseToggle();
          return KeyEventResult.handled;
        }

        // Handle left arrow key
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (event is KeyDownEvent) {
            // Press: If not auto-seeking, seek once. If auto-seeking, change speed.
            _handleArrowPress(-1);
            return KeyEventResult.handled;
          } else if (event is KeyRepeatEvent) {
            // Long press detected (holding) - start auto-seeking if not already
            if (_autoSeekDirection == 0) {
              _startAutoSeek(-1);
            }
            return KeyEventResult.handled;
          }
        }

        // Handle right arrow key
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          if (event is KeyDownEvent) {
            // Press: If not auto-seeking, seek once. If auto-seeking, change speed.
            _handleArrowPress(1);
            return KeyEventResult.handled;
          } else if (event is KeyRepeatEvent) {
            // Long press detected (holding) - start auto-seeking if not already
            if (_autoSeekDirection == 0) {
              _startAutoSeek(1);
            }
            return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return AnimatedOpacity(
            opacity: isFocused ? 1.0 : 0.6,
            duration: _opacityAnimationDuration,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(widget.currentPosition),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatDuration(widget.totalDuration),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Slider with moving indicator
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final progress = widget.totalDuration.inMilliseconds > 0
                          ? widget.currentPosition.inMilliseconds /
                                widget.totalDuration.inMilliseconds
                          : 0.0;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ExcludeFocus(child: _buildCustomSeekBar()),
                          _buildSliderIndicator(progress, constraints.maxWidth),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    double size = 56,
    bool autofocus = false,
  }) {
    return Focus(
      autofocus: autofocus,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return AnimatedScale(
            scale: isFocused ? 1.15 : 1.0,
            duration: _opacityAnimationDuration,
            child: AnimatedOpacity(
              opacity: isFocused ? 1.0 : 0.6,
              duration: _opacityAnimationDuration,
              child: GestureDetector(
                onTap: onPressed,
                child: Padding(
                  padding: EdgeInsets.all(size * 0.2),
                  child: Icon(icon, size: size, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.5),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.9),
          ],
          stops: const [0.0, 0.1, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Top bar with minimal info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: AppConstants.padding(AppConstants.spacing32),
              child: Row(
                children: [
                  if (widget.onBack != null)
                    _buildIconButton(
                      icon: Icons.arrow_back,
                      onPressed: widget.onBack!,
                      tooltip: 'Back',
                      size: 32,
                    ),
                  const Spacer(),
                  _buildIconButton(
                    icon: Icons.settings,
                    onPressed: widget.onSettings,
                    tooltip: 'Settings',
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          // Bottom: Seek bar and additional controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: AppConstants.padding(AppConstants.spacing32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Seek bar with D-pad control (left/right arrows)
                  _buildFocusableSeekBar(),
                  AppConstants.spacingY(AppConstants.spacing24),
                  // Bottom action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconButton(
                        icon: Icons.audiotrack,
                        onPressed: widget.onAudioSettings,
                        tooltip: 'Audio',
                        size: 32,
                      ),
                      AppConstants.spacingX(AppConstants.spacing24),
                      _buildIconButton(
                        icon: Icons.subtitles,
                        onPressed: widget.onSubtitleSettings,
                        tooltip: 'Subtitles',
                        size: 32,
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
