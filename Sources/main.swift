import AppKit
import ApplicationServices

enum ModifierKey: String, CaseIterable {
    case command = "Command"
    case option = "Option"
    case control = "Control"
    case shift = "Shift"
    
    var flag: CGEventFlags {
        switch self {
        case .command: return .maskCommand
        case .option: return .maskAlternate
        case .control: return .maskControl
        case .shift: return .maskShift
        }
    }
    
    var displayName: String {
        switch self {
        case .command: return "⌘ Command"
        case .option: return "⌥ Option"
        case .control: return "⌃ Control"
        case .shift: return "⇧ Shift"
        }
    }
}

struct AppConfiguration {
    let name: String
    let bundleIdentifier: String?
    let appPath: String?
    let isEnabled: Bool
    
    init(name: String, bundleIdentifier: String? = nil, appPath: String? = nil, isEnabled: Bool = true) {
        self.name = name
        self.bundleIdentifier = bundleIdentifier
        self.appPath = appPath
        self.isEnabled = isEnabled
    }
    
    static let empty = AppConfiguration(name: "None", isEnabled: false)
    
    static let defaults: [AppConfiguration] = [
        AppConfiguration(name: "Firefox", bundleIdentifier: "org.mozilla.firefox"),
        AppConfiguration(name: "iTerm", bundleIdentifier: "com.googlecode.iterm2"),
        AppConfiguration(name: "Cursor", appPath: "/Applications/Cursor.app"),
        AppConfiguration(name: "VS Code", appPath: "/Applications/Visual Studio Code.app"),
        AppConfiguration(name: "Teams", bundleIdentifier: "com.microsoft.teams2"),
        AppConfiguration.empty, // 6 - empty by default
        AppConfiguration.empty, // 7 - empty by default
        AppConfiguration.empty, // 8 - empty by default
        AppConfiguration.empty, // 9 - empty by default
        AppConfiguration.empty  // 0 - empty by default
    ]
}

@MainActor
final class AccessibilityManager {
    static func ensureTrusted(prompt: Bool) -> Bool {
        // Use non-prompting check to avoid Swift concurrency issues with CF global var.
        // User can enable in System Settings > Privacy & Security > Accessibility.
        return AXIsProcessTrusted()
    }
}

final class KeyEventTap {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let windowManager: WindowManager
    private let onAppNumberChange: (Int) -> Void
    private var modifierKey: ModifierKey
    private var appConfigurations: [AppConfiguration]

    init(windowManager: WindowManager, onAppNumberChange: @escaping (Int) -> Void, modifierKey: ModifierKey = .option, appConfigurations: [AppConfiguration] = AppConfiguration.defaults) {
        self.windowManager = windowManager
        self.onAppNumberChange = onAppNumberChange
        self.modifierKey = modifierKey
        self.appConfigurations = appConfigurations
    }
    
    func updateModifierKey(_ newModifierKey: ModifierKey) {
        self.modifierKey = newModifierKey
    }
    
    func updateAppConfigurations(_ newConfigurations: [AppConfiguration]) {
        self.appConfigurations = newConfigurations
    }

    func start(handler: @escaping (CGEvent) -> CGEvent?) {
        let mask = (1 << CGEventType.keyDown.rawValue)
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: { (_, type, event, userInfo) -> Unmanaged<CGEvent>? in
                guard type == .keyDown else { return Unmanaged.passRetained(event) }
                guard let userInfo = userInfo else { return Unmanaged.passRetained(event) }
                let tapSelf = Unmanaged<KeyEventTap>.fromOpaque(userInfo).takeUnretainedValue()
                if let processed = tapSelf.handle(event: event) {
                    return Unmanaged.passRetained(processed)
                }
                return Unmanaged.passRetained(event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        ) else {
            print("Failed to create event tap. Ensure Accessibility permissions are granted.")
            return
        }
        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        if let source = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        CGEvent.tapEnable(tap: tap, enable: true)
    }

    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        runLoopSource = nil
        if let tap = eventTap {
            CFMachPortInvalidate(tap)
        }
        eventTap = nil
    }

    private func handle(event: CGEvent) -> CGEvent? {
        let flags = event.flags
        let isCtrl = flags.contains(.maskControl)
        let keycode = event.getIntegerValueField(.keyboardEventKeycode)
        
        // Check if the current modifier key is pressed
        let isModifierPressed = flags.contains(modifierKey.flag)
        
        // App switching hotkeys (Modifier+1-0)
        let appKeycodes = [18, 19, 20, 21, 23, 22, 26, 28, 25, 29] // 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
        for (index, appKeycode) in appKeycodes.enumerated() {
            if isModifierPressed && keycode == appKeycode {
                let appIndex = index + 1
                if appIndex <= appConfigurations.count {
                    let appConfig = appConfigurations[appIndex - 1]
                    if appConfig.isEnabled {
                        launchApplication(appConfig)
                        onAppNumberChange(appIndex)
                    }
                    // If not enabled (empty), do nothing - just return nil to consume the event
                }
                return nil
            }
        }
        
        // Window tiling hotkeys (Modifier+Ctrl+Left/Right)
        if isModifierPressed && isCtrl {
            switch keycode {
            case 123: // left arrow
                windowManager.tileFocusedWindowLeftHalf()
                return nil
            case 124: // right arrow
                windowManager.tileFocusedWindowRightHalf()
                return nil
            default:
                break
            }
        }
        return event
    }
    
    private func launchApplication(_ appConfig: AppConfiguration) {
        guard appConfig.isEnabled else { return }
        
        let config = NSWorkspace.OpenConfiguration()
        
        if let bundleId = appConfig.bundleIdentifier {
            // Try bundle identifier first
            if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) {
                NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
                return
            }
        }
        
        if let appPath = appConfig.appPath {
            // Try direct path
            let appURL = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
            return
        }
        
        // Fallback: try to find by name
        if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: appConfig.name) {
            NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
        }
    }
}

final class WindowManager {
    func tileFocusedWindowLeftHalf() {
        guard let screen = NSScreen.main else { return }
        let frame = screen.visibleFrame
        let target = CGRect(x: frame.minX, y: frame.minY, width: frame.width / 2, height: frame.height)
        moveFocusedWindow(to: target)
    }

    func tileFocusedWindowRightHalf() {
        guard let screen = NSScreen.main else { return }
        let frame = screen.visibleFrame
        let target = CGRect(x: frame.minX + frame.width / 2, y: frame.minY, width: frame.width / 2, height: frame.height)
        moveFocusedWindow(to: target)
    }

    private func moveFocusedWindow(to frame: CGRect) {
        guard let app = NSWorkspace.shared.frontmostApplication else { return }
        let pid = app.processIdentifier
        let appElem = AXUIElementCreateApplication(pid)

        var focused: CFTypeRef?
        if AXUIElementCopyAttributeValue(appElem, kAXFocusedWindowAttribute as CFString, &focused) == .success, let anyRef = focused {
            if CFGetTypeID(anyRef) == AXUIElementGetTypeID() {
                let window = anyRef as! AXUIElement
                let position = frame.origin
                let size = frame.size
                if let posVal = axValue(fromPoint: position), let sizeVal = axValue(fromSize: size) {
                    AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posVal)
                    AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeVal)
                }
            }
        }
    }
}

@inline(__always)
func axValue(fromPoint point: CGPoint) -> AXValue? {
    var p = point
    return AXValueCreate(.cgPoint, &p)
}

@inline(__always)
func axValue(fromSize size: CGSize) -> AXValue? {
    var s = size
    return AXValueCreate(.cgSize, &s)
}

@MainActor
final class SettingsWindow: NSWindowController {
    private var modifierKeyPopUp: NSPopUpButton!
    private var appPopUps: [NSPopUpButton] = []
    private var onModifierKeyChanged: (ModifierKey) -> Void
    private var onAppConfigurationsChanged: ([AppConfiguration]) -> Void
    private var currentModifierKey: ModifierKey
    private var currentAppConfigurations: [AppConfiguration]
    
    init(currentModifierKey: ModifierKey, currentAppConfigurations: [AppConfiguration], onModifierKeyChanged: @escaping (ModifierKey) -> Void, onAppConfigurationsChanged: @escaping ([AppConfiguration]) -> Void) {
        self.currentModifierKey = currentModifierKey
        self.currentAppConfigurations = currentAppConfigurations
        self.onModifierKeyChanged = onModifierKeyChanged
        self.onAppConfigurationsChanged = onAppConfigurationsChanged
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "macdwm Settings"
        window.center()
        window.isReleasedWhenClosed = false
        
        super.init(window: window)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        guard let contentView = window?.contentView else { return }
        
        let scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.alignment = .leading
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Modifier Key Selection
        let modifierKeyLabel = NSTextField(labelWithString: "Modifier Key:")
        modifierKeyLabel.font = NSFont.systemFont(ofSize: 14, weight: .medium)
        
        modifierKeyPopUp = NSPopUpButton()
        modifierKeyPopUp.translatesAutoresizingMaskIntoConstraints = false
        modifierKeyPopUp.target = self
        modifierKeyPopUp.action = #selector(modifierKeyChanged)
        
        for key in ModifierKey.allCases {
            modifierKeyPopUp.addItem(withTitle: key.displayName)
        }
        
        // Set current selection
        if let index = ModifierKey.allCases.firstIndex(of: currentModifierKey) {
            modifierKeyPopUp.selectItem(at: index)
        }
        
        // Application Configuration
        let appsLabel = NSTextField(labelWithString: "Application Configuration:")
        appsLabel.font = NSFont.systemFont(ofSize: 14, weight: .medium)
        
        // Create app selection popups
        let appNames = ["None", "Firefox", "iTerm", "Cursor", "VS Code", "Teams", "Safari", "Chrome", "Terminal", "Finder", "Mail", "Messages", "Slack", "Discord", "Spotify", "Other..."]
        
        for i in 0..<10 {
            let appLabel = NSTextField(labelWithString: "\(i + 1):")
            appLabel.font = NSFont.systemFont(ofSize: 12, weight: .medium)
            appLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let appPopUp = NSPopUpButton()
            appPopUp.translatesAutoresizingMaskIntoConstraints = false
            appPopUp.target = self
            appPopUp.action = #selector(appConfigurationChanged)
            appPopUp.tag = i
            
            for appName in appNames {
                appPopUp.addItem(withTitle: appName)
            }
            
            // Set current selection
            if i < currentAppConfigurations.count {
                let currentApp = currentAppConfigurations[i]
                if !currentApp.isEnabled {
                    appPopUp.selectItem(at: 0) // "None"
                } else if let index = appNames.firstIndex(of: currentApp.name) {
                    appPopUp.selectItem(at: index)
                } else {
                    appPopUp.selectItem(at: appNames.count - 1) // "Other..."
                }
            }
            
            appPopUps.append(appPopUp)
            
            let appStack = NSStackView()
            appStack.orientation = .horizontal
            appStack.spacing = 10
            appStack.addArrangedSubview(appLabel)
            appStack.addArrangedSubview(appPopUp)
            
            stackView.addArrangedSubview(appStack)
        }
        
        // Hotkeys Info
        let hotkeysLabel = NSTextField(labelWithString: "Current Hotkeys:")
        hotkeysLabel.font = NSFont.systemFont(ofSize: 14, weight: .medium)
        
        let hotkeysText = NSTextField(labelWithString: "• [Modifier]+1-0: Switch applications (6-0 empty by default)\n• [Modifier]+Ctrl+Left/Right: Tile windows")
        hotkeysText.font = NSFont.systemFont(ofSize: 12)
        hotkeysText.isEditable = false
        hotkeysText.isBordered = false
        hotkeysText.backgroundColor = .clear
        
        // Add to stack view
        stackView.addArrangedSubview(modifierKeyLabel)
        stackView.addArrangedSubview(modifierKeyPopUp)
        stackView.addArrangedSubview(NSBox()) // Spacer
        stackView.addArrangedSubview(appsLabel)
        for popup in appPopUps {
            stackView.addArrangedSubview(popup.superview!)
        }
        stackView.addArrangedSubview(NSBox()) // Spacer
        stackView.addArrangedSubview(hotkeysLabel)
        stackView.addArrangedSubview(hotkeysText)
        
        scrollView.documentView = stackView
        contentView.addSubview(scrollView)
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    @objc private func modifierKeyChanged() {
        let selectedIndex = modifierKeyPopUp.indexOfSelectedItem
        if selectedIndex >= 0 && selectedIndex < ModifierKey.allCases.count {
            let newModifierKey = ModifierKey.allCases[selectedIndex]
            currentModifierKey = newModifierKey
            onModifierKeyChanged(newModifierKey)
        }
    }
    
    @objc private func appConfigurationChanged() {
        let appNames = ["None", "Firefox", "iTerm", "Cursor", "VS Code", "Teams", "Safari", "Chrome", "Terminal", "Finder", "Mail", "Messages", "Slack", "Discord", "Spotify", "Other..."]
        var newConfigurations: [AppConfiguration] = []
        
        for popup in appPopUps {
            let selectedIndex = popup.indexOfSelectedItem
            if selectedIndex >= 0 && selectedIndex < appNames.count {
                let appName = appNames[selectedIndex]
                let configuration = createAppConfiguration(for: appName)
                newConfigurations.append(configuration)
            }
        }
        
        currentAppConfigurations = newConfigurations
        onAppConfigurationsChanged(newConfigurations)
    }
    
    private func createAppConfiguration(for appName: String) -> AppConfiguration {
        switch appName {
        case "None":
            return AppConfiguration.empty
        case "Firefox":
            return AppConfiguration(name: "Firefox", bundleIdentifier: "org.mozilla.firefox")
        case "iTerm":
            return AppConfiguration(name: "iTerm", bundleIdentifier: "com.googlecode.iterm2")
        case "Cursor":
            return AppConfiguration(name: "Cursor", appPath: "/Applications/Cursor.app")
        case "VS Code":
            return AppConfiguration(name: "VS Code", appPath: "/Applications/Visual Studio Code.app")
        case "Teams":
            return AppConfiguration(name: "Teams", bundleIdentifier: "com.microsoft.teams2")
        case "Safari":
            return AppConfiguration(name: "Safari", bundleIdentifier: "com.apple.Safari")
        case "Chrome":
            return AppConfiguration(name: "Chrome", bundleIdentifier: "com.google.Chrome")
        case "Terminal":
            return AppConfiguration(name: "Terminal", bundleIdentifier: "com.apple.Terminal")
        case "Finder":
            return AppConfiguration(name: "Finder", bundleIdentifier: "com.apple.finder")
        case "Mail":
            return AppConfiguration(name: "Mail", bundleIdentifier: "com.apple.mail")
        case "Messages":
            return AppConfiguration(name: "Messages", bundleIdentifier: "com.apple.iChat")
        case "Slack":
            return AppConfiguration(name: "Slack", bundleIdentifier: "com.tinyspeck.slackmacgap")
        case "Discord":
            return AppConfiguration(name: "Discord", bundleIdentifier: "com.hnc.Discord")
        case "Spotify":
            return AppConfiguration(name: "Spotify", bundleIdentifier: "com.spotify.client")
        default:
            return AppConfiguration(name: appName)
        }
    }
    
    func showWindow() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

// Entry
if !AccessibilityManager.ensureTrusted(prompt: true) {
    print("Waiting for Accessibility permission… Re-run after granting in System Settings > Privacy & Security > Accessibility.")
}

@MainActor
final class AppController: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let windowManager = WindowManager()
    private var keyTap: KeyEventTap?
    private var isEnabled: Bool = true
    private var currentAppNumber: Int = 0
    private var currentModifierKey: ModifierKey = .option
    private var currentAppConfigurations: [AppConfiguration] = AppConfiguration.defaults
    private var settingsWindow: SettingsWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        startTapIfNeeded()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.imagePosition = .imageOnly
        let menu = NSMenu()
        menu.addItem(withTitle: "Enabled", action: #selector(toggleEnabled), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Settings", action: #selector(showSettings), keyEquivalent: "")
        menu.addItem(withTitle: "About", action: #selector(showAbout), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        statusItem.menu = menu
        updateMenuState()
    }

    private func updateMenuState() {
        if isEnabled && currentAppNumber > 0 {
            // Show the terminal icon with number
            let symbolName = "terminal"
            if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "macdwm") {
                image.isTemplate = true
                statusItem.button?.image = image
                statusItem.button?.title = " \(currentAppNumber)"
            } else {
                statusItem.button?.image = nil
                statusItem.button?.title = " \(currentAppNumber)"
            }
        } else {
            // Show the terminal icon
            let symbolName = isEnabled ? "terminal" : "terminal.circle"
            if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "macdwm") {
                image.isTemplate = true
                statusItem.button?.image = image
                statusItem.button?.title = ""
            } else {
                statusItem.button?.image = nil
                statusItem.button?.title = ""
            }
        }
        if let first = statusItem.menu?.items.first {
            first.title = isEnabled ? "Enabled ✓" : "Enabled ✗"
        }
    }
    
    
    private func updateAppNumber(_ appNumber: Int) {
        currentAppNumber = appNumber
        updateMenuState()
    }

    private func startTapIfNeeded() {
        guard isEnabled else { return }
        if keyTap == nil {
            keyTap = KeyEventTap(windowManager: windowManager, onAppNumberChange: { [weak self] appNumber in
                self?.updateAppNumber(appNumber)
            }, modifierKey: currentModifierKey, appConfigurations: currentAppConfigurations)
        }
        keyTap?.start { $0 }
    }
    
    private func updateModifierKey(_ newModifierKey: ModifierKey) {
        currentModifierKey = newModifierKey
        keyTap?.updateModifierKey(newModifierKey)
    }
    
    private func updateAppConfigurations(_ newConfigurations: [AppConfiguration]) {
        currentAppConfigurations = newConfigurations
        keyTap?.updateAppConfigurations(newConfigurations)
    }

    private func stopTap() {
        keyTap?.stop()
    }

    @objc private func toggleEnabled() {
        isEnabled.toggle()
        if isEnabled {
            startTapIfNeeded()
        } else {
            stopTap()
        }
        updateMenuState()
    }

    @objc private func showSettings() {
        if settingsWindow == nil {
            settingsWindow = SettingsWindow(currentModifierKey: currentModifierKey, currentAppConfigurations: currentAppConfigurations, onModifierKeyChanged: { [weak self] newModifierKey in
                self?.updateModifierKey(newModifierKey)
            }, onAppConfigurationsChanged: { [weak self] newConfigurations in
                self?.updateAppConfigurations(newConfigurations)
            })
        }
        settingsWindow?.showWindow()
    }

    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "macdwm"
        alert.informativeText = "Lightweight tiling and app launcher"
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

// Singleton check - prevent multiple instances (temporarily disabled for debugging)
// let lockFile = FileManager.default.temporaryDirectory.appendingPathComponent("macdwm.lock")
// let lockFileURL = lockFile

// Try to create lock file (exclusive creation)
// let lockFileHandle = try? FileHandle(forWritingTo: lockFileURL)
// if lockFileHandle == nil {
//     // Lock file doesn't exist, create it
//     FileManager.default.createFile(atPath: lockFileURL.path, contents: nil, attributes: nil)
// } else {
//     // Lock file exists, another instance is running
//     print("macdwm is already running. Exiting.")
//     exit(1)
// }

// Clean up lock file on exit
// defer {
//     try? FileManager.default.removeItem(at: lockFileURL)
// }

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppController()
app.delegate = delegate
app.run()
