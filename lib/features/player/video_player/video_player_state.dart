import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerState {
  late final Player player;
  late final VideoController controller;
  double _lastVolume = 60;

  VideoPlayerState() {
    player = Player();
    controller = VideoController(player);
    player.setVolume(_lastVolume);
  }

  void play() => player.play();

  void pause() => player.pause();

  void togglePlay() {
    if (player.state.playing) {
      pause();
    } else {
      play();
    }
  }

  Duration get duration => player.state.duration;

  void seekForward() {
    player.seek(player.state.position + const Duration(seconds: 10));
  }

  void seekBackward() {
    player.seek(player.state.position - const Duration(seconds: 10));
  }

  void seekToProgress(double value) {
    final duration = player.state.duration;

    player.seek(
      Duration(milliseconds: (duration.inMilliseconds * value).round()),
    );
  }

  double progressFor(Duration position) {
    final duration = player.state.duration;

    if (duration.inMilliseconds == 0) {
      return 0;
    }

    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  double bufferProgress(Duration buffer) {
    final duration = player.state.duration;

    if (duration.inMilliseconds == 0) {
      return 0;
    }

    return (buffer.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  double volumeProgress(double volume) {
    return (volume / 100).clamp(0.0, 1.0);
  }

  void setVolume(double value) {
    final volume = (value * 100).clamp(0.0, 100.0);

    if (volume > 0) {
      _lastVolume = volume;
    }

    player.setVolume(volume);
  }

  void mute() {
    if (player.state.volume > 0) {
      _lastVolume = player.state.volume;
    }

    player.setVolume(0);
  }

  void unMute() {
    player.setVolume(_lastVolume);
  }

  void toggleMute() {
    if (player.state.volume == 0) {
      unMute();
    } else {
      mute();
    }
  }

  void dispose() {
    player.dispose();
  }

  // utility
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$mm:$ss';
    }

    return '$mm:$ss';
  }
}
