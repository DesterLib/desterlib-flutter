#!/bin/bash

# Setup script for Dester Flutter development environment
# This script installs all necessary dependencies and sets up git hooks

set -e

echo "🚀 Setting up Dester Flutter development environment..."
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed"
    echo "Please install Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "⚠️  Node.js is not installed"
    echo "Node.js is required for commit tools (commitizen, commitlint)"
    echo "Please install Node.js: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"
echo ""

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
echo ""

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies (commit tools)..."
if command -v pnpm &> /dev/null; then
    pnpm install
elif command -v npm &> /dev/null; then
    npm install
else
    echo "❌ No Node.js package manager found (npm or pnpm)"
    exit 1
fi
echo ""

# Install git hooks
echo "🪝 Installing git hooks..."
if command -v pnpm &> /dev/null; then
    pnpm run prepare
else
    npm run prepare
fi
echo ""

# Generate required code
echo "🔨 Generating code (build_runner)..."
dart run build_runner build --delete-conflicting-outputs
echo ""

# Run analyzer to check for issues
echo "🔍 Running Flutter analyzer..."
flutter analyze
echo ""

# Format code
echo "💄 Formatting code..."
dart format lib/
echo ""

echo "✅ Setup complete!"
echo ""
echo "📚 Next steps:"
echo "  1. Connect to DesterLib API (see README.md)"
echo "  2. Run the app: flutter run"
echo "  3. Make changes and commit with: npm run commit"
echo ""
echo "📖 Documentation:"
echo "  - README.md - Getting started"
echo "  - CONTRIBUTING.md - Contribution guidelines"
echo "  - COMMIT_CONVENTION.md - Commit message format"
echo "  - VERSIONING.md - Version management"
echo ""
echo "Happy coding! 🎉"

