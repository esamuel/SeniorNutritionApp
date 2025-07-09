import Foundation
import SwiftUI

/// A utility for handling localization and RTL support
enum LocalizationUtils {
    /// Returns the current app language code
    static var currentLanguage: String {
        return LanguageManager.shared.currentLanguage
    }
    
    /// Returns true if the current language is RTL (like Hebrew or Arabic)
    static var isRTL: Bool {
        return currentLanguage == "he" || currentLanguage == "ar"
    }
    
    /// Returns the current layout direction based on language
    static var layoutDirection: LayoutDirection {
        return isRTL ? .rightToLeft : .leftToRight
    }
    
    /// Returns the current locale based on the selected language
    static var currentLocale: Locale {
        return Locale(identifier: currentLanguage)
    }
    
    /// Forces the app to use RTL/LTR layout
    static func updateLayoutDirection() {
        let isRTL = self.isRTL
        let semanticAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        
        DispatchQueue.main.async {
            // Update the appearance for all new views
            UIView.appearance().semanticContentAttribute = semanticAttribute
            
            // Update all existing windows using the newer API
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        window.semanticContentAttribute = semanticAttribute
                        // Force refresh all views
                        if let rootViewController = window.rootViewController {
                            rootViewController.view.setNeedsLayout()
                            rootViewController.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    /// Helper to create a localized string with format arguments
    static func localizedString(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }
}
