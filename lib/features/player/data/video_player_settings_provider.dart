import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Video player settings model
class VideoPlayerSettings {
  final String defaultAudioTrack;
  final String defaultSubtitleTrack;
  final double defaultPlaybackSpeed;
  final double subtitleSize;
  final double subtitleBackgroundOpacity; // 0.0 to 1.0

  const VideoPlayerSettings({
    this.defaultAudioTrack = 'original',
    this.defaultSubtitleTrack = 'off',
    this.defaultPlaybackSpeed = 1.0,
    this.subtitleSize = 16.0,
    this.subtitleBackgroundOpacity = 0.75,
  });

  VideoPlayerSettings copyWith({
    String? defaultAudioTrack,
    String? defaultSubtitleTrack,
    double? defaultPlaybackSpeed,
    double? subtitleSize,
    double? subtitleBackgroundOpacity,
  }) {
    return VideoPlayerSettings(
      defaultAudioTrack: defaultAudioTrack ?? this.defaultAudioTrack,
      defaultSubtitleTrack: defaultSubtitleTrack ?? this.defaultSubtitleTrack,
      defaultPlaybackSpeed: defaultPlaybackSpeed ?? this.defaultPlaybackSpeed,
      subtitleSize: subtitleSize ?? this.subtitleSize,
      subtitleBackgroundOpacity:
          subtitleBackgroundOpacity ?? this.subtitleBackgroundOpacity,
    );
  }
}

/// Notifier for video player settings
class VideoPlayerSettingsNotifier extends Notifier<VideoPlayerSettings> {
  static const String _keyAudioTrack = 'video_player_default_audio_track';
  static const String _keySubtitleTrack = 'video_player_default_subtitle_track';
  static const String _keyPlaybackSpeed = 'video_player_default_playback_speed';
  static const String _keySubtitleSize = 'video_player_subtitle_size';
  static const String _keySubtitleBgOpacity =
      'video_player_subtitle_bg_opacity';

  @override
  VideoPlayerSettings build() {
    _loadSettings();
    return const VideoPlayerSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final audioTrack = prefs.getString(_keyAudioTrack) ?? 'original';
      final subtitleTrack = prefs.getString(_keySubtitleTrack) ?? 'off';
      final playbackSpeed = prefs.getDouble(_keyPlaybackSpeed) ?? 1.0;
      final subtitleSize = prefs.getDouble(_keySubtitleSize) ?? 16.0;
      final subtitleBgOpacity = prefs.getDouble(_keySubtitleBgOpacity) ?? 0.75;

      state = VideoPlayerSettings(
        defaultAudioTrack: audioTrack,
        defaultSubtitleTrack: subtitleTrack,
        defaultPlaybackSpeed: playbackSpeed,
        subtitleSize: subtitleSize,
        subtitleBackgroundOpacity: subtitleBgOpacity,
      );
    } catch (e) {
      // If loading fails, keep default values
      debugPrint('⚠️ Failed to load video player settings: $e');
    }
  }

  /// Update default audio track
  Future<void> setDefaultAudioTrack(String track) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAudioTrack, track);
      state = state.copyWith(defaultAudioTrack: track);
    } catch (e) {
      debugPrint('⚠️ Failed to save default audio track: $e');
    }
  }

  /// Update default subtitle track
  Future<void> setDefaultSubtitleTrack(String track) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keySubtitleTrack, track);
      state = state.copyWith(defaultSubtitleTrack: track);
    } catch (e) {
      debugPrint('⚠️ Failed to save default subtitle track: $e');
    }
  }

  /// Update default playback speed
  Future<void> setDefaultPlaybackSpeed(double speed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keyPlaybackSpeed, speed);
      state = state.copyWith(defaultPlaybackSpeed: speed);
    } catch (e) {
      debugPrint('⚠️ Failed to save default playback speed: $e');
    }
  }

  /// Update subtitle size
  Future<void> setSubtitleSize(double size) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keySubtitleSize, size);
      state = state.copyWith(subtitleSize: size);
    } catch (e) {
      debugPrint('⚠️ Failed to save subtitle size: $e');
    }
  }

  /// Update subtitle background opacity
  Future<void> setSubtitleBackgroundOpacity(double opacity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keySubtitleBgOpacity, opacity);
      state = state.copyWith(subtitleBackgroundOpacity: opacity);
    } catch (e) {
      debugPrint('⚠️ Failed to save subtitle background opacity: $e');
    }
  }

  /// Save all settings at once
  Future<void> saveAllSettings({
    required String audioTrack,
    required String subtitleTrack,
    required double playbackSpeed,
    required double subtitleSize,
    required double subtitleBackgroundOpacity,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(_keyAudioTrack, audioTrack),
        prefs.setString(_keySubtitleTrack, subtitleTrack),
        prefs.setDouble(_keyPlaybackSpeed, playbackSpeed),
        prefs.setDouble(_keySubtitleSize, subtitleSize),
        prefs.setDouble(_keySubtitleBgOpacity, subtitleBackgroundOpacity),
      ]);

      state = VideoPlayerSettings(
        defaultAudioTrack: audioTrack,
        defaultSubtitleTrack: subtitleTrack,
        defaultPlaybackSpeed: playbackSpeed,
        subtitleSize: subtitleSize,
        subtitleBackgroundOpacity: subtitleBackgroundOpacity,
      );

      debugPrint('✅ Video player settings saved successfully');
    } catch (e) {
      debugPrint('⚠️ Failed to save video player settings: $e');
      rethrow;
    }
  }
}

/// Provider for video player settings
final videoPlayerSettingsProvider =
    NotifierProvider<VideoPlayerSettingsNotifier, VideoPlayerSettings>(() {
      return VideoPlayerSettingsNotifier();
    });
