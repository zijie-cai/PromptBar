import Cocoa
import SwiftUI

@main
enum PromptBarMain {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var statusMenu: NSMenu!
    var palettePanel: FloatingPanel<CommandPaletteView>?
    var editorWindow: NSWindow?
    var store = PromptStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        setupMenuBar()
        setupGlobalHotkey()
    }

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "wand.and.stars", accessibilityDescription: "PromptBar") {
                image.isTemplate = true
                button.image = image
            } else {
                let fallback = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "PromptBar")
                fallback?.isTemplate = true
                button.image = fallback
            }

            button.target = self
            button.action = #selector(handleStatusItemClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        let menu = NSMenu()
        menu.showsStateColumn = false

        let titleItem = NSMenuItem(title: "PromptBar", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)

        let openItem = NSMenuItem(title: "Quick Access", action: #selector(togglePalette), keyEquivalent: "p")
        openItem.keyEquivalentModifierMask = [.command, .shift]
        openItem.target = self
        menu.addItem(openItem)

        let manageItem = NSMenuItem(title: "Edit Prompts", action: #selector(openEditor), keyEquivalent: "")
        manageItem.target = self
        menu.addItem(manageItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "")
        quitItem.target = self
        quitItem.image = nil
        menu.addItem(quitItem)

        statusMenu = menu
    }

    @objc func handleStatusItemClick(_ sender: Any?) {
        guard let event = NSApp.currentEvent else {
            togglePalette()
            return
        }

        switch event.type {
        case .rightMouseUp:
            statusItem.menu = statusMenu
            statusItem.button?.performClick(nil)
            DispatchQueue.main.async { [weak self] in
                self?.statusItem.menu = nil
            }
        default:
            togglePalette()
        }
    }

    @objc func togglePalette() {
        if palettePanel == nil {
            let view = CommandPaletteView(store: store) { [weak self] in
                self?.palettePanel?.orderOut(nil)
            }
            palettePanel = FloatingPanel(content: view)
            palettePanel?.center()
        }

        if palettePanel?.isVisible == true {
            palettePanel?.orderOut(nil)
        } else {
            NSApp.activate(ignoringOtherApps: true)
            palettePanel?.makeKeyAndOrderFront(nil)
        }
    }

    @objc func openEditor() {
        if editorWindow == nil {
            let view = PromptEditorView(store: store)
            let hostingController = NSHostingController(rootView: view)

            let window = NSWindow(contentViewController: hostingController)
            window.title = "Manage Prompts"
            window.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView, .utilityWindow]
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.setContentSize(NSSize(width: 960, height: 640))
            window.center()
            window.isReleasedWhenClosed = false
            window.isMovableByWindowBackground = true
            window.backgroundColor = .clear

            let visualEffect = NSVisualEffectView()
            visualEffect.blendingMode = .behindWindow
            visualEffect.state = .active
            visualEffect.material = .hudWindow
            window.contentView = visualEffect

            let hostingView = NSHostingView(rootView: view)
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            visualEffect.addSubview(hostingView)
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: visualEffect.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor),
                hostingView.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor)
            ])

            editorWindow = window
        }

        editorWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    func setupGlobalHotkey() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            let commandKey = event.modifierFlags.contains(.command)
            let shiftKey = event.modifierFlags.contains(.shift)

            if commandKey && shiftKey && event.keyCode == 35 {
                DispatchQueue.main.async {
                    self?.togglePalette()
                }
            }
        }

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            let commandKey = event.modifierFlags.contains(.command)
            let shiftKey = event.modifierFlags.contains(.shift)

            if commandKey && shiftKey && event.keyCode == 35 {
                DispatchQueue.main.async {
                    self?.togglePalette()
                }
                return nil
            }
            return event
        }
    }
}
