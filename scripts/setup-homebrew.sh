#!/bin/bash

# Setup script for Homebrew distribution of macdwm

set -e

echo "🍺 Setting up Homebrew distribution for macdwm..."

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Please run this script from the macdwm root directory"
    exit 1
fi

# Create homebrew-tap repository if it doesn't exist
TAP_REPO="homebrew-tap"
if [ ! -d "../$TAP_REPO" ]; then
    echo "📁 Creating homebrew-tap repository..."
    cd ..
    gh repo create sunnybharne/homebrew-tap --public --description "Homebrew tap for macdwm"
    git clone https://github.com/sunnybharne/homebrew-tap.git
    cd macdwm
fi

# Copy formula to tap repository
echo "📋 Copying formula to tap repository..."
cp Formula/macdwm.rb ../homebrew-tap/

# Calculate SHA256 for the latest release
echo "🔍 Calculating SHA256 for release..."
if [ -z "$1" ]; then
    echo "❌ Error: Please provide the release version as an argument"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION=$1
TARBALL_URL="https://github.com/sunnybharne/macdwm/archive/v${VERSION}.tar.gz"
SHA256=$(curl -sL "$TARBALL_URL" | shasum -a 256 | cut -d' ' -f1)

echo "📊 SHA256 for v${VERSION}: $SHA256"

# Update formula with correct SHA256
sed -i.bak "s/PLACEHOLDER_SHA256/$SHA256/g" ../homebrew-tap/macdwm.rb
rm ../homebrew-tap/macdwm.rb.bak

echo "✅ Homebrew formula updated with SHA256: $SHA256"

# Instructions for next steps
echo ""
echo "🎉 Homebrew setup complete!"
echo ""
echo "Next steps:"
echo "1. Commit and push the formula to your tap repository:"
echo "   cd ../homebrew-tap"
echo "   git add macdwm.rb"
echo "   git commit -m 'Add macdwm v${VERSION}'"
echo "   git push origin main"
echo ""
echo "2. Users can then install with:"
echo "   brew tap sunnybharne/tap"
echo "   brew install macdwm"
echo ""
echo "3. Or in one command:"
echo "   brew install sunnybharne/tap/macdwm"
