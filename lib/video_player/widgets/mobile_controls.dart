import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/video_player_cubit.dart';
import '../cubits/controls_cubit.dart';
import '../models/controls_state.dart';
import 'mobile_control_button.dart';
import 'progress_bar.dart';
import 'track_menu.dart';

/// Mobile video controls layout
class MobileControls extends StatelessWidget {
  const MobileControls({super.key});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<VideoPlayerCubit>();
    final controlsCubit = context.read<ControlsCubit>();
    final playerState = context.watch<VideoPlayerCubit>().state;
    final controlsState = context.watch<ControlsCubit>().state;
    final isPlaying = playerState.isPlaying;

    return Stack(
      children: [
        // Top gradient backdrop (non-interactive)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.3,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: controlsState.isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha:  0.6),
                      Colors.black.withValues(alpha:  0.0),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Bottom gradient backdrop (non-interactive)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: controlsState.isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha:  0.0),
                      Colors.black.withValues(alpha:  0.7),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Top left - Back button
        Positioned(
          top: 16,
          left: 16,
          child: AnimatedOpacity(
            opacity: controlsState.isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !controlsState.isVisible,
              child: SafeArea(
                child: MobileControlButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          ),
        ),

        // Top right - Settings/Options
        Positioned(
          top: 16,
          right: 16,
          child: AnimatedOpacity(
            opacity: controlsState.isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !controlsState.isVisible,
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MobileControlButton(
                      icon: playerState.isMuted
                          ? Icons.volume_off_rounded
                          : playerState.volume > 50
                          ? Icons.volume_up_rounded
                          : Icons.volume_down_rounded,
                      onPressed: () {
                        playerCubit.toggleMute();
                        controlsCubit.showControls();
                      },
                    ),
                    const SizedBox(width: 8),
                    MobileControlButton(
                      icon: Icons.audiotrack_rounded,
                      onPressed: () {
                        showMobileTrackDrawer(context, TrackMenuType.audio);
                      },
                    ),
                    const SizedBox(width: 8),
                    MobileControlButton(
                      icon: Icons.closed_caption_rounded,
                      onPressed: () {
                        showMobileTrackDrawer(context, TrackMenuType.subtitle);
                      },
                    ),
                    const SizedBox(width: 8),
                    MobileControlButton(
                      icon: playerState.isFullscreen
                          ? Icons.fullscreen_exit_rounded
                          : Icons.fullscreen_rounded,
                      onPressed: playerCubit.toggleFullscreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Center - Playback controls
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: controlsState.isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Center(
              child: IgnorePointer(
                ignoring: !controlsState.isVisible,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MobileControlButton(
                      icon: Icons.replay_10_rounded,
                      size: 28,
                      onPressed: () {
                        playerCubit.seekRelative(const Duration(seconds: -10));
                        controlsCubit.showControls();
                      },
                    ),
                    const SizedBox(width: 32),
                    MobileControlButton(
                      icon: isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 36,
                      onPressed: () {
                        playerCubit.playOrPause();
                        controlsCubit.showControls();
                      },
                    ),
                    const SizedBox(width: 32),
                    MobileControlButton(
                      icon: Icons.forward_10_rounded,
                      size: 28,
                      onPressed: () {
                        playerCubit.seekRelative(const Duration(seconds: 10));
                        controlsCubit.showControls();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom area - Progress bar only
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: controlsState.isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !controlsState.isVisible,
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: MobileProgressBar(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
