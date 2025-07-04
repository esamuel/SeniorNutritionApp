import Foundation

// MARK: - DateFormatterCache
// A thread-safe, centralized cache for DateFormatter instances that automatically
// invalidates itself when the app's language changes.
class DateFormatterCache {
    static let shared = DateFormatterCache()
    private var cache = [String: DateFormatter]()
    private var lock = NSLock()

    private init() {
        // Observe language changes to invalidate the cache
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: NSNotification.Name("LanguageDidChange"), object: nil)
    }

    @objc private func languageDidChange() {
        lock.lock()
        defer { lock.unlock() }
        cache.removeAll()
        print("[DateFormatterCache] Language changed, cache cleared.")
    }

    /// Retrieves or creates a formatter for a specific format string and language.
    func formatter(with format: String, for language: String) -> DateFormatter {
        let key = "\(format)-\(language)"
        
        lock.lock()
        defer { lock.unlock() }
        
        if let cachedFormatter = cache[key] {
            return cachedFormatter
        }

        let newFormatter = DateFormatter()
        newFormatter.dateFormat = format
        newFormatter.locale = Locale(identifier: language)
        
        cache[key] = newFormatter
        return newFormatter
    }
    
    /// Retrieves or creates a formatter for a specific date/time style and language.
    func formatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, for language: String) -> DateFormatter {
        let key = "\(dateStyle.rawValue)-\(timeStyle.rawValue)-\(language)"
        
        lock.lock()
        defer { lock.unlock() }
        
        if let cachedFormatter = cache[key] {
            return cachedFormatter
        }

        let newFormatter = DateFormatter()
        newFormatter.dateStyle = dateStyle
        newFormatter.timeStyle = timeStyle
        newFormatter.locale = Locale(identifier: language)
        
        cache[key] = newFormatter
        return newFormatter
    }
}

// MARK: - DateFormatter Extension
// Provides static methods to access localized date formatters.
extension DateFormatter {
    
    /// Returns a localized formatter for a specific date and time style.
    static func localizedFormatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> DateFormatter {
        return DateFormatterCache.shared.formatter(dateStyle: dateStyle, timeStyle: timeStyle, for: LanguageManager.shared.currentLanguage)
    }

    /// Returns a localized formatter for a specific format string.
    static func localizedFormatter(with format: String) -> DateFormatter {
        return DateFormatterCache.shared.formatter(with: format, for: LanguageManager.shared.currentLanguage)
    }
    
    // Convenience formatters
    
    static func localizedShortDateFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .short, timeStyle: .none)
    }

    static func localizedMediumDateFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .medium, timeStyle: .none)
    }

    static func localizedLongDateFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .long, timeStyle: .none)
    }

    static func localizedFullDateFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .full, timeStyle: .none)
    }
    
    static func localizedTimeFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .none, timeStyle: .short)
    }
    
    static func localizedDateFormatter() -> DateFormatter {
        return localizedFormatter(dateStyle: .long, timeStyle: .none)
    }
}

// MARK: - Date Extension
// Provides convenience methods for formatting dates using the localized formatters.
extension Date {
    
    /// Formats this date with the app's current language settings using specified styles.
    func localizedString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> String {
        return DateFormatter.localizedFormatter(dateStyle: dateStyle, timeStyle: timeStyle).string(from: self)
    }
    
    /// Formats just the time component of this date with the app's current language settings.
    func localizedTimeString() -> String {
        return DateFormatter.localizedTimeFormatter().string(from: self)
    }
    
    /// Formats just the date component of this date with the app's current language settings.
    func localizedDateString(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter.localizedFormatter(dateStyle: style, timeStyle: .none)
        return formatter.string(from: self)
    }
    
    /// Format the date in full style with the app's current language settings
    func localizedFullDateString() -> String {
        return DateFormatter.localizedFullDateFormatter().string(from: self)
    }
}

// MARK: - String Extension
// Provides convenience properties and methods for localized date strings.
extension String {
    
    /// Get the current date as a localized string (e.g., "Jun 27, 2025").
    static var currentLocalizedDate: String {
        return Date().localizedDateString()
    }
    
    /// Get the current date as a full-style localized string (e.g., "Friday, June 27, 2025").
    static func currentLocalizedFullDateString() -> String {
        return Date().localizedFullDateString()
    }
    
    /// Format a time range with the app's current language settings (e.g., "1:50 PM - 2:50 PM").
    static func localizedTimeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter.localizedTimeFormatter()
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}
