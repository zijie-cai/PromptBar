import SwiftUI

struct CommandPaletteView: View {
    @ObservedObject var store: PromptStore
    var onClose: () -> Void
    
    @State private var query = ""
    @State private var hoveredIndex: Int? = nil
    @State private var copiedPromptID: UUID? = nil
    @State private var resetCopiedStateWorkItem: DispatchWorkItem?
    @FocusState private var isSearchFocused: Bool
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var viewHeight: CGFloat = 0
    
    var filteredPrompts: [Prompt] {
        if query.isEmpty { return store.prompts }
        return store.prompts.filter { 
            $0.title.localizedCaseInsensitiveContains(query) || 
            $0.description.localizedCaseInsensitiveContains(query) ||
            $0.category.localizedCaseInsensitiveContains(query)
        }
    }
    
    var body: some View {
        mainContent
        .frame(width: 640)
        .ignoresSafeArea()
        .onAppear {
            isSearchFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { _ in
            query = ""
            hoveredIndex = nil
            copiedPromptID = nil
            isSearchFocused = true
        }
        .onDisappear {
            resetCopiedStateWorkItem?.cancel()
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            searchBar
            Divider().background(Color.white.opacity(0.1))
            resultsList
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white.opacity(0.5))
            
            TextField("Search prompts...", text: $query)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.white)
                .focused($isSearchFocused)
                .onChange(of: query) { _, _ in hoveredIndex = nil }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }
    
    private var resultsList: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 4) {
                        if filteredPrompts.isEmpty {
                            Text("No prompts found for \"\(query)\"")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.5))
                                .padding(.vertical, 60)
                        } else {
                            ForEach(Array(filteredPrompts.enumerated()), id: \.element.id) { index, prompt in
                                promptRow(for: prompt, at: index)
                            }
                        }
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 16)
                    .padding(.vertical, 12)
                    .background(
                        GeometryReader { contentGeo in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: contentGeo.frame(in: .named("scroll")).minY
                                )
                                .preference(
                                    key: ContentHeightPreferenceKey.self,
                                    value: contentGeo.size.height
                                )
                        }
                    )
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                .onPreferenceChange(ContentHeightPreferenceKey.self) { value in
                    contentHeight = value
                }
                .onAppear {
                    viewHeight = geometry.size.height
                }
                .onChange(of: geometry.size.height) { _, newHeight in
                    viewHeight = newHeight
                }
                
                // Custom Skinny Scrollbar
                if contentHeight > viewHeight && viewHeight > 0 {
                    let scrollRatio = viewHeight / contentHeight
                    let scrollbarHeight = max(viewHeight * scrollRatio, 20)
                    let maxOffset = contentHeight - viewHeight
                    let currentOffset = min(max(-scrollOffset, 0), maxOffset)
                    let scrollProgress = currentOffset / maxOffset
                    let scrollbarY = scrollProgress * (viewHeight - scrollbarHeight)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 4, height: scrollbarHeight)
                        .padding(.trailing, 4)
                        .offset(y: scrollbarY)
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
        }
        .frame(maxHeight: 380)
    }
    
    private func promptRow(for prompt: Prompt, at index: Int) -> some View {
        HStack(spacing: 16) {
            Text(prompt.emoji)
                .font(.system(size: 24))
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(prompt.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                    
                    if prompt.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 11))
                    }
                }
                Text(prompt.description)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                    .lineLimit(1)
            }
            Spacer()
            
            promptAction(for: prompt, isHovered: index == hoveredIndex)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(index == hoveredIndex ? Color.white.opacity(0.15) : Color.clear)
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            copyToClipboard(prompt: prompt)
        }
        .onHover { isHovered in
            if isHovered { 
                hoveredIndex = index 
            } else if hoveredIndex == index {
                hoveredIndex = nil
            }
        }
    }
    
    @ViewBuilder
    private func promptAction(for prompt: Prompt, isHovered: Bool) -> some View {
        let isCopied = copiedPromptID == prompt.id
        
        if isHovered || isCopied {
            ZStack {
                HStack(spacing: 4) {
                    Image(systemName: "cursorarrow.click")
                    Text("Copy")
                }
                .opacity(isCopied ? 0 : 1)

                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                    Text("Copied")
                }
                .opacity(isCopied ? 1 : 0)
            }
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(isCopied ? Color.green.opacity(0.95) : Color.white.opacity(0.6))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isCopied ? Color.green.opacity(0.15) : Color.white.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isCopied ? Color.green.opacity(0.22) : Color.clear, lineWidth: 1)
            )
            .cornerRadius(6)
            .animation(.easeInOut(duration: 0.16), value: isCopied)
        }
    }
    
    func copyToClipboard(prompt: Prompt) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(prompt.content, forType: .string)
        
        resetCopiedStateWorkItem?.cancel()

        withAnimation(.easeInOut(duration: 0.18)) {
            copiedPromptID = prompt.id
        }

        let workItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.18)) {
                if copiedPromptID == prompt.id {
                    copiedPromptID = nil
                }
            }
        }

        resetCopiedStateWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: workItem)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
