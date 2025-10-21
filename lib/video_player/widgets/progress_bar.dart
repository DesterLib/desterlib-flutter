import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/video_player_cubit.dart';
import '../cubits/controls_cubit.dart';
import '../utils/duration_formatter.dart';

/// Progress bar widget for desktop layout
class DesktopProgressBar extends StatelessWidget {
  const DesktopProgressBar({super.key});

  double _getCurrentSliderValue(BuildContext context) {
    final controlsState = context.watch<ControlsCubit>().state;
    final playerState = context.watch<VideoPlayerCubit>().state;

    if (controlsState.isDragging && controlsState.dragValue != null) {
      return controlsState.dragValue!;
    }
    return playerState.position.inMilliseconds.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<VideoPlayerCubit>();
    final controlsCubit = context.read<ControlsCubit>();
    final playerState = context.watch<VideoPlayerCubit>().state;
    final currentValue = _getCurrentSliderValue(context);
    final duration = playerState.duration;

    return Row(
      children: [
        Text(
          DurationFormatter.format(
            Duration(milliseconds: currentValue.toInt()),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha:  0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha:  0.2),
            ),
            child: Slider(
              value: currentValue.clamp(
                0.0,
                duration.inMilliseconds.toDouble(),
              ),
              min: 0.0,
              max: duration.inMilliseconds.toDouble(),
              onChangeStart: (value) {
                controlsCubit.setDragging(true, dragValue: value);
              },
              onChanged: (value) {
                controlsCubit.setDragging(true, dragValue: value);
                playerCubit.seek(Duration(milliseconds: value.toInt()));
              },
              onChangeEnd: (value) {
                controlsCubit.setDragging(false);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          DurationFormatter.format(duration),
          style: TextStyle(
            color: Colors.white.withValues(alpha:  0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// Progress bar widget for mobile layout
class MobileProgressBar extends StatelessWidget {
  const MobileProgressBar({super.key});

  double _getCurrentSliderValue(BuildContext context) {
    final controlsState = context.watch<ControlsCubit>().state;
    final playerState = context.watch<VideoPlayerCubit>().state;

    if (controlsState.isDragging && controlsState.dragValue != null) {
      return controlsState.dragValue!;
    }
    return playerState.position.inMilliseconds.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<VideoPlayerCubit>();
    final controlsCubit = context.read<ControlsCubit>();
    final playerState = context.watch<VideoPlayerCubit>().state;
    final currentValue = _getCurrentSliderValue(context);
    final duration = playerState.duration;

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha:  0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha:  0.2),
          ),
          child: Slider(
            value: currentValue.clamp(0.0, duration.inMilliseconds.toDouble()),
            min: 0.0,
            max: duration.inMilliseconds.toDouble(),
            onChangeStart: (value) {
              controlsCubit.setDragging(true, dragValue: value);
            },
            onChanged: (value) {
              controlsCubit.setDragging(true, dragValue: value);
              playerCubit.seek(Duration(milliseconds: value.toInt()));
            },
            onChangeEnd: (value) {
              controlsCubit.setDragging(false);
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DurationFormatter.format(
                  Duration(milliseconds: currentValue.toInt()),
                ),
                style: TextStyle(
                  color: Colors.white.withValues(alpha:  0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                DurationFormatter.format(duration),
                style: TextStyle(
                  color: Colors.white.withValues(alpha:  0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
