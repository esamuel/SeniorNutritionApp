import Foundation

/// Utility class for handling translation of medical conditions and dietary restrictions
/// This ensures that profile data is stored in English keys and translated dynamically
class ProfileTranslationUtils {
    
    // MARK: - Medical Conditions Translation
    
    /// English medical conditions (these are the keys we store)
    static let medicalConditionsEnglish = [
        "High Blood Pressure",
        "Diabetes",
        "Heart Disease",
        "Arthritis",
        "Osteoporosis",
        "Asthma",
        "COPD",
        "Cancer",
        "Stroke",
        "Alzheimer's",
        "Parkinson's",
        "Kidney Disease",
        "Thyroid Disorder",
        "Chronic Pain"
    ]
    
    /// Dietary restrictions in English (these are the keys we store)
    static let dietaryRestrictionsEnglish = [
        "Vegetarian",
        "Vegan",
        "Gluten-Free",
        "Dairy-Free",
        "Nut-Free",
        "Low Sodium",
        "Low Sugar",
        "Low Fat",
        "Kosher",
        "Halal",
        "Pescatarian",
        "Keto",
        "Paleo"
    ]
    
    // MARK: - Translation Methods
    
    /// Translates a medical condition from English key to current language
    /// - Parameter englishKey: The English key (e.g., "High Blood Pressure")
    /// - Returns: The localized string for the current language
    static func translateMedicalCondition(_ englishKey: String) -> String {
        return NSLocalizedString(englishKey, comment: "Medical condition translation")
    }
    
    /// Translates a dietary restriction from English key to current language
    /// - Parameter englishKey: The English key (e.g., "Vegetarian")
    /// - Returns: The localized string for the current language
    static func translateDietaryRestriction(_ englishKey: String) -> String {
        return NSLocalizedString(englishKey, comment: "Dietary restriction translation")
    }
    
    /// Translates an array of medical conditions from English keys to current language
    /// - Parameter englishKeys: Array of English keys
    /// - Returns: Array of localized strings
    static func translateMedicalConditions(_ englishKeys: [String]) -> [String] {
        return englishKeys.map { translateMedicalCondition($0) }
    }
    
    /// Translates an array of dietary restrictions from English keys to current language
    /// - Parameter englishKeys: Array of English keys
    /// - Returns: Array of localized strings
    static func translateDietaryRestrictions(_ englishKeys: [String]) -> [String] {
        return englishKeys.map { translateDietaryRestriction($0) }
    }
    
    // MARK: - Reverse Translation (for migration)
    
    /// Attempts to find the English key for a translated medical condition
    /// This is used for migrating existing translated data to English keys
    /// - Parameter translatedText: The translated text to find English key for
    /// - Returns: The English key if found, otherwise the original text
    static func findEnglishKeyForMedicalCondition(_ translatedText: String) -> String {
        // First check if it's already an English key
        if medicalConditionsEnglish.contains(translatedText) {
            return translatedText
        }
        
        // Try to find by comparing translations
        for englishKey in medicalConditionsEnglish {
            let translations = getTranslationsForMedicalCondition(englishKey)
            if translations.contains(translatedText) {
                return englishKey
            }
        }
        
        // If not found, return original (might be a custom condition)
        return translatedText
    }
    
    /// Attempts to find the English key for a translated dietary restriction
    /// This is used for migrating existing translated data to English keys
    /// - Parameter translatedText: The translated text to find English key for
    /// - Returns: The English key if found, otherwise the original text
    static func findEnglishKeyForDietaryRestriction(_ translatedText: String) -> String {
        // First check if it's already an English key
        if dietaryRestrictionsEnglish.contains(translatedText) {
            return translatedText
        }
        
        // Try to find by comparing translations
        for englishKey in dietaryRestrictionsEnglish {
            let translations = getTranslationsForDietaryRestriction(englishKey)
            if translations.contains(translatedText) {
                return englishKey
            }
        }
        
        // If not found, return original (might be a custom restriction)
        return translatedText
    }
    
    // MARK: - Helper Methods
    
    /// Gets all translations for a medical condition across all supported languages
    /// - Parameter englishKey: The English key
    /// - Returns: Array of all translations including the English key
    private static func getTranslationsForMedicalCondition(_ englishKey: String) -> [String] {
        var translations = [englishKey] // Include English
        
        // Get translations for each supported language
        let supportedLanguages = ["he", "fr", "es"]
        for language in supportedLanguages {
            let translation = getTranslationForLanguage(englishKey, language: language)
            translations.append(translation)
        }
        
        return translations
    }
    
    /// Gets all translations for a dietary restriction across all supported languages
    /// - Parameter englishKey: The English key
    /// - Returns: Array of all translations including the English key
    private static func getTranslationsForDietaryRestriction(_ englishKey: String) -> [String] {
        var translations = [englishKey] // Include English
        
        // Get translations for each supported language
        let supportedLanguages = ["he", "fr", "es"]
        for language in supportedLanguages {
            let translation = getTranslationForLanguage(englishKey, language: language)
            translations.append(translation)
        }
        
        return translations
    }
    
    /// Gets translation for a specific language
    /// - Parameters:
    ///   - key: The English key to translate
    ///   - language: The target language code
    /// - Returns: The translated string
    private static func getTranslationForLanguage(_ key: String, language: String) -> String {
        // Save current language
        let currentLanguage = LanguageManager.shared.currentLanguage
        
        // Temporarily switch to target language
        Bundle.setLanguage(language)
        let translation = NSLocalizedString(key, comment: "")
        
        // Restore original language
        Bundle.setLanguage(currentLanguage)
        
        return translation
    }
    
    // MARK: - Migration Methods
    
    /// Migrates existing profile data from translated text to English keys
    /// - Parameter profile: The user profile to migrate
    /// - Returns: Updated profile with English keys
    static func migrateProfileToEnglishKeys(_ profile: UserProfile) -> UserProfile {
        var updatedProfile = profile
        
        // Migrate medical conditions
        updatedProfile.medicalConditions = profile.medicalConditions.map { condition in
            findEnglishKeyForMedicalCondition(condition)
        }
        
        // Migrate dietary restrictions
        updatedProfile.dietaryRestrictions = profile.dietaryRestrictions.map { restriction in
            findEnglishKeyForDietaryRestriction(restriction)
        }
        
        return updatedProfile
    }
    
    /// Migrates existing UserSettings data from translated text to English keys
    /// - Parameter userSettings: The user settings to migrate
    @MainActor
    static func migrateUserSettingsToEnglishKeys(_ userSettings: UserSettings) {
        // Migrate dietary restrictions in UserSettings
        userSettings.userDietaryRestrictions = userSettings.userDietaryRestrictions.map { restriction in
            findEnglishKeyForDietaryRestriction(restriction)
        }
    }
    
    // MARK: - Validation Methods
    
    /// Checks if a medical condition is a valid predefined condition
    /// - Parameter condition: The condition to check
    /// - Returns: True if it's a predefined condition, false if it's custom
    static func isValidMedicalCondition(_ condition: String) -> Bool {
        return medicalConditionsEnglish.contains(condition)
    }
    
    /// Checks if a dietary restriction is a valid predefined restriction
    /// - Parameter restriction: The restriction to check
    /// - Returns: True if it's a predefined restriction, false if it's custom
    static func isValidDietaryRestriction(_ restriction: String) -> Bool {
        return dietaryRestrictionsEnglish.contains(restriction)
    }
} 