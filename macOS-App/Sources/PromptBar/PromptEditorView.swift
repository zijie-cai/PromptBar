import SwiftUI
import AppKit

struct PromptEditorView: View {
    @ObservedObject var store: PromptStore
    @State private var selectedPromptId: UUID?

    private var selectedPromptBinding: Binding<Prompt>? {
        guard let id = selectedPromptId,
              let index = store.prompts.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        return $store.prompts[index]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(NSColor.windowBackgroundColor)
                    .edgesIgnoringSafeArea(.top)
            }
            .frame(height: 28)

            Divider()

            HStack(spacing: 0) {
                // Sidebar
                VStack(spacing: 0) {
                    HStack {
                        Text("All Prompts")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Button(action: addPrompt) {
                            Image(systemName: "plus")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                                .frame(width: 20, height: 20)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(IconOnlyButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    .padding(.bottom, 6)
                    
                    ScrollView {
                        LazyVStack(spacing: 4) {
                            ForEach($store.prompts) { $prompt in
                                PromptRowView(
                                    prompt: $prompt,
                                    isSelected: selectedPromptId == prompt.id,
                                    onSelect: { selectedPromptId = prompt.id }
                                )
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 16)
                    }
                }
                .frame(width: 260)
                
                // Vertical Separator
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1)
                
                // Main Editor Area
                ZStack {
                    Color.clear // Transparent background to let the window's visual effect show through
                    
                    if let selectedPrompt = selectedPromptBinding {
                        PromptDetailView(
                            prompt: selectedPrompt,
                            onDelete: {
                                if let id = selectedPromptId,
                                   let idx = store.prompts.firstIndex(where: { $0.id == id }) {
                                    store.prompts.remove(at: idx)
                                }
                                selectedPromptId = nil
                            },
                            onFavoriteToggle: {
                                if let id = selectedPromptId,
                                   let idx = store.prompts.firstIndex(where: { $0.id == id }) {
                                    store.prompts[idx].isFavorite.toggle()
                                    withAnimation {
                                        store.sortPrompts()
                                    }
                                }
                            }
                        )
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("Select a prompt to edit or create a new one.")
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .preferredColorScheme(.dark)
    }
    
    func addPrompt() {
        let newPrompt = Prompt(emoji: "✨", title: "New Prompt", description: "", content: "", category: "General", isFavorite: false)
        store.prompts.insert(newPrompt, at: 0)
        store.sortPrompts()
        selectedPromptId = newPrompt.id
    }
}

struct PromptDetailView: View {
    @Binding var prompt: Prompt
    var onDelete: () -> Void
    var onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            // Header: Emoji, Title, Actions
            HStack(spacing: 16) {
                EmojiPickerField(emoji: $prompt.emoji)
                
                TextField("Prompt Title", text: $prompt.title)
                    .font(.system(size: 24, weight: .bold))
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.primary)
                
                Spacer()
                
                EditorActionButton(
                    icon: prompt.isFavorite ? "star.fill" : "star",
                    color: prompt.isFavorite ? .yellow : .secondary,
                    bgNormal: prompt.isFavorite ? Color.yellow.opacity(0.1) : Color.white.opacity(0.05),
                    bgHover: prompt.isFavorite ? Color.yellow.opacity(0.2) : Color.white.opacity(0.1),
                    strokeNormal: prompt.isFavorite ? Color.yellow.opacity(0.2) : Color.white.opacity(0.1),
                    strokeHover: prompt.isFavorite ? Color.yellow.opacity(0.4) : Color.white.opacity(0.2),
                    action: onFavoriteToggle
                )
                
                EditorActionButton(
                    icon: "trash",
                    color: .red.opacity(0.8),
                    bgNormal: Color.white.opacity(0.05),
                    bgHover: Color.red.opacity(0.15),
                    strokeNormal: Color.white.opacity(0.1),
                    strokeHover: Color.red.opacity(0.3),
                    action: onDelete
                )
            }
            
            // Description Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                
                TextField("Short description...", text: $prompt.description)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .cornerRadius(6)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            
            // Content Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Prompt Content")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                
                PromptContentEditor(text: $prompt.content)
                    .id(prompt.id)
                    .frame(minHeight: 280)
                    .background(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .cornerRadius(6)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct PromptContentEditor: NSViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.scrollerStyle = .overlay

        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.drawsBackground = false
        textView.isRichText = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.textContainerInset = NSSize(width: 8, height: 10)
        textView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.textColor = NSColor.labelColor
        textView.insertionPointColor = NSColor.systemBlue
        textView.string = text
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.heightTracksTextView = false
        textView.textContainer?.containerSize = NSSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize = .zero
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

        scrollView.documentView = textView
        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        if textView.string != text {
            textView.string = text
        }
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            text = textView.string
        }
    }
}

struct PromptRowView: View {
    @Binding var prompt: Prompt
    var isSelected: Bool
    var onSelect: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 10) {
            Text(prompt.emoji)
                .font(.system(size: 14))
            Text(prompt.title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(1)
            Spacer()
            if prompt.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(isSelected ? .white : .yellow)
                    .font(.system(size: 11))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            isSelected ? Color.accentColor :
            (isHovered ? Color.white.opacity(0.1) : Color.clear)
        )
        .cornerRadius(6)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = hovering
            }
        }
        .onTapGesture {
            onSelect()
        }
    }
}

struct EditorActionButton: View {
    var icon: String
    var color: Color
    var bgNormal: Color
    var bgHover: Color
    var strokeNormal: Color
    var strokeHover: Color
    var action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 32, height: 32)
                .background(isHovered ? bgHover : bgNormal)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isHovered ? strokeHover : strokeNormal, lineWidth: 1)
                )
                .cornerRadius(6)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = hovering
            }
        }
    }
}

struct IconOnlyButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isHovered ? 1.0 : 0.6)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isHovered = hovering
                }
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct EmojiProvider {
    static let allEmojis: [String] = {
        var emojis: [String] = []
        let ranges: [ClosedRange<UInt32>] = [
            0x1F600...0x1F64F, // Emoticons
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1FA70...0x1FAFF, // Symbols and Pictographs Extended-A
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Miscellaneous Symbols
            0x2700...0x27BF    // Dingbats
        ]
        
        for range in ranges {
            for i in range {
                guard let scalar = UnicodeScalar(i) else { continue }
                if scalar.properties.isEmojiPresentation {
                    emojis.append(String(scalar))
                }
            }
        }
        return emojis
    }()
}

struct EmojiPickerField: View {
    @Binding var emoji: String
    @State private var isShowingPicker = false
    
    let emojis = EmojiProvider.allEmojis
    
    let columns = [
        GridItem(.adaptive(minimum: 32))
    ]
    
    var body: some View {
        Button(action: {
            isShowingPicker.toggle()
        }) {
            Text(emoji)
                .font(.system(size: 22))
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isShowingPicker ? Color.accentColor.opacity(0.9) : Color.white.opacity(0.1), lineWidth: isShowingPicker ? 1.5 : 1)
                )
                .cornerRadius(8)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $isShowingPicker, arrowEdge: .bottom) {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(emojis, id: \.self) { e in
                        EmojiButton(emoji: e, isSelected: emoji == e) {
                            emoji = e
                            isShowingPicker = false
                        }
                    }
                }
                .padding(12)
            }
            .frame(width: 280, height: 320)
        }
    }
}

struct EmojiButton: View {
    let emoji: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.system(size: 24))
                .frame(width: 32, height: 32)
                .background(isSelected ? Color.accentColor.opacity(0.3) : (isHovered ? Color.white.opacity(0.1) : Color.clear))
                .cornerRadius(6)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
