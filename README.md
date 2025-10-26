# 📱 Dester - Mobile & Desktop App

This is the **mobile and desktop app** for DesterLib! It lets you browse and watch your personal movie and TV show collection on your phone, tablet, or desktop computer. Supports Android, iOS, macOS, Linux, Windows, and TV support coming soon!

---

## 🎯 What Does This App Do?

- 🍿 **Browse Movies & Shows** - Explore your entire collection
- ▶️ **Watch Videos** - Stream smoothly with cool playback controls
- 📺 **Track Progress** - Remember where you stopped watching
- ⚙️ **Personalize** - Adjust settings to your liking
- 📱 **Multi-Device** - Works on Android, iOS, macOS, Linux, Windows, and soon on TV!

---

## 📦 What You Need

Before starting, make sure you have:

1. **Flutter** installed ([Install Flutter](https://flutter.dev/docs/get-started/install))
   - The tool that builds the app
   
2. **DesterLib API Running**
   - The backend that provides your media
   - See the main README for setup instructions
   
3. **A computer** with 4GB+ RAM (for development)

---

## 🚀 Quick Start

### Step 1: Get the Code Ready

```bash
# Download all dependencies
flutter pub get

# (First time only) Generate code
dart run build_runner build --delete-conflicting-outputs
```

### Step 2: Run the App

#### For Development (testing on your computer)

```bash
# Start in debug mode (watch for changes)
flutter run

# This will ask you which device to run on
# Choose your connected phone, emulator, or desktop (macOS/Linux/Windows)
```

#### For Your Phone

```bash
# Build for Android
flutter build apk
# Transfer the file to your phone and install

# Build for iOS
flutter build ios
# Open in Xcode and deploy to your device
```

#### For Desktop (macOS)

```bash
# Run on macOS desktop
flutter run -d macos

# Build for macOS desktop
flutter build macos
```

#### For Desktop (Linux)

```bash
# Run on Linux desktop
flutter run -d linux

# Build for Linux desktop
flutter build linux
```

#### For Desktop (Windows)

```bash
# Run on Windows desktop
flutter run -d windows

# Build for Windows desktop
flutter build windows
```

### Step 3: Connect to Your Server

When the app opens:

1. **Settings** → **Server Configuration**
2. Enter your DesterLib API address:
   - If testing locally: `http://localhost:3001`
   - If on your network: `http://192.168.1.XXX:3001` (replace XXX)
   - If remote: `https://yourdomain.com`
3. The app will connect automatically!

---

## 📂 Project Structure (Simple Version)

```
lib/
├── main.dart              ← App starts here
│
├── app/
│   ├── router.dart        ← Navigation between screens
│   └── theme/            ← Colors and styles
│
├── features/              ← Main features
│   ├── movies/           ← Browse and play movies
│   ├── tv_shows/         ← Browse and play TV shows
│   ├── player/           ← Video player
│   └── settings/         ← App settings
│
├── shared/
│   ├── widgets/          ← Reusable UI pieces (buttons, cards, etc.)
│   ├── animations/       ← Cool visual effects
│   └── responsive/       ← Works on phone, tablet, and desktop (macOS, Linux, Windows)
│
├── core/
│   ├── config/           ← Settings and constants
│   ├── errors/           ← Error handling
│   └── utils/            ← Helper functions
│
└── api/                   ← Talks to DesterLib backend
    ├── openapi.dart      ← API client (auto-generated)
    ├── models/           ← Data structures
    └── services/         ← How to use the API
```

---

## 💻 Development Commands

### Running & Testing

```bash
# Start developing (picks up code changes automatically)
flutter run

# Run on specific device
flutter run -d macos               # macOS desktop
flutter run -d linux               # Linux desktop
flutter run -d windows             # Windows desktop
flutter run -d "iPhone 15"         # iOS simulator
flutter run -d "Pixel 6"           # Android emulator

# Run all tests
flutter test

# Analyze code for issues
flutter analyze

# Format code nicely
dart format lib/
```

### Building for Release

```bash
# Build for production
flutter build apk        # Android app
flutter build ios        # iOS app
flutter build macos      # macOS desktop app
flutter build linux      # Linux desktop app
flutter build windows    # Windows desktop app

# Note: TV support is in development
```

### Cleaning & Fixing Issues

```bash
# Clean everything (use when things break badly)
flutter clean

# Get dependencies again
flutter pub get

# Upgrade dependencies (careful - may break things!)
flutter pub upgrade

# Generate code (if changes don't show)
dart run build_runner build --delete-conflicting-outputs
```

---

## 🔌 How the App Connects to the Backend

The app uses the **OpenAPI API Client** (`lib/api/openapi.dart`) that was automatically generated from the backend.

### Key API Features

- 🎬 Get movies and shows
- ▶️ Get streaming URLs
- 📊 Save your watch progress
- ⚙️ Manage settings
- 🔐 Handle authentication

### Configure API Connection

Edit `lib/core/config/api_config.dart` or use Settings in the app:

```dart
// Basic configuration
const apiBaseUrl = 'http://localhost:3001';  // Change this to your server
```

---

## 🎨 Customization

### Change Colors & Styles

Edit `lib/app/theme/app_theme.dart`:

```dart
// Change primary color
primaryColor: Colors.blue,  // Change to your favorite color

// Change text styles, sizes, etc.
```

### Add New Screens

1. Create a new feature folder: `lib/features/your_feature/`
2. Add screens: `lib/features/your_feature/screens/`
3. Add it to router: `lib/app/router.dart`

### Use State Management (Riverpod)

This app uses **Riverpod** for state management (like Redux or MobX):

```dart
// Create a provider
final myProvider = StateProvider<String>((ref) => 'initial value');

// Use it in a widget
final String value = ref.watch(myProvider);

// Change it
ref.read(myProvider.notifier).state = 'new value';
```

---

## 🎬 Video Player

The app includes a powerful video player using **media_kit**:

- ⏯️ Play, pause, seek
- 🔊 Volume & audio track selection
- 📺 Fullscreen support
- 🎚️ Playback speed control
- 💾 Remember where you stopped

---

## 🐛 Troubleshooting

### "App can't connect to server"
- Check server address in Settings
- Make sure DesterLib API is running (`docker-compose up`)
- Try using your computer's IP instead of localhost
- Check firewall settings

### "Videos won't play"
- Check internet connection
- Make sure server is accessible
- Try a different video format
- Check video permissions

### "App is slow or crashes"
- Run: `flutter clean && flutter pub get`
- Restart emulator/device
- Check device storage space
- Update Flutter: `flutter upgrade`

### "Code changes don't show up"
- Hot reload usually works: `r` in terminal
- If not: Hot restart: `R`
- Full restart: `flutter run` again

---

## 📚 Useful Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Guide**: https://riverpod.dev
- **Media Kit**: https://media-kit.js.org
- **Go Router**: https://gorouter.dev

---

## 🎯 Project Goals

✅ Beautiful UI - Easy to use and nice to look at  
✅ Fast - Responsive and smooth  
✅ Works Everywhere - Phone, tablet, desktop  
✅ Accessible - Works for everyone  
✅ Maintainable - Clean, organized code  

---

## 🚀 Building for Production

### Android

```bash
# Build signed APK for Play Store
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Upload to App Store
# (Use Xcode or App Store Connect)
```

### macOS

```bash
# Build optimized macOS version
flutter build macos --release
```

### Linux

```bash
# Build optimized Linux version
flutter build linux --release

# Run the app
./build/linux/x64/release/bundle/dester
```

### Windows

```bash
# Build optimized Windows version
flutter build windows --release

# Run the app
.\build\windows\x64\runner\Release\dester.exe
```

### TV (Coming Soon)

TV app support is planned for future releases!