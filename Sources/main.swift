import AppKit
import ApplicationServices

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

    init(windowManager: WindowManager, onAppNumberChange: @escaping (Int) -> Void) {
        self.windowManager = windowManager
        self.onAppNumberChange = onAppNumberChange
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
        let isCmd = flags.contains(.maskCommand)
        let isAlt = flags.contains(.maskAlternate)
        let isCtrl = flags.contains(.maskControl)
        let keycode = event.getIntegerValueField(.keyboardEventKeycode)
        // Cmd+1: activate Firefox
        if isCmd && !isAlt && keycode == 18 { // 18 = '1'
            if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "org.mozilla.firefox") {
                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
            }
            onAppNumberChange(1)
            return nil
        }
        // Cmd+2: activate iTerm
        if isCmd && !isAlt && keycode == 19 { // 19 = '2'
            if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.googlecode.iterm2") {
                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
            }
            onAppNumberChange(2)
            return nil
        }
        // Cmd+3: activate Cursor
        if isCmd && !isAlt && keycode == 20 { // 20 = '3'
            let appURL = URL(fileURLWithPath: "/Applications/Cursor.app")
            let config = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
            onAppNumberChange(3)
            return nil
        }
        // Cmd+4: activate Visual Studio Code
        if isCmd && !isAlt && keycode == 21 { // 21 = '4'
            let appURL = URL(fileURLWithPath: "/Applications/Visual Studio Code.app")
            let config = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
            onAppNumberChange(4)
            return nil
        }
        // Cmd+5: activate Microsoft Teams
        if isCmd && !isAlt && keycode == 23 { // 23 = '5'
            if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.microsoft.teams2") ??
                NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.microsoft.teams") {
                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.openApplication(at: appURL, configuration: config) { _, _ in }
            }
            onAppNumberChange(5)
            return nil
        }
        if isCmd && (isAlt || isCtrl) {
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
            keyTap = KeyEventTap(windowManager: windowManager) { [weak self] appNumber in
                self?.updateAppNumber(appNumber)
            }
        }
        keyTap?.start { $0 }
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
        let info = "Hotkeys:\n- Cmd+Ctrl+Left/Right: tile left/right\n- Cmd+1: Firefox\n- Cmd+2: iTerm\n- Cmd+3: Cursor\n- Cmd+4: VS Code\n- Cmd+5: Teams"
        let alert = NSAlert()
        alert.messageText = "macdwm Settings"
        alert.informativeText = info
        alert.addButton(withTitle: "OK")
        alert.runModal()
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

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppController()
app.delegate = delegate
app.run()
