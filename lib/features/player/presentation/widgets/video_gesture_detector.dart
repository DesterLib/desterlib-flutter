import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';

/// Gesture detector for video player with brightness and volume controls
class VideoGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback onDoubleTapLeft;
  final VoidCallback onDoubleTapRight;
  final ValueChanged<double>? onVolumeChanged;
  final double currentVolume;

  const VideoGestureDetector({
    super.key,
    required this.child,
    required this.onTap,
    required this.onDoubleTapLeft,
    required this.onDoubleTapRight,
    this.onVolumeChanged,
    required this.currentVolume,
  });

  @override
  State<VideoGestureDetector> createState() => _VideoGestureDetectorState();
}

class _VideoGestureDetectorState extends State<VideoGestureDetector> {
  double? _volumeAdjustment;
  bool _showVolumeIndicator = false;

  void _handleVerticalDrag(double delta, double screenWidth, double localX) {
    // Only handle volume on right side
    if (localX > screenWidth / 2 && widget.onVolumeChanged != null) {
      setState(() {
        final adjustment = -delta / 300; // Sensitivity adjustment
        _volumeAdjustment =
            (_volumeAdjustment ?? widget.currentVolume) + adjustment;
        _volumeAdjustment = _volumeAdjustment!.clamp(0.0, 1.0);
        _showVolumeIndicator = true;
      });
    }
  }

  void _handleVerticalDragEnd() {
    if (_volumeAdjustment != null && widget.onVolumeChanged != null) {
      widget.onVolumeChanged!(_volumeAdjustment!);
    }

    // Hide indicator after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _volumeAdjustment = null;
          _showVolumeIndicator = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        debugPrint('🖐️ VideoGestureDetector tap caught');
        widget.onTap();
      },
      behavior: HitTestBehavior
          .deferToChild, // Only catch taps not handled by children
      onVerticalDragUpdate: (details) {
        _handleVerticalDrag(
          details.delta.dy,
          screenWidth,
          details.localPosition.dx,
        );
      },
      onVerticalDragEnd: (details) {
        _handleVerticalDragEnd();
      },
      child: Stack(
        children: [
          widget.child,

          // Double tap zones (invisible, won't block taps on buttons)
          IgnorePointer(
            ignoring: true,
            child: Row(
              children: [
                // Left zone for seek backward
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: widget.onDoubleTapLeft,
                    behavior: HitTestBehavior.translucent,
                    child: Container(color: Colors.transparent),
                  ),
                ),

                // Right zone for seek forward
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: widget.onDoubleTapRight,
                    behavior: HitTestBehavior.translucent,
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          // Volume indicator
          if (_showVolumeIndicator)
            _VolumeIndicator(volume: _volumeAdjustment ?? widget.currentVolume),
        ],
      ),
    );
  }
}

/// Volume indicator overlay
class _VolumeIndicator extends StatelessWidget {
  final double volume;

  const _VolumeIndicator({required this.volume});

  @override
  Widget build(BuildContext context) {
    final percentage = (volume * 100).round();
    final iconData = volume == 0
        ? Icons.volume_off_rounded
        : volume < 0.5
        ? Icons.volume_down_rounded
        : Icons.volume_up_rounded;

    return Positioned(
      right: 24,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          width: 60,
          height: 200,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: AppRadius.radiusLG,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: Colors.white, size: 24),
              AppSpacing.gapVerticalSM,
              Expanded(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                      thumbColor: AppColors.primary,
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 0,
                      ),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0.0,
                      max: 1.0,
                      onChanged: null, // Read-only
                    ),
                  ),
                ),
              ),
              AppSpacing.gapVerticalSM,
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Seek feedback overlay (shown on double tap)
class SeekFeedbackOverlay extends StatefulWidget {
  final bool isForward;

  const SeekFeedbackOverlay({super.key, required this.isForward});

  @override
  State<SeekFeedbackOverlay> createState() => _SeekFeedbackOverlayState();
}

class _SeekFeedbackOverlayState extends State<SeekFeedbackOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.8),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    widget.isForward
                        ? Icons.forward_10_rounded
                        : Icons.replay_10_rounded,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
