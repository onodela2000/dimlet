import AppKit
import CoreGraphics
import DimletCore

enum Copy {
    static let japanese = Locale.preferredLanguages.first?.hasPrefix("ja") == true
    static func text(_ english: String, _ japanese: String) -> String {
        self.japanese ? japanese : english
    }
}

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
            title: Copy.text("Black out all external displays", "すべての外部モニターを暗くする"),
            action: #selector(toggle), keyEquivalent: ""
        )
        toggleItem.target = self
        menu.addItem(toggleItem)
        displayCountItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menu.addItem(displayCountItem)
        menu.addItem(.separator())
        awakeItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menu.addItem(awakeItem)
        let about = NSMenuItem(title: Copy.text("About Dimlet…", "Dimletについて…"), action: #selector(showAbout), keyEquivalent: "")
        about.target = self
        menu.addItem(about)
        let quit = NSMenuItem(title: Copy.text("Quit Dimlet", "Dimletを終了"), action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        statusItem.menu = menu

        NotificationCenter.default.addObserver(self, selector: #selector(rebuild), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(rebuild), name: NSWorkspace.didWakeNotification, object: nil)
        macAssertion = preventSleep("-i")
        awakeItem.title = macAssertion == nil
            ? Copy.text("Could not prevent Mac sleep", "Macのスリープ防止を開始できませんでした")
            : Copy.text("Mac stays awake while Dimlet is open", "起動中はMacの自動スリープを防止")
        setBlackout(CommandLine.arguments.contains("--blackout-on"))

        if CommandLine.arguments.contains("--smoke-test") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.smokeTest() }
        }
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
        let state = value ? "ON" : "OFF"
        let label = Copy.text("Dimlet · Blackout \(state)", "Dimlet · 暗くする：\(state)")
        statusItem.button?.toolTip = label
        statusItem.button?.setAccessibilityLabel(label)
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
        let eligible = DisplayPolicy.targets(in: screens.map { $0.1 }, enabled: true)
        let mirrored = screens.contains { $0.1.isMirrored }
        displayCountItem.title = mirrored
            ? Copy.text("Mirrored displays are skipped", "ミラーリング中の画面は対象外です")
            : Copy.text("\(eligible.count) external display\(eligible.count == 1 ? "" : "s") · built-in untouched", "外部\(eligible.count)台が対象 · 内蔵画面はそのまま")
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
            view.setAccessibilityLabel(Copy.text("Click to reveal all external displays", "クリックするとすべての外部画面が戻ります"))
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
        alert.informativeText = Copy.text(
            "Screens rest. Your Mac keeps going.\n\nVersion \(version) · Free & open source\nBlack overlays, not monitor power-off.\nNo account. No tracking. No network access.",
            "画面は静かに。Macは、そのまま。\n\nバージョン \(version) · 無料・オープンソース\n電源OFFではなく、外部画面を黒く覆います。\nアカウント・追跡・ネットワーク通信なし。"
        )
        alert.addButton(withTitle: Copy.text("Done", "閉じる"))
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
        toggle()
        precondition(!enabled && panels.isEmpty && toggleItem.state == .off && displayAssertion == nil)
        precondition(macAssertion?.isRunning == true, "OFF keeps the Mac awake while resident")
        print("PASS: SVG icons, external-only coverage (\(expected.count) displays), ON/OFF, assertion ownership")
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
