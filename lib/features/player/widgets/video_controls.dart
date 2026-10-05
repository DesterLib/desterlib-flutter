import 'package:desterlib_client/core/icons/play_icon.dart';
import 'package:desterlib_client/core/icons/skip_next_icon.dart';
import 'package:desterlib_client/core/icons/skip_previous_icon.dart';
import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
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

    return Positioned(
      left: 0,
      right: 0,
      bottom: 24,
      child: Center(
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: shape),
          child: Container(
            width: 600,
            padding: EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: AppTheme.white.withValues(alpha: 0.2),
              shape: shape,
            ),
            child: Column(
              spacing: 8,
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
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        ActionButton(
                          icon: (context, color, size, iconKey) =>
                              SkipPreviousIcon(
                                color: color,
                                size: size,
                                key: iconKey,
                              ),
                          onPressed: () => print("Hello"),
                        ),
                        ActionButton(
                          icon: (context, color, size, iconKey) =>
                              PlayIcon(color: color, size: size, key: iconKey),
                          onPressed: () => print("Hello"),
                        ),
                        ActionButton(
                          icon: (context, color, size, iconKey) => SkipNextIcon(
                            color: color,
                            size: size,
                            key: iconKey,
                          ),
                          onPressed: () => print("Hello"),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Slider(
                        value:
                            position.inMilliseconds / duration.inMilliseconds,
                        onChanged: (value) {
                          final position = Duration(
                            milliseconds: (duration.inMilliseconds * value)
                                .round(),
                          );
                          onSeek(position);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
