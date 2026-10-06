import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/features/player/video_player/video_controls.dart';
import 'package:desterlib_client/features/player/video_player/video_player_state.dart';
import 'package:desterlib_client/features/player/widgets/toolbar.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final videoPlayerState = VideoPlayerState();

  Duration position = Duration.zero;
  final duration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    videoPlayerState.player.open(
      Media(
        'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4',
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.black,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9.0 / 16.0,
              child: Video(
                controller: videoPlayerState.controller,
                controls: NoVideoControls,
              ),
            ),
          ),
          Toolbar(),
          VideoControls(videoPlayerState: videoPlayerState),
        ],
      ),
    );
  }
}
