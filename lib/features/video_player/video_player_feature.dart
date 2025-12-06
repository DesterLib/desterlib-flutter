/// Video Player Feature
///
/// This feature provides platform-specific video player UI controls for
/// mobile, desktop, and TV platforms.
///
/// ## Usage
///
/// ```dart
/// import 'package:dester/features/video_player/video_player_feature.dart';
///
/// // Use the platform-aware wrapper (automatically detects platform)
/// PlatformPlayerControls(
///   isPlaying: true,
///   currentPosition: Duration(seconds: 30),
///   totalDuration: Duration(minutes: 2),
///   bufferedPosition: Duration(seconds: 45),
///   volume: 0.8,
///   isMuted: false,
///   isFullscreen: false,
///   onPlayPause: () {},
///   onSeek: (position) {},
///   onSkipForward: () {},
///   onSkipBackward: () {},
///   onAudioSettings: () {},
///   onSubtitleSettings: () {},
///   onSettings: () {},
/// )
///
/// // Or use specific platform layouts
/// MobilePlayerControls(...);
/// DesktopPlayerControls(...);
/// TvPlayerControls(...);
/// ```
///
/// ## Features
///
/// - **Platform Detection**: Automatically detects and applies appropriate layout
/// - **Mobile Layout**: Touch-optimized controls for phones and tablets
/// - **Desktop Layout**: Mouse and keyboard-optimized with horizontal controls
/// - **TV Layout**: Remote control/D-pad optimized with large touch targets
/// - **Reusable Controls**: Individual control widgets for custom layouts
///
/// ## Controls Included
///
/// 1. Play/Pause toggle button
/// 2. Seek bar with buffer indicator
/// 3. Forward/Backward 15s skip buttons
/// 4. Volume slider (desktop/horizontal and TV/vertical)
/// 5. Audio track selector
/// 6. Subtitle selector
/// 7. Settings button
/// 8. Fullscreen toggle (mobile/desktop)
///
library;

// Platform-aware wrapper
export 'presentation/widgets/platform_player_controls.dart';

// Platform-specific layouts
export 'presentation/widgets/layouts/layouts.dart';

// Individual control widgets
export 'presentation/widgets/controls/controls.dart';
