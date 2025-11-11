import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../../../core/config/api_config.dart';
import '../../data/video_player_settings_provider.dart';

/// Video player state
class VideoPlayerState {
  final Player player;
  final VideoController controller;
  final bool isPlaying;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final Duration buffer;
  final double volume;
  final double playbackSpeed;
  final bool isFullscreen;
  final bool showControls;
  final bool isCompleted;
  final String? error;

  const VideoPlayerState({
    required this.player,
    required this.controller,
    this.isPlaying = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.buffer = Duration.zero,
    this.volume = 1.0,
    this.playbackSpeed = 1.0,
    this.isFullscreen = false,
    this.showControls = true,
    this.isCompleted = false,
    this.error,
  });

  VideoPlayerState copyWith({
    Player? player,
    VideoController? controller,
    bool? isPlaying,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    Duration? buffer,
    double? volume,
    double? playbackSpeed,
    bool? isFullscreen,
    bool? showControls,
    bool? isCompleted,
    String? error,
  }) {
    return VideoPlayerState(
      player: player ?? this.player,
      controller: controller ?? this.controller,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      buffer: buffer ?? this.buffer,
      volume: volume ?? this.volume,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      showControls: showControls ?? this.showControls,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error,
    );
  }

  double get progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  double get bufferProgress {
    if (duration.inMilliseconds == 0) return 0.0;
    return buffer.inMilliseconds / duration.inMilliseconds;
  }
}

/// Video player controller class
class VideoPlayerController extends ChangeNotifier {
  final String mediaId;
  final String? mediaTitle;
  final VideoPlayerSettings playerSettings;

  VideoPlayerState? _state;
  VideoPlayerState? get state => _state;

  Timer? _hideControlsTimer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration>? _bufferSubscription;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<bool>? _bufferingSubscription;
  StreamSubscription<bool>? _completedSubscription;

  bool _disposed = false;
  bool _isInitializing = false;

  VideoPlayerController(this.mediaId, this.mediaTitle, this.playerSettings);

  void _updateState(VideoPlayerState? newState) {
    if (_disposed) return; // Don't update if already disposed
    _state = newState;
    notifyListeners();
  }

  /// Initialize the player
  Future<void> initialize() async {
    // Prevent multiple initializations or initialization after disposal
    if (_disposed || _isInitializing) {
      return;
    }

    _isInitializing = true;

    try {
      // Create player and controller
      final player = Player();
      final controller = VideoController(player);

      if (_disposed) return; // Check again after async operations
      _updateState(VideoPlayerState(player: player, controller: controller));

      // Set up stream listeners
      _setupListeners();

      // Build stream URL
      await ApiConfig.loadBaseUrl();

      if (_disposed) return; // Check after async operation
      final streamUrl = '${ApiConfig.baseUrl}/api/v1/stream/$mediaId';

      // Load media - await to catch any errors
      await player.open(
        Media(streamUrl),
        play: true, // Auto-play video
      );

      if (_disposed) return; // Check after async operation

      // Apply default playback speed from settings
      if (playerSettings.defaultPlaybackSpeed != 1.0) {
        if (_disposed) return;
        player.setRate(playerSettings.defaultPlaybackSpeed);
        if (state != null && !_disposed) {
          _updateState(
            state!.copyWith(playbackSpeed: playerSettings.defaultPlaybackSpeed),
          );
        }
      }

      // Start hide controls timer
      if (!_disposed) {
        _startHideControlsTimer();
      }
    } catch (e) {
      if (_disposed) return;

      if (state != null) {
        _updateState(state!.copyWith(error: 'Failed to load stream: $e'));
      } else {
        // Create an error state if we don't have a state yet
        final player = Player();
        final controller = VideoController(player);
        _updateState(
          VideoPlayerState(
            player: player,
            controller: controller,
            error: 'Failed to initialize player: $e',
          ),
        );
      }
    } finally {
      _isInitializing = false;
    }
  }

  /// Set up stream listeners
  void _setupListeners() {
    final player = state?.player;
    if (player == null) return;

    // Error listener
    player.stream.error.listen((error) {
      if (state != null) {
        _updateState(state!.copyWith(error: 'Playback error: $error'));
      }
    });

    // Position updates
    _positionSubscription = player.stream.position.listen((position) {
      if (state != null) {
        _updateState(state!.copyWith(position: position));
      }
    });

    // Duration updates
    _durationSubscription = player.stream.duration.listen((Duration? duration) {
      final currentState = state;
      if (currentState != null && duration != null) {
        _updateState(currentState.copyWith(duration: duration));
      }
    });

    // Buffer updates
    _bufferSubscription = player.stream.buffer.listen((buffer) {
      if (state != null) {
        _updateState(state!.copyWith(buffer: buffer));
      }
    });

    // Playing state
    _playingSubscription = player.stream.playing.listen((isPlaying) {
      if (state != null) {
        _updateState(state!.copyWith(isPlaying: isPlaying));
      }
      if (isPlaying) {
        _startHideControlsTimer();
      } else {
        _cancelHideControlsTimer();
      }
    });

    // Buffering state
    _bufferingSubscription = player.stream.buffering.listen((isBuffering) {
      if (state != null) {
        _updateState(state!.copyWith(isBuffering: isBuffering));
      }
    });

    // Completed state
    _completedSubscription = player.stream.completed.listen((isCompleted) {
      if (state == null) return;

      // Only mark as completed if we're actually near the end of the video
      // This prevents false "completed" states from stream errors or buffering issues
      if (isCompleted) {
        final duration = state!.duration;
        final position = state!.position;

        // Consider completed if within last 5 seconds or actually at the end
        final isActuallyComplete =
            duration.inSeconds > 0 &&
            (position.inSeconds >= duration.inSeconds - 5 ||
                position.inSeconds == duration.inSeconds);

        if (isActuallyComplete) {
          _updateState(state!.copyWith(isCompleted: true));
          _showControls();
        }
      } else {
        _updateState(state!.copyWith(isCompleted: false));
      }
    });
  }

  /// Play/Pause toggle
  void togglePlayPause() {
    if (_disposed) return;
    final player = state?.player;
    if (player == null) return;

    player.playOrPause();
  }

  /// Seek to position
  void seek(Duration position) {
    if (_disposed) return;
    final player = state?.player;
    if (player == null) return;

    player.seek(position);
  }

  /// Seek forward by seconds
  void seekForward([int seconds = 10]) {
    if (_disposed) return;
    final currentPosition = state?.position ?? Duration.zero;
    final duration = state?.duration ?? Duration.zero;
    final newPosition = currentPosition + Duration(seconds: seconds);
    seek(newPosition > duration ? duration : newPosition);
  }

  /// Seek backward by seconds
  void seekBackward([int seconds = 10]) {
    if (_disposed) return;
    final currentPosition = state?.position ?? Duration.zero;
    final newPosition = currentPosition - Duration(seconds: seconds);
    seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  /// Set volume (0.0 to 1.0)
  void setVolume(double volume) {
    if (_disposed) return;
    final player = state?.player;
    if (player == null) return;

    final clampedVolume = volume.clamp(0.0, 1.0);
    player.setVolume(clampedVolume * 100); // media_kit uses 0-100
    if (state != null) {
      _updateState(state!.copyWith(volume: clampedVolume));
    }
  }

  /// Set playback speed
  void setPlaybackSpeed(double speed) {
    if (_disposed) return;
    final player = state?.player;
    if (player == null) return;

    player.setRate(speed);
    if (state != null) {
      _updateState(state!.copyWith(playbackSpeed: speed));
    }
  }

  /// Get available audio tracks
  List<AudioTrack> getAudioTracks() {
    final player = state?.player;
    if (player == null) return [];
    return player.state.tracks.audio;
  }

  /// Get available subtitle tracks
  List<SubtitleTrack> getSubtitleTracks() {
    final player = state?.player;
    if (player == null) return [];
    return player.state.tracks.subtitle;
  }

  /// Get selected audio track
  AudioTrack getSelectedAudioTrack() {
    final player = state?.player;
    if (player == null) return const AudioTrack('auto', '', '');
    return player.state.track.audio;
  }

  /// Get selected subtitle track
  SubtitleTrack getSelectedSubtitleTrack() {
    final player = state?.player;
    if (player == null) return const SubtitleTrack('auto', '', '');
    return player.state.track.subtitle;
  }

  /// Set audio track
  Future<void> setAudioTrack(AudioTrack track) async {
    if (_disposed) return;
    final player = state?.player;
    if (player == null) return;

    await player.setAudioTrack(track);
  }

  /// Set subtitle track
  Future<void> setSubtitleTrack(SubtitleTrack track) async {
    if (_disposed) return;
    final player = state?.player;
    if (player == null) return;

    await player.setSubtitleTrack(track);
  }

  /// Toggle fullscreen
  void toggleFullscreen() {
    if (state == null) return;

    final newFullscreen = !state!.isFullscreen;
    _updateState(state!.copyWith(isFullscreen: newFullscreen));

    // Update system UI overlay based on fullscreen state
    if (newFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  /// Show controls
  void _showControls() {
    if (_disposed) return;
    if (state != null) {
      _updateState(state!.copyWith(showControls: true));
    }
  }

  /// Hide controls
  void _hideControls() {
    if (_disposed) return;
    final currentState = state;
    if (currentState == null) return;

    // Don't hide if not playing or if completed
    if (!currentState.isPlaying || currentState.isCompleted) {
      return;
    }

    _updateState(currentState.copyWith(showControls: false));
  }

  /// Toggle controls visibility
  void toggleControls() {
    if (_disposed) return;
    final currentState = state;
    if (currentState == null) return;

    final showControls = !currentState.showControls;
    _updateState(currentState.copyWith(showControls: showControls));

    if (showControls && currentState.isPlaying) {
      _startHideControlsTimer();
    } else {
      _cancelHideControlsTimer();
    }
  }

  /// Start timer to hide controls
  void _startHideControlsTimer() {
    if (_disposed) return;
    _cancelHideControlsTimer();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      _hideControls();
    });
  }

  /// Cancel hide controls timer
  void cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }

  /// Reset hide controls timer
  void resetHideControlsTimer() {
    if (_disposed) return;
    final currentState = state;
    if (currentState != null && currentState.showControls) {
      _startHideControlsTimer();
    }
  }

  // Private wrapper for internal use
  void _cancelHideControlsTimer() => cancelHideControlsTimer();

  /// Replay video from beginning
  void replay() {
    if (_disposed) return;
    seek(Duration.zero);
    state?.player.play();
    if (state != null) {
      _updateState(state!.copyWith(isCompleted: false));
    }
  }

  /// Clean up resources
  @override
  void dispose() {
    // Set disposed flag first to stop any ongoing operations
    _disposed = true;

    _cancelHideControlsTimer();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _bufferSubscription?.cancel();
    _playingSubscription?.cancel();
    _bufferingSubscription?.cancel();
    _completedSubscription?.cancel();

    // Reset system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Dispose player
    state?.player.dispose();

    super.dispose();
  }
}

/// Provider for video player controller
final videoPlayerControllerProvider = Provider.autoDispose
    .family<VideoPlayerController, (String, String?)>((ref, params) {
      final (mediaId, mediaTitle) = params;
      // Use read instead of watch to prevent recreation when settings change
      final playerSettings = ref.read(videoPlayerSettingsProvider);
      final controller = VideoPlayerController(
        mediaId,
        mediaTitle,
        playerSettings,
      );

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

/// Provider for video player state (convenience)
final videoPlayerProvider = Provider.autoDispose
    .family<VideoPlayerState?, (String, String?)>((ref, params) {
      final controller = ref.watch(videoPlayerControllerProvider(params));

      // Add a listener that forces the provider to rebuild when state changes
      void listener() {
        ref.invalidateSelf();
      }

      controller.addListener(listener);
      ref.onDispose(() {
        controller.removeListener(listener);
      });

      return controller.state;
    });
