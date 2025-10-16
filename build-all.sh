#!/bin/bash

# Automated build script: Bundles web app and builds Flutter app
# Usage: ./build-all.sh [platform] [build-type]
# Example: ./build-all.sh macos release

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Dester Flutter - Automated Build${NC}"
echo ""

# Parse arguments
PLATFORM=${1:-macos}
BUILD_TYPE=${2:-release}

# Validate platform
case $PLATFORM in
  macos|windows|linux|ios|android|apk|appbundle)
    ;;
  *)
    echo -e "${YELLOW}❌ Invalid platform: $PLATFORM${NC}"
    echo ""
    echo "Usage: ./build-all.sh [platform] [build-type]"
    echo ""
    echo "Platforms:"
    echo "  macos      - Build for macOS"
    echo "  windows    - Build for Windows"
    echo "  linux      - Build for Linux"
    echo "  ios        - Build for iOS"
    echo "  android    - Build Android APK"
    echo "  apk        - Build Android APK"
    echo "  appbundle  - Build Android App Bundle"
    echo ""
    echo "Build types:"
    echo "  release    - Production build (default)"
    echo "  debug      - Debug build"
    echo "  profile    - Profile build"
    exit 1
    ;;
esac

# Step 1: Bundle web app
echo -e "${BLUE}📦 Step 1/3: Bundling web app...${NC}"
./bundle-web-assets.sh

# Step 2: Get Flutter dependencies
echo ""
echo -e "${BLUE}📥 Step 2/3: Getting Flutter dependencies...${NC}"
flutter pub get

# Step 3: Build Flutter app
echo ""
echo -e "${BLUE}🔨 Step 3/3: Building Flutter app for $PLATFORM ($BUILD_TYPE)...${NC}"

case $PLATFORM in
  apk)
    flutter build apk --$BUILD_TYPE
    BUILD_OUTPUT="build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk"
    ;;
  appbundle)
    flutter build appbundle --$BUILD_TYPE
    BUILD_OUTPUT="build/app/outputs/bundle/${BUILD_TYPE}Release/app-${BUILD_TYPE}.aab"
    ;;
  android)
    flutter build apk --$BUILD_TYPE
    BUILD_OUTPUT="build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk"
    ;;
  *)
    flutter build $PLATFORM --$BUILD_TYPE
    case $PLATFORM in
      macos)
        BUILD_OUTPUT="build/macos/Build/Products/Release/desterlib_flutter.app"
        ;;
      windows)
        BUILD_OUTPUT="build/windows/runner/Release/"
        ;;
      linux)
        BUILD_OUTPUT="build/linux/x64/release/bundle/"
        ;;
      ios)
        BUILD_OUTPUT="build/ios/iphoneos/Runner.app"
        ;;
    esac
    ;;
esac

# Success!
echo ""
echo -e "${GREEN}✅ Build completed successfully!${NC}"
echo ""
echo -e "${GREEN}📍 Output location:${NC}"
echo "   $BUILD_OUTPUT"
echo ""

# Platform-specific instructions
case $PLATFORM in
  macos)
    echo -e "${BLUE}To run:${NC}"
    echo "   open $BUILD_OUTPUT"
    ;;
  windows)
    echo -e "${BLUE}To run:${NC}"
    echo "   .\\$BUILD_OUTPUT\\desterlib_flutter.exe"
    ;;
  linux)
    echo -e "${BLUE}To run:${NC}"
    echo "   ./$BUILD_OUTPUT/desterlib_flutter"
    ;;
  ios)
    echo -e "${BLUE}Next steps:${NC}"
    echo "   Open ios/Runner.xcworkspace in Xcode and archive"
    ;;
  apk|android)
    echo -e "${BLUE}To install on device:${NC}"
    echo "   flutter install"
    echo "   or"
    echo "   adb install $BUILD_OUTPUT"
    ;;
  appbundle)
    echo -e "${BLUE}Upload to Play Store:${NC}"
    echo "   Use the .aab file in Google Play Console"
    ;;
esac

echo ""

