// External packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// Feature
import 'layouts/layouts.dart';

/// Platform detection for video player
enum PlayerPlatform { mobile, desktop, tv }

/// Platform-aware video player controls wrapper
/// Automatically switches between mobile, desktop, and TV layouts based on platform
class PlatformPlayerControls extends StatelessWidget {
  // Player state
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final Duration bufferedPosition;
  final double volume;
  final bool isMuted;
  final bool isFullscreen;

  // Callbacks
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onSkipForward;
  final VoidCallback onSkipBackward;
  final ValueChanged<double>? onVolumeChanged;
  final VoidCallback? onMuteToggle;
  final VoidCallback onAudioSettings;
  final VoidCallback onSubtitleSettings;
  final VoidCallback onSettings;
  final VoidCallback? onFullscreenToggle;
  final VoidCallback? onBack;

  // Optional: Force a specific platform layout
  final PlayerPlatform? forcePlatform;

  const PlatformPlayerControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.bufferedPosition,
    required this.volume,
    required this.isMuted,
    required this.isFullscreen,
    required this.onPlayPause,
    required this.onSeek,
    required this.onSkipForward,
    required this.onSkipBackward,
    this.onVolumeChanged,
    this.onMuteToggle,
    required this.onAudioSettings,
    required this.onSubtitleSettings,
    required this.onSettings,
    this.onFullscreenToggle,
    this.onBack,
    this.forcePlatform,
  });

  PlayerPlatform _detectPlatform() {
    if (forcePlatform != null) {
      return forcePlatform!;
    }

    // Web detection
    if (kIsWeb) {
      return PlayerPlatform.desktop;
    }

    // Platform detection for native apps
    if (Platform.isAndroid || Platform.isIOS) {
      return PlayerPlatform.mobile;
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return PlayerPlatform.desktop;
    }

    // Fallback to desktop
    return PlayerPlatform.desktop;
  }

  @override
  Widget build(BuildContext context) {
    final platform = _detectPlatform();

    switch (platform) {
      case PlayerPlatform.mobile:
        return MobilePlayerControls(
          isPlaying: isPlaying,
          currentPosition: currentPosition,
          totalDuration: totalDuration,
          bufferedPosition: bufferedPosition,
          volume: volume,
          isMuted: isMuted,
          isFullscreen: isFullscreen,
          onPlayPause: onPlayPause,
          onSeek: onSeek,
          onSkipForward: onSkipForward,
          onSkipBackward: onSkipBackward,
          onAudioSettings: onAudioSettings,
          onSubtitleSettings: onSubtitleSettings,
          onSettings: onSettings,
          onFullscreenToggle: onFullscreenToggle ?? () {},
          onBack: onBack,
        );

      case PlayerPlatform.desktop:
        return DesktopPlayerControls(
          isPlaying: isPlaying,
          currentPosition: currentPosition,
          totalDuration: totalDuration,
          bufferedPosition: bufferedPosition,
          volume: volume,
          isMuted: isMuted,
          isFullscreen: isFullscreen,
          onPlayPause: onPlayPause,
          onSeek: onSeek,
          onSkipForward: onSkipForward,
          onSkipBackward: onSkipBackward,
          onVolumeChanged: onVolumeChanged ?? (_) {},
          onMuteToggle: onMuteToggle ?? () {},
          onAudioSettings: onAudioSettings,
          onSubtitleSettings: onSubtitleSettings,
          onSettings: onSettings,
          onFullscreenToggle: onFullscreenToggle ?? () {},
          onBack: onBack,
        );

      case PlayerPlatform.tv:
        return TvPlayerControls(
          isPlaying: isPlaying,
          currentPosition: currentPosition,
          totalDuration: totalDuration,
          bufferedPosition: bufferedPosition,
          onPlayPause: onPlayPause,
          onSeek: onSeek,
          onAudioSettings: onAudioSettings,
          onSubtitleSettings: onSubtitleSettings,
          onSettings: onSettings,
          onBack: onBack,
        );
    }
  }
}
