import 'dart:ui';

import 'package:desterlib_client/core/app/app.dart';
import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:desterlib_client/core/widgets/app_icon.dart';
import 'package:desterlib_client/features/player/video_player/video_player_state.dart';
import 'package:desterlib_client/features/player/widgets/slider.dart';
import 'package:flutter/widgets.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({super.key, required this.videoPlayerState});

  final VideoPlayerState videoPlayerState;

  @override
  Widget build(BuildContext context) {
    final player = videoPlayerState.player;

    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(12),
    );

    Color iconColor = AppTheme.white;
    double iconSize = 20;

    final controlsTextStyle = AppThemeScope.of(context).textTheme.controls;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 24,
      child: Center(
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: shape),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: 600,
              padding: EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: AppTheme.playerSurface,
                shape: shape,
              ),
              child: Column(
                spacing: 4,
                children: [
                  StreamBuilder(
                    stream: player.stream.position,
                    builder: (context, asyncSnapshot) {
                      final position = asyncSnapshot.data ?? Duration.zero;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            videoPlayerState.formatDuration(position),
                            style: controlsTextStyle,
                          ),
                          Text(
                            videoPlayerState.formatDuration(
                              videoPlayerState.duration,
                            ),
                            style: controlsTextStyle,
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder<Duration>(
                    stream: player.stream.position,
                    builder: (context, asyncSnapshot) {
                      final position = asyncSnapshot.data ?? Duration.zero;

                      return StreamBuilder(
                        stream: player.stream.buffer,
                        builder: (context, asyncSnapshot) {
                          final buffer = asyncSnapshot.data ?? Duration.zero;

                          return Slider(
                            value: videoPlayerState.progressFor(position),
                            secondaryValue: videoPlayerState.bufferProgress(
                              buffer,
                            ),
                            onChanged: videoPlayerState.seekToProgress,
                          );
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 4,
                        children: [
                          // ActionButton(
                          //   iconSize: iconSize,
                          //   color: iconColor,
                          //   icon: (context, color, size, iconKey) => AppIcon(
                          //     key: iconKey,
                          //     icon: AppIcons.backward,
                          //     color: color,
                          //     size: size,
                          //   ),
                          //   onPressed: () => print("Hello"),
                          // ),
                          StreamBuilder(
                            stream: player.stream.playing,
                            builder: (context, asyncSnapshot) {
                              final isPlaying = asyncSnapshot.data ?? false;

                              return ActionButton(
                                iconSize: iconSize,
                                color: iconColor,
                                onPressed: videoPlayerState.togglePlay,
                                icon: (context, color, size, key) {
                                  return AppIcon(
                                    key: key,
                                    icon: isPlaying
                                        ? AppIcons.pause
                                        : AppIcons.play,
                                    color: color,
                                    size: size,
                                  );
                                },
                              );
                            },
                          ),
                          // ActionButton(
                          //   iconSize: iconSize,
                          //   color: iconColor,
                          //   icon: (context, color, size, iconKey) => AppIcon(
                          //     key: iconKey,
                          //     icon: AppIcons.forward,
                          //     color: color,
                          //     size: size,
                          //   ),
                          //   onPressed: () => print("Hello"),
                          // ),
                        ],
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          Row(
                            spacing: 4,
                            children: [
                              StreamBuilder(
                                stream: player.stream.volume,
                                builder: (context, asyncSnapshot) {
                                  return ActionButton(
                                    iconSize: iconSize,
                                    color: iconColor,
                                    icon: (context, color, size, iconKey) =>
                                        AppIcon(
                                          key: iconKey,
                                          icon: AppIcons.volumeFull,
                                          color: color,
                                          size: size,
                                        ),
                                    onPressed: () {
                                      videoPlayerState.toggleMute();
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                width: 100,
                                child: StreamBuilder(
                                  stream: player.stream.volume,
                                  builder: (context, asyncSnapshot) {
                                    final volume =
                                        asyncSnapshot.data ??
                                        player.state.volume;

                                    return Slider(
                                      value: videoPlayerState.volumeProgress(
                                        volume,
                                      ),
                                      onChanged: videoPlayerState.setVolume,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   spacing: 4,
                          //   children: [
                          //     ActionButton(
                          //       iconSize: iconSize,
                          //       color: iconColor,
                          //       icon: (context, color, size, iconKey) =>
                          //           AppIcon(
                          //             key: iconKey,
                          //             icon: AppIcons.audioTrack,
                          //             color: color,
                          //             size: size,
                          //           ),
                          //       onPressed: () => print("Hello"),
                          //     ),
                          //     ActionButton(
                          //       iconSize: iconSize,
                          //       color: iconColor,
                          //       icon: (context, color, size, iconKey) =>
                          //           AppIcon(
                          //             key: iconKey,
                          //             icon: AppIcons.subtitlesOff,
                          //             color: color,
                          //             size: size,
                          //           ),
                          //       onPressed: () => print("Hello"),
                          //     ),
                          //     ActionButton(
                          //       iconSize: iconSize,
                          //       color: iconColor,
                          //       icon: (context, color, size, iconKey) =>
                          //           AppIcon(
                          //             key: iconKey,
                          //             icon: AppIcons.fullscreen,
                          //             color: color,
                          //             size: size,
                          //           ),
                          //       onPressed: () => print("Hello"),
                          //     ),
                          //   ],
                          // ),
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
    );
  }
}
