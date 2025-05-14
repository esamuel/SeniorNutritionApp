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
} 