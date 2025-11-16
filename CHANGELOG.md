# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Fixed

### Deprecated

### Removed

### Security

## [0.2.0] - 2025-01-XX

### Added

- **Version Management & Compatibility**

  - Version compatibility checking with API server
  - Automatic version validation on API requests
  - Version mismatch error handling (HTTP 426)
  - Version info provider for tracking client and API versions
  - Dio interceptor for reading API version from response headers (`X-API-Version`)
  - Client version header (`X-Client-Version`) sent with all requests
  - User-friendly version mismatch error messages
  - Version checker utility with semantic versioning support

- **API 0.2.0 Compatibility**
  - Support for enhanced media scanning features
  - Support for color extraction and mesh gradient endpoints
  - Support for real-time logging and monitoring features
  - Updated OpenAPI client for API 0.2.0 endpoints

### Changed

- Updated client version to 0.2.0 to match API version
- Enhanced error handling for version-related API responses
- Improved timeout handling for long-running operations (scanning, etc.)

### Fixed

### Removed

### Security

## [0.1.1] - 2025-11-08

### Added

- **Video Player Complete Revamp**

  - Custom iOS-style controls for mobile with fade animations
  - Custom macOS-style compact control bar for desktop
  - Fullscreen landscape-only playback with auto-play
  - Custom progress bar with live scrubbing and haptic feedback
  - Speed control overlay with clean left-aligned layout
  - Audio and subtitle track selection with Netflix-style UI
  - Language mapping utility supporting 30+ languages (ISO 639-1/2)
  - Track helper utility with intelligent filtering and deduplication
  - Platform-aware icons (Cupertino for iOS/macOS, Material for others)
  - Subtitle customization settings (size: 12-48px, background opacity: 0-100%)
  - Persistent video player settings stored locally
  - TV show metadata display in player (S1 E1 | Episode Name)
  - Formatted timestamps below progress bar (current / duration)
  - Auto-play first available episode for TV shows

- **UI/UX Enhancements**

  - Consistent desktop padding strategy (left: 24px, right: 44px)
  - Light haptic feedback across all interactive elements
  - Custom `DLoadingIndicator` component used throughout app
  - Fade-in animations for hero images with `CachedNetworkImage`
  - Opacity-based tap feedback replacing Material ripple effects
  - Improved grid layouts ensuring full-width distribution
  - Consistent 24px spacing for desktop scroll lists and grids
  - Simplified responsive breakpoints (mobile/desktop only)
  - Custom mesh gradient backgrounds for genre cards
  - Enhanced card hover and press animations

- **New Utilities**
  - `LanguageMapper` - Maps language codes to readable names
  - `TrackHelper` - Filters and labels audio/subtitle tracks intelligently
  - `BaseOverlay` - Reusable fullscreen overlay widget with blur and fade

### Changed

- **Video Player**

  - Moved timestamps from sides to below progress bar with space-between layout
  - Changed video fit from `cover` to `contain` to prevent cropping
  - Updated player controls file naming with `player_` prefix
  - Improved overlay exit animations with stateful `BaseOverlay`
  - Enhanced progress bar touch area to 48px height

- **Layouts**

  - Home screen now uses responsive padding for scroll lists
  - Library screen uses Column of Rows for grid layouts (fixes full-width issues)
  - Media detail screen has asymmetric padding on desktop
  - Settings layout automatically applies desktop padding rules
  - Sidebar has 24px right padding for better content separation

- **Performance**
  - Optimized image loading with proper cache dimensions
  - Fixed video player disposal race conditions
  - Improved state management with disposal guards
  - Prevented unnecessary controller recreations

### Fixed

- Video player controls not responding to taps in center area
- Controls not showing/hiding on tap gestures
- Progress bar thumb getting clipped
- Progress/buffer tracks overflowing container
- Controls hiding during progress bar scrubbing
- Progress track glitching during seeking
- Duplicate haptic feedback on button taps
- Subtitle size not applying to media_kit player
- Double "Auto" audio tracks in track selector
- Last grid item spanning all columns in incomplete rows
- Video player disposal errors and initialization loops
- Library grid items not occupying full width on desktop

### Removed

- All debug/console logs for production-ready builds
- Fullscreen toggle control (player always fullscreen)
- Platform-native settings menu (replaced with custom overlays)
- Unused imports across the codebase
- Material ripple effects on season/episode list items
- Control button tooltips
- Redundant wrapper widgets

### Security

- No security-related changes in this release

## [0.1.0] - Initial Release

### Added

- Basic Flutter app structure
- OpenAPI client integration
- Video streaming functionality
- Library browsing features
- Settings and configuration

[Unreleased]: https://github.com/DesterLib/desterlib-flutter/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/DesterLib/desterlib-flutter/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/DesterLib/desterlib-flutter/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/DesterLib/desterlib-flutter/releases/tag/v0.1.0
