// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';

/// Video seek bar with progress and buffer indicators
class SeekBar extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<Duration>? onSeekStart;
  final ValueChanged<Duration>? onSeekEnd;
  final bool showTimeLabels;

  const SeekBar({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.bufferedPosition,
    required this.onSeek,
    this.onSeekStart,
    this.onSeekEnd,
    this.showTimeLabels = true,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalDuration.inMilliseconds > 0
        ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
        : 0.0;
    final buffered = totalDuration.inMilliseconds > 0
        ? bufferedPosition.inMilliseconds / totalDuration.inMilliseconds
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
              elevation: 2,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppConstants.accentColor,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: AppConstants.accentColor,
            overlayColor: AppConstants.accentColor.withOpacity(0.2),
          ),
          child: Stack(
            children: [
              // Buffer indicator
              Positioned.fill(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 0,
                    ),
                    activeTrackColor: Colors.white.withOpacity(0.5),
                    inactiveTrackColor: Colors.transparent,
                  ),
                  child: Slider(
                    value: buffered.clamp(0.0, 1.0),
                    onChanged: null,
                  ),
                ),
              ),
              // Progress slider
              Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (value) {
                  final position = Duration(
                    milliseconds: (value * totalDuration.inMilliseconds)
                        .round(),
                  );
                  onSeek(position);
                },
                onChangeStart: (value) {
                  if (onSeekStart != null) {
                    final position = Duration(
                      milliseconds: (value * totalDuration.inMilliseconds)
                          .round(),
                    );
                    onSeekStart!(position);
                  }
                },
                onChangeEnd: (value) {
                  if (onSeekEnd != null) {
                    final position = Duration(
                      milliseconds: (value * totalDuration.inMilliseconds)
                          .round(),
                    );
                    onSeekEnd!(position);
                  }
                },
              ),
            ],
          ),
        ),
        if (showTimeLabels) ...[
          Padding(
            padding: AppConstants.paddingX(AppConstants.spacing8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(currentPosition),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDuration(totalDuration),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
