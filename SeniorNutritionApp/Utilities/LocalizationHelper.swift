import SwiftUI
import Foundation

extension View {
    /// Applies appropriate layout direction based on the current locale
    func respectingRTL() -> some View {
        let isRTL: Bool
        if #available(iOS 16, *) {
            isRTL = Locale.current.language.languageCode?.identifier == "he" || Locale.current.language.languageCode?.identifier == "ar"
        } else {
            isRTL = Locale.current.languageCode == "he" || Locale.current.languageCode == "ar"
        }
        return self.environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
    }
}

extension HorizontalAlignment {
    /// Returns the appropriate text alignment based on the current locale
    static var leadingAlignment: HorizontalAlignment {
        let isRTL: Bool
        if #available(iOS 16, *) {
            isRTL = Locale.current.language.languageCode?.identifier == "he" || Locale.current.language.languageCode?.identifier == "ar"
        } else {
            isRTL = Locale.current.languageCode == "he" || Locale.current.languageCode == "ar"
        }
        return isRTL ? .trailing : .leading
    }
}

/// Helper to handle localization and formatting for RTL languages
struct LocalizationHelper {
    /// Returns the appropriate edge for semantic leading edge based on current locale
    static var leadingEdge: Edge.Set {
        let isRTL = Locale.current.languageCode == "he" || 
                    Locale.current.languageCode == "ar"
        
        return isRTL ? .trailing : .leading
    }
    
    /// Returns the appropriate edge for semantic trailing edge based on current locale
    static var trailingEdge: Edge.Set {
        let isRTL = Locale.current.languageCode == "he" || 
                    Locale.current.languageCode == "ar"
        
        return isRTL ? .leading : .trailing
    }
    
    /// Returns appropriate system image name for semantic chevron forward based on locale
    static var forwardChevron: String {
        let isRTL = Locale.current.languageCode == "he" || 
                    Locale.current.languageCode == "ar"
        
        return isRTL ? "chevron.left" : "chevron.right"
    }
    
    /// Returns appropriate system image name for semantic chevron backward based on locale
    static var backwardChevron: String {
        let isRTL = Locale.current.languageCode == "he" || 
                    Locale.current.languageCode == "ar"
        
        return isRTL ? "chevron.right" : "chevron.left"
    }
} 