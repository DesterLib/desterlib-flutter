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

  @override
  void initState() {
    super.initState();

    // Create player instance
    player = Player();

    // Create video controller
    controller = VideoController(player);

    // Load and play the video
    player.open(Media(widget.videoUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video player with custom controls
          Center(
            child: Video(
              controller: controller,
              controls: (state) => VideoControls(
                state: state,
                player: player,
                title: widget.title,
                season: widget.season,
                episode: widget.episode,
                episodeTitle: widget.episodeTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
