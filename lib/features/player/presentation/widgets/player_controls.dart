import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'player_progress_bar.dart';
import 'player_button.dart';

/// Custom video player controls
class VideoControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final bool isCompleted;
  final Duration position;
  final Duration duration;
  final Duration buffer;
  final double volume;
  final double playbackSpeed;
  final String? title;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback? onSeekStart;
  final VoidCallback? onSeekEnd;
  final VoidCallback onSeekForward;
  final VoidCallback onSeekBackward;
  final VoidCallback onBack;
  final VoidCallback onReplay;
  final VoidCallback? onSpeedSettings;
  final VoidCallback? onTracksSettings;

  const VideoControls({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.isCompleted,
    required this.position,
    required this.duration,
    required this.buffer,
    required this.volume,
    required this.playbackSpeed,
    this.title,
    required this.onPlayPause,
    required this.onSeek,
    this.onSeekStart,
    this.onSeekEnd,
    required this.onSeekForward,
    required this.onSeekBackward,
    required this.onBack,
    required this.onReplay,
    this.onSpeedSettings,
    this.onTracksSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tinted background gradient (non-interactive)
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.0, 0.15, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Controls content
        Column(
          children: [
            // Top bar
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    // Back button
                    VideoPlayerButton(
                      icon: PlatformIcons.arrowBack,
                      onTap: onBack,
                      size: VideoPlayerButtonSize.standard,
                      tooltip: 'Back',
                    ),
                  ],
                ),
              ),
            ),

            // Center spacer (ignore pointer events in middle)
            const Expanded(
              child: IgnorePointer(ignoring: true, child: SizedBox.expand()),
            ),

            // Bottom bar with slider and controls
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar
                    PlayerProgressBar(
                      position: position,
                      duration: duration,
                      buffer: buffer,
                      onSeek: onSeek,
                      onSeekStart: onSeekStart,
                      onSeekEnd: onSeekEnd,
                    ),
                    AppSpacing.gapVerticalMD,
                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (onSpeedSettings != null)
                          VideoPlayerButton(
                            icon: PlatformIcons.speed,
                            label: 'Speed',
                            size: VideoPlayerButtonSize.standard,
                            onTap: onSpeedSettings!,
                            tooltip: 'Playback Speed',
                          ),
                        if (onSpeedSettings != null && onTracksSettings != null)
                          AppSpacing.gapHorizontalMD,
                        if (onTracksSettings != null)
                          VideoPlayerButton(
                            icon: PlatformIcons.subtitles,
                            label: 'Audio & Subtitles',
                            size: VideoPlayerButtonSize.standard,
                            onTap: onTracksSettings!,
                            tooltip: 'Audio & Subtitle Tracks',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
