import SwiftUI

// Extension specifically for DatePicker to handle RTL issues
extension DatePicker {
    /// Makes the DatePicker always display in LTR format regardless of app language
    /// This ensures consistent time/date visualization across all languages
    func fixRTLTimeDisplay() -> some View {
        self
            .environment(\.layoutDirection, .leftToRight)
            .environment(\.locale, Locale(identifier: "en_US"))
    }
}

// Add DatePicker modifier to ViewModifier protocol for easier application
struct DatePickerRTLFix: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(\.layoutDirection, .leftToRight)
            .environment(\.locale, Locale(identifier: "en_US"))
    }
}

// Extension to easily apply to any DatePicker
extension View {
    func fixRTLDatePicker() -> some View {
        self.modifier(DatePickerRTLFix())
    }
} 