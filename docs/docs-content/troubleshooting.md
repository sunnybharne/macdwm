# Troubleshooting

Common issues and solutions for macdwm. Most problems are user error.

## Installation Issues

### "Failed to create event tap"
This error means macdwm can't create a global event tap, usually because you didn't give it permissions.

**Solution:**
1. Open System Settings → Privacy & Security → Accessibility
2. Click the + button and add your terminal application
3. Make sure the toggle is enabled (green)
4. Restart your terminal application
5. Run macdwm again

### Auto-Start Installation Issues

#### "Permission denied" during install-autostart.sh
The script needs sudo access to install the binary to `/usr/local/bin/`.

**Solution:**
- Enter your password when prompted
- This is required to install the binary system-wide

#### Auto-start not working after installation
macdwm is installed but not starting automatically.

**Troubleshooting steps:**
1. **Check if LaunchAgent is loaded:**
   ```bash
   launchctl list | grep macdwm
   ```

2. **Check LaunchAgent file:**
   ```bash
   ls -la ~/Library/LaunchAgents/com.sunnybharne.macdwm.plist
   ```

3. **Manually load the LaunchAgent:**
   ```bash
   launchctl load ~/Library/LaunchAgents/com.sunnybharne.macdwm.plist
   ```

4. **Check logs:**
   ```bash
   tail -f /tmp/macdwm.log
   tail -f /tmp/macdwm.error.log
   ```

#### "Failed to create event tap" with auto-start
This happens when auto-start is working but Accessibility permissions aren't granted.

**Solution:**
1. Open System Settings → Privacy & Security → Accessibility
2. Click the + button and add `/usr/local/bin/macdwm`
3. Make sure the toggle is enabled (green)
4. Restart the service:
   ```bash
   launchctl stop com.sunnybharne.macdwm
   launchctl start com.sunnybharne.macdwm
   ```

### "Permission denied" when running
The binary doesn't have execute permissions.

**Solution:**
```bash
chmod +x macdwm
./macdwm
```

### Homebrew tap asks for GitHub authentication
When running `brew tap sunnybharne/tap`, it asks for GitHub login.

**Why this happens:**
- The tap repository doesn't exist yet on GitHub
- Homebrew tries to clone it and needs authentication
- Your company may restrict GitHub access

**Solutions:**
1. **Skip Homebrew** (recommended): Use the pre-built binary instead
   ```bash
   # Download from releases page
   chmod +x macdwm
   ./macdwm
   ```

2. **Use personal GitHub account**: If you have a personal GitHub account, you can authenticate with that

3. **Wait for tap setup**: The tap will be set up later, then you can use Homebrew without authentication

## Runtime Issues

### Menu bar icon not appearing
The terminal icon should appear in your menu bar when macdwm is running.

**Troubleshooting steps:**
1. **Check if macdwm is running:**
   ```bash
   ps aux | grep macdwm
   ```

2. **Look for error messages:**
   ```bash
   # Run in foreground to see output
   ./macdwm
   ```

3. **Check Console.app** for error messages:
   - Open Console.app
   - Search for "macdwm"
   - Look for error messages

### Hotkeys not working
The keyboard shortcuts are not responding.

**Troubleshooting steps:**
1. **Check if macdwm is enabled:**
   - Click the menu bar icon
   - Make sure "Enabled" is checked

2. **Verify Accessibility permissions:**
   - System Settings → Privacy & Security → Accessibility
   - Make sure your terminal app is listed and enabled

3. **Test with different applications:**
   - Try tiling different windows
   - Test with different applications

4. **Check for hotkey conflicts:**
   - System Settings → Keyboard → Shortcuts
   - Look for conflicting shortcuts

### App launcher not working
The Cmd+1-5 hotkeys are not launching applications.

**Troubleshooting steps:**
1. **Verify application paths:**
   ```bash
   # Check if applications exist
   ls -la "/Applications/Firefox.app"
   ls -la "/Applications/iTerm.app"
   ```

2. **Test manual launch:**
   ```bash
   # Try launching manually
   open "/Applications/Firefox.app"
   ```

3. **Check bundle IDs:**
   ```bash
   # Get bundle ID for an app
   mdls -name kMDItemCFBundleIdentifier "/Applications/Firefox.app"
   ```

### Window tiling not working
Windows are not resizing or repositioning.

**Troubleshooting steps:**
1. **Make sure window is focused:**
   - Click on the window before using tiling hotkeys
   - Use Cmd+Tab to switch to the window

2. **Test with different applications:**
   - Some apps may not support window manipulation
   - Try with Finder, Safari, or Terminal

3. **Check window properties:**
   - Some windows may be non-resizable
   - Try with a resizable window

## Auto-Start Service Management

### Controlling the Auto-Start Service

#### Start/Stop the service
```bash
# Start macdwm now
launchctl start com.sunnybharne.macdwm

# Stop macdwm
launchctl stop com.sunnybharne.macdwm

# Check if it's running
launchctl list | grep macdwm
```

#### Uninstall auto-start
```bash
# From the macdwm project directory
./scripts/uninstall-autostart.sh
```

#### Check service status
```bash
# See all loaded services
launchctl list | grep macdwm

# Check if the plist file exists
ls -la ~/Library/LaunchAgents/com.sunnybharne.macdwm.plist

# View service logs
tail -f /tmp/macdwm.log
tail -f /tmp/macdwm.error.log
```

### Common Auto-Start Issues

#### Service not starting on login
1. **Check if the plist file exists:**
   ```bash
   ls -la ~/Library/LaunchAgents/com.sunnybharne.macdwm.plist
   ```

2. **Reload the service:**
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.sunnybharne.macdwm.plist
   launchctl load ~/Library/LaunchAgents/com.sunnybharne.macdwm.plist
   ```

3. **Check for errors in logs:**
   ```bash
   tail -20 /tmp/macdwm.error.log
   ```

#### Service keeps crashing
1. **Check the error log:**
   ```bash
   tail -20 /tmp/macdwm.error.log
   ```

2. **Most common cause**: Missing Accessibility permissions
3. **Solution**: Grant permissions to `/usr/local/bin/macdwm` in System Settings

## Getting Help

### Common solutions
1. **Restart macdwm** - Solves most temporary issues
2. **Re-grant permissions** - Fixes accessibility issues
3. **Check for conflicts** - Resolves hotkey problems
4. **Update system** - Fixes compatibility issues

### Reporting issues
When reporting issues, include:

1. **macOS version**: `sw_vers`
2. **Architecture**: `uname -m`
3. **Error messages**: From Console.app or terminal
4. **Steps to reproduce**: Detailed reproduction steps
5. **Expected behavior**: What should happen
6. **Actual behavior**: What actually happens

### Before you ask for help
1. Read this troubleshooting guide
2. Check if the issue is already reported on GitHub
3. Make sure you've given macdwm proper permissions
4. Try restarting the application
5. Check the console for error messages

Most issues are caused by not giving macdwm Accessibility permissions. Make sure you've done this step properly.