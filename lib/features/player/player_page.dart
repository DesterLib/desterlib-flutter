import 'package:desterlib_client/core/theme/theme.dart';
import 'package:desterlib_client/features/player/widgets/toolbar.dart';
import 'package:desterlib_client/features/player/widgets/video_controls.dart';
import 'package:flutter/widgets.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Duration position = Duration.zero;
  final duration = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.black,
      child: Stack(
        children: [
          Toolbar(),
          VideoControls(
            isPlaying: false,
            position: position,
            duration: duration,
            onPlayPause: () => print("toggle"),
            onSeek: (value) {
              setState(() {
                position = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
