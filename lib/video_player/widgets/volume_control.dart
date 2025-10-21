import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/video_player_cubit.dart';
import '../cubits/controls_cubit.dart';
import 'desktop_control_button.dart';

/// Desktop volume control widget
class VolumeControl extends StatelessWidget {
  const VolumeControl({super.key});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<VideoPlayerCubit>();
    final controlsCubit = context.read<ControlsCubit>();
    final playerState = context.watch<VideoPlayerCubit>().state;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DesktopControlButton(
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
        SizedBox(
          width: 100,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity( 0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity( 0.2),
            ),
            child: Slider(
              value: playerState.isMuted ? 0 : playerState.volume,
              min: 0.0,
              max: 100.0,
              onChanged: (value) {
                playerCubit.setVolume(value);
                controlsCubit.showControls();
              },
            ),
          ),
        ),
      ],
    );
  }
}
