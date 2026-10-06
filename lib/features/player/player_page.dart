import 'package:desterlib_client/features/player/video_player/video_player.dart';
import 'package:flutter/widgets.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayer();
  }
}
