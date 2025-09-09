# macdwm

A minimal macOS tiling window manager inspired by dwm. Personal use only.

## Features

- **Window tiling**: Configurable modifier key + Ctrl + Left/Right to tile windows
- **App launcher**: Configurable modifier key + 1-0 to switch between applications
- **Firefox tab switching**: Dedicated hotkeys for specific Firefox tabs (Tab 1-6)
- **Configurable hotkeys**: Change modifier key (Command, Option, Control, Shift) without restart
- **Configurable apps**: Assign any app to any hotkey (1-0) with persistent settings
- **Menu bar indicator**: Shows which app you're currently focused on
- **Settings window**: Easy access to change modifier key and app preferences
- **Persistent settings**: Your configurations are saved and restored on restart
- **Lightweight**: Uses minimal system resources

## Hotkeys

**Default modifier key is Option (⌥), but you can change this in Settings!**

| Hotkey | Action |
|--------|--------|
| `[Modifier]+Ctrl+Left` | Tile window to left half |
| `[Modifier]+Ctrl+Right` | Tile window to right half |
| `[Modifier]+1` | Activate Firefox |
| `[Modifier]+2` | Activate iTerm |
| `[Modifier]+3` | Activate Cursor |
| `[Modifier]+4` | Activate Visual Studio Code |
| `[Modifier]+5` | Activate Microsoft Teams |
| `[Modifier]+6-0` | Customizable (empty by default) |

### Firefox Tab Hotkeys

You can assign specific Firefox tabs to any hotkey:

| Option | Action |
|--------|--------|
| Firefox Tab 1 | Switch to 1st Firefox tab (Cmd+1) |
| Firefox Tab 2 | Switch to 2nd Firefox tab (Cmd+2) |
| Firefox Tab 3 | Switch to 3rd Firefox tab (Cmd+3) |
| Firefox Tab 4 | Switch to 4th Firefox tab (Cmd+4) |
| Firefox Tab 5 | Switch to 5th Firefox tab (Cmd+5) |
| Firefox Tab 6 | Switch to 6th Firefox tab (Cmd+6) |

**Available modifier keys**: ⌘ Command, ⌥ Option, ⌃ Control, ⇧ Shift

## Quick Start

### Step 1: Clone and Build
```bash
# Clone the repository
git clone https://github.com/sunnybharne/macdwm.git
cd macdwm

# Build the application
swift build --configuration release --disable-sandbox
```

### Step 2: Grant Accessibility Permissions
**This step is required for macdwm to work!**

1. **Open System Settings** (click the Apple menu → System Settings)
2. **Go to Privacy & Security** → **Accessibility**
3. **Click the + button** (plus icon)
4. **Navigate to and select**: `.build/release/macdwm` (from your cloned directory)
5. **Make sure the toggle is enabled** (should be green/checked)

### Step 3: Run macdwm
```bash
# Start macdwm directly from the build directory
./.build/release/macdwm
```

**You should see a terminal icon in your menu bar when it's running!**

### Step 4: Test It Works
1. **Click on any window** to focus it (like Finder, Safari, etc.)
2. **Press `Option+Ctrl+Left`** - the window should tile to the left half
3. **Press `Option+Ctrl+Right`** - the window should tile to the right half

If the window tiles, congratulations! macdwm is working.

### Step 5: Configure Your Hotkeys (Optional)
1. **Click the terminal icon** in your menu bar
2. **Select "Settings"** from the menu
3. **Choose your preferred modifier key** from the dropdown
4. **Assign apps to hotkeys 1-0** by selecting from the dropdown
5. **Available options**:
   - Regular apps: Firefox, iTerm, Cursor, VS Code, Teams, Safari, Chrome, etc.
   - Firefox tabs: Firefox Tab 1-6 (for specific tab switching)
   - None: Leave hotkey empty
6. **Test the new hotkeys** - changes take effect immediately!
7. **Settings are automatically saved** and restored on restart

**Perfect for different keyboards or avoiding conflicts with other apps!**

## Optional: System-Wide Installation

If you want to install macdwm system-wide (so you can run it from anywhere):

```bash
# Copy to system location (requires password)
sudo cp .build/release/macdwm /usr/local/bin/macdwm

# Then you can run it from anywhere with:
/usr/local/bin/macdwm
```

**Note**: If you install system-wide, make sure to grant Accessibility permissions to `/usr/local/bin/macdwm` instead of the local build path.

## Usage

- **Menu bar icon**: Look for the terminal icon in your menu bar
- **Settings access**: Click the icon to access settings and quit options
- **Window tiling**: Use `[Modifier]+Ctrl+Left/Right` to tile windows
- **App switching**: Use `[Modifier]+1-0` to launch/switch applications
- **Firefox tabs**: Use assigned Firefox Tab hotkeys for instant tab switching
- **Persistent settings**: All configurations are automatically saved
- **No restart required**: Hotkey changes take effect immediately

## Requirements

- **macOS 13.0 (Ventura) or later**
- **Xcode Command Line Tools** (for Swift compilation)
- **Swift 6.0+** (for building from source)
- **Accessibility permissions** (required for window management)
- **Firefox** (for Firefox tab switching features)

## Development

To build and run during development:

```bash
# Build in debug mode (faster compilation)
swift build

# Run the debug version
./.build/debug/macdwm

# Or build release version for better performance
swift build --configuration release --disable-sandbox
./.build/release/macdwm
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
3. **Most likely cause**: Missing Accessibility permissions for `.build/release/macdwm`

### Hotkeys not working
1. **Grant Accessibility permissions** (Step 3 above)
2. **Make sure the window is focused** before using tiling hotkeys
3. **Check for conflicts** in System Settings → Keyboard → Shortcuts
4. **Try a different modifier key** in Settings if current one conflicts with other apps

### "Failed to create event tap"
This means Accessibility permissions are not granted. Follow Step 3 above carefully.

### App launcher not working
Make sure the applications are installed in the expected locations:
- Firefox: Should be in Applications folder
- iTerm: Should be in Applications folder  
- Cursor: Should be in Applications folder
- VS Code: Should be in Applications folder
- Teams: Should be in Applications folder
