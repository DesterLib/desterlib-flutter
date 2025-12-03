#!/bin/bash

# Post-generation fix script for built_value deserialization issues
# This script fixes known issues in generated OpenAPI client code
# where built_value objects need to be converted to builders during deserialization

set -e

OUTPUT_DIR="${1:-lib/core/network/api_client}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Fixing built_value deserialization issues...${NC}"

# Fix update_settings_request.dart
UPDATE_SETTINGS_FILE="${OUTPUT_DIR}/lib/src/model/update_settings_request.dart"
if [ -f "${UPDATE_SETTINGS_FILE}" ]; then
    echo -e "${BLUE}   Fixing update_settings_request.dart...${NC}"
    # Fix scanSettings assignment
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' 's/result\.scanSettings = valueDes;$/result.scanSettings = valueDes.toBuilder();/' "${UPDATE_SETTINGS_FILE}"
        # Remove unused json_object import if present
        sed -i '' '/^import '\''package:built_value\/json_object\.dart'\'';$/d' "${UPDATE_SETTINGS_FILE}"
    else
        # Linux sed
        sed -i 's/result\.scanSettings = valueDes;$/result.scanSettings = valueDes.toBuilder();/' "${UPDATE_SETTINGS_FILE}"
        sed -i '/^import '\''package:built_value\/json_object\.dart'\'';$/d' "${UPDATE_SETTINGS_FILE}"
    fi
    echo -e "${GREEN}   ✅ Fixed update_settings_request.dart${NC}"
fi

# Fix update_settings_request_scan_settings.dart
UPDATE_SETTINGS_SCAN_FILE="${OUTPUT_DIR}/lib/src/model/update_settings_request_scan_settings.dart"
if [ -f "${UPDATE_SETTINGS_SCAN_FILE}" ]; then
    echo -e "${BLUE}   Fixing update_settings_request_scan_settings.dart...${NC}"
    # Fix mediaTypeDepth assignment
    # Fix mediaTypePatterns assignment
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' 's/result\.mediaTypeDepth = valueDes;$/result.mediaTypeDepth = valueDes.toBuilder();/' "${UPDATE_SETTINGS_SCAN_FILE}"
        sed -i '' 's/result\.mediaTypePatterns = valueDes;$/result.mediaTypePatterns = valueDes.toBuilder();/' "${UPDATE_SETTINGS_SCAN_FILE}"
        # Remove unused json_object import if present
        sed -i '' '/^import '\''package:built_value\/json_object\.dart'\'';$/d' "${UPDATE_SETTINGS_SCAN_FILE}"
    else
        # Linux sed
        sed -i 's/result\.mediaTypeDepth = valueDes;$/result.mediaTypeDepth = valueDes.toBuilder();/' "${UPDATE_SETTINGS_SCAN_FILE}"
        sed -i 's/result\.mediaTypePatterns = valueDes;$/result.mediaTypePatterns = valueDes.toBuilder();/' "${UPDATE_SETTINGS_SCAN_FILE}"
        sed -i '/^import '\''package:built_value\/json_object\.dart'\'';$/d' "${UPDATE_SETTINGS_SCAN_FILE}"
    fi
    echo -e "${GREEN}   ✅ Fixed update_settings_request_scan_settings.dart${NC}"
fi

echo -e "${GREEN}✅ Built_value deserialization fixes applied${NC}"

