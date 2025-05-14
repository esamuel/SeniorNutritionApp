import SwiftUI

// Extension to force LTR direction for time/date pickers regardless of app language
extension View {
    func forceLTR() -> some View {
        self
            .environment(\.layoutDirection, .leftToRight)
    }
    
    // Extension specifically for DatePickers to ensure they're always LTR
    // regardless of the app's language setting
    func datePickerLTR() -> some View {
        self
            .environment(\.layoutDirection, .leftToRight)
            .environment(\.locale, Locale(identifier: "en_US"))
    }
    
    // Extension for help guide content to ensure proper RTL layout
    // This ensures proper alignment and spacing in RTL languages
    func adaptiveHelpGuideLayout() -> some View {
        let isRTL = Locale.current.language.languageCode?.identifier == "he" || 
                   Locale.current.language.languageCode?.identifier == "ar"
        
        return self.modifier(HelpGuideLayoutModifier(isRTL: isRTL))
    }
}

// Custom modifier to handle RTL-specific layout needs in Help Guide
struct HelpGuideLayoutModifier: ViewModifier {
    let isRTL: Bool
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(isRTL ? .trailing : .leading)
            .flipsForRightToLeftLayoutDirection(true)
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
    }
} 