import Foundation
import SwiftUI

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
    static func setLanguage(_ language: String) {
        // Always use a valid bundle for every language, including English
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let value = path.flatMap { Bundle(path: $0) }
        
        // If we couldn't find the language bundle, fall back to Base or English
        let finalValue: Bundle?
        if value == nil {
            let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj")
            finalValue = basePath.flatMap { Bundle(path: $0) }
            print("[Bundle+Language] Warning: Couldn't find bundle for \(language), falling back to Base")
        } else {
            finalValue = value
            print("[Bundle+Language] Set language to \(language)")
        }
        
        object_setClass(Bundle.main, LocalizedBundle.self) // Swizzle first
        objc_setAssociatedObject(Bundle.main, &bundleKey, finalValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Set the language direction
        let isRTL = ["he", "ar"].contains(language)
        UIView.appearance().semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        
        // Force layout direction update
        NotificationCenter.default.post(name: NSNotification.Name("LanguageDidChange"), object: nil)
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