# Dester Flutter App

A cross-platform media library application built with Flutter.

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.24.3 (Required - see compatibility note below)
- **Android Studio** (for Android builds)
- **Xcode** (for iOS/macOS builds, macOS only)
- **Visual Studio** (for Windows builds)

### ⚠️ Important: Flutter Version Compatibility

This project currently requires **Flutter 3.24.3** due to compatibility issues with the `media_kit_video` plugin.

**Why not the latest Flutter version?**
- Flutter 3.27+ introduced breaking changes to `TextureRegistry.SurfaceProducer.Callback` API
- The current version of `media_kit_video` (1.3.1) does not yet support these changes
- Using Flutter 3.27+ will result in compilation errors

**To install the correct Flutter version:**

```bash
# Using fvm (Flutter Version Management) - Recommended
fvm install 3.24.3
fvm use 3.24.3

# Or using flutter downgrade
flutter downgrade 3.24.3
```

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# Debug mode
flutter run

# Release mode (Android)
flutter build apk --release
```

## 🏗️ Building for Different Platforms

### Android
```bash
# APK (split per ABI)
flutter build apk --release --split-per-abi

# App Bundle (for Play Store)
flutter build appbundle --release

# Android TV
flutter build apk --release --target-platform android-arm64
```

### iOS/macOS
```bash
# iOS
flutter build ios --release

# macOS
flutter config --enable-macos-desktop
flutter build macos --release
```

### Linux
```bash
flutter config --enable-linux-desktop
flutter build linux --release
```

### Windows
```bash
flutter config --enable-windows-desktop
flutter build windows --release
```

## 🤖 CI/CD - GitHub Actions

This project includes comprehensive GitHub Actions workflows:

- **build-release.yml**: Builds for all platforms (Android, iOS, macOS, Linux, Windows)
- **pr-checks.yml**: Runs code analysis, tests, and build checks on pull requests
- **nightly-build.yml**: Automated nightly builds if there are changes

### Triggering a Release

To create a release with all platform builds:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will automatically build all platforms and create a GitHub release with downloadable artifacts.

## 📦 Dependencies

Key dependencies:
- `media_kit` - Video playback
- `media_kit_video` - Video rendering
- `flutter_bloc` - State management
- `flutter_inappwebview` - Web content
- `window_manager` - Desktop window management

For a full list, see [pubspec.yaml](pubspec.yaml).

## 📝 Development Notes

### Android SDK Requirements
- Compile SDK: 36 (required by media_kit plugins)
- Min SDK: Set by Flutter
- Target SDK: Set by Flutter
- NDK: 27.0.12077973

### Known Issues

1. **Flutter 3.27+ Compatibility**: Not compatible with current media_kit_video version
   - **Workaround**: Use Flutter 3.24.3
   - **Status**: Waiting for media_kit_video update

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

[Add your license here]
