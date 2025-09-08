# macdwm

A minimal macOS tiling window manager inspired by dwm (Dynamic Window Manager).

[![Build Status](https://github.com/yourusername/macdwm/workflows/CI/badge.svg)](https://github.com/yourusername/macdwm/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)

## Features

- **Tiling Windows**: Tile focused windows to left/right halves
- **App Launcher**: Quick app switching with customizable hotkeys
- **Menu Bar Control**: Visual status indicator with toggle functionality
- **Lightweight**: Minimal resource usage, no system modifications
- **Accessibility-Based**: Uses macOS Accessibility APIs

## Quick Start

1. **Download** from [Releases](https://github.com/yourusername/macdwm/releases)
2. **Grant Permissions**: Enable Accessibility in System Settings
3. **Run**: Execute the binary and look for the terminal icon in menu bar
4. **Use**: Try `Cmd+Ctrl+Left/Right` to tile windows

## Hotkeys

| Hotkey | Action |
|--------|--------|
| `Cmd+Ctrl+Left` | Tile window to left half |
| `Cmd+Ctrl+Right` | Tile window to right half |
| `Cmd+1` | Activate Firefox |
| `Cmd+2` | Activate iTerm |
| `Cmd+3` | Activate Cursor |
| `Cmd+4` | Activate Visual Studio Code |
| `Cmd+5` | Activate Microsoft Teams |

## Installation

### Pre-built Binary
```bash
# Download from releases page
chmod +x macdwm
./macdwm
```

### Build from Source
```bash
git clone https://github.com/yourusername/macdwm.git
cd macdwm
swift build --configuration release
.build/release/macdwm
```

## Requirements

- macOS 13.0 (Ventura) or later
- Accessibility permissions
- Swift 6.1+ (for building from source)

## Documentation

- 📖 [Full Documentation](https://yourusername.github.io/macdwm/)
- 🚀 [Installation Guide](https://yourusername.github.io/macdwm/docs/v1.0.0/installation/)
- 📋 [Release Notes](https://yourusername.github.io/macdwm/releases/)
- 🤝 [Contributing](https://yourusername.github.io/macdwm/contributing/)

## Philosophy

macdwm brings the efficiency and keyboard-driven workflow of dwm to macOS, while respecting the platform's design principles. It provides essential tiling functionality without the complexity of full window manager replacement.

## Contributing

Contributions welcome! Please see our [Contributing Guide](https://yourusername.github.io/macdwm/contributing/) for details.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by [dwm](https://dwm.suckless.org/) - Dynamic Window Manager
- Built with Swift and macOS Accessibility APIs
- Icons from SF Symbols