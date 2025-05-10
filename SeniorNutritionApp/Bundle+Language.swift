import Foundation
import SwiftUI

private var bundleKey: UInt8 = 0

final class LocalizedBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setLanguage(_ language: String) {
        // Always use a valid bundle for every language, including English
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let value = path.flatMap { Bundle(path: $0) }
        object_setClass(Bundle.main, LocalizedBundle.self) // Swizzle first
        objc_setAssociatedObject(Bundle.main, &bundleKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
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