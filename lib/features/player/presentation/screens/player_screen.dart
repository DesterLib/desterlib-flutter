import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/utils/platform_icons.dart';
import 'package:dester/shared/utils/track_helper.dart';
import 'package:dester/shared/widgets/ui/loading_indicator.dart';
import '../provider/video_player_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/player_overlay_speed.dart';
import '../widgets/player_overlay_tracks.dart';
import '../widgets/player_button.dart';
import '../../data/video_player_settings_provider.dart';

/// Video player screen with custom controls
class PlayerScreen extends ConsumerStatefulWidget {
  final String mediaId;
  final String? mediaTitle; // Movie title or TV show title
  final String? episodeTitle; // Episode-specific title (only for TV shows)
  final int? seasonNumber;
  final int? episodeNumber;

  const PlayerScreen({
    super.key,
    required this.mediaId,
    this.mediaTitle,
    this.episodeTitle,
    this.seasonNumber,
    this.episodeNumber,
  });

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _showSpeedSelector = false;
  bool _showTracksSelector = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📱 PlayerScreen initState for media: ${widget.mediaId}');

    // Lock orientation to landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Initialize player after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) return;
      _initialized = true;

      debugPrint('🎬 PostFrameCallback: Calling initialize()');
      ref
          .read(
            videoPlayerControllerProvider((widget.mediaId, widget.mediaTitle)),
          )
          .initialize();
    });
  }

  @override
  void dispose() {
    // Reset orientation to allow all orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(
      videoPlayerProvider((widget.mediaId, widget.mediaTitle)),
    );
    final playerController = ref.read(
      videoPlayerControllerProvider((widget.mediaId, widget.mediaTitle)),
    );
    final videoPlayerSettings = ref.watch(videoPlayerSettingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    debugPrint(
      '🔍 Player State: ${playerState == null ? "null" : "initialized"}, Duration: ${playerState?.duration}, Error: ${playerState?.error}, isBuffering: ${playerState?.isBuffering}, showControls: ${playerState?.showControls}',
    );
    debugPrint(
      '📝 Subtitle Settings: size=${videoPlayerSettings.subtitleSize}px, bgOpacity=${videoPlayerSettings.subtitleBackgroundOpacity}',
    );

    // Show loading if player is not initialized
    if (playerState == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DLoadingIndicator(),
              AppSpacing.gapVerticalMD,
              Text(
                'Initializing player...',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show error if there's an error
    if (playerState.error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 64),
              AppSpacing.gapVerticalMD,
              Text(
                'Failed to load video',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapVerticalSM,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  playerState.error!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.gapVerticalXL,
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video player - full screen
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width:
                    playerState.controller.player.state.width?.toDouble() ?? 16,
                height:
                    playerState.controller.player.state.height?.toDouble() ?? 9,
                child: Video(
                  key: ValueKey(
                    'video_${videoPlayerSettings.subtitleSize}_${videoPlayerSettings.subtitleBackgroundOpacity}',
                  ),
                  controller: playerState.controller,
                  controls: NoVideoControls,
                  subtitleViewConfiguration: SubtitleViewConfiguration(
                    style: TextStyle(
                      height: 1.4,
                      fontSize: videoPlayerSettings.subtitleSize,
                      letterSpacing: 0.0,
                      wordSpacing: 0.0,
                      color: const Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                      backgroundColor: Color.fromRGBO(
                        0,
                        0,
                        0,
                        videoPlayerSettings.subtitleBackgroundOpacity,
                      ),
                      shadows: const [
                        Shadow(
                          color: Color(0xCC000000),
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                        Shadow(
                          color: Color(0x99000000),
                          blurRadius: 8,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    padding: const EdgeInsets.all(24.0),
                  ),
                ),
              ),
            ),
          ),

          // Full-screen gesture detector layer
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                debugPrint('🖐️ Screen tapped - toggling controls');
                playerController.toggleControls();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),

          // Center controls with fade animation (mobile only - desktop has inline controls)
          if (!isDesktop &&
              !playerState.isBuffering &&
              !playerState.isCompleted)
            AnimatedOpacity(
              opacity: playerState.showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: IgnorePointer(
                ignoring: !playerState.showControls,
                child: Center(
                  child: _CenterPlaybackControls(
                    isPlaying: playerState.isPlaying,
                    onPlayPause: () {
                      debugPrint('📞 Play/Pause tapped');
                      playerController.togglePlayPause();
                    },
                    onSeekBackward: () {
                      debugPrint('⏪ Seek backward tapped');
                      playerController.seekBackward();
                    },
                    onSeekForward: () {
                      debugPrint('⏩ Seek forward tapped');
                      playerController.seekForward();
                    },
                  ),
                ),
              ),
            ),

          // Completed overlay with fade animation
          if (playerState.isCompleted)
            AnimatedOpacity(
              opacity: playerState.showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: IgnorePointer(
                ignoring: !playerState.showControls,
                child: Center(
                  child: _CompletedOverlay(
                    onReplay: () => playerController.replay(),
                  ),
                ),
              ),
            ),

          // Buffering indicator (always visible when buffering, doesn't block pointer events)
          if (playerState.isBuffering)
            const IgnorePointer(child: Center(child: DLoadingIndicator())),

          // Controls overlay (top and bottom bars only) with fade animation
          AnimatedOpacity(
            opacity: playerState.showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: !playerState.showControls,
              child: VideoControls(
                isPlaying: playerState.isPlaying,
                isBuffering: playerState.isBuffering,
                isCompleted: playerState.isCompleted,
                position: playerState.position,
                duration: playerState.duration,
                buffer: playerState.buffer,
                volume: playerState.volume,
                playbackSpeed: playerState.playbackSpeed,
                title: widget.mediaTitle,
                episodeTitle: widget.episodeTitle,
                seasonNumber: widget.seasonNumber,
                episodeNumber: widget.episodeNumber,
                onPlayPause: () {
                  playerController.togglePlayPause();
                },
                onSeek: (position) {
                  playerController.seek(position);
                },
                onSeekStart: () {
                  debugPrint('🎯 Seek started - canceling hide timer');
                  playerController.cancelHideControlsTimer();
                },
                onSeekEnd: () {
                  debugPrint('🎯 Seek ended - resetting hide timer');
                  playerController.resetHideControlsTimer();
                },
                onSeekForward: () {
                  playerController.seekForward();
                },
                onSeekBackward: () {
                  playerController.seekBackward();
                },
                onBack: () {
                  context.pop();
                },
                onReplay: () {
                  playerController.replay();
                },
                onSpeedSettings: () {
                  setState(() => _showSpeedSelector = true);
                },
                onTracksSettings: () {
                  setState(() => _showTracksSelector = true);
                },
              ),
            ),
          ),

          // Speed selector overlay with fade animation
          if (_showSpeedSelector)
            SpeedSelectorOverlay(
              currentSpeed: playerState.playbackSpeed,
              onSpeedChanged: (speed) {
                playerController.setPlaybackSpeed(speed);
              },
              onClose: () {
                setState(() => _showSpeedSelector = false);
              },
            ),

          // Tracks selector overlay with fade animation
          if (_showTracksSelector)
            TracksSelectorOverlay(
              audioTracks: () {
                final allTracks = playerController.getAudioTracks();

                // Add "Auto" option if there's an auto track
                final hasAutoTrack = allTracks.any(
                  (t) => t.id == 'auto' || t.id == 'no',
                );
                final autoOption = hasAutoTrack
                    ? [const TrackOption(id: 'auto', label: 'Auto')]
                    : <TrackOption>[];

                // Filter valid tracks and create options with context-aware labels
                final validTracks = allTracks
                    .where((track) => TrackHelper.isValidTrack(track))
                    .map((track) {
                      final label = TrackHelper.getTrackLabelWithContext(
                        track,
                        allTracks,
                      );
                      return TrackOption(id: track.id, label: label);
                    })
                    .toList();

                return [...autoOption, ...validTracks];
              }(),
              subtitleTracks: () {
                final allTracks = playerController.getSubtitleTracks();

                // Add "Auto" option if there's an auto track
                final hasAutoTrack = allTracks.any((t) => t.id == 'auto');
                final autoOption = hasAutoTrack
                    ? [const TrackOption(id: 'auto', label: 'Auto')]
                    : <TrackOption>[];

                // Filter valid tracks and create options with context-aware labels
                final validTracks = allTracks
                    .where((track) => TrackHelper.isValidTrack(track))
                    .map((track) {
                      final label = TrackHelper.getTrackLabelWithContext(
                        track,
                        allTracks,
                      );
                      return TrackOption(id: track.id, label: label);
                    })
                    .toList();

                return [
                  const TrackOption(id: 'no', label: 'Off'),
                  ...autoOption,
                  ...validTracks,
                ];
              }(),
              selectedAudioId: playerController.getSelectedAudioTrack().id,
              selectedSubtitleId: playerController
                  .getSelectedSubtitleTrack()
                  .id,
              onAudioChanged: (id) {
                // Handle "Auto" selection
                if (id == 'auto') {
                  final autoTrack = playerController
                      .getAudioTracks()
                      .firstWhere(
                        (t) => t.id == 'auto' || t.id == 'no',
                        orElse: () => const AudioTrack('auto', '', ''),
                      );
                  playerController.setAudioTrack(autoTrack);
                  return;
                }

                final track = playerController.getAudioTracks().firstWhere(
                  (t) => t.id == id,
                );
                playerController.setAudioTrack(track);
              },
              onSubtitleChanged: (id) {
                // Handle "Off" selection
                if (id == 'no') {
                  playerController.setSubtitleTrack(
                    const SubtitleTrack('no', '', ''),
                  );
                  return;
                }

                // Handle "Auto" selection
                if (id == 'auto') {
                  final autoTrack = playerController
                      .getSubtitleTracks()
                      .firstWhere(
                        (t) => t.id == 'auto',
                        orElse: () => const SubtitleTrack('auto', '', ''),
                      );
                  playerController.setSubtitleTrack(autoTrack);
                  return;
                }

                final track = playerController.getSubtitleTracks().firstWhere(
                  (t) => t.id == id,
                );
                playerController.setSubtitleTrack(track);
              },
              onClose: () {
                setState(() => _showTracksSelector = false);
              },
            ),
        ],
      ),
    );
  }
}

/// Center playback controls (play/pause and seek buttons)
class _CenterPlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;

  const _CenterPlaybackControls({
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSeekBackward,
    required this.onSeekForward,
  });

  void _handlePlayPause() {
    debugPrint('🎮 Play/Pause button tapped!');
    onPlayPause();
  }

  void _handleSeekBackward() {
    debugPrint('⏪ Seek backward tapped');
    onSeekBackward();
  }

  void _handleSeekForward() {
    debugPrint('⏩ Seek forward tapped');
    onSeekForward();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    Widget controls = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Seek backward
        VideoPlayerButton(
          icon: PlatformIcons.replay10,
          onTap: _handleSeekBackward,
          size: VideoPlayerButtonSize.large,
        ),
        // Play/Pause
        VideoPlayerButton(
          icon: isPlaying ? PlatformIcons.pause : PlatformIcons.playArrow,
          onTap: _handlePlayPause,
          size: VideoPlayerButtonSize.extraLarge,
        ),
        // Seek forward
        VideoPlayerButton(
          icon: PlatformIcons.forward10,
          onTap: _handleSeekForward,
          size: VideoPlayerButtonSize.large,
        ),
      ],
    );

    return isDesktop
        ? Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: controls,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: controls,
          );
  }
}

/// Completed overlay with replay button
class _CompletedOverlay extends StatelessWidget {
  final VoidCallback onReplay;

  const _CompletedOverlay({required this.onReplay});

  void _handleReplay() {
    debugPrint('🔄 Replay tapped');
    onReplay();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VideoPlayerButton(
          icon: PlatformIcons.replay,
          onTap: _handleReplay,
          size: VideoPlayerButtonSize.extraLarge,
        ),
        AppSpacing.gapVerticalMD,
        const Text(
          'Replay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
