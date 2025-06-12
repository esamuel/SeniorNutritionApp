import SwiftUI

/// A view modifier that applies the current locale and layout direction
struct LocalizedViewModifier: ViewModifier {
    @EnvironmentObject private var languageManager: LanguageManager
    
    func body(content: Content) -> some View {
        content
            .environment(\.locale, Locale(identifier: languageManager.currentLanguage))
            .environment(\.layoutDirection, languageManager.layoutDirection)
            .environment(\.sizeCategory, .large) // Support Dynamic Type
            .onAppear {
                // Force update layout when view appears
                LocalizationUtils.updateLayoutDirection()
            }
    }
}

extension View {
    /// Applies the current locale and layout direction to the view hierarchy
    func localized() -> some View {
        self.modifier(LocalizedViewModifier())
    }
    
    /// Applies RTL-aware layout if needed, with optional forced direction
    func rtlAware(forceDirection: LayoutDirection? = nil) -> some View {
        self.environment(\.layoutDirection, forceDirection ?? LocalizationUtils.layoutDirection)
    }
    
    // Note: forceLTR() is defined in View+Extensions.swift to avoid duplication
}

// MARK: - Text Alignment Helpers

extension Text {
    /// Returns text with appropriate alignment for the current language
    func alignedToLanguage() -> some View {
        self.multilineTextAlignment(LocalizationUtils.isRTL ? .trailing : .leading)
    }
    
    /// Returns text with center alignment
    func centerAligned() -> some View {
        self.multilineTextAlignment(.center)
    }
}
