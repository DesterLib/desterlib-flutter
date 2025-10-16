#!/bin/bash

# Script to build and bundle the web app into Flutter assets
# Run this before building the Flutter app

set -e

echo "🚀 Building and bundling web app..."

# Paths
WEB_DIR="../desterlib/apps/web"
FLUTTER_ASSETS_DIR="assets/web"

# Check if web directory exists
if [ ! -d "$WEB_DIR" ]; then
  echo "❌ Error: Web directory not found at $WEB_DIR"
  exit 1
fi

# Build the web app
echo "📦 Building web app..."
cd "$WEB_DIR"

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
  echo "📥 Installing dependencies..."
  pnpm install
fi

# Build
pnpm run build

if [ ! -d "dist" ]; then
  echo "❌ Error: Build failed - dist directory not found"
  exit 1
fi

echo "✅ Web app built successfully"

# Go back to Flutter directory
cd - > /dev/null

# Create assets directory
echo "📁 Creating Flutter assets directory..."
mkdir -p "$FLUTTER_ASSETS_DIR"

# Clean old assets
echo "🧹 Cleaning old bundled assets..."
rm -rf "$FLUTTER_ASSETS_DIR"/*

# Copy build output to Flutter assets
echo "📋 Copying built files to Flutter assets..."
cp -r "$WEB_DIR/dist/"* "$FLUTTER_ASSETS_DIR/"

# Fix asset paths in index.html for Flutter
echo "🔧 Fixing asset paths for Flutter..."
if [ -f "$FLUTTER_ASSETS_DIR/index.html" ]; then
  # Convert absolute paths to relative paths
  # /assets/... -> assets/...
  sed -i '' 's|href="/|href="|g' "$FLUTTER_ASSETS_DIR/index.html"
  sed -i '' 's|src="/|src="|g' "$FLUTTER_ASSETS_DIR/index.html"
  
  # Remove vite.svg reference (doesn't exist)
  sed -i '' 's|<link rel="icon" type="image/svg+xml" href="vite.svg" />||g' "$FLUTTER_ASSETS_DIR/index.html"
  
  # Add a script to mark as bundled version and test if JS works
  sed -i '' 's|</head>|  <script>\n    window.__FLUTTER_BUNDLED__ = true;\n    // Test if JavaScript executes\n    document.addEventListener("DOMContentLoaded", function() {\n      if (window.console) {\n        window.console.postMessage("JavaScript is executing!");\n      }\n      // Add visible indicator\n      const root = document.getElementById("root");\n      if (root) {\n        root.innerHTML = "<div style=\\"color: white; padding: 20px;\\">Loading app...</div>";\n      }\n    });\n  </script>\n  </head>|' "$FLUTTER_ASSETS_DIR/index.html"
  
  echo "✅ Asset paths fixed"
fi

# Create version file
echo "📝 Creating version file..."
echo "Built on: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" > "$FLUTTER_ASSETS_DIR/version.txt"
echo "Commit: $(cd "$WEB_DIR" && git rev-parse --short HEAD 2>/dev/null || echo 'unknown')" >> "$FLUTTER_ASSETS_DIR/version.txt"

echo ""
echo "✅ Web app bundled successfully!"
echo "📍 Location: $FLUTTER_ASSETS_DIR"
echo ""
echo "Next steps:"
echo "  1. Run: flutter pub get"
echo "  2. Run: flutter run"
echo ""
echo "Note: Re-run this script whenever you update the web app"

