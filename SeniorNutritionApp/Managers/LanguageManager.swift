import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    // New property to track if we should follow system language
    @Published var followSystemLanguage: Bool = false {
        didSet {
            if followSystemLanguage {
                // When enabling follow system, update to current system language
                let systemLang = detectSystemLanguage()
                print("[LanguageManager] Follow system enabled, setting to: \(systemLang)")
                currentLanguage = systemLang
                
                // Store the preference in UserDefaults
                UserDefaults.standard.set(true, forKey: "FollowSystemLanguage")
                // Remove specific language selection
                UserDefaults.standard.removeObject(forKey: "AppLanguage")
            } else {
                // When disabling, just store the current language
                UserDefaults.standard.set(false, forKey: "FollowSystemLanguage")
                UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            }
        }
    }
    
    @Published var currentLanguage: String {
        didSet {
            // Only store the selected language in UserDefaults if not following system
            if !followSystemLanguage {
                UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            }
            
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
        // Check if we should follow system language
        let shouldFollowSystem = UserDefaults.standard.bool(forKey: "FollowSystemLanguage")
        
        // First initialize followSystemLanguage (without triggering didSet)
        self.followSystemLanguage = shouldFollowSystem
        
        // Get saved language if not following system
        let savedLanguage = shouldFollowSystem ? nil : UserDefaults.standard.string(forKey: "AppLanguage")
        
        // Set initial value - this must happen before any method calls on self
        if let saved = savedLanguage, supported.contains(saved) {
            currentLanguage = saved
        } else {
            // Default to English initially - will be updated properly after initialization
            currentLanguage = "en"
        }
        
        // Now that properties are initialized, we can update with proper value if needed
        if shouldFollowSystem || savedLanguage == nil || (savedLanguage != nil && !supported.contains(savedLanguage!)) {
            // Now it's safe to call methods on self
            let systemLanguage = detectSystemLanguage()
            currentLanguage = systemLanguage
            print("[LanguageManager] Using detected system language: \(currentLanguage)")
        } else {
            print("[LanguageManager] Using saved language: \(currentLanguage)")
        }
        
        // Ensure the language is correctly applied at startup
        Bundle.setLanguage(currentLanguage)
        
        // Set up notification observer for system language changes
        setupLocaleChangeObserver()
        
        // If we're following system language, force a check at startup
        if shouldFollowSystem {
            // Force a check of the system language on startup
            DispatchQueue.main.async { [weak self] in
                self?.checkAndUpdateSystemLanguage()
            }
        }
    }
    
    // Helper method to check and update system language if needed
    private func checkAndUpdateSystemLanguage() {
        if followSystemLanguage {
            let systemLanguage = detectSystemLanguage()
            print("[LanguageManager] Checking system language: \(systemLanguage)")
            
            if systemLanguage != currentLanguage {
                print("[LanguageManager] Updating to match system language: \(systemLanguage)")
                currentLanguage = systemLanguage
                Bundle.setLanguage(currentLanguage)
                forceRefreshLocalization()
            }
        }
    }
    
    // Set up notification observer for system language changes
    private func setupLocaleChangeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )
        print("[LanguageManager] Set up locale change observer")
    }
    
    // Handle system locale changes
    @objc private func localeDidChange() {
        print("[LanguageManager] System locale changed")
        if followSystemLanguage {
            // Update to the new system language
            let systemLanguage = detectSystemLanguage()
            print("[LanguageManager] Updating to new system language: \(systemLanguage)")
            
            // Only update if the language actually changed
            if systemLanguage != currentLanguage {
                currentLanguage = systemLanguage
            } else {
                print("[LanguageManager] System language unchanged: \(systemLanguage)")
            }
        } else {
            print("[LanguageManager] Not following system language, ignoring locale change")
        }
    }
    
    func setLanguage(_ language: String) {
        print("[LanguageManager] setLanguage called with: \(language)")
        guard supported.contains(language) else {
            print("[LanguageManager] Invalid language code: \(language)")
            return
        }
        
        // When explicitly setting a language, disable follow system mode
        if followSystemLanguage {
            print("[LanguageManager] Disabling follow system mode due to explicit language selection")
            followSystemLanguage = false
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
        
        // Enable follow system mode
        followSystemLanguage = true
        
        // Use the user's preferred language order
        let systemLanguage = detectSystemLanguage()
        print("[LanguageManager] Detected system language: \(systemLanguage)")
        
        // Force the language change
        currentLanguage = systemLanguage
        Bundle.setLanguage(currentLanguage)
        
        // Force UI refresh
        forceRefreshLocalization()
        
        print("[LanguageManager] Reset to system language: \(currentLanguage)")
    }
    
    private func detectSystemLanguage() -> String {
        // Get current locale identifier from system
        let preferredLanguages = Locale.preferredLanguages
        print("[LanguageManager] System preferred languages: \(preferredLanguages)")
        
        // Get current locale
        let currentLocale = Locale.current
        print("[LanguageManager] Current locale: \(currentLocale.identifier)")
        
        // Try to match based on the current locale's language code
        let localeLanguageCode = currentLocale.languageCode ?? ""
        print("[LanguageManager] Current locale language code: \(localeLanguageCode)")
        
        // Check if the locale language code is directly supported
        if supported.contains(localeLanguageCode) {
            print("[LanguageManager] Found direct match for locale language: \(localeLanguageCode)")
            return localeLanguageCode
        }
        
        // Special case for Hebrew which might be represented as 'iw' in some systems
        if localeLanguageCode == "iw" && supported.contains("he") {
            print("[LanguageManager] Detected 'iw' code, using 'he' for Hebrew")
            return "he"
        }
        
        // Try to match the first preferred language
        for lang in preferredLanguages {
            print("[LanguageManager] Checking preferred language: \(lang)")
            
            // Direct match for full language code
            if supported.contains(lang) {
                print("[LanguageManager] Found direct match for: \(lang)")
                return lang
            }
            
            // Extract language code from identifier (e.g., "en-US" → "en")
            if let code = lang.split(separator: "-").first {
                let langCode = String(code)
                if supported.contains(langCode) {
                    print("[LanguageManager] Found match after splitting by '-': \(langCode)")
                    return langCode
                }
            }
            
            // Try splitting by underscore (e.g., "en_US" → "en")
            if let code = lang.split(separator: "_").first {
                let langCode = String(code)
                if supported.contains(langCode) {
                    print("[LanguageManager] Found match after splitting by '_': \(langCode)")
                    return langCode
                }
            }
            
            // Special case for Hebrew
            if lang.hasPrefix("he") || lang.hasPrefix("iw") {
                print("[LanguageManager] Detected Hebrew language code variant")
                return "he"
            }
        }
        
        // If no match found among preferred languages, default to English
        print("[LanguageManager] No match found, defaulting to English")
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