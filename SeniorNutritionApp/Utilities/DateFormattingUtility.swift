import Foundation
import SwiftUI

/// Utility for handling date formatting in a localization-aware manner
class DateFormattingUtility {
    static let shared = DateFormattingUtility()
    
    private init() {}
    
    /// Returns a date formatter configured for the current app language
    func getLocalizedDateFormatter(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> DateFormatter {
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
            let hebrewCalendar = Calendar(identifier: .hebrew)
            formatter.calendar = hebrewCalendar
            
            // Customize date format for Hebrew if needed
            if dateStyle != .none && timeStyle == .none {
                formatter.dateFormat = "EEEE, d MMMM yyyy"
            }
        }
        
        return formatter
    }
    
    /// Returns a time-only formatter configured for the current app language
    func getLocalizedTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
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
    
    /// Format a date as a string using the current app language
    func formatDate(_ date: Date, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> String {
        let formatter = getLocalizedDateFormatter(dateStyle: dateStyle, timeStyle: timeStyle)
        return formatter.string(from: date)
    }
    
    /// Format a time as a string using the current app language
    func formatTime(_ date: Date) -> String {
        let formatter = getLocalizedTimeFormatter()
        return formatter.string(from: date)
    }
    
    /// Format a date range as a string using the current app language
    func formatTimeRange(start: Date, end: Date) -> String {
        let formatter = getLocalizedTimeFormatter()
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    /// Get the current date formatted according to the app language
    func getCurrentDateFormatted() -> String {
        let formatter = getLocalizedDateFormatter(dateStyle: .full, timeStyle: .none)
        return formatter.string(from: Date())
    }
}

// SwiftUI View extension for date formatting
extension View {
    /// Format a date using the app's current language
    func formatDate(_ date: Date, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> String {
        return DateFormattingUtility.shared.formatDate(date, dateStyle: dateStyle, timeStyle: timeStyle)
    }
    
    /// Format a time using the app's current language
    func formatTime(_ date: Date) -> String {
        return DateFormattingUtility.shared.formatTime(date)
    }
}
