// External packages
import 'package:flutter/material.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/widgets/d_icon.dart';

// Feature
import '../controls/play_pause_button.dart';
import '../controls/seek_bar.dart';
import '../controls/skip_button.dart';
import '../controls/player_icon_button.dart';

/// Mobile-optimized video player controls
/// Designed for touch interaction with portrait and landscape support
class MobilePlayerControls extends StatelessWidget {
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
  final VoidCallback onAudioSettings;
  final VoidCallback onSubtitleSettings;
  final VoidCallback onSettings;
  final VoidCallback onFullscreenToggle;
  final VoidCallback? onBack;

  const MobilePlayerControls({
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
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.8),
          ],
          stops: const [0.0, 0.2, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: AppConstants.padding(AppConstants.spacing16),
                child: Row(
                  children: [
                    if (onBack != null)
                      PlayerIconButton(
                        icon: DIconName.arrowBack,
                        onPressed: onBack!,
                        tooltip: 'Back',
                      ),
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
          ),

          // Center controls
          Center(
            child: Padding(
              padding: AppConstants.padding(AppConstants.spacing24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkipButton(
                    isForward: false,
                    seconds: 15,
                    onPressed: onSkipBackward,
                    size: AppConstants.size2xl,
                  ),
                  AppConstants.spacingX(AppConstants.spacing32),
                  PlayPauseButton(
                    isPlaying: isPlaying,
                    onPressed: onPlayPause,
                    size: AppConstants.size3xl,
                  ),
                  AppConstants.spacingX(AppConstants.spacing32),
                  SkipButton(
                    isForward: true,
                    seconds: 15,
                    onPressed: onSkipForward,
                    size: AppConstants.size2xl,
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: AppConstants.padding(AppConstants.spacing16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Seek bar
                    SeekBar(
                      currentPosition: currentPosition,
                      totalDuration: totalDuration,
                      bufferedPosition: bufferedPosition,
                      onSeek: onSeek,
                      showTimeLabels: true,
                    ),
                    AppConstants.spacingY(AppConstants.spacing12),
                    // Bottom action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                          ],
                        ),
                        PlayerIconButton(
                          icon: isFullscreen
                              ? DIconName.fullscreenExit
                              : DIconName.fullscreen,
                          onPressed: onFullscreenToggle,
                          tooltip: isFullscreen
                              ? 'Exit fullscreen'
                              : 'Fullscreen',
                          size: AppConstants.iconButtonSizeSm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
