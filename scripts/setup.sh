#!/bin/bash

# Setup script for Dester Flutter development environment
# This script sets up dependencies and applies necessary patches

set -e

echo "🚀 Setting up Dester Flutter development environment..."
echo ""

# Check Flutter version
echo "📋 Checking Flutter version..."
FLUTTER_VERSION=$(flutter --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
echo "   Current Flutter version: $FLUTTER_VERSION"
echo ""

# Get dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
echo ""

# Apply media_kit patch
echo "🔧 Applying media_kit_video patch..."
bash scripts/patch_media_kit.sh
echo ""

# Run analysis
echo "🔍 Running code analysis..."
flutter analyze --no-pub
echo ""

echo "✅ Setup complete!"
echo ""
echo "You can now run the app with:"
echo "  flutter run                    # Debug mode"
echo "  flutter build apk --release    # Android release build"
echo ""
echo "For more information, see:"
echo "  - README.md"
echo "  - FLUTTER_COMPATIBILITY.md"

