# Dester Flutter App

A cross-platform Flutter desktop/mobile app that loads the Dester web interface with automatic offline fallback.

## Architecture

This app uses a hybrid approach:

- **WebView** for displaying the web interface
- **Native video player** for optimal playback performance
- **Bundled assets** for offline support

### Loading Strategy

The app uses an **API-first, bundled-fallback** strategy:

1. **Try API Server First** (when online):

   - Attempt to load from local dev server or production API
   - If successful, use live version with latest features

2. **Fallback to Bundled Assets** (when offline or server unreachable):

   - Load from pre-bundled web app included in the Flutter app
   - Works completely offline
   - No internet required after installation

3. **Offline Indicator**:
   - Shows "Offline Mode" badge when using bundled version
   - User knows they're running cached version

## Setup

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Node.js 18+ and pnpm (for building web app)
- For development: Local Dester API server running on port 5173

### Installation

```bash
# 1. Bundle the web app (required before first run)
./bundle-web-assets.sh

# 2. Get Flutter dependencies
flutter pub get

# 3. Run on desktop
flutter run -d macos    # macOS
flutter run -d windows  # Windows
flutter run -d linux    # Linux

# Or run on mobile
flutter run -d ios      # iOS
flutter run -d android  # Android
```

## Development Workflow

### First Time Setup

1. **Bundle the web app:**

   ```bash
   ./bundle-web-assets.sh
   ```

   This will:

   - Build the web app from `../desterlib/apps/web`
   - Copy dist files to `assets/web/`
   - Create version info

2. **Run Flutter app:**
   ```bash
   flutter pub get
   flutter run
   ```

### Daily Development

#### Option A: Use Live Dev Server (Recommended)

1. Start the Dester web dev server:

   ```bash
   cd ../desterlib/apps/web
   pnpm dev
   ```

2. Run the Flutter app:
   ```bash
   flutter run
   ```

The app will automatically detect and load from `localhost:5173`, giving you hot-reload for web changes.

#### Option B: Use Bundled Assets

If you want to test the offline experience or bundled version:

1. Stop the dev server (or disconnect from network)
2. Run the Flutter app - it will use bundled assets

### Updating Bundled Assets

Whenever you make changes to the web app that you want bundled:

```bash
# Rebuild and rebundle
./bundle-web-assets.sh

# Restart Flutter app (hot restart)
# Press 'R' in the Flutter terminal
```

**Note:** You don't need to rebuild for every change during development - only when you want to update the bundled offline version.

## Server Configuration

### Default URLs

Edit `lib/web_view_page.dart` to customize server URLs:

```dart
String get _apiServerUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:5173';  // Android emulator
  }

  if (Platform.isIOS || Platform.isMacOS) {
    return 'http://localhost:5173';  // iOS/macOS
  }

  // For physical devices, use your machine's IP
  // return 'http://192.168.1.100:5173';

  return 'http://localhost:5173';
}
```

### Production Deployment

For production, update the URL to your actual API server:

```dart
String get _apiServerUrl {
  // Production API server
  return 'https://api.yourdomain.com';
}
```

## Features

### ✨ Web Interface

- Full Dester web UI loaded in WebView
- Responsive and smooth navigation
- All web features available

### 📱 Native Video Player

- Uses `media_kit` for optimal performance
- Hardware acceleration
- Better battery life than web video
- Seamless integration via JavaScript bridge

### 🔌 Offline Support

- Pre-bundled web assets included in app
- Automatic fallback when server unreachable
- Works completely offline after installation
- Visual indicator when in offline mode

### 🌐 Platform Support

- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ iOS
- ✅ Android

## Building for Production

### 1. Bundle Latest Web App

```bash
./bundle-web-assets.sh
```

### 2. Build Flutter App

```bash
# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release

# iOS (requires macOS with Xcode)
flutter build ios --release
# Then open ios/Runner.xcworkspace in Xcode and archive

# Android
flutter build apk --release              # APK
flutter build appbundle --release        # App Bundle (for Play Store)
```

## Troubleshooting

### "Failed to load bundled assets"

**Web app not bundled**

Solution:

```bash
./bundle-web-assets.sh
flutter pub get
flutter run
```

### "Connecting to server..." stays loading

**API server not running or unreachable**

Solutions:

1. Check if API server is running: `cd ../desterlib/apps/web && pnpm dev`
2. Verify the URL in `_apiServerUrl` matches your setup
3. For physical devices, ensure your machine's firewall allows connections
4. Wait 3 seconds - it will automatically fallback to bundled assets

### WebView not loading

**Platform-specific issues**

Solutions:

- **macOS**: Check entitlements allow network access
- **iOS**: Ensure `Info.plist` has `NSAppTransportSecurity` configured
- **Android**: Verify internet permission in `AndroidManifest.xml`

### Changes to web app not reflecting

**Using cached bundled version**

Solutions:

1. Rebuild bundled assets: `./bundle-web-assets.sh`
2. Hot restart Flutter app (press 'R' in terminal)
3. Or ensure dev server is running and reachable

## Architecture Details

### JavaScript Bridges

The app exposes two JavaScript channels:

```javascript
// Play video in native player
window.playVideo.postMessage(
  JSON.stringify({
    url: "http://example.com/video.mp4",
    title: "Movie Title",
    season: 1, // Optional
    episode: 1, // Optional
    episodeTitle: "Ep", // Optional
  })
);

// Pick directory (for library management)
window.pickDirectory.postMessage("");

// Check if running in bundled mode
if (window.__FLUTTER_BUNDLED__) {
  console.log("Running in offline mode");
}
```

### Asset Path Rewriting

When loading bundled assets, the app automatically rewrites asset paths from absolute (`/assets/...`) to Flutter asset paths (`flutter_assets/assets/web/...`).

### File Structure

```
desterlib-flutter/
├── lib/
│   ├── main.dart              # App entry point
│   ├── web_view_page.dart     # WebView with fallback logic
│   └── video_player/          # Native video player
├── assets/
│   └── web/                   # Bundled web app (generated)
│       ├── index.html
│       ├── assets/
│       └── version.txt
├── bundle-web-assets.sh       # Script to bundle web app
└── pubspec.yaml               # Dependencies and asset config
```

## Scripts

### `./dev.sh [device]`

**Development mode** - Bundles web app and runs Flutter in debug mode.

**Usage:**

```bash
./dev.sh           # Run on default device
./dev.sh macos     # Run on macOS
./dev.sh android   # Run on Android
```

**What it does:**

1. Bundles web app for offline fallback
2. Gets Flutter dependencies
3. Runs Flutter app in debug mode

### `./build-all.sh [platform] [build-type]`

**Automated production build** - Bundles web app and builds Flutter app.

**Usage:**

```bash
./build-all.sh macos           # macOS release build
./build-all.sh windows debug   # Windows debug build
./build-all.sh android         # Android APK
```

**What it does:**

1. Bundles latest web app
2. Gets Flutter dependencies
3. Builds Flutter app for specified platform

### `./bundle-web-assets.sh`

**Manual bundling** - Just bundles the web app without building Flutter.

**What it does:**

1. Builds web app: `cd ../desterlib/apps/web && pnpm build`
2. Copies `dist/` to `assets/web/`
3. Creates version file with build timestamp

**When to run:**

- Before first Flutter run (or use `./dev.sh` instead)
- After web app changes you want in bundled version
- Before building production releases (or use `./build-all.sh` instead)

## Environment Variables

None required! The app auto-detects the best configuration based on platform.

## License

MIT
