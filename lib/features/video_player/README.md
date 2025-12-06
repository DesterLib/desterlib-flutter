# Video Player Feature

A comprehensive, platform-specific video player UI feature for Flutter applications with support for mobile, desktop, and TV platforms.

## Overview

This feature provides three distinct video player layouts optimized for different platforms:

- **Mobile**: Touch-optimized controls for phones and tablets
- **Desktop**: Mouse and keyboard-optimized with horizontal controls and volume slider
- **TV**: Remote control/D-pad optimized with large touch targets and focused navigation

## Features

✅ **Platform Detection**: Automatically detects and applies appropriate layout  
✅ **Play/Pause Toggle**: Central play/pause button with visual feedback  
✅ **Seek Bar**: Interactive progress bar with buffer indicator  
✅ **Skip Controls**: 15-second forward and backward buttons  
✅ **Volume Control**: Horizontal slider (desktop) or vertical slider (TV)  
✅ **Audio & Subtitle**: Quick access to audio track and subtitle settings  
✅ **Settings**: Player settings button  
✅ **Fullscreen**: Toggle fullscreen mode (mobile/desktop)  
✅ **Clean Architecture**: Following the project's clean architecture pattern

## Usage

### Quick Start with Platform Detection

```dart
import 'package:dester/features/video_player/video_player_feature.dart';

PlatformPlayerControls(
  isPlaying: true,
  currentPosition: Duration(seconds: 30),
  totalDuration: Duration(minutes: 2),
  bufferedPosition: Duration(seconds: 45),
  volume: 0.8,
  isMuted: false,
  isFullscreen: false,
  onPlayPause: () {
    // Handle play/pause
  },
  onSeek: (position) {
    // Handle seek to position
  },
  onSkipForward: () {
    // Skip forward 15 seconds
  },
  onSkipBackward: () {
    // Skip backward 15 seconds
  },
  onVolumeChanged: (volume) {
    // Handle volume change (desktop)
  },
  onMuteToggle: () {
    // Handle mute toggle
  },
  onAudioSettings: () {
    // Show audio track selector
  },
  onSubtitleSettings: () {
    // Show subtitle selector
  },
  onSettings: () {
    // Show player settings
  },
  onFullscreenToggle: () {
    // Toggle fullscreen
  },
  onBack: () {
    // Handle back button
  },
)
```

### Using Specific Platform Layouts

#### Mobile Layout

```dart
MobilePlayerControls(
  isPlaying: isPlaying,
  currentPosition: currentPosition,
  totalDuration: totalDuration,
  bufferedPosition: bufferedPosition,
  volume: volume,
  isMuted: isMuted,
  isFullscreen: isFullscreen,
  onPlayPause: () {},
  onSeek: (position) {},
  onSkipForward: () {},
  onSkipBackward: () {},
  onAudioSettings: () {},
  onSubtitleSettings: () {},
  onSettings: () {},
  onFullscreenToggle: () {},
  onBack: () {},
)
```

#### Desktop Layout

```dart
DesktopPlayerControls(
  isPlaying: isPlaying,
  currentPosition: currentPosition,
  totalDuration: totalDuration,
  bufferedPosition: bufferedPosition,
  volume: volume,
  isMuted: isMuted,
  isFullscreen: isFullscreen,
  onPlayPause: () {},
  onSeek: (position) {},
  onSkipForward: () {},
  onSkipBackward: () {},
  onVolumeChanged: (volume) {},
  onMuteToggle: () {},
  onAudioSettings: () {},
  onSubtitleSettings: () {},
  onSettings: () {},
  onFullscreenToggle: () {},
  onBack: () {},
)
```

#### TV Layout

```dart
TvPlayerControls(
  isPlaying: isPlaying,
  currentPosition: currentPosition,
  totalDuration: totalDuration,
  bufferedPosition: bufferedPosition,
  volume: volume,
  isMuted: isMuted,
  onPlayPause: () {},
  onSeek: (position) {},
  onSkipForward: () {},
  onSkipBackward: () {},
  onAudioSettings: () {},
  onSubtitleSettings: () {},
  onSettings: () {},
  onBack: () {},
)
```

### Force Specific Platform Layout

```dart
PlatformPlayerControls(
  // ... all required parameters
  forcePlatform: PlayerPlatform.desktop, // Force desktop layout
)
```

## Individual Control Widgets

You can also use individual control widgets to build custom layouts:

```dart
// Play/Pause Button
PlayPauseButton(
  isPlaying: true,
  onPressed: () {},
  size: 64,
)

// Seek Bar
SeekBar(
  currentPosition: Duration(seconds: 30),
  totalDuration: Duration(minutes: 2),
  bufferedPosition: Duration(seconds: 45),
  onSeek: (position) {},
  showTimeLabels: true,
)

// Skip Button
SkipButton(
  isForward: true,
  seconds: 15,
  onPressed: () {},
  size: 48,
)

// Volume Slider
VolumeSlider(
  volume: 0.8,
  isMuted: false,
  onVolumeChanged: (volume) {},
  onMuteToggle: () {},
  direction: Axis.horizontal, // or Axis.vertical
  width: 150,
)

// Player Icon Button
PlayerIconButton(
  icon: DIconName.settings,
  onPressed: () {},
  tooltip: 'Settings',
  size: 48,
)
```

## Architecture

The feature follows clean architecture principles:

```
video_player/
├── presentation/
│   └── widgets/
│       ├── controls/           # Individual control widgets
│       │   ├── play_pause_button.dart
│       │   ├── seek_bar.dart
│       │   ├── skip_button.dart
│       │   ├── volume_slider.dart
│       │   ├── player_icon_button.dart
│       │   └── controls.dart   # Barrel file
│       ├── layouts/            # Platform-specific layouts
│       │   ├── mobile_player_controls.dart
│       │   ├── desktop_player_controls.dart
│       │   ├── tv_player_controls.dart
│       │   └── layouts.dart    # Barrel file
│       ├── platform_player_controls.dart
│       └── example_player_screen.dart
├── video_player_feature.dart   # Main barrel file
└── README.md                   # This file
```

## Platform Differences

### Mobile

- **Layout**: Vertical stacking with bottom controls
- **Touch Areas**: Medium-sized, touch-optimized
- **Volume**: Not visible (uses system volume)
- **Fullscreen**: Toggle button available
- **Navigation**: Back button in top-left

### Desktop

- **Layout**: Horizontal controls at bottom
- **Touch Areas**: Smaller, precise for mouse
- **Volume**: Horizontal slider always visible
- **Fullscreen**: Toggle button with keyboard hint (f)
- **Navigation**: Back button in top-left

### TV

- **Layout**: Centered large controls
- **Touch Areas**: Extra large for remote/D-pad
- **Volume**: Not shown (uses system volume)
- **Fullscreen**: Always fullscreen
- **Navigation**: Focusable elements with autofocus

## Design System Integration

All components use the app's design system from `AppConstants`:

- Spacing: `spacing8`, `spacing16`, `spacing24`, etc.
- Sizes: `size2xl`, `size3xl`, `size4xl`, etc.
- Colors: `accentColor`, `successColor`, etc.
- Radius: `radiusLg`, `radiusXl`, etc.
- Icons: Custom `DIcon` widget with `DIconName` enum

## Example

See `example_player_screen.dart` for a complete implementation with state management.

## Customization

### Custom Colors

```dart
PlayPauseButton(
  isPlaying: true,
  onPressed: () {},
  color: Colors.blue, // Icon color
  backgroundColor: Colors.white, // Background color
)
```

### Custom Sizes

```dart
SkipButton(
  isForward: true,
  seconds: 15,
  onPressed: () {},
  size: 80, // Custom size
  color: Colors.amber,
)
```

### Custom Volume Slider Direction

```dart
VolumeSlider(
  volume: 0.8,
  isMuted: false,
  onVolumeChanged: (volume) {},
  onMuteToggle: () {},
  direction: Axis.vertical, // Vertical for TV-style
  height: 200,
)
```

## Notes

- This feature provides **UI only** - integrate with your video player package of choice
- All callbacks are required except `onBack`, `onVolumeChanged`, `onMuteToggle`, and `onFullscreenToggle`
- Platform detection is automatic but can be overridden with `forcePlatform`
- All durations use Dart's `Duration` class for consistency
- Volume is represented as a double between 0.0 and 1.0

## Future Enhancements

- [ ] Picture-in-picture mode
- [ ] Quality selector
- [ ] Playback speed controls
- [ ] Gesture controls (swipe to seek, volume)
- [ ] Mini player mode
- [ ] Chromecast support
- [ ] Live streaming indicators
- [ ] Chapter markers

## License

Part of the Dester project.
