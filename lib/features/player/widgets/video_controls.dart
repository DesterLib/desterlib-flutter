import 'dart:ui';

import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:desterlib_client/core/widgets/app_icon.dart';
import 'package:desterlib_client/features/player/widgets/slider.dart';
import 'package:flutter/widgets.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({
    super.key,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onSeek,
  });

  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(12),
    );

    double iconSize = 20;

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
                  Slider(
                    value: position.inMilliseconds / duration.inMilliseconds,
                    onChanged: (value) {
                      final position = Duration(
                        milliseconds: (duration.inMilliseconds * value).round(),
                      );

                      onSeek(position);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 4,
                        children: [
                          ActionButton(
                            iconSize: iconSize,
                            icon: (context, color, size, iconKey) => AppIcon(
                              key: iconKey,
                              icon: AppIcons.backward,
                              color: color,
                              size: size,
                            ),
                            onPressed: () => print("Hello"),
                          ),
                          ActionButton(
                            iconSize: iconSize,
                            icon: (context, color, size, iconKey) => AppIcon(
                              key: iconKey,
                              icon: AppIcons.play,
                              color: color,
                              size: size,
                            ),
                            onPressed: () => print("Hello"),
                          ),
                          ActionButton(
                            iconSize: iconSize,
                            icon: (context, color, size, iconKey) => AppIcon(
                              key: iconKey,
                              icon: AppIcons.forward,
                              color: color,
                              size: size,
                            ),
                            onPressed: () => print("Hello"),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          Row(
                            spacing: 4,
                            children: [
                              ActionButton(
                                iconSize: iconSize,
                                icon: (context, color, size, iconKey) =>
                                    AppIcon(
                                      key: iconKey,
                                      icon: AppIcons.volumeFull,
                                      color: color,
                                      size: size,
                                    ),
                                onPressed: () => print("Hello"),
                              ),
                              SizedBox(
                                width: 100,
                                child: Slider(
                                  value:
                                      position.inMilliseconds /
                                      duration.inMilliseconds,
                                  onChanged: (value) {
                                    final position = Duration(
                                      milliseconds:
                                          (duration.inMilliseconds * value)
                                              .round(),
                                    );
                                    onSeek(position);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              ActionButton(
                                iconSize: iconSize,
                                icon: (context, color, size, iconKey) =>
                                    AppIcon(
                                      key: iconKey,
                                      icon: AppIcons.volumeFull,
                                      color: color,
                                      size: size,
                                    ),
                                onPressed: () => print("Hello"),
                              ),
                              ActionButton(
                                iconSize: iconSize,
                                icon: (context, color, size, iconKey) =>
                                    AppIcon(
                                      key: iconKey,
                                      icon: AppIcons.volumeFull,
                                      color: color,
                                      size: size,
                                    ),
                                onPressed: () => print("Hello"),
                              ),
                            ],
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
    );
  }
}
