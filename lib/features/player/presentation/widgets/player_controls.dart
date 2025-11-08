import 'package:flutter/material.dart';
import 'dart:ui';
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
  final String? title; // Movie title or TV show title
  final String? episodeTitle; // Episode-specific title (only for TV shows)
  final int? seasonNumber;
  final int? episodeNumber;
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
    this.episodeTitle,
    this.seasonNumber,
    this.episodeNumber,
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

  /// Format duration for display (e.g., "13:45" or "1:23:45")
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Build title widget
  /// For TV shows: Two-line display with show title and episode info
  /// For movies: Single line with movie title
  Widget? _buildTitleWidget() {
    if (title == null) return null;

    final isTVShow = seasonNumber != null && episodeNumber != null;

    if (isTVShow) {
      // TV Show: Two-line format
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            'S$seasonNumber E$episodeNumber${episodeTitle != null ? ' | $episodeTitle' : ''}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    } else {
      // Movie: Single line
      return Text(
        title!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

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
              child: isDesktop
                  ? Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              // Back button
                              VideoPlayerButton(
                                icon: PlatformIcons.arrowBack,
                                onTap: onBack,
                                size: VideoPlayerButtonSize.standard,
                              ),
                              if (_buildTitleWidget() != null) ...[
                                AppSpacing.gapHorizontalMD,
                                Expanded(child: _buildTitleWidget()!),
                              ],
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
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
                          ),
                          if (_buildTitleWidget() != null) ...[
                            AppSpacing.gapHorizontalMD,
                            Expanded(child: _buildTitleWidget()!),
                          ],
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
              child: isDesktop
                  ? Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 40.0,
                                sigmaY: 40.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800.withValues(
                                    alpha: 0.1,
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade800.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 0.33,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Main control bar
                                    Row(
                                      children: [
                                        // Left section - Playback controls
                                        Row(
                                          children: [
                                            VideoPlayerButton(
                                              icon: PlatformIcons.replay10,
                                              onTap: onSeekBackward,
                                              size: VideoPlayerButtonSize
                                                  .standard,
                                            ),
                                            AppSpacing.gapHorizontalXS,
                                            VideoPlayerButton(
                                              icon: isPlaying
                                                  ? PlatformIcons.pause
                                                  : PlatformIcons.playArrow,
                                              onTap: onPlayPause,
                                              size: VideoPlayerButtonSize
                                                  .standard,
                                            ),
                                            AppSpacing.gapHorizontalXS,
                                            VideoPlayerButton(
                                              icon: PlatformIcons.forward10,
                                              onTap: onSeekForward,
                                              size: VideoPlayerButtonSize
                                                  .standard,
                                            ),
                                          ],
                                        ),

                                        const Spacer(),

                                        // Right section - Settings buttons
                                        Row(
                                          children: [
                                            if (onSpeedSettings != null)
                                              VideoPlayerButton(
                                                icon: PlatformIcons.speed,
                                                onTap: onSpeedSettings!,
                                                size: VideoPlayerButtonSize
                                                    .standard,
                                              ),
                                            if (onSpeedSettings != null &&
                                                onTracksSettings != null)
                                              AppSpacing.gapHorizontalSM,
                                            if (onTracksSettings != null)
                                              VideoPlayerButton(
                                                icon: PlatformIcons.subtitles,
                                                onTap: onTracksSettings!,
                                                size: VideoPlayerButtonSize
                                                    .standard,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Progress bar
                                    PlayerProgressBar(
                                      position: position,
                                      duration: duration,
                                      buffer: buffer,
                                      onSeek: onSeek,
                                      onSeekStart: onSeekStart,
                                      onSeekEnd: onSeekEnd,
                                    ),
                                    // Timestamps below progress bar
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(position),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(duration),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                    )
                  : Padding(
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
                          // Timestamps below progress bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
                                ),
                              if (onSpeedSettings != null &&
                                  onTracksSettings != null)
                                AppSpacing.gapHorizontalXS,
                              if (onTracksSettings != null)
                                VideoPlayerButton(
                                  icon: PlatformIcons.subtitles,
                                  label: 'Audio & Subtitles',
                                  size: VideoPlayerButtonSize.standard,
                                  onTap: onTracksSettings!,
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
