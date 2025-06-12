import Foundation
import SwiftUI
import UIKit

private var bundleKey: UInt8 = 0

final class LocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        // Get the string from the specified language bundle
        let localizedString = bundle.localizedString(forKey: key, value: value, table: tableName)
        
        // If the string is identical to the key and we're not using the base language,
        // fall back to the base bundle to prevent strings from appearing in the wrong language
        if localizedString == key && bundle.bundlePath.contains(".lproj") {
            // Try to get the string from the Base.lproj bundle
            if let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj"),
               let baseBundle = Bundle(path: basePath) {
                let baseString = baseBundle.localizedString(forKey: key, value: value, table: tableName)
                if baseString != key {
                    return baseString
                }
            }
            
            // If still not found, try the English bundle as a last resort
            if let enPath = Bundle.main.path(forResource: "en", ofType: "lproj"),
               let enBundle = Bundle(path: enPath) {
                return enBundle.localizedString(forKey: key, value: value, table: tableName)
            }
        }
        
        return localizedString
    }
}

extension Bundle {
    /// Changes the app's language and updates the UI direction
    /// - Parameter language: The language code (e.g., "en", "he", "fr", "es")
    static func setLanguage(_ language: String) {
        // Ensure we have a valid language code
        let supportedLanguages = ["en", "he", "fr", "es"]
        let languageCode = supportedLanguages.contains(language) ? language : "en"
        
        // Store the selected language
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Get the bundle for the selected language
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        let value = path.flatMap { Bundle(path: $0) }
        
        // Fallback to Base or English if needed
        let finalValue: Bundle
        if let value = value {
            finalValue = value
            print("[Bundle+Language] Set language to \(languageCode)")
        } else if let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj"), 
                  let baseBundle = Bundle(path: basePath) {
            finalValue = baseBundle
            print("[Bundle+Language] Warning: Couldn't find bundle for \(languageCode), falling back to Base")
        } else if let enPath = Bundle.main.path(forResource: "en", ofType: "lproj"),
                  let enBundle = Bundle(path: enPath) {
            finalValue = enBundle
            print("[Bundle+Language] Warning: Couldn't find Base bundle, falling back to English")
        } else {
            fatalError("Could not find any language bundle")
        }
        
        // Swizzle the main bundle
        object_setClass(Bundle.main, LocalizedBundle.self)
        objc_setAssociatedObject(Bundle.main, &bundleKey, finalValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Update UI direction
        let isRTL = ["he", "ar"].contains(languageCode)
        let semanticAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        
        // Update appearance for new views
        UIView.appearance().semanticContentAttribute = semanticAttribute
        
        // Force text alignment for RTL
        UILabel.appearance().textAlignment = isRTL ? .right : .left
        UITextView.appearance().textAlignment = isRTL ? .right : .left
        UITextField.appearance().textAlignment = isRTL ? .right : .left
        
        // Post notifications
        NotificationCenter.default.post(name: NSNotification.Name("LanguageDidChange"), object: nil)
        NotificationCenter.default.post(name: NSLocale.currentLocaleDidChangeNotification, object: nil)
        
        // Update all connected scenes
        DispatchQueue.main.async {
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        window.semanticContentAttribute = semanticAttribute
                        // Force refresh all views
                        window.subviews.forEach { view in
                            view.removeFromSuperview()
                            window.addSubview(view)
                        }
                    }
                }
            }
        }
    }
    
    static var isRTL: Bool {
        return UIView.appearance().semanticContentAttribute == .forceRightToLeft
    }
}

// SwiftUI environment key for RTL support
struct LayoutDirectionKey: EnvironmentKey {
    static let defaultValue: LayoutDirection = .leftToRight
}

extension EnvironmentValues {
    var layoutDirection: LayoutDirection {
        get { self[LayoutDirectionKey.self] }
        set { self[LayoutDirectionKey.self] = newValue }
    }
}

// Helper extension for RTL-aware views
extension View {
    func rtlAware() -> some View {
        self.environment(\.layoutDirection, Bundle.isRTL ? .rightToLeft : .leftToRight)
    }
} 