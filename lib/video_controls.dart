import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoControls extends StatefulWidget {
  final VideoState state;
  final Player player;

  const VideoControls({super.key, required this.state, required this.player});

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _controlsVisible = true;
  Timer? _hideTimer;
  bool _isDragging = false;
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_isDragging && widget.player.state.playing) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _showControls() {
    setState(() => _controlsVisible = true);
    _startHideTimer();
  }

  void _togglePlayPause() {
    widget.player.playOrPause();
    _showControls();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${minutes}:${twoDigits(seconds)}';
  }

  double get _currentSliderValue {
    if (_isDragging && _dragValue != null) {
      return _dragValue!;
    }
    return widget.player.state.position.inMilliseconds.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _controlsVisible = !_controlsVisible);
        if (_controlsVisible) _startHideTimer();
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Center play/pause button
            Center(
              child: AnimatedOpacity(
                opacity: _controlsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.player.state.playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: AnimatedOpacity(
                opacity: _controlsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Progress bar
                            Row(
                              children: [
                                Text(
                                  _formatDuration(
                                    Duration(
                                      milliseconds: _currentSliderValue.toInt(),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 3,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                            overlayRadius: 12,
                                          ),
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor: Colors.white
                                          .withValues(alpha: 0.3),
                                      thumbColor: Colors.white,
                                      overlayColor: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                    child: Slider(
                                      value: _currentSliderValue.clamp(
                                        0.0,
                                        widget
                                            .player
                                            .state
                                            .duration
                                            .inMilliseconds
                                            .toDouble(),
                                      ),
                                      min: 0.0,
                                      max: widget
                                          .player
                                          .state
                                          .duration
                                          .inMilliseconds
                                          .toDouble(),
                                      onChangeStart: (value) {
                                        setState(() {
                                          _isDragging = true;
                                          _dragValue = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() => _dragValue = value);
                                        // Seek immediately for responsive feedback
                                        widget.player.seek(
                                          Duration(milliseconds: value.toInt()),
                                        );
                                      },
                                      onChangeEnd: (value) {
                                        setState(() {
                                          _isDragging = false;
                                          _dragValue = null;
                                        });
                                        _startHideTimer();
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _formatDuration(widget.player.state.duration),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Control buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Skip backward
                                _ControlButton(
                                  icon: Icons.replay_10_rounded,
                                  onPressed: () {
                                    final newPosition =
                                        widget.player.state.position -
                                        const Duration(seconds: 10);
                                    widget.player.seek(newPosition);
                                    _showControls();
                                  },
                                ),

                                const SizedBox(width: 24),

                                // Play/Pause
                                _ControlButton(
                                  icon: widget.player.state.playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 32,
                                  onPressed: _togglePlayPause,
                                ),

                                const SizedBox(width: 24),

                                // Skip forward
                                _ControlButton(
                                  icon: Icons.forward_10_rounded,
                                  onPressed: () {
                                    final newPosition =
                                        widget.player.state.position +
                                        const Duration(seconds: 10);
                                    widget.player.seek(newPosition);
                                    _showControls();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.white,
            size: size,
            shadows: [
              Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4),
            ],
          ),
        ),
      ),
    );
  }
}
