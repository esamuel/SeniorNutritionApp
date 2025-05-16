import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            // Store the selected language in UserDefaults
            UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            
            // Apply the language change to Bundle
            Bundle.setLanguage(currentLanguage)
            
            // Notify observers of the change
            objectWillChange.send()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageDidChange"), object: nil)
            
            print("[LanguageManager] Language changed to: \(currentLanguage)")
        }
    }
    
    private let supported = ["en", "he", "es", "fr"]
    
    private init() {
        // First initialize currentLanguage with a default value
        let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage")
        
        // Set initial value - this must happen before any method calls on self
        if let saved = savedLanguage, supported.contains(saved) {
            currentLanguage = saved
        } else {
            // Default to English initially - will be updated properly after initialization
            currentLanguage = "en"
        }
        
        // Now that properties are initialized, we can update with proper value if needed
        if savedLanguage == nil || (savedLanguage != nil && !supported.contains(savedLanguage!)) {
            // Now it's safe to call methods on self
            let systemLanguage = detectSystemLanguage()
            currentLanguage = systemLanguage
            print("[LanguageManager] Using detected system language: \(currentLanguage)")
        } else {
            print("[LanguageManager] Using saved language: \(currentLanguage)")
        }
        
        // Ensure the language is correctly applied at startup
        Bundle.setLanguage(currentLanguage)
    }
    
    func setLanguage(_ language: String) {
        print("[LanguageManager] setLanguage called with: \(language)")
        guard supported.contains(language) else {
            print("[LanguageManager] Invalid language code: \(language)")
            return
        }
        
        if language != currentLanguage {
            currentLanguage = language
            print("[LanguageManager] currentLanguage set to: \(currentLanguage)")
        } else {
            // Even if the language is the same, re-apply it to ensure localization is correct
            Bundle.setLanguage(language)
            print("[LanguageManager] Re-applied same language: \(language)")
        }
    }
    
    func resetToSystemLanguage() {
        print("[LanguageManager] resetToSystemLanguage called")
        UserDefaults.standard.removeObject(forKey: "AppLanguage")
        
        // Use the user's preferred language order
        let systemLanguage = detectSystemLanguage()
        print("[LanguageManager] Detected system language: \(systemLanguage)")
        currentLanguage = systemLanguage
        Bundle.setLanguage(currentLanguage)
        print("[LanguageManager] Reset to system language: \(currentLanguage)")
    }
    
    private func detectSystemLanguage() -> String {
        // Get current locale identifier from system
        let preferredLanguages = Locale.preferredLanguages
        print("[LanguageManager] System preferred languages: \(preferredLanguages)")
        
        // Try to match the first preferred language
        for lang in preferredLanguages {
            // Extract language code from identifier (e.g., "en-US" → "en")
            if let code = lang.split(separator: "-").first,
               let langCode = code.split(separator: "_").first, // Handle potential region codes
               supported.contains(String(langCode)) {
                return String(langCode)
            }
        }
        
        // If no match found among preferred languages, default to English
        return "en"
    }
    
    var isRTL: Bool {
        return ["he", "ar"].contains(currentLanguage)
    }
    
    var layoutDirection: LayoutDirection {
        return isRTL ? .rightToLeft : .leftToRight
    }
    
    // Helper to get localized language name
    func localizedLanguageName(for code: String) -> String {
        // let locale = Locale(identifier: code) // Unused
        return NSLocalizedString(code.capitalized, comment: "")
    }
    
    // Force refresh localization in all views
    func forceRefreshLocalization() {
        // Re-apply the current language to force a refresh
        Bundle.setLanguage(currentLanguage)
        // Notify of changes
        objectWillChange.send()
        NotificationCenter.default.post(name: NSNotification.Name("LanguageDidChange"), object: nil)
    }
}

// SwiftUI environment key for language
struct LanguageKey: EnvironmentKey {
    static let defaultValue = LanguageManager.shared
}

extension EnvironmentValues {
    var languageManager: LanguageManager {
        get { self[LanguageKey.self] }
        set { self[LanguageKey.self] = newValue }
    }
} 