#!/bin/bash

# Patch script for media_kit_video to support Flutter 3.27+
# This adds the missing onSurfaceDestroyed() method required by the new TextureRegistry API

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

# Check if already patched (correct version)
if grep -q "public void onSurfaceDestroyed()" "$VIDEO_OUTPUT_FILE"; then
  echo "✅ Already patched!"
  exit 0
fi

echo "📝 Applying patch..."

# Create a backup
cp "$VIDEO_OUTPUT_FILE" "$VIDEO_OUTPUT_FILE.bak"

# Find the last closing brace and insert the new method before it
awk '
BEGIN { method_added = 0 }
{
    # If we find the last closing brace (class end)
    if (/^}$/ && !method_added) {
        # Add the new method before the closing brace
        print "  @Override"
        print "  public void onSurfaceDestroyed() {"
        print "    // Required by Flutter 3.27+ TextureRegistry.SurfaceProducer.Callback"
        print "    synchronized (lock) {"
        print "      Log.i(TAG, \"onSurfaceDestroyed\");"
        print "      onSurfaceCleanup();"
        print "    }"
        print "  }"
        print ""
        method_added = 1
    }
    print
}
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
