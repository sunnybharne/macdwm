#!/bin/bash

# macdwm Auto-Start Installation Script
# This script installs macdwm to start automatically on login

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PLIST_FILE="com.sunnybharne.macdwm.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
BINARY_PATH="/usr/local/bin/macdwm"

echo "🚀 Installing macdwm auto-start..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Don't run this script as root. It needs to install to your user directory."
   exit 1
fi

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$LAUNCH_AGENTS_DIR"

# Build the binary if it doesn't exist
if [[ ! -f "$PROJECT_ROOT/.build/release/macdwm" ]]; then
    echo "📦 Building macdwm..."
    cd "$PROJECT_ROOT"
    swift build --configuration release
fi

# Install binary to /usr/local/bin (requires sudo)
echo "📋 Installing binary to $BINARY_PATH..."
sudo cp "$PROJECT_ROOT/.build/release/macdwm" "$BINARY_PATH"
sudo chmod +x "$BINARY_PATH"

# Copy plist file to LaunchAgents
echo "📋 Installing LaunchAgent..."
cp "$PROJECT_ROOT/$PLIST_FILE" "$LAUNCH_AGENTS_DIR/"

# Load the LaunchAgent
echo "🔄 Loading LaunchAgent..."
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_FILE"

echo "✅ macdwm auto-start installed successfully!"
echo ""
echo "macdwm will now start automatically when you log in."
echo "You can control it with:"
echo "  • launchctl start com.sunnybharne.macdwm    # Start now"
echo "  • launchctl stop com.sunnybharne.macdwm     # Stop now"
echo "  • launchctl unload ~/Library/LaunchAgents/$PLIST_FILE  # Disable auto-start"
echo ""
echo "Logs are available at:"
echo "  • /tmp/macdwm.log"
echo "  • /tmp/macdwm.error.log"
