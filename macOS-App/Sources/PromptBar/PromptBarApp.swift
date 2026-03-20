import SwiftUI
import Cocoa

@main
struct PromptBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var palettePanel: FloatingPanel<CommandPaletteView>?
    var editorWindow: NSWindow?
    var store = PromptStore()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as an accessory app (doesn't show in Dock)
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
        }
        
        let menu = NSMenu()
        menu.showsStateColumn = false
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let versionItem = NSMenuItem(title: "PromptBar v\(version)", action: nil, keyEquivalent: "")
        versionItem.isEnabled = false
        menu.addItem(versionItem)
        
        let openItem = NSMenuItem(title: "Quick Access", action: #selector(togglePalette), keyEquivalent: "p")
        openItem.keyEquivalentModifierMask = [.command, .shift]
        menu.addItem(openItem)
        
        let manageItem = NSMenuItem(title: "Edit Prompts", action: #selector(openEditor), keyEquivalent: "")
        menu.addItem(manageItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        quitItem.image = nil
        menu.addItem(quitItem)
        
        statusItem.menu = menu
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
            
            // Apply the Liquid Glass effect to the editor window
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
        // Note: For this to work globally outside the app, the app needs Accessibility permissions.
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            let commandKey = event.modifierFlags.contains(.command)
            let shiftKey = event.modifierFlags.contains(.shift)
            
            // 35 is the keycode for 'P'
            if commandKey && shiftKey && event.keyCode == 35 {
                DispatchQueue.main.async {
                    self?.togglePalette()
                }
            }
        }
        
        // Also listen locally when the app is active
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
