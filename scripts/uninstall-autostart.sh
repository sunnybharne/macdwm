#!/bin/bash

# macdwm Auto-Start Uninstallation Script
# This script removes macdwm auto-start functionality

set -e

PLIST_FILE="com.sunnybharne.macdwm"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
BINARY_PATH="/usr/local/bin/macdwm"

echo "🗑️  Uninstalling macdwm auto-start..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Don't run this script as root. It needs to uninstall from your user directory."
   exit 1
fi

# Stop and unload the LaunchAgent if it's running
if launchctl list | grep -q "$PLIST_FILE"; then
    echo "🛑 Stopping macdwm service..."
    launchctl stop "$PLIST_FILE" 2>/dev/null || true
    launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_FILE.plist" 2>/dev/null || true
fi

# Remove the plist file
if [[ -f "$LAUNCH_AGENTS_DIR/$PLIST_FILE.plist" ]]; then
    echo "📋 Removing LaunchAgent plist..."
    rm "$LAUNCH_AGENTS_DIR/$PLIST_FILE.plist"
fi

# Remove the binary (requires sudo)
if [[ -f "$BINARY_PATH" ]]; then
    echo "📋 Removing binary from $BINARY_PATH..."
    sudo rm "$BINARY_PATH"
fi

# Clean up log files
echo "🧹 Cleaning up log files..."
rm -f /tmp/macdwm.log /tmp/macdwm.error.log

echo "✅ macdwm auto-start uninstalled successfully!"
echo ""
echo "macdwm will no longer start automatically on login."
echo "You can still run it manually from the project directory."
