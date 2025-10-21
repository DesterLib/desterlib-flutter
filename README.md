# Dester Flutter App

A cross-platform media library application built with Flutter.

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.27.1 (Required)
- **Android Studio** (for Android builds)
- **Xcode** (for iOS/macOS builds, macOS only)
- **Visual Studio** (for Windows builds)

### ⚠️ Important: media_kit_video Compatibility Patch

This project uses **Flutter 3.27.1** and includes an automatic patch for `media_kit_video` compatibility.

**What's the issue?**

- Flutter 3.27+ introduced changes to the `TextureRegistry.SurfaceProducer.Callback` API
- The current version of `media_kit_video` (1.3.1) doesn't include the required `onSurfaceDestroyed()` method
- Our build automatically applies a patch to fix this (see `scripts/patch_media_kit.sh`)

**To install Flutter 3.27.1:**

```bash
# Using fvm (Flutter Version Management) - Recommended
fvm install 3.27.1
fvm use 3.27.1

# Or using flutter
flutter upgrade
# or
flutter downgrade 3.27.1
```

### Installation

#### Quick Setup (Recommended)

```bash
# One command to install dependencies and apply patches
bash scripts/setup.sh
```

#### Manual Setup

1. Clone the repository
2. Install dependencies and apply patches:

```bash
flutter pub get
bash scripts/patch_media_kit.sh  # Apply media_kit_video patch
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

1. **media_kit_video Flutter 3.27 Compatibility**

   - **Issue**: media_kit_video 1.3.1 lacks `onSurfaceDestroyed()` method for Flutter 3.27+
   - **Solution**: Automatic patch applied via `scripts/patch_media_kit.sh`
   - **Status**: Patch required until media_kit_video releases an update

   If you encounter build issues, run:

   ```bash
   flutter pub get
   bash scripts/patch_media_kit.sh
   flutter clean
   flutter build apk
   ```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

[Add your license here]
