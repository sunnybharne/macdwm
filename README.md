# macdwm

A minimal macOS tiling window manager inspired by dwm (Dynamic Window Manager).

[![Build Status](https://github.com/sunnybharne/macdwm/workflows/CI/badge.svg)](https://github.com/sunnybharne/macdwm/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)

## Features

- **Tiling Windows**: Tile focused windows to left/right halves
- **App Launcher**: Quick app switching with customizable hotkeys
- **Menu Bar Control**: Visual status indicator with toggle functionality
- **Lightweight**: Minimal resource usage, no system modifications
- **Accessibility-Based**: Uses macOS Accessibility APIs

## Quick Start

### Method 1: Pre-built Binary (Recommended)

1. **Download the binary:**
   - Go to [Releases](https://github.com/sunnybharne/macdwm/releases)
   - Download the latest `macdwm` binary
   - Save it to your Downloads folder

2. **Make it executable:**
   ```bash
   cd ~/Downloads
   chmod +x macdwm
   ```

3. **Grant Accessibility permissions:**
   - Open **System Settings** (Apple menu → System Settings)
   - Go to **Privacy & Security** → **Accessibility**
   - Click the **+** button
   - Navigate to your Downloads folder and select **macdwm**
   - Make sure the toggle is **enabled** (green)

4. **Run macdwm:**
   ```bash
   ./macdwm
   ```
   - Look for a terminal icon in your menu bar
   - If you see it, macdwm is running!

5. **Test it:**
   - Click on any window to focus it
   - Press `Option+Ctrl+Left` - the window should tile to the left half
   - Press `Option+Ctrl+Right` - the window should tile to the right half

### Method 2: Homebrew (Alternative)

```bash
brew tap sunnybharne/tap
brew install macdwm
```

**Note**: This requires GitHub access. If your company restricts GitHub, use Method 1 instead.

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

### Pre-built Binary
```bash
# Download from releases page
chmod +x macdwm
./macdwm
```
an
### Build from Source
```bash
git clone https://github.com/sunnybharne/macdwm.git
cd macdwm
swift build --configuration release
.build/release/macdwm
```

## Requirements

- macOS 13.0 (Ventura) or later
- Accessibility permissions
- Swift 6.1+ (for building from source)

## Documentation

- 📖 [Full Documentation](https://sunnybharne.github.io/macdwm/)
- 🚀 [Installation Guide](https://sunnybharne.github.io/macdwm/installation/)
- 📋 [Release Notes](https://sunnybharne.github.io/macdwm/releases/)
- 🤝 [Contributing](https://sunnybharne.github.io/macdwm/contributing/)

## Philosophy

macdwm brings the efficiency and keyboard-driven workflow of dwm to macOS, while respecting the platform's design principles. It provides essential tiling functionality without the complexity of full window manager replacement.

## Contributing

Contributions welcome! Please see our [Contributing Guide](https://sunnybharne.github.io/macdwm/contributing/) for details.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by [dwm](https://dwm.suckless.org/) - Dynamic Window Manager
- Built with Swift and macOS Accessibility APIs
- Icons from SF Symbols