# Installation

Step-by-step installation guide for macdwm. Follow these instructions exactly and you'll be tiling windows in minutes.

## Prerequisites

- **macOS 13.0 (Ventura) or later** - Check with `sw_vers`
- **Administrator access** - You'll need this for permissions

## Method 1: Pre-built Binary (Recommended)

This is the easiest and most reliable method. No GitHub access required.

### Step 1: Download the Binary

1. **Open your web browser** and go to: https://github.com/sunnybharne/macdwm/releases
2. **Find the latest release** (usually at the top)
3. **Click on the `macdwm` binary** to download it
4. **Save it to your Downloads folder** (default location)

### Step 2: Make it Executable

1. **Open Terminal** (Applications → Utilities → Terminal)
2. **Navigate to Downloads:**
   ```bash
   cd ~/Downloads
   ```
3. **Make the binary executable:**
   ```bash
   chmod +x macdwm
   ```
4. **Verify it worked:**
   ```bash
   ls -la macdwm
   ```
   You should see something like: `-rwxr-xr-x 1 username staff ... macdwm`

### Step 3: Grant Accessibility Permissions

**This is the most important step. Don't skip it.**

1. **Open System Settings:**
   - Click the Apple menu (🍎) in the top-left corner
   - Select "System Settings"

2. **Navigate to Privacy & Security:**
   - Click "Privacy & Security" in the sidebar
   - Click "Accessibility" in the main area

3. **Add macdwm:**
   - Click the **+** button (plus sign)
   - Navigate to your Downloads folder
   - Select the `macdwm` file
   - Click "Open"

4. **Enable the permission:**
   - Make sure the toggle next to `macdwm` is **enabled** (green)
   - If it's not green, click the toggle to enable it

### Step 4: Run macdwm

1. **In Terminal, run:**
   ```bash
   ./macdwm
   ```

2. **Look for the terminal icon:**
   - Check your menu bar (top-right area)
   - You should see a terminal icon
   - If you see it, macdwm is running!

3. **If you don't see the icon:**
   - Check the Terminal for error messages
   - Go back to Step 3 and make sure permissions are granted
   - Try running `./macdwm` again

### Step 5: Test It Works

1. **Click on any window** to focus it (like Finder, Safari, etc.)
2. **Press `Option+Ctrl+Left`** - the window should tile to the left half
3. **Press `Option+Ctrl+Right`** - the window should tile to the right half

If the window tiles, congratulations! macdwm is working.

## Method 2: Homebrew (Alternative)

Only use this if you have GitHub access and prefer Homebrew.

### Install with Homebrew
```bash
brew tap sunnybharne/tap
brew install macdwm
```

**Note**: If the tap command asks for GitHub authentication, use Method 1 instead.

### Grant permissions
Same as Method 1, Step 3, but add your terminal application instead of the macdwm binary.

### Run it
```bash
macdwm
```

## Method 3: Build from Source (For people who like pain)

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
2. **Test hotkeys**: Try `Option+Ctrl+Left` on a window
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