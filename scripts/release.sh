#!/bin/bash

# Script to create a new release
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 1.0.0

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION=$1
TAG="v${VERSION}"

echo "🚀 Creating release $TAG..."

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ You must be on the main branch to create a release"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    echo "❌ Working directory is not clean. Commit or stash changes first."
    exit 1
fi

# Check if tag already exists
if git tag -l | grep -q "^${TAG}$"; then
    echo "❌ Tag $TAG already exists"
    exit 1
fi

# Create and push tag
echo "📝 Creating tag $TAG..."
git tag -a "$TAG" -m "Release $TAG"
git push origin "$TAG"

echo "✅ Tag $TAG created and pushed"
echo "🔄 GitHub Actions will now build and create the release automatically"
echo "📋 Check the Actions tab to monitor progress: https://github.com/sunnybharne/macdwm/actions"
