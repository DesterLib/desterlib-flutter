import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../../../core/config/api_config.dart';

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

  VideoPlayerState? _state;
  VideoPlayerState? get state => _state;

  Timer? _hideControlsTimer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration>? _bufferSubscription;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<bool>? _bufferingSubscription;
  StreamSubscription<bool>? _completedSubscription;

  VideoPlayerController(this.mediaId, this.mediaTitle);

  void _updateState(VideoPlayerState? newState) {
    _state = newState;
    notifyListeners();
  }

  /// Initialize the player
  Future<void> initialize() async {
    try {
      // Create player and controller
      final player = Player();
      final controller = VideoController(player);

      _updateState(VideoPlayerState(player: player, controller: controller));

      // Set up stream listeners
      _setupListeners();

      // Build stream URL
      await ApiConfig.loadBaseUrl();
      final streamUrl = '${ApiConfig.baseUrl}/api/v1/stream/$mediaId';

      debugPrint('🎬 Opening stream: $streamUrl');

      // Load media - await to catch any errors
      await player.open(
        Media(streamUrl),
        play: false, // Don't auto-play, wait for user
      );

      debugPrint('✅ Stream opened successfully');

      // Start hide controls timer
      _startHideControlsTimer();
    } catch (e) {
      debugPrint('❌ Stream error: $e');
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
    }
  }

  /// Set up stream listeners
  void _setupListeners() {
    final player = state?.player;
    if (player == null) return;

    // Error listener
    player.stream.error.listen((error) {
      debugPrint('❌ Player error: $error');
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
      if (state != null) {
        _updateState(state!.copyWith(isCompleted: isCompleted));
      }
      if (isCompleted) {
        _showControls();
      }
    });
  }

  /// Play/Pause toggle
  void togglePlayPause() {
    final player = state?.player;
    if (player == null) return;

    player.playOrPause();
  }

  /// Seek to position
  void seek(Duration position) {
    final player = state?.player;
    if (player == null) return;

    player.seek(position);
  }

  /// Seek forward by seconds
  void seekForward([int seconds = 10]) {
    final currentPosition = state?.position ?? Duration.zero;
    final duration = state?.duration ?? Duration.zero;
    final newPosition = currentPosition + Duration(seconds: seconds);
    seek(newPosition > duration ? duration : newPosition);
  }

  /// Seek backward by seconds
  void seekBackward([int seconds = 10]) {
    final currentPosition = state?.position ?? Duration.zero;
    final newPosition = currentPosition - Duration(seconds: seconds);
    seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  /// Set volume (0.0 to 1.0)
  void setVolume(double volume) {
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
    final player = state?.player;
    if (player == null) return;

    player.setRate(speed);
    if (state != null) {
      _updateState(state!.copyWith(playbackSpeed: speed));
    }
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
    if (state != null) {
      _updateState(state!.copyWith(showControls: true));
    }
  }

  /// Hide controls
  void _hideControls() {
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
    final currentState = state;
    if (currentState != null && currentState.showControls) {
      _startHideControlsTimer();
    }
  }

  // Private wrapper for internal use
  void _cancelHideControlsTimer() => cancelHideControlsTimer();

  /// Replay video from beginning
  void replay() {
    seek(Duration.zero);
    state?.player.play();
    if (state != null) {
      _updateState(state!.copyWith(isCompleted: false));
    }
  }

  /// Clean up resources
  @override
  void dispose() {
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
      final controller = VideoPlayerController(mediaId, mediaTitle);

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
