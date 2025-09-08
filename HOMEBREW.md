# Homebrew Distribution

This document explains how to distribute macdwm via Homebrew.

## Setup Process

### 1. Create a Release

First, create a release on GitHub:

```bash
# Tag the release
git tag v1.0.0
git push origin v1.0.0

# Create a release on GitHub (or use GitHub CLI)
gh release create v1.0.0 --title "macdwm v1.0.0" --notes "Initial release"
```

### 2. Set Up Homebrew Tap

Run the setup script:

```bash
./scripts/setup-homebrew.sh 1.0.0
```

This will:
- Create a `homebrew-tap` repository
- Copy the formula to the tap
- Calculate the SHA256 for your release
- Update the formula with the correct checksum

### 3. Publish the Tap

```bash
cd ../homebrew-tap
git add macdwm.rb
git commit -m "Add macdwm v1.0.0"
git push origin main
```

### 4. Test Installation

Users can now install with:

```bash
brew tap sunnybharne/tap
brew install macdwm
```

Or in one command:

```bash
brew install sunnybharne/tap/macdwm
```

## Formula Details

The Homebrew formula (`Formula/macdwm.rb`) includes:

- **Dependencies**: macOS and Swift build tools
- **Build Process**: Uses `swift build --configuration release`
- **Installation**: Installs the binary to `/usr/local/bin/`
- **Caveats**: Reminds users about Accessibility permissions
- **Test**: Basic binary existence and executable checks

## Updating for New Releases

For each new release:

1. Create a new GitHub release
2. Run `./scripts/setup-homebrew.sh <version>`
3. Update the tap repository
4. Push changes

## Future: Homebrew Core

To submit to the official Homebrew repository:

1. Fork the [homebrew-core](https://github.com/Homebrew/homebrew-core) repository
2. Copy your formula to `Formula/macdwm.rb`
3. Submit a pull request
4. Follow Homebrew's contribution guidelines

This requires:
- At least 30 stars on GitHub
- Stable, well-maintained software
- Proper documentation
- No security issues

## Benefits of Homebrew Distribution

- **Easy Installation**: One command installation
- **Automatic Updates**: Users can update with `brew upgrade`
- **Dependency Management**: Homebrew handles Swift dependencies
- **Professional**: Shows the project is well-maintained
- **Discoverability**: Users can find it with `brew search`
