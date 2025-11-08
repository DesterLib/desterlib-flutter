import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:dester/app/theme/theme.dart';
import 'package:dester/shared/widgets/ui/button.dart';
import '../provider/video_player_provider.dart';
import '../widgets/video_controls.dart';
import '../widgets/video_settings_overlay.dart';

/// Video player screen with custom controls
class PlayerScreen extends ConsumerStatefulWidget {
  final String mediaId;
  final String? mediaTitle;

  const PlayerScreen({super.key, required this.mediaId, this.mediaTitle});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();
    // Initialize player after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(
            videoPlayerControllerProvider((widget.mediaId, widget.mediaTitle)),
          )
          .initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(
      videoPlayerProvider((widget.mediaId, widget.mediaTitle)),
    );
    final playerController = ref.read(
      videoPlayerControllerProvider((widget.mediaId, widget.mediaTitle)),
    );

    debugPrint(
      '🔍 Player State: ${playerState == null ? "null" : "initialized"}, Duration: ${playerState?.duration}, Error: ${playerState?.error}, isBuffering: ${playerState?.isBuffering}, showControls: ${playerState?.showControls}',
    );

    // Show loading if player is not initialized
    if (playerState == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
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
          // Video player
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Video(
                controller: playerState.controller,
                controls: NoVideoControls,
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

          // Center controls with fade animation
          if (!playerState.isBuffering && !playerState.isCompleted)
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
            IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: AppRadius.radiusLG,
                  ),
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),

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
                isFullscreen: playerState.isFullscreen,
                title: widget.mediaTitle,
                onPlayPause: () {
                  playerController.togglePlayPause();
                },
                onSeek: (position) {
                  playerController.seek(position);
                  playerController.resetHideControlsTimer();
                },
                onSeekForward: () {
                  playerController.seekForward();
                },
                onSeekBackward: () {
                  playerController.seekBackward();
                },
                onFullscreen: () {
                  playerController.toggleFullscreen();
                },
                onBack: () {
                  context.pop();
                },
                onReplay: () {
                  playerController.replay();
                },
                onSettings: () {
                  setState(() {
                    _showSettings = true;
                  });
                },
              ),
            ),
          ),

          // Settings overlay with fade animation
          AnimatedOpacity(
            opacity: _showSettings ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _showSettings
                ? VideoSettingsOverlay(
                    playbackSpeed: playerState.playbackSpeed,
                    volume: playerState.volume,
                    onPlaybackSpeedChanged: (speed) {
                      playerController.setPlaybackSpeed(speed);
                    },
                    onVolumeChanged: (volume) {
                      playerController.setVolume(volume);
                    },
                    onClose: () {
                      setState(() {
                        _showSettings = false;
                      });
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Center playback controls (play/pause and seek buttons)
class _CenterPlaybackControls extends StatefulWidget {
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

  @override
  State<_CenterPlaybackControls> createState() =>
      _CenterPlaybackControlsState();
}

class _CenterPlaybackControlsState extends State<_CenterPlaybackControls>
    with TickerProviderStateMixin {
  late AnimationController _playPauseController;
  late AnimationController _seekBackwardController;
  late AnimationController _seekForwardController;

  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _seekBackwardController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _seekForwardController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    _seekBackwardController.dispose();
    _seekForwardController.dispose();
    super.dispose();
  }

  void _handlePlayPause() {
    debugPrint('🎮 Play/Pause button tapped!');
    HapticFeedback.mediumImpact();
    _playPauseController.forward().then((_) => _playPauseController.reverse());
    widget.onPlayPause();
  }

  void _handleSeekBackward() {
    HapticFeedback.lightImpact();
    _seekBackwardController.forward().then(
      (_) => _seekBackwardController.reverse(),
    );
    widget.onSeekBackward();
  }

  void _handleSeekForward() {
    HapticFeedback.lightImpact();
    _seekForwardController.forward().then(
      (_) => _seekForwardController.reverse(),
    );
    widget.onSeekForward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Seek backward
        _BouncyButton(
          controller: _seekBackwardController,
          child: DButton(
            icon: Icons.replay_10_rounded,
            variant: DButtonVariant.ghost,
            size: DButtonSize.lg,
            onTap: _handleSeekBackward,
          ),
        ),
        AppSpacing.gapHorizontalXL,
        // Play/Pause
        _BouncyButton(
          controller: _playPauseController,
          scale: 1.15,
          child: DButton(
            icon: widget.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            variant: DButtonVariant.ghost,
            size: DButtonSize.lg,
            onTap: () {
              debugPrint('🎯 DButton onTap called');
              _handlePlayPause();
            },
          ),
        ),
        AppSpacing.gapHorizontalXL,
        // Seek forward
        _BouncyButton(
          controller: _seekForwardController,
          child: DButton(
            icon: Icons.forward_10_rounded,
            variant: DButtonVariant.ghost,
            size: DButtonSize.lg,
            onTap: _handleSeekForward,
          ),
        ),
      ],
    );
  }
}

/// Bouncy button wrapper with iOS-style spring animation
class _BouncyButton extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final double scale;

  const _BouncyButton({
    required this.controller,
    required this.child,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scaleValue = 1.0 - (controller.value * 0.15);
        return Transform.scale(scale: scaleValue * scale, child: child);
      },
      child: child,
    );
  }
}

/// Completed overlay with replay button
class _CompletedOverlay extends StatefulWidget {
  final VoidCallback onReplay;

  const _CompletedOverlay({required this.onReplay});

  @override
  State<_CompletedOverlay> createState() => _CompletedOverlayState();
}

class _CompletedOverlayState extends State<_CompletedOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _replayController;

  @override
  void initState() {
    super.initState();
    _replayController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _replayController.dispose();
    super.dispose();
  }

  void _handleReplay() {
    HapticFeedback.mediumImpact();
    _replayController.forward().then((_) => _replayController.reverse());
    widget.onReplay();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BouncyButton(
          controller: _replayController,
          scale: 1.15,
          child: DButton(
            icon: Icons.replay_rounded,
            variant: DButtonVariant.ghost,
            size: DButtonSize.lg,
            onTap: _handleReplay,
          ),
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
