#!/bin/bash

# Development mode: Bundle web app and run Flutter in debug mode
# Usage: ./dev.sh [device]
# Example: ./dev.sh macos

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Dester Flutter - Development Mode${NC}"
echo ""

DEVICE=${1:-macos}

# Step 1: Bundle web app (for offline fallback)
echo -e "${BLUE}📦 Bundling web app for offline fallback...${NC}"
./bundle-web-assets.sh

# Step 2: Get dependencies
echo ""
echo -e "${BLUE}📥 Getting Flutter dependencies...${NC}"
flutter pub get

# Step 3: Run Flutter app
echo ""
echo -e "${GREEN}🎯 Running Flutter app on $DEVICE...${NC}"
echo -e "${YELLOW}💡 Tip: Start your web dev server for live updates!${NC}"
echo -e "${YELLOW}   cd ../desterlib/apps/web && pnpm dev${NC}"
echo ""

flutter run -d $DEVICE

