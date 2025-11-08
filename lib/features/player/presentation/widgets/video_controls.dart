import 'package:flutter/material.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'video_progress_bar.dart';

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
  final bool isFullscreen;
  final String? title;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onSeekForward;
  final VoidCallback onSeekBackward;
  final VoidCallback onFullscreen;
  final VoidCallback onBack;
  final VoidCallback onReplay;
  final VoidCallback onSettings;

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
    required this.isFullscreen,
    this.title,
    required this.onPlayPause,
    required this.onSeek,
    required this.onSeekForward,
    required this.onSeekBackward,
    required this.onFullscreen,
    required this.onBack,
    required this.onReplay,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient (non-interactive)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.2, 0.6, 1.0],
              ),
            ),
          ),
        ),

        // Top bar with title and back button
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(title: title, onBack: onBack),
        ),

        // Bottom bar with progress and controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _BottomBar(
            position: position,
            duration: duration,
            buffer: buffer,
            volume: volume,
            playbackSpeed: playbackSpeed,
            isFullscreen: isFullscreen,
            onSeek: onSeek,
            onFullscreen: onFullscreen,
            onSettings: onSettings,
          ),
        ),
      ],
    );
  }
}

/// Top bar with title and back button
class _TopBar extends StatelessWidget {
  final String? title;
  final VoidCallback onBack;

  const _TopBar({this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            DButton(
              icon: PlatformIcons.arrowBack,
              variant: DButtonVariant.ghost,
              size: DButtonSize.sm,
              onTap: onBack,
            ),
            if (title != null) ...[
              AppSpacing.gapHorizontalMD,
              Expanded(
                child: Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bottom bar with progress and controls
class _BottomBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Duration buffer;
  final double volume;
  final double playbackSpeed;
  final bool isFullscreen;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onFullscreen;
  final VoidCallback onSettings;

  const _BottomBar({
    required this.position,
    required this.duration,
    required this.buffer,
    required this.volume,
    required this.playbackSpeed,
    required this.isFullscreen,
    required this.onSeek,
    required this.onFullscreen,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar
            VideoProgressBar(
              position: position,
              duration: duration,
              buffer: buffer,
              onSeek: onSeek,
            ),

            AppSpacing.gapVerticalSM,

            // Time and controls
            Row(
              children: [
                VideoTimeDisplay(position: position, duration: duration),
                const Spacer(),
                // Settings button
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  color: Colors.white,
                  iconSize: 22,
                  onPressed: onSettings,
                ),
                AppSpacing.gapHorizontalSM,
                // Fullscreen button
                IconButton(
                  icon: Icon(
                    isFullscreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                  ),
                  color: Colors.white,
                  iconSize: 22,
                  onPressed: onFullscreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
