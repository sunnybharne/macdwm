# macdwm

A minimal macOS tiling window manager. Because dragging windows around is for peasants.

## What is this thing?

macdwm is a window manager for macOS that actually makes sense. Inspired by dwm (Dynamic Window Manager), it brings the efficiency of keyboard-driven window management to macOS without the usual bloat.

If you're still using Mission Control to manage windows, you're doing it wrong.

## Features that matter

- **Window tiling**: `Cmd+Ctrl+Left/Right` to tile windows. No more guessing.
- **App launcher**: `Cmd+1-5` to switch between your most used apps. Because clicking is slow.
- **Menu bar indicator**: Shows which app you're currently focused on. No more wondering.
- **Lightweight**: Uses about 2MB of RAM. Your browser uses more for a single tab.
- **Accessibility-based**: Uses macOS APIs properly, unlike most "window managers" that just move windows around.

## Quick start (for impatient people)

1. Install with Homebrew: `brew tap sunnybharne/tap && brew install macdwm`
2. Give it Accessibility permissions (System Settings → Privacy & Security → Accessibility)
3. Run it: `macdwm`
4. Look for the terminal icon in your menu bar
5. Try `Cmd+Ctrl+Left` on a window. It should tile to the left half. If it doesn't, you probably didn't give it permissions.

## Hotkeys

### Window tiling
| Hotkey | What it does |
|--------|--------------|
| `Cmd+Ctrl+Left` | Tiles window to left half |
| `Cmd+Ctrl+Right` | Tiles window to right half |

### App launcher
| Hotkey | App |
|--------|-----|
| `Cmd+1` | Firefox |
| `Cmd+2` | iTerm |
| `Cmd+3` | Cursor |
| `Cmd+4` | VS Code |
| `Cmd+5` | Teams |

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
