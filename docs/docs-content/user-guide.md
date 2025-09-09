# User Guide

Complete guide to using macdwm. Read this if you want to actually understand what you're doing.

## Getting Started

### First Launch
1. Run macdwm for the first time
2. Look for the terminal icon in your menu bar
3. Click the icon to access the menu
4. Make sure "Enabled" is checked (it should be by default)

### Auto-Start Setup (Recommended)
macdwm is designed to run automatically when you log in. To set this up:

```bash
# From the macdwm project directory
./scripts/install-autostart.sh
```

This will:
- Install macdwm to `/usr/local/bin/macdwm`
- Set up automatic startup on login
- Start macdwm immediately

**Important**: After installation, you must grant Accessibility permissions:
1. Open System Settings → Privacy & Security → Accessibility
2. Click the + button and add `/usr/local/bin/macdwm`
3. Ensure the toggle is enabled (green)

### Manual Control
If you prefer to run macdwm manually:

```bash
# Start macdwm
macdwm

# Or from the project directory
.build/release/macdwm
```

### Menu Bar Controls
The menu bar icon gives you access to all macdwm features:

- **Enabled/Disabled**: Toggle to start/stop hotkey functionality
- **Settings**: View current hotkey configuration
- **About**: Display version information
- **Quit**: Exit the application

## Window Tiling

### Basic Tiling
macdwm provides two main tiling operations:

- **Left Half**: `Option+Ctrl+Left` - Tiles the focused window to the left half of the screen
- **Right Half**: `Option+Ctrl+Right` - Tiles the focused window to the right half of the screen

### How It Works
1. Focus any window (click on it or use Cmd+Tab)
2. Press the tiling hotkey
3. The window will resize and reposition to fill half the screen
4. The window maintains its aspect ratio and content

### Supported Applications
Tiling works with most macOS applications including:
- Web browsers (Safari, Chrome, Firefox)
- Text editors (VS Code, Cursor, Xcode)
- Terminal applications (Terminal, iTerm2)
- System applications (Finder, System Settings)

## App Launcher

### Quick App Switching
Use the app launcher hotkeys to instantly switch to or launch applications:

| Hotkey | Application | Bundle ID/Path |
|--------|-------------|----------------|
| `Option+1` | Firefox | `org.mozilla.firefox` |
| `Option+2` | iTerm | `com.googlecode.iterm2` |
| `Option+3` | Cursor | `/Applications/Cursor.app` |
| `Option+4` | VS Code | `/Applications/Visual Studio Code.app` |
| `Option+5` | Teams | `com.microsoft.teams2` |

### How App Launcher Works
1. Press the hotkey for your desired application
2. If the app is already running, it will be brought to the front
3. If the app is not running, it will be launched
4. The app window will be focused and ready to use

## Advanced Usage

### Combining Features
You can combine tiling and app launching for efficient workflows:

1. **Split Screen Coding**: 
   - Use `Option+3` to open Cursor
   - Use `Option+Ctrl+Left` to tile it left
   - Use `Option+2` to open iTerm
   - Use `Option+Ctrl+Right` to tile it right

2. **Documentation + Browser**:
   - Use `Option+1` to open Firefox
   - Use `Option+Ctrl+Left` to tile it left
   - Open documentation in another app
   - Use `Option+Ctrl+Right` to tile it right

### Window Focus Management
- Always ensure the target window is focused before tiling
- Use Cmd+Tab to switch between applications
- Click on windows to focus them before using tiling hotkeys

## Best Practices

### Workflow Optimization
1. **Consistent Setup**: Use the same applications for the same hotkeys
2. **Keyboard-First**: Minimize mouse usage for better efficiency
3. **Window Management**: Keep frequently used apps in predictable positions
4. **Regular Usage**: The more you use the hotkeys, the more natural they become

### System Integration
- macdwm works alongside existing macOS features
- No conflicts with Mission Control or Spaces
- Compatible with other window management tools
- Respects system accessibility settings

## Common Mistakes

### Not Focusing Windows
The most common mistake is trying to tile a window that isn't focused. Make sure you click on the window or use Cmd+Tab to focus it first.

### Permission Issues
If hotkeys aren't working, check that you've given macdwm Accessibility permissions. This is the most common cause of problems.

### App Not Found
If an app launcher hotkey doesn't work, the application might not be installed in the expected location. Check the bundle ID or path in the source code.

## Tips and Tricks

- Use the menu bar icon to quickly check if macdwm is enabled
- The app number in the menu bar shows which app you're currently focused on
- You can disable macdwm temporarily without quitting the application
- The settings dialog shows all available hotkeys for reference