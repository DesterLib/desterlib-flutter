import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:desterlib_flutter/video_controls.dart';

class VideoPlayerPage extends StatefulWidget {
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
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final Player player;
  late final VideoController controller;
  final ValueNotifier<bool> _controlsVisibleNotifier = ValueNotifier<bool>(
    true,
  );

  @override
  void initState() {
    super.initState();

    // Create player instance
    player = Player();

    // Create video controller WITHOUT subtitle rendering
    controller = VideoController(
      player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    // Load and play the video
    player.open(Media(widget.videoUrl));
  }

  @override
  void dispose() {
    _controlsVisibleNotifier.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Video(
          controller: controller,
          subtitleViewConfiguration: SubtitleViewConfiguration(
            padding: const EdgeInsets.only(bottom: 150.0, left: 16, right: 16),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w500,
              height: 1.4,
              backgroundColor: Color.fromARGB(81, 0, 0, 0),
            ),
          ),
          controls: (state) => VideoControls(
            state: state,
            player: player,
            title: widget.title,
            season: widget.season,
            episode: widget.episode,
            episodeTitle: widget.episodeTitle,
            controlsVisibleNotifier: _controlsVisibleNotifier,
          ),
        ),
      ),
    );
  }
}
