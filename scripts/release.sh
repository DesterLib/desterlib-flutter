#!/bin/bash

# Release script for Dester Flutter Client
# Automates version bumping and changelog generation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo -e "${RED}Error: Must be on main branch to create a release${NC}"
  echo "Current branch: $CURRENT_BRANCH"
  echo ""
  echo "Please checkout main and pull latest:"
  echo "  git checkout main"
  echo "  git pull origin main"
  exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
  echo -e "${RED}Error: Working directory is not clean${NC}"
  echo "Please commit or stash your changes first"
  git status --short
  exit 1
fi

# Get current version from pubspec.yaml
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
CURRENT_BUILD=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)

echo -e "${BLUE}Current version: ${CURRENT_VERSION}+${CURRENT_BUILD}${NC}"
echo ""

# Ask for version bump type
echo "Select version bump type:"
echo "  1) Patch (bug fixes)         - ${CURRENT_VERSION} → X.Y.Z+1"
echo "  2) Minor (new features)      - ${CURRENT_VERSION} → X.Y.0+1"
echo "  3) Major (breaking changes)  - ${CURRENT_VERSION} → X.0.0+1"
echo "  4) Build only (no version)   - ${CURRENT_VERSION}+${CURRENT_BUILD} → ${CURRENT_VERSION}+$((CURRENT_BUILD+1))"
echo "  5) Custom version"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
  1)
    BUMP_TYPE="patch"
    ;;
  2)
    BUMP_TYPE="minor"
    ;;
  3)
    BUMP_TYPE="major"
    ;;
  4)
    BUMP_TYPE="build"
    ;;
  5)
    read -p "Enter new version (X.Y.Z): " NEW_VERSION
    if [[ ! $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo -e "${RED}Invalid version format. Use X.Y.Z${NC}"
      exit 1
    fi
    ;;
  *)
    echo -e "${RED}Invalid choice${NC}"
    exit 1
    ;;
esac

# Bump version
if [ "$choice" != "5" ]; then
  echo -e "${YELLOW}Bumping version...${NC}"
  dart run scripts/version_bump.dart $BUMP_TYPE
  
  # Get new version
  NEW_VERSION=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
  NEW_BUILD=$(grep '^version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)
  NEW_FULL_VERSION="${NEW_VERSION}+${NEW_BUILD}"
else
  # Manual version with build number 1
  NEW_FULL_VERSION="${NEW_VERSION}+1"
  # Update pubspec.yaml
  sed -i.bak "s/^version:.*/version: ${NEW_FULL_VERSION}/" pubspec.yaml && rm pubspec.yaml.bak
fi

echo -e "${GREEN}Version bumped to: ${NEW_FULL_VERSION}${NC}"
echo ""

# Generate changelog
echo -e "${YELLOW}Generating changelog from commits...${NC}"
npm run changelog:generate

echo -e "${GREEN}Changelog updated${NC}"
echo ""

# Show what changed
echo -e "${BLUE}Changes to be committed:${NC}"
git diff pubspec.yaml CHANGELOG.md
echo ""

# Confirm
read -p "Create release commit and tag? [y/N]: " confirm
if [[ $confirm != [yY] ]]; then
  echo -e "${YELLOW}Aborted. Changes are staged but not committed.${NC}"
  exit 0
fi

# Stage changes
git add pubspec.yaml CHANGELOG.md

# Commit
COMMIT_MSG="chore(release): bump version to ${NEW_VERSION}"
git commit -m "$COMMIT_MSG"

# Create tag
TAG="v${NEW_VERSION}"
git tag -a "$TAG" -m "Release ${NEW_VERSION}"

echo ""
echo -e "${GREEN}✓ Release prepared successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git show"
echo "  2. Push to remote: git push origin main --tags"
echo "  3. Create GitHub release at: https://github.com/DesterLib/desterlib-flutter/releases/new?tag=${TAG}"
echo ""
echo -e "${BLUE}Tag created: ${TAG}${NC}"

