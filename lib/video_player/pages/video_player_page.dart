import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../cubits/video_player_cubit.dart';
import '../cubits/controls_cubit.dart';
import '../models/video_player_state.dart';
import '../widgets/video_controls.dart';
import '../constants/video_player_constants.dart';

/// Video player page with BLoC state management
class VideoPlayerPage extends StatelessWidget {
  final String videoUrl;
  final String? title;
  final int? season;
  final int? episode;
  final String? episodeTitle;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    this.title,
    this.season,
    this.episode,
    this.episodeTitle,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('=== VIDEO PLAYER PAGE ===');
    debugPrint('VideoPlayerPage created with URL: $videoUrl');
    debugPrint('Title: $title');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VideoPlayerCubit(
            videoUrl: videoUrl,
            title: title,
            season: season,
            episode: episode,
            episodeTitle: episodeTitle,
          ),
        ),
        BlocProvider(create: (context) => ControlsCubit()),
      ],
      child: const _VideoPlayerView(),
    );
  }
}

class _VideoPlayerView extends StatelessWidget {
  const _VideoPlayerView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
      builder: (context, state) {
        final playerCubit = context.read<VideoPlayerCubit>();

        // Show error state if there's an error
        if (state.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => playerCubit.clearError(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Responsive subtitle positioning - lower on mobile, higher on desktop
        final screenHeight = MediaQuery.of(context).size.height;
        final isMobile = screenHeight < VideoPlayerConstants.mobileBreakpoint;
        final subtitleBottomPadding = isMobile
            ? VideoPlayerConstants.mobileSubtitleBottomPadding
            : VideoPlayerConstants.desktopSubtitleBottomPadding;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Video(
              controller: playerCubit.controller,
              subtitleViewConfiguration: SubtitleViewConfiguration(
                visible: true,
                padding: EdgeInsets.only(
                  bottom: subtitleBottomPadding,
                  left: 16,
                  right: 16,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  backgroundColor: Color.fromARGB(81, 0, 0, 0),
                ),
              ),
              controls: (state) => const VideoControls(),
            ),
          ),
        );
      },
    );
  }
}
