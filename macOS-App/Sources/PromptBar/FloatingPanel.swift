import Cocoa
import SwiftUI
import QuartzCore

class FloatingPanel<Content: View>: NSPanel {
    init(content: Content) {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 640, height: 480),
                   styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        
        self.isFloatingPanel = true
        self.level = .floating
        self.collectionBehavior.insert(.fullScreenAuxiliary)
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.isReleasedWhenClosed = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.animationBehavior = .none
        
        // Hide standard window buttons
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        
        // Apply the Liquid Glass effect
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .hudWindow // Dark translucent native material
        
        // Match the web app's rounded corners and border
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 16
        visualEffect.layer?.borderWidth = 1
        visualEffect.layer?.borderColor = NSColor.white.withAlphaComponent(0.15).cgColor
        visualEffect.layer?.masksToBounds = true
        
        let hostingView = NSHostingView(rootView: content.preferredColorScheme(.dark))
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffect.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor)
        ])
        
        self.contentView = visualEffect
        
        // Auto-close when clicking outside (losing focus)
        NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: self, queue: nil) { [weak self] _ in
            self?.orderOut(nil)
        }
    }
    
    // Allow the panel to receive keyboard events
    override var canBecomeKey: Bool { return true }
    override var canBecomeMain: Bool { return true }
    
    override func makeKeyAndOrderFront(_ sender: Any?) {
        self.alphaValue = 0
        super.makeKeyAndOrderFront(sender)
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.15
            $0.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.animator().alphaValue = 1.0
        }
    }
    
    override func orderOut(_ sender: Any?) {
        NSAnimationContext.runAnimationGroup({
            $0.duration = 0.15
            $0.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.animator().alphaValue = 0.0
        }, completionHandler: {
            super.orderOut(sender)
        })
    }
}
