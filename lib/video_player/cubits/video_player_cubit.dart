import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:window_manager/window_manager.dart';
import '../models/video_player_state.dart';

/// Cubit for managing video player state and operations
class VideoPlayerCubit extends Cubit<VideoPlayerState> with WindowListener {
  late final Player player;
  late final VideoController controller;
  final List<StreamSubscription> _subscriptions = [];

  VideoPlayerCubit({
    required String videoUrl,
    String? title,
    int? season,
    int? episode,
    String? episodeTitle,
  }) : super(
         VideoPlayerState(
           videoUrl: videoUrl,
           title: title,
           season: season,
           episode: episode,
           episodeTitle: episodeTitle,
         ),
       ) {
    _initialize();
  }

  void _initialize() {
    // Create player instance
    player = Player();

    // Create video controller
    controller = VideoController(
      player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    // Listen to window fullscreen changes
    windowManager.addListener(this);

    // Listen to player state changes
    _subscriptions.add(
      player.stream.playing.listen((isPlaying) {
        emit(state.copyWith(isPlaying: isPlaying));
      }),
    );

    _subscriptions.add(
      player.stream.position.listen((position) {
        emit(state.copyWith(position: position));
      }),
    );

    _subscriptions.add(
      player.stream.duration.listen((duration) {
        emit(state.copyWith(duration: duration));
      }),
    );

    // Load and play the video
    player.open(Media(state.videoUrl));

    emit(state.copyWith(isInitialized: true));
  }

  @override
  void onWindowEnterFullScreen() {
    emit(state.copyWith(isFullscreen: true));
  }

  @override
  void onWindowLeaveFullScreen() {
    emit(state.copyWith(isFullscreen: false));
  }

  // Playback controls
  void playOrPause() {
    player.playOrPause();
  }

  void seek(Duration position) {
    player.seek(position);
  }

  void seekRelative(Duration delta) {
    player.seek(state.position + delta);
  }

  // Volume controls
  void setVolume(double volume) {
    player.setVolume(volume);
    emit(state.copyWith(volume: volume));
  }

  void toggleMute() {
    final newMutedState = !state.isMuted;
    if (newMutedState) {
      player.setVolume(0);
    } else {
      player.setVolume(state.volume);
    }
    emit(state.copyWith(isMuted: newMutedState));
  }

  // Fullscreen controls
  Future<void> toggleFullscreen() async {
    if (state.isFullscreen) {
      await windowManager.setFullScreen(false);
    } else {
      await windowManager.setFullScreen(true);
    }
  }

  // Track controls
  void setAudioTrack(AudioTrack track) {
    player.setAudioTrack(track);
  }

  void setSubtitleTrack(SubtitleTrack track) {
    player.setSubtitleTrack(track);
  }

  @override
  Future<void> close() async {
    windowManager.removeListener(this);
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await player.dispose();
    return super.close();
  }
}
