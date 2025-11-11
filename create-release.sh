#!/bin/bash

# Release script for Server Management Tools

set -e

VERSION_FILE="VERSION"
CHANGELOG_FILE="CHANGELOG.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not a git repository!"
    exit 1
fi

# Get current version from file or git tags
if [[ -f "$VERSION_FILE" ]]; then
    CURRENT_VERSION=$(cat $VERSION_FILE)
else
    CURRENT_VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
fi

print_status "Current version: $CURRENT_VERSION"

# Ask for new version
read -p "Enter new version (e.g., v1.2.0): " NEW_VERSION

# Validate version format
if ! [[ $NEW_VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format. Use format: vX.Y.Z"
    exit 1
fi

# Update version in script
sed -i "s/# Version: .*/# Version: ${NEW_VERSION#v}/" server-manager.sh
sed -i "s/SERVER MANAGEMENT TOOLS v.*/SERVER MANAGEMENT TOOLS ${NEW_VERSION#v}/" server-manager.sh

# Update version file
echo "$NEW_VERSION" > $VERSION_FILE

print_status "Updated version to $NEW_VERSION"

# Commit changes
git add .
git commit -m "Bump version to $NEW_VERSION"

# Create tag
git tag -a "$NEW_VERSION" -m "Release $NEW_VERSION"

print_status "Created tag $NEW_VERSION"

# Ask to push
read -p "Push to remote? (y/n): " PUSH_CONFIRM
if [[ $PUSH_CONFIRM == "y" || $PUSH_CONFIRM == "Y" ]]; then
    git push origin main
    git push origin "$NEW_VERSION"
    print_status "Pushed to remote repository"
else
    print_warning "Changes committed locally. Push manually with:"
    echo "  git push origin main"
    echo "  git push origin $NEW_VERSION"
fi

print_status "Release $NEW_VERSION prepared successfully!"
print_warning "Don't forget to update $CHANGELOG.md with release notes"
