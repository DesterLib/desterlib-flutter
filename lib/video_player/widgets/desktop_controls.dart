import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/video_player_cubit.dart';
import '../cubits/controls_cubit.dart';
import 'desktop_control_button.dart';
import 'progress_bar.dart';
import 'volume_control.dart';

/// Desktop video controls layout
class DesktopControls extends StatelessWidget {
  const DesktopControls({super.key});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<VideoPlayerCubit>();
    final controlsCubit = context.read<ControlsCubit>();
    final playerState = context.watch<VideoPlayerCubit>().state;
    final isPlaying = playerState.isPlaying;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 768),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar with timestamps
                    const DesktopProgressBar(),
                    const SizedBox(height: 16),
                    // Controls row
                    Row(
                      children: [
                        // Left side - Playback controls
                        Row(
                          children: [
                            DesktopControlButton(
                              icon: isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              onPressed: () {
                                playerCubit.playOrPause();
                                controlsCubit.showControls();
                              },
                            ),
                            const SizedBox(width: 8),
                            DesktopControlButton(
                              icon: Icons.replay_10_rounded,
                              onPressed: () {
                                playerCubit.seekRelative(
                                  const Duration(seconds: -10),
                                );
                                controlsCubit.showControls();
                              },
                            ),
                            const SizedBox(width: 8),
                            DesktopControlButton(
                              icon: Icons.forward_10_rounded,
                              onPressed: () {
                                playerCubit.seekRelative(
                                  const Duration(seconds: 10),
                                );
                                controlsCubit.showControls();
                              },
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Right side - Volume, tracks, fullscreen
                        Row(
                          children: [
                            const VolumeControl(),
                            const SizedBox(width: 16),
                            DesktopControlButton(
                              icon: Icons.audiotrack_rounded,
                              onPressed: controlsCubit.toggleAudioMenu,
                            ),
                            const SizedBox(width: 8),
                            DesktopControlButton(
                              icon: Icons.closed_caption_rounded,
                              onPressed: controlsCubit.toggleSubtitleMenu,
                            ),
                            const SizedBox(width: 8),
                            DesktopControlButton(
                              icon: playerState.isFullscreen
                                  ? Icons.fullscreen_exit_rounded
                                  : Icons.fullscreen_rounded,
                              onPressed: playerCubit.toggleFullscreen,
                            ),
                          ],
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
    );
  }
}
