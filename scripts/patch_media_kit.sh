#!/bin/bash

# Patch script for media_kit_video to support Flutter 3.27+
# This fixes the interface changes in TextureRegistry.SurfaceProducer.Callback

set -e

echo "🔧 Patching media_kit_video for Flutter 3.27+ compatibility..."

# Find the VideoOutput.java file
CACHE_DIR="$HOME/.pub-cache"
if [ ! -z "$PUB_CACHE" ]; then
  CACHE_DIR="$PUB_CACHE"
fi

VIDEO_OUTPUT_FILE="$CACHE_DIR/hosted/pub.dev/media_kit_video-1.3.1/android/src/main/java/com/alexmercerind/media_kit_video/VideoOutput.java"

if [ ! -f "$VIDEO_OUTPUT_FILE" ]; then
  echo "⚠️  VideoOutput.java not found at: $VIDEO_OUTPUT_FILE"
  echo "   Trying alternative path..."
  
  VIDEO_OUTPUT_FILE="$CACHE_DIR/hosted/pub.dartlang.org/media_kit_video-1.3.1/android/src/main/java/com/alexmercerind/media_kit_video/VideoOutput.java"
  
  if [ ! -f "$VIDEO_OUTPUT_FILE" ]; then
    echo "❌ Could not find VideoOutput.java file"
    echo "   This script may need to be updated for your pub cache structure"
    exit 0  # Exit gracefully to not break the build
  fi
fi

# Check if already patched
if grep -q "public void onSurfaceDestroyed()" "$VIDEO_OUTPUT_FILE"; then
  echo "✅ Already patched!"
  exit 0
fi

echo "📝 Applying patch..."

# Create a backup
cp "$VIDEO_OUTPUT_FILE" "$VIDEO_OUTPUT_FILE.bak"

# Apply the patch using sed/awk
# 1. Remove @Override from onSurfaceCleanup (it's no longer an interface method in Flutter 3.27+)
# 2. Add onSurfaceDestroyed() method that calls onSurfaceCleanup()
awk '
/^    @Override$/ {
    # Peek at the next line
    getline nextline
    # If next line is onSurfaceCleanup, skip the @Override
    if (nextline ~ /public void onSurfaceCleanup/) {
        print "    // Note: onSurfaceCleanup is now a private helper method"
        print nextline
    } else {
        # Otherwise, keep the @Override and the next line
        print
        print nextline
    }
    next
}
# Add onSurfaceDestroyed before the final closing brace
/^}$/ && !patched {
    print "    @Override"
    print "    public void onSurfaceDestroyed() {"
    print "        // Required by Flutter 3.27+ TextureRegistry.SurfaceProducer.Callback"
    print "        // In Flutter 3.27+, onSurfaceCleanup() was renamed to onSurfaceDestroyed()"
    print "        onSurfaceCleanup();"
    print "    }"
    print ""
    patched = 1
}
{ print }
' "$VIDEO_OUTPUT_FILE.bak" > "$VIDEO_OUTPUT_FILE"

# Verify the patch was applied
if grep -q "public void onSurfaceDestroyed()" "$VIDEO_OUTPUT_FILE"; then
  echo "✅ Patch applied successfully!"
  rm -f "$VIDEO_OUTPUT_FILE.bak"
else
  echo "⚠️  Patch failed, restoring backup"
  cp "$VIDEO_OUTPUT_FILE.bak" "$VIDEO_OUTPUT_FILE"
  rm -f "$VIDEO_OUTPUT_FILE.bak"
  exit 1
fi
