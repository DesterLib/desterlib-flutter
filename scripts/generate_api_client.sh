#!/bin/bash

# Generate OpenAPI client from DesterLib API
# This script generates the Dart API client from the Swagger spec and builds it

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# API configuration
API_URL="${API_URL:-http://localhost:3001}"
SWAGGER_JSON_URL="${API_URL}/api/docs.json"
OUTPUT_DIR="lib/core/network/api_client"
SDK_VERSION="3.10.0"

echo -e "${BLUE}🔧 DesterLib API Client Generator${NC}"
echo ""

# Check if API server is running
echo -e "${BLUE}📡 Checking API server at ${API_URL}...${NC}"
if ! curl -s "${API_URL}/health" > /dev/null 2>&1; then
    echo -e "${RED}❌ API server is not running at ${API_URL}${NC}"
    echo -e "${YELLOW}💡 Start the API server first:${NC}"
    echo -e "   cd ../desterlib/apps/api && pnpm dev"
    echo ""
    echo -e "${YELLOW}💡 Or set a different URL:${NC}"
    echo -e "   API_URL=http://your-api-url:3001 bash scripts/generate_api_client.sh"
    exit 1
fi
echo -e "${GREEN}✅ API server is running${NC}"
echo ""

# Check Swagger endpoint
echo -e "${BLUE}📚 Checking Swagger documentation...${NC}"
if ! curl -s "${SWAGGER_JSON_URL}" | grep -q '"openapi"\|"swagger"'; then
    echo -e "${RED}❌ Swagger JSON not available at ${SWAGGER_JSON_URL}${NC}"
    echo -e "${YELLOW}💡 Make sure the API server is running and the endpoint is correct${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Swagger documentation found${NC}"
echo ""

# Generate OpenAPI client
echo -e "${BLUE}🔨 Generating Dart client from OpenAPI spec...${NC}"
npx @openapitools/openapi-generator-cli generate \
  -i "${SWAGGER_JSON_URL}" \
  -g dart-dio \
  -o "${OUTPUT_DIR}" \
  --additional-properties=pubName=openapi,pubVersion=1.0.0

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to generate API client${NC}"
    exit 1
fi
echo -e "${GREEN}✅ API client generated successfully${NC}"
echo ""

# Update SDK version in generated pubspec.yaml
echo -e "${BLUE}🔧 Updating SDK version to ${SDK_VERSION}...${NC}"
if [ -f "${OUTPUT_DIR}/pubspec.yaml" ]; then
    # Use sed to replace the SDK version (works on both macOS and Linux)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' "s/sdk: '[^']*'/sdk: '${SDK_VERSION}'/" "${OUTPUT_DIR}/pubspec.yaml"
    else
        # Linux sed
        sed -i "s/sdk: '[^']*'/sdk: '${SDK_VERSION}'/" "${OUTPUT_DIR}/pubspec.yaml"
    fi
    echo -e "${GREEN}✅ SDK version updated to ${SDK_VERSION}${NC}"
else
    echo -e "${YELLOW}⚠️  pubspec.yaml not found, skipping SDK version update${NC}"
fi
echo ""

# Fix built_value deserialization issues
echo -e "${BLUE}🔧 Fixing built_value deserialization issues...${NC}"
FIX_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${FIX_SCRIPT_DIR}/fix_built_value_deserialization.sh" "${OUTPUT_DIR}"

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  Failed to apply built_value fixes (continuing anyway)${NC}"
fi
echo ""

# Build the generated client
echo -e "${BLUE}🏗️  Building generated client (build_runner)...${NC}"
cd "${OUTPUT_DIR}"
dart run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to build API client${NC}"
    cd - > /dev/null  # Return to original directory
    exit 1
fi
cd - > /dev/null  # Return to project root
echo -e "${GREEN}✅ API client built successfully${NC}"
echo ""

# Summary
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✨ API Client Generation Complete!  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📦 Generated files:${NC}"
echo -e "   - API classes: ${OUTPUT_DIR}/lib/src/api/"
echo -e "   - Models: ${OUTPUT_DIR}/lib/src/model/"
echo -e "   - Documentation: ${OUTPUT_DIR}/doc/"
echo ""
echo -e "${BLUE}🎯 Next steps:${NC}"
echo -e "   1. Review generated API in ${OUTPUT_DIR}/"
echo -e "   2. Run your Flutter app: flutter run"
echo -e "   3. Test the new endpoints!"
echo ""

