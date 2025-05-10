import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            Bundle.setLanguage(currentLanguage)
            // Force UI update and layout direction change
            objectWillChange.send()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageDidChange"), object: nil)
        }
    }
    
    private init() {
        // Always default to English if no saved language
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage") {
            currentLanguage = savedLanguage
        } else {
            currentLanguage = "en"
        }
        
        // Set initial language
        Bundle.setLanguage(currentLanguage)
    }
    
    func setLanguage(_ language: String) {
        guard ["en", "he", "es", "fr", "de"].contains(language) else {
            print("Invalid language code: \(language)")
            return
        }
        currentLanguage = language
    }
    
    var isRTL: Bool {
        return ["he", "ar"].contains(currentLanguage)
    }
    
    var layoutDirection: LayoutDirection {
        return isRTL ? .rightToLeft : .leftToRight
    }
    
    // Helper to get localized language name
    func localizedLanguageName(for code: String) -> String {
        let locale = Locale(identifier: code)
        return NSLocalizedString(code.capitalized, comment: "")
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