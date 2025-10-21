import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import '../cubits/video_player_cubit.dart';
import '../cubits/controls_cubit.dart';
import '../models/controls_state.dart';
import '../utils/track_helper.dart';
import 'track_menu_item.dart';
import 'drawer_track_item.dart';

/// Desktop track menu overlay
class TrackMenu extends StatelessWidget {
  const TrackMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<VideoPlayerCubit>();
    final controlsCubit = context.read<ControlsCubit>();
    final controlsState = context.watch<ControlsCubit>().state;
    final activeMenu = controlsState.activeMenu;

    final title = activeMenu == TrackMenuType.audio
        ? 'Audio Tracks'
        : 'Subtitles';
    final tracks = activeMenu == TrackMenuType.audio
        ? playerCubit.player.state.tracks.audio
        : playerCubit.player.state.tracks.subtitle;
    final currentTrack = activeMenu == TrackMenuType.audio
        ? playerCubit.player.state.track.audio
        : playerCubit.player.state.track.subtitle;
    final isSubtitle = activeMenu == TrackMenuType.subtitle;
    final isAudio = activeMenu == TrackMenuType.audio;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 180,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Align(
              alignment: Alignment.centerRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 280,
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:  0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha:  0.1),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withValues(alpha:  0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        // Track list
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              // Auto option for audio tracks
                              if (isAudio)
                                TrackMenuItem(
                                  label: 'Auto',
                                  isSelected: currentTrack.id == 'auto',
                                  onTap: () {
                                    playerCubit.setAudioTrack(
                                      AudioTrack.auto(),
                                    );
                                    controlsCubit.closeMenus();
                                  },
                                ),
                              // Off option for subtitles
                              if (isSubtitle)
                                TrackMenuItem(
                                  label: 'Off',
                                  isSelected: currentTrack.id == 'no',
                                  onTap: () {
                                    playerCubit.setSubtitleTrack(
                                      SubtitleTrack.no(),
                                    );
                                    controlsCubit.closeMenus();
                                  },
                                ),
                              // All available tracks (filtered)
                              ...tracks
                                  .where(TrackHelper.isValidTrack)
                                  .map(
                                    (track) => TrackMenuItem(
                                      label:
                                          TrackHelper.getTrackLabelWithContext(
                                            track,
                                            tracks,
                                          ),
                                      isSelected: currentTrack.id == track.id,
                                      onTap: () {
                                        if (activeMenu == TrackMenuType.audio) {
                                          playerCubit.setAudioTrack(
                                            track as AudioTrack,
                                          );
                                        } else {
                                          playerCubit.setSubtitleTrack(
                                            track as SubtitleTrack,
                                          );
                                        }
                                        controlsCubit.closeMenus();
                                      },
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mobile track drawer
void showMobileTrackDrawer(BuildContext context, TrackMenuType menuType) {
  final playerCubit = context.read<VideoPlayerCubit>();

  final title = menuType == TrackMenuType.audio ? 'Audio Tracks' : 'Subtitles';
  final tracks = menuType == TrackMenuType.audio
      ? playerCubit.player.state.tracks.audio
      : playerCubit.player.state.tracks.subtitle;
  final currentTrack = menuType == TrackMenuType.audio
      ? playerCubit.player.state.track.audio
      : playerCubit.player.state.track.subtitle;
  final isSubtitle = menuType == TrackMenuType.subtitle;
  final isAudio = menuType == TrackMenuType.audio;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:  0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          // Track list
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Auto option for audio tracks
                if (isAudio)
                  DrawerTrackItem(
                    label: 'Auto',
                    isSelected: currentTrack.id == 'auto',
                    onTap: () {
                      playerCubit.setAudioTrack(AudioTrack.auto());
                      Navigator.pop(context);
                    },
                  ),
                // Off option for subtitles
                if (isSubtitle)
                  DrawerTrackItem(
                    label: 'Off',
                    isSelected: currentTrack.id == 'no',
                    onTap: () {
                      playerCubit.setSubtitleTrack(SubtitleTrack.no());
                      Navigator.pop(context);
                    },
                  ),
                // All available tracks (filtered)
                ...tracks
                    .where(TrackHelper.isValidTrack)
                    .map(
                      (track) => DrawerTrackItem(
                        label: TrackHelper.getTrackLabelWithContext(
                          track,
                          tracks,
                        ),
                        isSelected: currentTrack.id == track.id,
                        onTap: () {
                          if (menuType == TrackMenuType.audio) {
                            playerCubit.setAudioTrack(track as AudioTrack);
                          } else {
                            playerCubit.setSubtitleTrack(
                              track as SubtitleTrack,
                            );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
