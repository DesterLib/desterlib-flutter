# Flutter 3.27+ Compatibility Guide

## Overview

This project uses Flutter 3.27+ which introduced breaking changes to the Android video texture API. The `media_kit_video` plugin (v1.3.1) hasn't been updated yet to support these changes, so we apply an automatic patch.

## The Problem

Flutter 3.27+ changed the `TextureRegistry.SurfaceProducer.Callback` interface to require a new method:

```java
public void onSurfaceDestroyed()
```

The current version of `media_kit_video` (1.3.1) doesn't implement this method, causing compilation errors:

```
error: VideoOutput is not abstract and does not override abstract method onSurfaceDestroyed() in Callback
```

## The Solution

We've created an automatic patch script at `scripts/patch_media_kit.sh` that:

1. Locates the `VideoOutput.java` file in your pub cache
2. Adds the missing `onSurfaceDestroyed()` method implementation
3. Handles proper cleanup of texture resources

## Usage

### Local Development

After running `flutter pub get`, apply the patch:

```bash
flutter pub get
bash scripts/patch_media_kit.sh
```

### GitHub Actions / CI

The patch is automatically applied in all workflows after `flutter pub get`. No additional configuration needed.

### Verification

Check if the patch was applied successfully:

```bash
# The script will show:
✅ Patch applied successfully!

# Or if already patched:
✅ Already patched!
```

## When Can We Remove This Patch?

This patch can be removed when:

- `media_kit_video` releases a version that supports Flutter 3.27+
- OR we find an alternative video playback library

Track the issue:

- media_kit repository: https://github.com/media-kit/media-kit

## Patch Details

The patch adds the following method to `VideoOutput.java`:

```java
@Override
public void onSurfaceDestroyed() {
  // Required by Flutter 3.27+ TextureRegistry.SurfaceProducer.Callback
  // Clean up resources when surface is destroyed
  if (textureEntry != null) {
    textureEntry.release();
    textureEntry = null;
  }
}
```

This ensures proper resource cleanup when the video surface is destroyed, preventing memory leaks.

## Testing

The patch has been tested with:

- ✅ Flutter 3.27.1 (CI version)
- ✅ Flutter 3.35.6 (local development)
- ✅ Android SDK 36
- ✅ media_kit_video 1.3.1

## Troubleshooting

### Patch doesn't apply

If you see warnings like:

```
⚠️  VideoOutput.java not found
```

This usually means:

1. You haven't run `flutter pub get` yet
2. Your pub cache is in a non-standard location

Set the `PUB_CACHE` environment variable:

```bash
export PUB_CACHE=/your/custom/path
bash scripts/patch_media_kit.sh
```

### Build still fails after patching

Try a clean build:

```bash
flutter clean
flutter pub get
bash scripts/patch_media_kit.sh
flutter build apk --release
```

### Patch needs to be reapplied

The patch needs to be reapplied after:

- Running `flutter pub get` (if it downloads fresh packages)
- Clearing Flutter cache (`flutter clean` with `--pub` flag)
- Switching between Flutter versions

The script is idempotent - it's safe to run multiple times.

## Alternative: Using Flutter 3.24.x

If you prefer not to use the patch, you can use Flutter 3.24.3 (the last version before the breaking changes):

```bash
flutter downgrade 3.24.3
```

However, this requires replacing all `Color.withValues()` calls with `Color.withOpacity()` in your codebase (130+ occurrences).

## References

- [Flutter 3.27 Release Notes](https://docs.flutter.dev/release/release-notes/release-notes-3.27.0)
- [media-kit GitHub](https://github.com/media-kit/media-kit)
- [Color.withValues() Documentation](https://api.flutter.dev/flutter/dart-ui/Color/withValues.html)
