// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';

// Feature
import '../controls/play_pause_button.dart';
import '../controls/seek_bar.dart';
import '../controls/skip_button.dart';
import '../controls/volume_slider.dart';
import '../controls/player_icon_button.dart';

/// Desktop-optimized video player controls
/// Designed for mouse and keyboard interaction with horizontal layout
class DesktopPlayerControls extends StatelessWidget {
  // Player state
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final Duration bufferedPosition;
  final double volume;
  final bool isMuted;
  final bool isFullscreen;

  // Callbacks
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onSkipForward;
  final VoidCallback onSkipBackward;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onMuteToggle;
  final VoidCallback onAudioSettings;
  final VoidCallback onSubtitleSettings;
  final VoidCallback onSettings;
  final VoidCallback onFullscreenToggle;
  final VoidCallback? onBack;

  const DesktopPlayerControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.bufferedPosition,
    required this.volume,
    required this.isMuted,
    required this.isFullscreen,
    required this.onPlayPause,
    required this.onSeek,
    required this.onSkipForward,
    required this.onSkipBackward,
    required this.onVolumeChanged,
    required this.onMuteToggle,
    required this.onAudioSettings,
    required this.onSubtitleSettings,
    required this.onSettings,
    required this.onFullscreenToggle,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.85),
          ],
          stops: const [0.0, 0.15, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: AppConstants.padding(AppConstants.spacing20),
              child: Row(
                children: [
                  if (onBack != null) ...[
                    PlayerIconButton(
                      icon: DIconName.arrowBack,
                      onPressed: onBack!,
                      tooltip: 'Back',
                    ),
                    AppConstants.spacingX(AppConstants.spacing16),
                  ],
                  const Spacer(),
                  PlayerIconButton(
                    icon: DIconName.settings,
                    onPressed: onSettings,
                    tooltip: 'Settings',
                  ),
                ],
              ),
            ),
          ),

          // Center play/pause overlay
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: PlayPauseButton(
                isPlaying: isPlaying,
                onPressed: onPlayPause,
                size: AppConstants.size4xl,
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: AppConstants.padding(AppConstants.spacing20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Seek bar
                  SeekBar(
                    currentPosition: currentPosition,
                    totalDuration: totalDuration,
                    bufferedPosition: bufferedPosition,
                    onSeek: onSeek,
                    showTimeLabels: false,
                  ),
                  AppConstants.spacingY(AppConstants.spacing12),
                  // Bottom row with all controls
                  Row(
                    children: [
                      // Left: Play/Pause and Skip buttons
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: PlayPauseButton(
                              isPlaying: isPlaying,
                              onPressed: onPlayPause,
                              size: AppConstants.size2xl,
                            ),
                          ),
                          AppConstants.spacingX(AppConstants.spacing12),
                          SkipButton(
                            isForward: false,
                            seconds: 15,
                            onPressed: onSkipBackward,
                            size: AppConstants.iconButtonSizeSm,
                          ),
                          AppConstants.spacingX(AppConstants.spacing8),
                          SkipButton(
                            isForward: true,
                            seconds: 15,
                            onPressed: onSkipForward,
                            size: AppConstants.iconButtonSizeSm,
                          ),
                          AppConstants.spacingX(AppConstants.spacing16),
                          // Volume slider
                          VolumeSlider(
                            volume: volume,
                            isMuted: isMuted,
                            onVolumeChanged: onVolumeChanged,
                            onMuteToggle: onMuteToggle,
                            direction: Axis.horizontal,
                            width: 120,
                          ),
                        ],
                      ),
                      AppConstants.spacingX(AppConstants.spacing16),
                      // Center: Time display
                      Expanded(
                        child: Center(
                          child: Text(
                            '${_formatDuration(currentPosition)} / ${_formatDuration(totalDuration)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      AppConstants.spacingX(AppConstants.spacing16),
                      // Right: Audio, Subtitle, Fullscreen buttons
                      Row(
                        children: [
                          PlayerIconButton(
                            icon: DIconName.audiotrack,
                            onPressed: onAudioSettings,
                            tooltip: 'Audio',
                            size: AppConstants.iconButtonSizeSm,
                          ),
                          AppConstants.spacingX(AppConstants.spacing8),
                          PlayerIconButton(
                            icon: DIconName.subtitles,
                            onPressed: onSubtitleSettings,
                            tooltip: 'Subtitles',
                            size: AppConstants.iconButtonSizeSm,
                          ),
                          AppConstants.spacingX(AppConstants.spacing8),
                          PlayerIconButton(
                            icon: isFullscreen
                                ? DIconName.fullscreenExit
                                : DIconName.fullscreen,
                            onPressed: onFullscreenToggle,
                            tooltip: isFullscreen
                                ? 'Exit fullscreen (f)'
                                : 'Fullscreen (f)',
                            size: AppConstants.iconButtonSizeSm,
                          ),
                        ],
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
