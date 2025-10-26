# 📱 Dester Client

Cross-platform client application for **DesterLib** - Browse and stream your personal media collection on any device.

[![GitHub](https://img.shields.io/badge/GitHub-desterlib--flutter-blue?logo=github)](https://github.com/DesterLib/desterlib-flutter)
[![License](https://img.shields.io/badge/License-AGPL--3.0-blue.svg)](LICENSE)
[![Documentation](https://img.shields.io/badge/docs-desterlib-blue)](https://desterlib.github.io/desterlib/clients/overview)

---

## 📱 Supported Platforms

### Available Now
- **Android** - Phones and tablets
- **iOS** - iPhone and iPad
- **macOS** - Desktop application
- **Linux** - Desktop application
- **Windows** - Desktop application

### Coming Soon
- **Android TV** - TV interface with remote control
- **Apple TV** - Native TV experience

---

## 🚀 Quick Start

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.9.2+
- [DesterLib API Server](https://github.com/DesterLib/desterlib) running

### Installation

```bash
# Clone the repository
git clone https://github.com/DesterLib/desterlib-flutter.git
cd desterlib-flutter

# Run automated setup
bash scripts/setup.sh

# Or manual setup:
flutter pub get
npm install
npm run prepare
dart run build_runner build --delete-conflicting-outputs
```

### Run the App

```bash
# Run on your device
flutter run

# Or specify platform
flutter run -d macos    # macOS
flutter run -d android  # Android
flutter run -d ios      # iOS
```

### First Launch

1. Open the app
2. Go to **Settings** → **Server Configuration**
3. Enter your DesterLib API URL:
   - Local: `http://localhost:3001`
   - Network: `http://192.168.1.XXX:3001`
   - Remote: `https://yourdomain.com`

---

## 📚 Documentation

**📖 Full Documentation:** [desterlib.github.io/desterlib](https://desterlib.github.io/desterlib)

### Quick Links

- [Client Overview](https://desterlib.github.io/desterlib/clients/overview) - Features and platforms
- [Platform Setup](https://desterlib.github.io/desterlib/clients/flutter) - Detailed setup guide
- [Contributing](https://desterlib.github.io/desterlib/development/contributing) - How to contribute
- [API Server Setup](https://desterlib.github.io/desterlib/api/overview) - Backend setup

---

## 🎨 Features

- 🍿 **Browse Media** - Explore your movies and TV shows
- ▶️ **Video Streaming** - Smooth playback with controls
- 📺 **Watch Progress** - Automatic tracking across devices
- 🔍 **Search & Filter** - Find content quickly
- ⚙️ **Settings** - Customize your experience
- 🌓 **Dark Mode** - Eye-friendly viewing
- 📱 **Responsive UI** - Works on any screen size

---

## 🛠️ Development

### Project Structure

```
lib/
├── main.dart              # App entry point
├── app/                   # App configuration
├── features/              # Feature modules (home, library, media, settings)
├── shared/                # Shared resources (widgets, utils, providers)
└── api/                   # Generated API client
```

See [CODE_STRUCTURE.md](CODE_STRUCTURE.md) for details.

### Commands

```bash
# Run app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Build for release
flutter build apk        # Android
flutter build ios        # iOS
flutter build macos      # macOS
flutter build linux      # Linux
flutter build windows    # Windows
```

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](https://desterlib.github.io/desterlib/development/contributing).

**Quick Start:**
```bash
# Fork, clone, and setup
bash scripts/setup.sh

# Create feature branch
git checkout -b feat/your-feature

# Make changes with conventional commits
npm run commit

# Push and create PR
git push origin feat/your-feature
```

**Resources:**
- [Contributing Guide](CONTRIBUTING.md) - Quick start
- [Commit Guidelines](https://desterlib.github.io/desterlib/development/commit-guidelines)
- [Versioning Guide](https://desterlib.github.io/desterlib/development/versioning)

---

## 📦 Building for Release

### Android
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
flutter build ios --release
# Open in Xcode for deployment
```

### Desktop
```bash
flutter build macos --release   # macOS
flutter build linux --release   # Linux
flutter build windows --release # Windows
```

---

## 🐛 Troubleshooting

### Can't Connect to Server
- Check server URL in Settings
- Ensure DesterLib API is running
- Try using IP address instead of localhost
- Check firewall settings

### Videos Won't Play
- Check internet connection
- Verify server is accessible
- Try a different video
- Check video codec support

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 💬 Support

- 📖 [Documentation](https://desterlib.github.io/desterlib)
- 🐛 [Report Issues](https://github.com/DesterLib/desterlib-flutter/issues)
- 💬 [Discussions](https://github.com/DesterLib/desterlib-flutter/discussions)

---

## 📄 License

GNU Affero General Public License v3.0 (AGPL-3.0)

This ensures the software remains free and open source forever. See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

Built with:
- [Flutter](https://flutter.dev/) - Cross-platform framework
- [media_kit](https://github.com/media-kit/media-kit) - Video playback
- [Riverpod](https://riverpod.dev/) - State management
- [go_router](https://pub.dev/packages/go_router) - Navigation

---

**Made with ❤️ by the DesterLib community**
