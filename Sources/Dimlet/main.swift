import AppKit
import CoreGraphics
import DimletCore

final class BlackView: NSView {
    var reveal: (() -> Void)?
    override func mouseDown(with event: NSEvent) { reveal?() }
    override func rightMouseDown(with event: NSEvent) { reveal?() }
}

final class BlackPanel: NSPanel {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panels: [NSPanel] = []
    private var statusItem: NSStatusItem!
    private var toggleItem: NSMenuItem!
    private var displayCountItem: NSMenuItem!
    private var awakeItem: NSMenuItem!
    private var language = AppLanguage.load()
    private var languageItem: NSMenuItem!
    private var languageChoices: [NSMenuItem] = []
    private var aboutItem: NSMenuItem!
    private var quitItem: NSMenuItem!
    private var enabled = false
    private var macAssertion: Process?
    private var displayAssertion: Process?
    private var awakeIcon: NSImage?
    private var sleepyIcon: NSImage?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        awakeIcon = loadIcon("menubar-off")
        sleepyIcon = loadIcon("menubar-on")
        let menu = NSMenu()
        toggleItem = NSMenuItem(
            title: language.text(.toggle),
            action: #selector(toggle), keyEquivalent: ""
        )
        toggleItem.target = self
        menu.addItem(toggleItem)
        displayCountItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menu.addItem(displayCountItem)
        menu.addItem(.separator())
        awakeItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menu.addItem(awakeItem)
        languageItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        let languages = NSMenu()
        for choice in AppLanguage.allCases {
            let item = NSMenuItem(title: choice.nativeName, action: #selector(selectLanguage(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = choice.rawValue
            languages.addItem(item)
            languageChoices.append(item)
        }
        languageItem.submenu = languages
        menu.addItem(languageItem)
        aboutItem = NSMenuItem(title: "", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        quitItem = NSMenuItem(title: "", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        statusItem.menu = menu

        NotificationCenter.default.addObserver(self, selector: #selector(rebuild), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(rebuild), name: NSWorkspace.didWakeNotification, object: nil)
        macAssertion = preventSleep("-i")
        refreshLanguage()
        setBlackout(CommandLine.arguments.contains("--blackout-on"))

        if CommandLine.arguments.contains("--smoke-test") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.smokeTest() }
        }
    }

    @objc private func selectLanguage(_ sender: NSMenuItem) {
        guard let code = sender.representedObject as? String,
              let selected = AppLanguage(rawValue: code) else { return }
        language = selected
        language.save()
        refreshLanguage()
    }

    private func refreshLanguage() {
        toggleItem.title = language.text(.toggle)
        // Keep "Language" recognizable if someone chooses an unfamiliar language.
        languageItem.title = language == .english ? "Language" : "\(language.text(.language)) / Language"
        languageItem.submenu?.title = languageItem.title
        for item in languageChoices {
            item.state = (item.representedObject as? String) == language.rawValue ? .on : .off
        }
        aboutItem.title = language.text(.about)
        quitItem.title = language.text(.quit)
        awakeItem.title = language.text(macAssertion?.isRunning == true ? .awake : .awakeFailed)
        refreshStatusLabel()
        refreshDisplayCount()
        // Only text changes: keep overlays and sleep assertions alive without flicker.
        panels.forEach { $0.contentView?.setAccessibilityLabel(language.text(.reveal)) }
    }

    private func refreshStatusLabel() {
        let label = language.text(enabled ? .blackoutOn : .blackoutOff)
        statusItem.button?.toolTip = label
        statusItem.button?.setAccessibilityLabel(label)
    }

    private func refreshDisplayCount() {
        let screens = screensAndDescriptors().map { $0.1 }
        displayCountItem.title = screens.contains { $0.isMirrored }
            ? language.text(.mirrored)
            : language.displayCount(DisplayPolicy.targets(in: screens, enabled: true).count)
    }

    private func loadIcon(_ name: String) -> NSImage? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "svg"),
              let image = NSImage(contentsOf: url) else { return nil }
        image.size = NSSize(width: 22, height: 22)
        image.isTemplate = true
        return image
    }

    private func preventSleep(_ option: String) -> Process? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        // The assertion also exits if Dimlet crashes or is force-quit.
        process.arguments = [option, "-w", String(ProcessInfo.processInfo.processIdentifier)]
        do { try process.run(); return process }
        catch { NSLog("Unable to start sleep prevention: %@", error.localizedDescription); return nil }
    }

    private func stop(_ process: Process?) {
        if let process = process, process.isRunning { process.terminate() }
    }

    @objc private func toggle() { setBlackout(!enabled) }

    private func setBlackout(_ value: Bool) {
        enabled = value
        toggleItem.state = value ? .on : .off
        let fallback = NSImage(systemSymbolName: value ? "moon.fill" : "display", accessibilityDescription: "Dimlet")
        statusItem.button?.image = (value ? sleepyIcon : awakeIcon) ?? fallback
        refreshStatusLabel()
        if value {
            if displayAssertion == nil { displayAssertion = preventSleep("-d") }
        } else {
            stop(displayAssertion)
            displayAssertion = nil
        }
        rebuild()
    }

    private func screensAndDescriptors() -> [(NSScreen, DisplayDescriptor)] {
        NSScreen.screens.compactMap { screen in
            guard let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber else { return nil }
            let id = CGDirectDisplayID(number.uint32Value)
            return (screen, DisplayDescriptor(id: id, isBuiltIn: CGDisplayIsBuiltin(id) != 0, isMirrored: CGDisplayIsInMirrorSet(id) != 0))
        }
    }

    @objc private func rebuild() {
        panels.forEach { $0.close() }
        panels.removeAll()
        let screens = screensAndDescriptors()
        refreshDisplayCount()
        let ids = Set(DisplayPolicy.targets(in: screens.map { $0.1 }, enabled: enabled))
        for (screen, descriptor) in screens where ids.contains(descriptor.id) {
            let panel = BlackPanel(contentRect: screen.frame, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: false)
            panel.isReleasedWhenClosed = false
            panel.hidesOnDeactivate = false
            panel.backgroundColor = .black
            panel.isOpaque = true
            panel.hasShadow = false
            panel.level = .screenSaver
            panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
            let view = BlackView(frame: NSRect(origin: .zero, size: screen.frame.size))
            view.reveal = { [weak self] in self?.setBlackout(false) }
            view.setAccessibilityLabel(language.text(.reveal))
            panel.contentView = view
            panel.setFrame(screen.frame, display: true)
            panel.orderFrontRegardless()
            panels.append(panel)
        }
    }

    @objc private func showAbout() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = "Dimlet"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "dev"
        alert.informativeText = language.about(version: version)
        alert.addButton(withTitle: language.text(.done))
        alert.addButton(withTitle: "GitHub")
        if alert.runModal() == .alertSecondButtonReturn,
           let url = URL(string: "https://github.com/onodela2000/dimlet") { NSWorkspace.shared.open(url) }
    }

    private func smokeTest() {
        // Runs against the current screens, then restores them before exiting.
        precondition(awakeIcon != nil && sleepyIcon != nil, "Bundled SVG icons must load")
        precondition(macAssertion?.isRunning == true, "Mac idle-sleep assertion must exist")
        setBlackout(true)
        let screens = screensAndDescriptors()
        let expected = DisplayPolicy.targets(in: screens.map { $0.1 }, enabled: true)
        precondition(panels.count == expected.count, "Every eligible external display needs an overlay")
        precondition(toggleItem.state == .on && displayAssertion?.isRunning == true)
        for (screen, descriptor) in screens where descriptor.isBuiltIn {
            precondition(!panels.contains { $0.frame == screen.frame }, "The built-in display must never be covered")
        }
        let assertionPID = displayAssertion?.processIdentifier
        setBlackout(true)
        precondition(displayAssertion?.processIdentifier == assertionPID, "Repeated ON must not leak assertions")
        let originalLanguage = language
        let originalPanels = panels.map(ObjectIdentifier.init)
        let macPID = macAssertion?.processIdentifier
        for choice in AppLanguage.allCases {
            language = choice
            refreshLanguage()
            precondition(toggleItem.title == choice.text(.toggle))
            precondition(aboutItem.title == choice.text(.about) && quitItem.title == choice.text(.quit))
            precondition(languageChoices.filter { $0.state == .on }.count == 1)
            precondition(languageChoices.first { $0.state == .on }?.representedObject as? String == choice.rawValue)
            precondition(statusItem.button?.toolTip == choice.text(.blackoutOn))
            precondition(panels.map(ObjectIdentifier.init) == originalPanels, "Language changes must preserve overlays")
            precondition(displayAssertion?.processIdentifier == assertionPID && macAssertion?.processIdentifier == macPID)
            precondition(enabled && toggleItem.state == .on)
        }
        language = originalLanguage
        refreshLanguage()
        toggle()
        precondition(!enabled && panels.isEmpty && toggleItem.state == .off && displayAssertion == nil)
        precondition(macAssertion?.isRunning == true, "OFF keeps the Mac awake while resident")
        print("PASS: SVG icons, external-only coverage (\(expected.count) displays), ON/OFF, assertion ownership, five live languages")
        NSApp.terminate(nil)
    }

    @objc private func quitApp() { NSApp.terminate(nil) }

    func applicationWillTerminate(_ notification: Notification) {
        panels.forEach { $0.close() }
        stop(displayAssertion)
        stop(macAssertion)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
