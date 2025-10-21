# CI/CD & Release Guide

This document explains how to use the GitHub Actions CI/CD pipeline to build optimized releases for all platforms.

## 📁 Workflows

- **`build-release.yml`** - Builds Android, macOS, Linux, Windows on push/PR/tags
- **`pr-checks.yml`** - Code validation for pull requests
- **`nightly-build.yml`** - Daily automated builds (2 AM UTC)

## 🚀 Quick Start

### Creating a Release

The CI/CD pipeline automatically builds releases for:

- **Android** (APK and AAB for phones/tablets)
- **Android TV** (APK optimized for TV with remote control support)
- **macOS** (DMG/ZIP)
- **tvOS** (Apple TV support - experimental)
- **Linux** (tar.gz)
- **Windows** (ZIP)

## 📋 Workflow Triggers

The build workflow is triggered by:

1. **Push to branches**: `main`, `master`, `dev`, `dev-new`
2. **Pull requests** to these branches
3. **Tags** starting with `v` (e.g., `v1.0.0`, `v2.1.0-beta`)
4. **Manual trigger** via GitHub Actions UI

## 🏷️ Creating a Release

To create a new release:

```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0
```

The workflow will automatically:

1. Build all platform binaries
2. Create a GitHub Release
3. Upload all build artifacts to the release

## 📦 Build Artifacts

### Android

- **APKs** (split by ABI):
  - `Dester-Android-arm64-v8a.apk` (64-bit ARM - phones/tablets)
  - `Dester-Android-armeabi-v7a.apk` (32-bit ARM - phones/tablets)
  - `Dester-Android-x86_64.apk` (64-bit x86 - emulators)
- **App Bundle**: `Dester-Android.aab` (for Google Play Store)

### Android TV

- **APK**: `Dester-AndroidTV-arm64.apk` (optimized for Android TV with remote control support)

### macOS

- **DMG**: `Dester-macOS.dmg` (installer)
- **ZIP**: `Dester-macOS.zip` (fallback if DMG fails)

### tvOS (Apple TV)

- **Info**: tvOS support is experimental in Flutter and will be available in future builds

### Linux

- **Archive**: `Dester-Linux-x64.tar.gz`

### Windows

- **Archive**: `Dester-Windows-x64.zip`

## 🔐 Code Signing (Optional)

### Android Signing

To enable Android app signing, add these secrets to your GitHub repository:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add the following secrets:
   - `ANDROID_KEYSTORE_BASE64`: Base64-encoded keystore file
   - `ANDROID_KEYSTORE_PASSWORD`: Keystore password
   - `ANDROID_KEY_ALIAS`: Key alias
   - `ANDROID_KEY_PASSWORD`: Key password

Then update the Android build job in `.github/workflows/build-release.yml`:

```yaml
- name: Decode keystore
  run: |
    echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks

- name: Create key.properties
  run: |
    cat > android/key.properties << EOF
    storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
    keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}
    keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}
    storeFile=keystore.jks
    EOF
```

### macOS Signing

For macOS code signing and notarization:

1. Add secrets:

   - `MACOS_CERTIFICATE_BASE64`: Base64-encoded certificate
   - `MACOS_CERTIFICATE_PASSWORD`: Certificate password
   - `APPLE_ID`: Apple ID email
   - `APPLE_ID_PASSWORD`: App-specific password
   - `APPLE_TEAM_ID`: Team ID

2. Add signing steps before building the macOS app

### Windows Signing

For Windows code signing:

1. Add secrets:

   - `WINDOWS_CERTIFICATE_BASE64`: Base64-encoded certificate
   - `WINDOWS_CERTIFICATE_PASSWORD`: Certificate password

2. Add signing steps using `signtool`

## 🔧 Customization

### Changing Flutter Version

Update the `FLUTTER_VERSION` environment variable in the workflow file:

```yaml
env:
  FLUTTER_VERSION: "3.27.0" # Change this version
```

### Build Optimization

All builds use the `--release` flag which:

- Enables aggressive optimizations
- Removes debugging information
- Strips unused code (tree shaking)
- Obfuscates Dart code

### Additional Build Flags

To add more build flags, modify the build commands:

```yaml
# Example: Add obfuscation and split debug info
run: flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/debug-info
```

## 📊 Monitoring Builds

1. Go to the **Actions** tab in your GitHub repository
2. Click on **Build Release** workflow
3. View real-time logs for each platform build
4. Download artifacts from completed builds

## ⏱️ Build Times

Approximate build times:

- Android: 10-15 minutes
- macOS: 15-20 minutes
- Linux: 10-15 minutes
- Windows: 15-20 minutes

Total workflow time: ~20-25 minutes (jobs run in parallel)

## 🐛 Troubleshooting

### Build Failures

1. **Check the logs** in GitHub Actions
2. **Common issues**:
   - Missing dependencies (install via package manager)
   - Flutter version compatibility
   - Platform-specific configuration errors

### Cache Issues

If you encounter caching problems:

1. Clear the cache by going to **Actions** → **Caches**
2. Delete outdated caches
3. Re-run the workflow

### Platform-Specific Issues

- **Linux**: Ensure all system dependencies are installed
- **macOS**: May require Xcode version compatibility
- **Windows**: Check Visual Studio build tools
- **Android**: Verify Gradle and Java versions

## 📝 Version Management

Update the version in `pubspec.yaml`:

```yaml
version: 1.0.0+1 # version+build-number
```

The version string follows [semantic versioning](https://semver.org/):

- **Major**: Breaking changes
- **Minor**: New features (backwards compatible)
- **Patch**: Bug fixes

## 🔄 Continuous Deployment

For automatic deployment to app stores:

1. **Google Play Store**: Use `fastlane` with the AAB file
2. **Apple App Store**: Use `fastlane` with the macOS/iOS build
3. **Microsoft Store**: Use partner center API with MSIX

## 📚 Resources

- [Flutter Build Modes](https://docs.flutter.dev/testing/build-modes)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Desktop Support](https://docs.flutter.dev/desktop)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

## 🆘 Support

If you encounter issues with the CI/CD pipeline:

1. Check the workflow logs in GitHub Actions
2. Review the [GitHub Actions documentation](https://docs.github.com/en/actions)
3. Consult Flutter's [deployment documentation](https://docs.flutter.dev/deployment)
