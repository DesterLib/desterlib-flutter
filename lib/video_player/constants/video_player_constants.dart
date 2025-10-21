/// Constants for the video player
class VideoPlayerConstants {
  // Debug configuration
  static const bool enableDebugLogging = false;

  // UI constants
  static const double mobileBreakpoint = 768.0;
  static const double mobileSubtitleBottomPadding = 20.0;
  static const double desktopSubtitleBottomPadding = 150.0;

  // Animation durations
  static const Duration controlsAnimationDuration = Duration(milliseconds: 250);
  static const Duration controlsHideDelay = Duration(seconds: 3);

  // Volume
  static const double defaultVolume = 100.0;
  static const double mutedVolume = 0.0;

  // Error messages
  static const String errorMediaLoad = 'Failed to load media';
  static const String errorInvalidUrl = 'Invalid video URL';
  static const String errorNetworkConnection = 'Network connection error';

  // Validation
  static const int minUrlLength = 10;
  static const double maxVolume = 100.0;
  static const double minVolume = 0.0;
}
