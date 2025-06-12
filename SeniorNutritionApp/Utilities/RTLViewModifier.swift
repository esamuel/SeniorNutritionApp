import SwiftUI

/// A view modifier that applies RTL-aware layout to its content
struct RTLViewModifier: ViewModifier {
    @EnvironmentObject private var languageManager: LanguageManager
    
    func body(content: Content) -> some View {
        content
            .environment(\.layoutDirection, languageManager.layoutDirection)
            .environment(\.locale, Locale(identifier: languageManager.currentLanguage))
            .flipsForRightToLeftLayoutDirection(languageManager.isRTL)
            .environment(\.rightToLeft, languageManager.isRTL)
    }
}

/// A view that forces RTL layout for its content
struct RTLView<Content: View>: View {
    let content: () -> Content
    @EnvironmentObject private var languageManager: LanguageManager
    
    var body: some View {
        content()
            .environment(\.layoutDirection, languageManager.layoutDirection)
            .environment(\.locale, Locale(identifier: languageManager.currentLanguage))
            .flipsForRightToLeftLayoutDirection(languageManager.isRTL)
            .environment(\.rightToLeft, languageManager.isRTL)
    }
}

// MARK: - Environment Key for RTL

private struct RightToLeftKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var rightToLeft: Bool {
        get { self[RightToLeftKey.self] }
        set { self[RightToLeftKey.self] = newValue }
    }
}

// MARK: - View Extensions for RTL Support

extension View {
    /// Wraps the view in an RTL-aware container
    func withRTLSupport() -> some View {
        RTLView { self }
    }
    
    /// Conditionally applies a view modifier based on the RTL setting
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies a rotation effect for RTL languages
    func mirrorForRTL() -> some View {
        self.modifier(MirrorForRTL())
    }
}

// MARK: - RTL-Aware Modifiers

/// A view modifier that mirrors the view for RTL languages
struct MirrorForRTL: ViewModifier {
    @EnvironmentObject private var languageManager: LanguageManager
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                languageManager.isRTL ? .degrees(180) : .zero,
                axis: (x: 0, y: 1, z: 0)
            )
    }
}

/// A view modifier that applies RTL-aware padding
struct RTLEdgeInsets: ViewModifier {
    let edges: Edge.Set
    let length: CGFloat?
    @EnvironmentObject private var languageManager: LanguageManager
    
    func body(content: Content) -> some View {
        content
            .padding(edges, length)
            .if(languageManager.isRTL) { view in
                view.padding(edges, length)
            }
    }
}

// MARK: - RTL-Aware HStack

struct RTLHStack<Content: View>: View {
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    @EnvironmentObject private var languageManager: LanguageManager
    
    init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            if languageManager.isRTL {
                content()
            } else {
                content()
            }
        }
        .environment(\.layoutDirection, languageManager.layoutDirection)
    }
}
