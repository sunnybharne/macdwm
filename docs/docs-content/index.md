# macdwm

A minimal macOS tiling window manager. Because dragging windows around is for peasants.

## What is this thing?

macdwm is a window manager for macOS that actually makes sense. Inspired by dwm (Dynamic Window Manager), it brings the efficiency of keyboard-driven window management to macOS without the usual bloat.

If you're still using Mission Control to manage windows, you're doing it wrong.

## Features that matter

- **Window tiling**: `Option+Ctrl+Left/Right` to tile windows. No more guessing.
- **App launcher**: `Option+1-5` to switch between your most used apps. Because clicking is slow.
- **Menu bar indicator**: Shows which app you're currently focused on. No more wondering.
- **Lightweight**: Uses about 2MB of RAM. Your browser uses more for a single tab.
- **Accessibility-based**: Uses macOS APIs properly, unlike most "window managers" that just move windows around.

## Quick start (for impatient people)

### Step 1: Download
- Go to [releases](https://github.com/sunnybharne/macdwm/releases)
- Download the latest `macdwm` binary
- Save to your Downloads folder

### Step 2: Make it executable
```bash
cd ~/Downloads
chmod +x macdwm
```

### Step 3: Grant permissions
- Open **System Settings** → **Privacy & Security** → **Accessibility**
- Click **+** button and add the `macdwm` file from Downloads
- Make sure the toggle is **enabled** (green)

### Step 4: Run it
```bash
./macdwm
```
- Look for terminal icon in menu bar
- If you see it, it's working!

### Step 5: Test it
- Click any window to focus it
- Press `Option+Ctrl+Left` - window should tile left
- Press `Option+Ctrl+Right` - window should tile right

**Alternative**: `brew tap sunnybharne/tap && brew install macdwm` (requires GitHub access)

**Manual start**: Run `./macdwm` whenever you want to use the window manager.

## Hotkeys

### Window tiling
| Hotkey | What it does |
|--------|--------------|
| `Option+Ctrl+Left` | Tiles window to left half |
| `Option+Ctrl+Right` | Tiles window to right half |

### App launcher
| Hotkey | App |
|--------|-----|
| `Option+1` | Firefox |
| `Option+2` | iTerm |
| `Option+3` | Cursor |
| `Option+4` | VS Code |
| `Option+5` | Teams |

## Requirements

- macOS 13.0 (Ventura) or later. No, it won't work on older versions.
- Accessibility permissions. This is non-negotiable.
- Swift 6.1+ (if building from source)

## Installation

### Pre-built binary (recommended)
```bash
chmod +x macdwm
./macdwm
```

### Build from source (for masochists)
```bash
git clone https://github.com/sunnybharne/macdwm.git
cd macdwm
swift build --configuration release
.build/release/macdwm
```

## Philosophy

macdwm follows the Unix philosophy: do one thing and do it well. It doesn't try to be everything to everyone. It just manages windows efficiently.

- **Simple**: No configuration files, no complex setup, no BS.
- **Fast**: Keyboard-driven workflow for people who value their time.
- **Compatible**: Works with existing macOS features instead of fighting them.
- **Minimal**: Small, focused, and doesn't get in your way.

## Links

- [GitHub Repository](https://github.com/sunnybharne/macdwm)
- [Releases](https://github.com/sunnybharne/macdwm/releases)
- [Issues](https://github.com/sunnybharne/macdwm/issues) (if you find bugs, report them)
