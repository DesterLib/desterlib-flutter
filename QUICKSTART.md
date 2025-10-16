# Quick Start Guide

Get the Dester Flutter app running in one command!

## Development Mode (One Command!)

```bash
./dev.sh
```

That's it! 🎉

This automatically:

- ✅ Bundles the web app for offline fallback
- ✅ Gets Flutter dependencies
- ✅ Runs the app

## Production Build (One Command!)

```bash
./build-all.sh macos        # or windows, linux, ios, android
```

This automatically:

- ✅ Bundles the latest web app
- ✅ Gets Flutter dependencies
- ✅ Builds the production app

---

## What Happens When You Run?

### Scenario 1: Dev Server Running ✅

If your Dester API server is running on `localhost:5173`:

- App loads the **live version** from the server
- You get hot-reload and latest features
- Perfect for development

**To start dev server:**

```bash
cd ../desterlib/apps/web
pnpm dev
```

### Scenario 2: Dev Server Not Running / Offline 📴

If the server is unreachable:

- App automatically loads **bundled version**
- Shows "Offline Mode" badge
- Everything works offline
- Perfect for testing offline functionality

---

## Daily Workflow

### Quick Start (Automated)

```bash
# Development mode - auto-bundles and runs
./dev.sh

# Or specify device
./dev.sh macos     # macOS
./dev.sh windows   # Windows
./dev.sh android   # Android
```

### With Live Web Server (Recommended for Development)

```bash
# Terminal 1: Start web dev server
cd ../desterlib/apps/web
pnpm dev

# Terminal 2: Run Flutter app (will use live server)
cd ../desterlib-flutter
./dev.sh
```

### Manual Steps (If You Prefer)

```bash
# Bundle web app
./bundle-web-assets.sh

# Run Flutter
flutter run
```

### After Web App Changes

If you modified the web app and want to update the bundled version:

```bash
# Option 1: Use automated script
./dev.sh  # Rebuilds and runs

# Option 2: Manual
./bundle-web-assets.sh
# Then press 'R' in Flutter terminal to hot restart
```

---

## Available Scripts

### `./dev.sh [device]`

Development mode - bundles web app and runs Flutter in debug mode.

```bash
./dev.sh           # Default device (macOS)
./dev.sh macos     # macOS
./dev.sh windows   # Windows
./dev.sh ios       # iOS
./dev.sh android   # Android
```

### `./build-all.sh [platform] [build-type]`

Production build - bundles web app and builds Flutter app.

```bash
./build-all.sh macos           # macOS release
./build-all.sh windows         # Windows release
./build-all.sh android debug   # Android debug APK
./build-all.sh appbundle       # Android App Bundle
```

### `./bundle-web-assets.sh`

Manual bundling - just bundles the web app without building Flutter.

```bash
./bundle-web-assets.sh
```

---

## Building for Production

### Automated (One Command)

```bash
./build-all.sh macos        # macOS
./build-all.sh windows      # Windows
./build-all.sh linux        # Linux
./build-all.sh ios          # iOS
./build-all.sh android      # Android APK
./build-all.sh appbundle    # Android App Bundle
```

### Manual (If You Prefer)

```bash
# 1. Bundle latest web app
./bundle-web-assets.sh

# 2. Build for your platform
flutter build macos --release
flutter build windows --release
flutter build linux --release
flutter build ios --release
flutter build apk --release
```

---

## Troubleshooting

### Script Permission Denied

```bash
chmod +x bundle-web-assets.sh
./bundle-web-assets.sh
```

### Web Directory Not Found

Make sure you're running the script from `desterlib-flutter/`:

```bash
cd /path/to/desterlib-flutter
./bundle-web-assets.sh
```

### "Failed to load bundled assets"

You forgot step 1! Run:

```bash
./bundle-web-assets.sh
flutter pub get
flutter run
```

### App Loads Old Version

Rebuild the bundle and hot restart:

```bash
./bundle-web-assets.sh
# Press 'R' in Flutter terminal
```

---

## Tips

💡 **You only need to rebuild the bundle when:**

- First time setup
- You made web changes you want in the offline version
- Building for production

💡 **You DON'T need to rebuild bundle when:**

- Developing with live dev server (it updates automatically)
- Making Flutter-only changes

💡 **Check which version is loaded:**

- If you see "Offline Mode" badge → Using bundled version
- No badge → Using live server version

---

**Need more help?** Check the full [README.md](README.md) for detailed documentation.
