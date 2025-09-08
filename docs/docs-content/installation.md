# Installation

Installing macdwm is straightforward. If you can't figure this out, maybe you should stick to using Mission Control.

## Prerequisites

- macOS 13.0 (Ventura) or later. No exceptions.
- Administrator access (you'll need this for permissions)

## Method 1: Homebrew (The easiest way)

### Install with Homebrew
```bash
brew tap sunnybharne/tap
brew install macdwm
```

### Grant permissions (this is important)
1. Open System Settings → Privacy & Security → Accessibility
2. Click the + button
3. Add your terminal application (Terminal, iTerm2, whatever you use)
4. Make sure the toggle is enabled (it should be green)

### Run it
```bash
macdwm
```

You should see a terminal icon in your menu bar. If you don't, you probably messed up the permissions step.

## Method 2: Pre-built Binary (For people who don't use Homebrew)

### Download
1. Go to the [releases page](https://github.com/sunnybharne/macdwm/releases)
2. Download the latest `macdwm` binary
3. Put it somewhere sensible like `~/bin/` or `/usr/local/bin/`

### Make it executable
```bash
chmod +x macdwm
```

### Grant permissions (this is important)
1. Open System Settings → Privacy & Security → Accessibility
2. Click the + button
3. Add your terminal application (Terminal, iTerm2, whatever you use)
4. Make sure the toggle is enabled (it should be green)

### Run it
```bash
./macdwm
```

You should see a terminal icon in your menu bar. If you don't, you probably messed up the permissions step.

## Method 2: Build from Source (For people who like pain)

### Install Xcode Command Line Tools
```bash
xcode-select --install
```

### Clone the repository
```bash
git clone https://github.com/sunnybharne/macdwm.git
cd macdwm
```

### Build it
```bash
swift build --configuration release
```

### Install it
```bash
cp .build/release/macdwm /usr/local/bin/
```

### Grant permissions
Same as Method 1. This step is not optional.

## Verification

After installation, verify it's working:

1. **Check menu bar**: Look for a terminal icon
2. **Test hotkeys**: Try `Cmd+Ctrl+Left` on a window
3. **Check menu**: Click the menu bar icon to see options

If any of these don't work, you probably didn't give it permissions.

## Troubleshooting

### "Failed to create event tap"
This means you didn't give it Accessibility permissions. Go back to the permissions step and actually do it this time.

### "Permission denied"
The binary isn't executable. Run `chmod +x macdwm`.

### Icon not appearing
Check if the process is running: `ps aux | grep macdwm`. If it's not running, check the console for error messages.

### Hotkeys not working
- Make sure the app is enabled (check the menu bar icon)
- Verify no other apps are stealing your hotkeys
- Test with different applications

## Uninstallation

1. Click the menu bar icon → Quit
2. Delete the macdwm binary
3. Remove it from Accessibility permissions (optional, but clean)