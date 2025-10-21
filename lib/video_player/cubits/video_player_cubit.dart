import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:window_manager/window_manager.dart';
import '../models/video_player_state.dart';
import '../constants/video_player_constants.dart';

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
    _logDebug('=== VIDEO PLAYER INITIALIZATION ===');
    _logDebug('VideoPlayerCubit created with:');
    _logDebug('  videoUrl: $videoUrl');
    _logDebug('  title: $title');
    _logDebug('  season: $season');
    _logDebug('  episode: $episode');
    _logDebug('  episodeTitle: $episodeTitle');

    // Validate URL before initialization
    if (!_isValidUrl(videoUrl)) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: VideoPlayerConstants.errorInvalidUrl,
        ),
      );
      return;
    }

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

    // Listen to window fullscreen changes (desktop only)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.addListener(this);
    }

    // Load and play the video first
    _logDebug('=== LOADING VIDEO ===');
    _logDebug('Opening media with URL: ${state.videoUrl}');
    _logDebug('URL validation:');
    _logDebug('  - URL length: ${state.videoUrl.length}');
    _logDebug('  - Starts with http: ${state.videoUrl.startsWith('http')}');
    _logDebug('  - Contains :// ${state.videoUrl.contains('://')}');

    try {
      player.open(Media(state.videoUrl));
      _logDebug('Media opened successfully');
    } catch (e) {
      _logDebug('Error opening media: $e');
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: VideoPlayerConstants.errorMediaLoad,
        ),
      );
      return;
    }

    // Listen to player state changes
    _subscriptions.add(
      player.stream.playing.listen((isPlaying) {
        _logDebug('=== PLAYING STATE UPDATE ===');
        _logDebug('Current URL: ${state.videoUrl}');
        _logDebug('Is playing: $isPlaying');
        emit(state.copyWith(isPlaying: isPlaying, hasError: false));
      }),
    );

    _subscriptions.add(
      player.stream.position.listen((position) {
        // Log URL periodically during playback
        if (position.inSeconds % 10 == 0 && position.inSeconds > 0) {
          _logDebug('=== POSITION UPDATE ===');
          _logDebug('Current URL: ${state.videoUrl}');
          _logDebug('Position: ${position.inSeconds}s');
        }
        emit(state.copyWith(position: position));
      }),
    );

    _subscriptions.add(
      player.stream.duration.listen((duration) {
        _logDebug('=== DURATION UPDATE ===');
        _logDebug('Current URL: ${state.videoUrl}');
        _logDebug('Duration: ${duration.inSeconds}s');
        emit(state.copyWith(duration: duration));
      }),
    );

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
    final clampedVolume = volume
        .clamp(VideoPlayerConstants.minVolume, VideoPlayerConstants.maxVolume)
        .toDouble();
    player.setVolume(clampedVolume);
    emit(state.copyWith(volume: clampedVolume));
  }

  void toggleMute() {
    final newMutedState = !state.isMuted;
    if (newMutedState) {
      player.setVolume(VideoPlayerConstants.mutedVolume);
    } else {
      player.setVolume(state.volume);
    }
    emit(state.copyWith(isMuted: newMutedState));
  }

  // Fullscreen controls
  Future<void> toggleFullscreen() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      if (state.isFullscreen) {
        await windowManager.setFullScreen(false);
      } else {
        await windowManager.setFullScreen(true);
      }
    }
    // For mobile platforms, fullscreen is handled by the system
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
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      windowManager.removeListener(this);
    }
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await player.dispose();
    return super.close();
  }

  // Helper methods
  void _logDebug(String message) {
    if (VideoPlayerConstants.enableDebugLogging) {
      debugPrint(message);
    }
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty || url.length < VideoPlayerConstants.minUrlLength) {
      return false;
    }

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Clear any existing errors
  void clearError() {
    emit(state.copyWith(hasError: false, errorMessage: null));
  }
}
