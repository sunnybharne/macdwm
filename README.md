# macdwm

A minimal macOS tiling window manager inspired by dwm. Personal use only.

## Features

- **Window tiling**: `Option+Ctrl+Left/Right` to tile windows
- **App launcher**: `Option+1-5` to switch between applications
- **Menu bar indicator**: Shows which app you're currently focused on
- **Lightweight**: Uses minimal system resources

## Hotkeys

| Hotkey | Action |
|--------|--------|
| `Option+Ctrl+Left` | Tile window to left half |
| `Option+Ctrl+Right` | Tile window to right half |
| `Option+1` | Activate Firefox |
| `Option+2` | Activate iTerm |
| `Option+3` | Activate Cursor |
| `Option+4` | Activate Visual Studio Code |
| `Option+5` | Activate Microsoft Teams |

## Installation

### Step 1: Clone and Build
```bash
# Clone the repository
git clone https://github.com/sunnybharne/macdwm.git
cd macdwm

# Build the application
swift build --configuration release --disable-sandbox
```

### Step 2: Install System-Wide
```bash
# Copy to system location (requires password)
sudo cp .build/release/macdwm /usr/local/bin/macdwm
```

### Step 3: Grant Accessibility Permissions
**This step is required for macdwm to work!**

1. **Open System Settings** (click the Apple menu → System Settings)
2. **Go to Privacy & Security** → **Accessibility**
3. **Click the + button** (plus icon)
4. **Navigate to and select**: `/usr/local/bin/macdwm`
5. **Make sure the toggle is enabled** (should be green/checked)

### Step 4: Run macdwm
```bash
# Start macdwm
/usr/local/bin/macdwm
```

**You should see a terminal icon in your menu bar when it's running!**

### Step 5: Test It Works
1. **Click on any window** to focus it (like Finder, Safari, etc.)
2. **Press `Option+Ctrl+Left`** - the window should tile to the left half
3. **Press `Option+Ctrl+Right`** - the window should tile to the right half

If the window tiles, congratulations! macdwm is working.

## Usage

- Look for the terminal icon in your menu bar
- Click the icon to access settings and quit options
- Use the hotkeys to tile windows and launch applications
- The app number (1-5) will show in the menu bar when using app launcher hotkeys

## Requirements

- macOS 13.0 (Ventura) or later
- Swift 6.1+ (for building from source)
- Accessibility permissions (required for window management)

## Building from Source

```bash
git clone https://github.com/sunnybharne/macdwm.git
cd macdwm
swift build --configuration release --disable-sandbox
```

## Stopping macdwm

- Use the menu bar icon → Quit
- Or run: `pkill -f macdwm`

## Troubleshooting

### "macdwm is already running. Exiting."
This means another instance is running. Stop it first:
```bash
pkill -f macdwm
```

### No menu bar icon visible
1. **Check if it's running**: `ps aux | grep macdwm`
2. **Check logs**: `tail -10 /tmp/macdwm.log`
3. **Most likely cause**: Missing Accessibility permissions

### Hotkeys not working
1. **Grant Accessibility permissions** (Step 3 above)
2. **Make sure the window is focused** before using tiling hotkeys
3. **Check for conflicts** in System Settings → Keyboard → Shortcuts

### "Failed to create event tap"
This means Accessibility permissions are not granted. Follow Step 3 above carefully.

### App launcher not working
Make sure the applications are installed in the expected locations:
- Firefox: Should be in Applications folder
- iTerm: Should be in Applications folder  
- Cursor: Should be in Applications folder
- VS Code: Should be in Applications folder
- Teams: Should be in Applications folder