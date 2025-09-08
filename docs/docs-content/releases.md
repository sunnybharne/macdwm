# Releases

Download the latest version of macdwm or browse previous releases.

## Latest Release

### v1.0.0 - Initial Release
**Released:** December 2024

#### Features
- Basic window tiling (left/right halves)
- App launcher hotkeys (Cmd+1-5)
- Menu bar status indicator with app number tracking
- Toggle on/off functionality
- Settings and About dialogs

#### Hotkeys
- `Cmd+Ctrl+Left/Right`: Tile windows
- `Cmd+1`: Firefox
- `Cmd+2`: iTerm  
- `Cmd+3`: Cursor
- `Cmd+4`: VS Code
- `Cmd+5`: Teams

#### Download
- [macdwm v1.0.0](https://github.com/sunnybharne/macdwm/releases/download/v1.0.0/macdwm) - Universal binary

#### Installation
1. Download the binary
2. Make executable: `chmod +x macdwm`
3. Grant Accessibility permissions in System Settings
4. Run: `./macdwm`

---

## Previous Releases

### Development Builds
- [v0.9.0-beta](https://github.com/sunnybharne/macdwm/releases/tag/v0.9.0-beta) - Beta release with core tiling
- [v0.8.0-alpha](https://github.com/sunnybharne/macdwm/releases/tag/v0.8.0-alpha) - Alpha release with basic hotkeys

---

## Release Notes

### v1.0.0 (Current)
- **New**: Complete rewrite with menu bar integration
- **New**: App launcher functionality
- **New**: Visual status indicator with app number tracking
- **Fixed**: Accessibility permission handling
- **Improved**: Event tap stability

### v0.9.0-beta
- **New**: Basic window tiling
- **New**: Global hotkey support
- **Fixed**: Memory leaks in event handling

### v0.8.0-alpha
- **New**: Initial Swift implementation
- **New**: Basic event tap functionality
- **Known Issues**: Occasional crashes on permission changes

---

## Building from Source

```bash
git clone https://github.com/sunnybharne/macdwm.git
cd macdwm
swift build --configuration release
```

## System Requirements

- macOS 13.0 (Ventura) or later
- Accessibility permissions
- No additional dependencies required