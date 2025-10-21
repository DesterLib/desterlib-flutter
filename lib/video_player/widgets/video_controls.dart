import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/controls_cubit.dart';
import '../models/controls_state.dart';
import '../constants/video_player_constants.dart';
import 'desktop_top_bar.dart';
import 'desktop_controls.dart';
import 'mobile_controls.dart';
import 'track_menu.dart';

/// Main video controls widget that adapts to desktop/mobile
class VideoControls extends StatelessWidget {
  const VideoControls({super.key});

  bool _isDesktop(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= VideoPlayerConstants.mobileBreakpoint;
  }

  @override
  Widget build(BuildContext context) {
    final controlsCubit = context.read<ControlsCubit>();
    final controlsState = context.watch<ControlsCubit>().state;
    final isDesktop = _isDesktop(context);

    return MouseRegion(
      onHover: (_) => controlsCubit.showControls(),
      child: GestureDetector(
        onTap: () {
          if (isDesktop && controlsState.activeMenu != TrackMenuType.none) {
            controlsCubit.closeMenus();
          } else {
            controlsCubit.toggleControls();
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Desktop top bar with title
              if (isDesktop)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: AnimatedOpacity(
                    opacity: controlsState.isVisible ? 1.0 : 0.0,
                    duration: VideoPlayerConstants.controlsAnimationDuration,
                    child: const DesktopTopBar(),
                  ),
                ),

              // Platform-specific controls
              if (isDesktop)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: controlsState.isVisible ? 1.0 : 0.0,
                    duration: VideoPlayerConstants.controlsAnimationDuration,
                    child: const DesktopControls(),
                  ),
                )
              else
                const MobileControls(),

              // Track menu (desktop only)
              if (isDesktop &&
                  controlsState.isVisible &&
                  controlsState.activeMenu != TrackMenuType.none)
                const TrackMenu(),
            ],
          ),
        ),
      ),
    );
  }
}
