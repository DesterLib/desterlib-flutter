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

# Check if already patched
if grep -q "onSurfaceDestroyed()" "$VIDEO_OUTPUT_FILE"; then
  echo "✅ Already patched!"
  exit 0
fi

echo "📝 Applying patch..."

# Create a backup
cp "$VIDEO_OUTPUT_FILE" "$VIDEO_OUTPUT_FILE.bak"

# Add the missing method before the closing brace of the class
# We'll add it after the last @Override method
sed -i'.tmp' '/@Override/,/^  }$/ {
  /^  }$/ a\
\
  @Override\
  public void onSurfaceDestroyed() {\
    // Required by Flutter 3.27+ TextureRegistry.SurfaceProducer.Callback\
    // Clean up resources when surface is destroyed\
    if (textureEntry != null) {\
      textureEntry.release();\
      textureEntry = null;\
    }\
  }
}' "$VIDEO_OUTPUT_FILE"

# If sed didn't work (some systems), try a different approach
if ! grep -q "onSurfaceDestroyed()" "$VIDEO_OUTPUT_FILE"; then
  echo "📝 Trying alternative patch method..."
  
  # Restore from backup
  cp "$VIDEO_OUTPUT_FILE.bak" "$VIDEO_OUTPUT_FILE"
  
  # Find the line number of the last closing brace (end of class)
  # Insert the new method before it
  awk '
  /^}$/ && !done {
    print "  @Override"
    print "  public void onSurfaceDestroyed() {"
    print "    // Required by Flutter 3.27+ TextureRegistry.SurfaceProducer.Callback"
    print "    // Clean up resources when surface is destroyed"
    print "    if (textureEntry != null) {"
    print "      textureEntry.release();"
    print "      textureEntry = null;"
    print "    }"
    print "  }"
    print ""
    done = 1
  }
  { print }
  ' "$VIDEO_OUTPUT_FILE.bak" > "$VIDEO_OUTPUT_FILE"
fi

# Clean up temp files
rm -f "$VIDEO_OUTPUT_FILE.tmp" "$VIDEO_OUTPUT_FILE.bak"

if grep -q "onSurfaceDestroyed()" "$VIDEO_OUTPUT_FILE"; then
  echo "✅ Patch applied successfully!"
else
  echo "⚠️  Patch may not have been applied correctly"
  echo "   Please check the VideoOutput.java file manually"
fi

