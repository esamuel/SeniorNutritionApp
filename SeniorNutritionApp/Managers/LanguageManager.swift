import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    // MARK: - Published Properties
    
    @Published var followSystemLanguage: Bool {
        didSet {
            UserDefaults.standard.set(followSystemLanguage, forKey: "FollowSystemLanguage")
            if followSystemLanguage {
                // When enabling, update to current system language
                let systemLang = LanguageManager.detectSystemLanguage()
                print("[LanguageManager] Follow system enabled, setting to: \(systemLang)")
                currentLanguage = systemLang
                UserDefaults.standard.removeObject(forKey: "AppLanguage")
            } else {
                // When disabling, just store the current language
                UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            }
        }
    }
    
    @Published var currentLanguage: String {
        didSet {
            if !followSystemLanguage {
                UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            }
            Bundle.setLanguage(currentLanguage)
            objectWillChange.send()
            NotificationCenter.default.post(name: .languageDidChange, object: nil)
            print("[LanguageManager] Language changed to: \(currentLanguage)")
        }
    }
    
    // MARK: - Static Properties
    
    private static let supportedLanguages = ["en", "he", "es", "fr"]
    
    // MARK: - Initialization
    
    private init() {
        // Determine initial state from UserDefaults
        let shouldFollowSystem = UserDefaults.standard.object(forKey: "FollowSystemLanguage") as? Bool ?? true
        let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage")
        let systemLanguage = LanguageManager.detectSystemLanguage()
        
        // Initialize properties without triggering didSet
        self.followSystemLanguage = shouldFollowSystem
        
        if !shouldFollowSystem, let lang = savedLanguage, LanguageManager.supportedLanguages.contains(lang) {
            self.currentLanguage = lang
            print("[LanguageManager] Initializing with saved language: \(lang)")
        } else {
            self.currentLanguage = systemLanguage
            print("[LanguageManager] Initializing with system language: \(systemLanguage)")
        }
        
        // Apply the language at startup
        Bundle.setLanguage(self.currentLanguage)
        
        // Set up notification observer for system language changes
        setupLocaleChangeObserver()
    }
    
    // MARK: - Public Methods
    
    func setLanguage(_ language: String) {
        print("[LanguageManager] setLanguage called with: \(language)")
        guard LanguageManager.supportedLanguages.contains(language) else {
            print("[LanguageManager] Invalid language code: \(language)")
            return
        }
        
        // Manually setting a language disables "follow system"
        if followSystemLanguage {
            followSystemLanguage = false
        }
        
        if currentLanguage != language {
            currentLanguage = language
        } else {
            // Re-apply to ensure UI is consistent if needed
            forceRefreshLocalization()
        }
    }
    
    func resetToSystemLanguage() {
        print("[LanguageManager] resetToSystemLanguage called")
        if !followSystemLanguage {
            followSystemLanguage = true
        } else {
            // Already following, just force a refresh with the latest system language
            let systemLanguage = LanguageManager.detectSystemLanguage()
            if currentLanguage != systemLanguage {
                currentLanguage = systemLanguage
            } else {
                forceRefreshLocalization()
            }
        }
    }
    
    var isRTL: Bool {
        return ["he", "ar"].contains(currentLanguage)
    }
    
    var layoutDirection: LayoutDirection {
        return isRTL ? .rightToLeft : .leftToRight
    }
    
    func localizedLanguageName(for code: String) -> String {
        return NSLocalizedString(code.capitalized, comment: "")
    }
    
    func forceRefreshLocalization() {
        objectWillChange.send()
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func setupLocaleChangeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )
        print("[LanguageManager] Set up locale change observer")
    }
    
    @objc private func localeDidChange() {
        print("[LanguageManager] System locale changed")
        if followSystemLanguage {
            let systemLanguage = LanguageManager.detectSystemLanguage()
            if currentLanguage != systemLanguage {
                print("[LanguageManager] Locale changed, updating language to: \(systemLanguage)")
                currentLanguage = systemLanguage
            }
        }
    }
    
    private static func detectSystemLanguage() -> String {
        guard let preferredLanguage = Locale.preferredLanguages.first else { return "en" }
        
        let languageCode = preferredLanguage.components(separatedBy: "-")[0]
        
        if languageCode == "iw" { // Handle Hebrew's alternative code
            return "he"
        }
        
        if supportedLanguages.contains(languageCode) {
            return languageCode
        }
        
        return "en" // Default to English
    }
}

// MARK: - Environment and Notification Extensions

extension Notification.Name {
    static let languageDidChange = Notification.Name("LanguageDidChange")
}

struct LanguageKey: EnvironmentKey {
    static let defaultValue = LanguageManager.shared
}

extension EnvironmentValues {
    var languageManager: LanguageManager {
        get { self[LanguageKey.self] }
        set { self[LanguageKey.self] = newValue }
    }
} 