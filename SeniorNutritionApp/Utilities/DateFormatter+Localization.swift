import Foundation

// Extension to provide localized date formatting that respects the app's language settings
extension DateFormatter {
    
    /// Returns a date formatter configured for the current app language
    static func localizedFormatter(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        
        // Use the current language from LanguageManager
        let currentLanguage = LanguageManager.shared.currentLanguage
        
        // Create a locale based on the current language
        var localeIdentifier: String
        switch currentLanguage {
        case "he":
            localeIdentifier = "he_IL" // Hebrew (Israel)
        case "es":
            localeIdentifier = "es_ES" // Spanish (Spain)
        case "fr":
            localeIdentifier = "fr_FR" // French (France)
        default:
            localeIdentifier = "en_US" // English (US) as fallback
        }
        
        formatter.locale = Locale(identifier: localeIdentifier)
        
        // For Hebrew, ensure correct calendar and direction
        if currentLanguage == "he" {
            // Use Hebrew calendar for Hebrew locale
            formatter.calendar = Calendar(identifier: .hebrew)
            
            // Customize date format for Hebrew if needed
            if dateStyle != .none && timeStyle == .none {
                formatter.dateFormat = "EEEE, d MMMM yyyy"
            }
        }
        
        return formatter
    }
    
    /// Returns a time-only formatter configured for the current app language
    static func localizedTimeFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .none, timeStyle: .short)
    }
    
    /// Returns a date-only formatter configured for the current app language
    static func localizedDateFormatter(style: DateFormatter.Style = .medium) -> DateFormatter {
        return localizedFormatter(dateStyle: style, timeStyle: .none)
    }
    
    /// Returns a full date formatter configured for the current app language
    static func localizedFullDateFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .full, timeStyle: .none)
    }
}

// Extension for FastingTimerView to provide localized time formatting
extension FastingManager {
    /// Get a properly localized time formatter for the FastingTimerView
    static func getLocalizedTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        // Use the current language from LanguageManager
        let currentLanguage = LanguageManager.shared.currentLanguage
        
        // Create a locale based on the current language
        var localeIdentifier: String
        switch currentLanguage {
        case "he":
            localeIdentifier = "he_IL" // Hebrew (Israel)
        case "es":
            localeIdentifier = "es_ES" // Spanish (Spain)
        case "fr":
            localeIdentifier = "fr_FR" // French (France)
        default:
            localeIdentifier = "en_US" // English (US) as fallback
        }
        
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter
    }
}

// Extension for Date to provide easy access to localized formatting
extension Date {
    /// Format this date with the app's current language settings
    func localizedString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> String {
        return DateFormatter.localizedFormatter(dateStyle: dateStyle, timeStyle: timeStyle).string(from: self)
    }
    
    /// Format just the time component with the app's current language settings
    func localizedTimeString() -> String {
        return DateFormatter.localizedTimeFormatter().string(from: self)
    }
    
    /// Format just the date component with the app's current language settings
    func localizedDateString(style: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedDateFormatter(style: style).string(from: self)
    }
    
    /// Format the date in full style with the app's current language settings
    func localizedFullDateString() -> String {
        return DateFormatter.localizedFullDateFormatter().string(from: self)
    }
    
    /// Get the current date as a localized string
    static func currentLocalizedDateString() -> String {
        return Date().localizedFullDateString()
    }
    
    /// Format a time range with the app's current language settings
    static func localizedTimeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter.localizedTimeFormatter()
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

// Convenience extension for String to display dates
extension String {
    /// Get the current date as a localized string
    static var currentLocalizedDate: String {
        return Date.currentLocalizedDateString()
    }
}
