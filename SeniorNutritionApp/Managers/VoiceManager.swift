import Foundation
import AVFoundation
import SwiftUI

@MainActor
class VoiceManager: NSObject, ObservableObject {
    static let shared = VoiceManager()
    private let synthesizer: AVSpeechSynthesizer
    @Published var isSpeaking = false
    
    // Replace the string-based dictionary with an utterance-based one
    private var completionHandlers: [AVSpeechUtterance: (Bool) -> Void] = [:]
    
    private override init() {
        synthesizer = AVSpeechSynthesizer()
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ text: String, userSettings: UserSettings? = nil, completion: ((Bool) -> Void)? = nil) {
        Task { @MainActor in
            // Stop any ongoing speech
            if isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            }
            
            // IMPORTANT: Ensure the text is properly localized for the current language
            // This prevents the issue where voice reads in native language but text is still in English
            let localizedText = ensureTextIsLocalized(text)
            print("DEBUG: Original text: \(text.prefix(50))...")
            print("DEBUG: Localized text: \(localizedText.prefix(50))...")
            
            let utterance = AVSpeechUtterance(string: localizedText)
            
            // Store the completion handler if provided
            if let completion = completion {
                completionHandlers[utterance] = completion
            }
            
            // IMPORTANT: Always prioritize the current app language for voice selection
            // This ensures correct language voices are used when app language changes
            let appLang = LanguageManager.shared.currentLanguage // "en", "fr", "es", "he"
            let langVoiceCode = Self.voiceLocale(for: appLang)
            
            print("DEBUG: App language: \(appLang), Voice locale: \(langVoiceCode)")
            
            // Get all available voices for debugging
            let allVoices = AVSpeechSynthesisVoice.speechVoices()
            print("DEBUG: Available voices for \(langVoiceCode): \(allVoices.filter { $0.language.starts(with: langVoiceCode.prefix(2)) }.map { "\($0.name) (\($0.language))" })")
            
            // First try to find a voice that matches the current app language
            var selectedVoice: AVSpeechSynthesisVoice?
            
            // For Hebrew, try specific Hebrew voices first
            if appLang == "he" {
                // Try to find Hebrew voices specifically
                let hebrewVoices = allVoices.filter { voice in
                    voice.language.starts(with: "he") || voice.language.contains("IL")
                }
                
                if let hebrewVoice = hebrewVoices.first {
                    selectedVoice = hebrewVoice
                    print("DEBUG: Found Hebrew voice: \(hebrewVoice.name) (\(hebrewVoice.language))")
                } else {
                    // If no Hebrew voice found, check if Hebrew is supported at all
                    if let hebrewVoice = AVSpeechSynthesisVoice(language: "he-IL") {
                        selectedVoice = hebrewVoice
                        print("DEBUG: Using he-IL voice: \(hebrewVoice.name)")
                    } else if let hebrewVoice = AVSpeechSynthesisVoice(language: "he") {
                        selectedVoice = hebrewVoice
                        print("DEBUG: Using he voice: \(hebrewVoice.name)")
                    } else {
                        print("DEBUG: No Hebrew voice available on this device")
                    }
                }
            } else {
                // For other languages, use the existing logic
                if let langVoice = AVSpeechSynthesisVoice(language: langVoiceCode) {
                    selectedVoice = langVoice
                    print("DEBUG: Using language voice for \(appLang): \(langVoice.name)")
                }
            }
            
            // Set the selected voice
            if let voice = selectedVoice {
                utterance.voice = voice
            }
            
            if let settings = userSettings {
                // Apply speech rate - AVSpeechUtterance rate is between 0 (slowest) and 1 (fastest)
                utterance.rate = settings.speechRate.rate
                print("DEBUG: Setting speech rate to: \(settings.speechRate.rawValue) (\(settings.speechRate.rate))")
                
                // Only use preferred voice if it matches the current language
                if let preferredVoiceId = settings.preferredVoiceIdentifier,
                   let exactVoice = AVSpeechSynthesisVoice(identifier: preferredVoiceId),
                   exactVoice.language.starts(with: langVoiceCode.prefix(2)) {
                    utterance.voice = exactVoice
                    print("DEBUG: Using preferred voice identifier that matches language: \(preferredVoiceId)")
                }
                
                // If we still don't have a voice, try language-aware fallbacks
                if utterance.voice == nil {
                    // Try to get a default voice for the selected gender that matches language
                    let voices = AVSpeechSynthesisVoice.speechVoices()
                    let languageVoices = voices.filter { $0.language.starts(with: langVoiceCode.prefix(2)) }
                    
                    if let matchingVoice = languageVoices.first {
                        utterance.voice = matchingVoice
                        print("DEBUG: Using matching language voice: \(matchingVoice.name)")
                    } else {
                        // If no matching voice, fallback to English
                        let englishVoices = voices.filter { $0.language.starts(with: "en") }
                        if let fallbackVoice = englishVoices.first {
                            utterance.voice = fallbackVoice
                            print("DEBUG: No voice for \(langVoiceCode), using English fallback: \(fallbackVoice.name)")
                        }
                    }
                }
            } else {
                // Default settings if user settings not available
                utterance.rate = 0.5
                
                // If we still don't have a voice, use language-appropriate fallback
                if utterance.voice == nil {
                    if appLang == "he" {
                        // For Hebrew, try one more time with different locale codes
                        if let hebrewVoice = AVSpeechSynthesisVoice(language: "he-IL") ?? 
                                            AVSpeechSynthesisVoice(language: "he") {
                            utterance.voice = hebrewVoice
                            print("DEBUG: Using fallback Hebrew voice: \(hebrewVoice.name)")
                        } else {
                            // If still no Hebrew voice, use English but warn user
                            if let fallback = AVSpeechSynthesisVoice(language: "en-US") {
                                utterance.voice = fallback
                                print("WARNING: No Hebrew voice available, using English fallback: \(fallback.name)")
                            }
                        }
                    } else {
                        // For other languages, use English as fallback
                        if let fallback = AVSpeechSynthesisVoice(language: "en-US") {
                            utterance.voice = fallback
                            print("DEBUG: Using fallback English voice: \(fallback.name)")
                        }
                    }
                }
            }
            
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            
            print("DEBUG: Final voice used: \(utterance.voice?.name ?? "Unknown") (\(utterance.voice?.language ?? "Unknown"))")
            print("DEBUG: Text to speak: \(text.prefix(50))...")
            
            synthesizer.speak(utterance)
            isSpeaking = true
        }
    }
    
    func stopSpeaking() {
        Task { @MainActor in
            synthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
        }
    }
    
    // MARK: - Language helpers
    private static func voiceLocale(for shortCode: String) -> String {
        switch shortCode {
        case "de": return "de-DE"
        case "fr": return "fr-FR"
        case "es": return "es-ES"
        case "he": return "he-IL"
        default:    return "en-US"
        }
    }
    
    // Ensure text is properly localized for the current app language
    private func ensureTextIsLocalized(_ text: String) -> String {
        let currentLang = LanguageManager.shared.currentLanguage
        
        // If we're in English, return the text as-is
        if currentLang == "en" {
            return text
        }
        
        // Force refresh the language bundle to ensure we get the correct localization
        Bundle.setLanguage(currentLang)
        
        // First, try to detect if this text contains localization keys and translate them
        var localizedText = translateLocalizationKeys(text)
        
        // Then apply common phrase translations
        localizedText = translateTextForCurrentLanguage(localizedText)
        
        return localizedText
    }
    
    // Translate text that may contain English phrases to the current language
    private func translateTextForCurrentLanguage(_ text: String) -> String {
        let currentLang = LanguageManager.shared.currentLanguage
        
        // If we're in English, return as-is
        if currentLang == "en" {
            return text
        }
        
        // Common phrases that might appear in voice synthesis
        let commonTranslations: [String: [String: String]] = [
            "he": [
                "Good morning": "בוקר טוב",
                "Good afternoon": "צהריים טובים", 
                "Good evening": "ערב טוב",
                "Good night": "לילה טוב",
                "Medication Reminders": "תזכורות תרופות",
                "No medications scheduled for today": "אין תרופות מתוכננות להיום",
                "in": "בעוד",
                "minutes": "דקות",
                "hours": "שעות",
                "hour": "שעה",
                "minute": "דקה",
                "And your fasting status": "ומצב הצום שלך",
                "Time remaining": "זמן שנותר",
                "percent remain": "אחוז נותר",
                "This is a test of the voice settings": "זהו מבחן של הגדרות הקול",
                "I am speaking at": "אני מדבר בקצב",
                "rate": "קצב",
                "Hello, this is a voice sample": "שלום, זוהי דוגמת קול",
                "I can read your medication reminders and health tips clearly": "אני יכול לקרוא את תזכורות התרופות והטיפים הבריאותיים שלך בבירור"
            ],
            "fr": [
                "Good morning": "Bonjour",
                "Good afternoon": "Bon après-midi",
                "Good evening": "Bonsoir", 
                "Good night": "Bonne nuit",
                "Medication Reminders": "Rappels de médicaments",
                "No medications scheduled for today": "Aucun médicament prévu pour aujourd'hui",
                "in": "dans",
                "minutes": "minutes",
                "hours": "heures",
                "hour": "heure",
                "minute": "minute",
                "And your fasting status": "Et votre statut de jeûne",
                "Time remaining": "Temps restant",
                "percent remain": "pour cent restant",
                "This is a test of the voice settings": "Ceci est un test des paramètres vocaux",
                "I am speaking at": "Je parle à un rythme",
                "rate": "rythme",
                "Hello, this is a voice sample": "Bonjour, ceci est un échantillon vocal",
                "I can read your medication reminders and health tips clearly": "Je peux lire clairement vos rappels de médicaments et conseils de santé"
            ],
            "es": [
                "Good morning": "Buenos días",
                "Good afternoon": "Buenas tardes",
                "Good evening": "Buenas noches",
                "Good night": "Buenas noches",
                "Medication Reminders": "Recordatorios de medicamentos",
                "No medications scheduled for today": "No hay medicamentos programados para hoy",
                "in": "en",
                "minutes": "minutos",
                "hours": "horas",
                "hour": "hora",
                "minute": "minuto",
                "And your fasting status": "Y su estado de ayuno",
                "Time remaining": "Tiempo restante",
                "percent remain": "por ciento restante",
                "This is a test of the voice settings": "Esta es una prueba de la configuración de voz",
                "I am speaking at": "Estoy hablando a ritmo",
                "rate": "ritmo",
                "Hello, this is a voice sample": "Hola, esta es una muestra de voz",
                "I can read your medication reminders and health tips clearly": "Puedo leer claramente sus recordatorios de medicamentos y consejos de salud"
            ]
        ]
        
        var translatedText = text
        
        // Apply translations for the current language
        if let translations = commonTranslations[currentLang] {
            for (english, translated) in translations {
                translatedText = translatedText.replacingOccurrences(of: english, with: translated, options: .caseInsensitive)
            }
        }
        
        return translatedText
    }
    
    // Detect and translate localization keys in the text
    private func translateLocalizationKeys(_ text: String) -> String {
        let currentLang = LanguageManager.shared.currentLanguage
        
        // If we're in English, return as-is
        if currentLang == "en" {
            return text
        }
        
        // Get the appropriate language bundle
        guard let langPath = Bundle.main.path(forResource: currentLang, ofType: "lproj"),
              let langBundle = Bundle(path: langPath) else {
            print("DEBUG: Could not find language bundle for \(currentLang)")
            return text
        }
        
        // Common localization keys that might appear in voice text
        let commonKeys = [
            "Good morning", "Good afternoon", "Good evening", "Good night",
            "Medication Reminders", "No medications scheduled for today",
            "And your fasting status", "Time remaining", "percent remain",
            "This is a test of the voice settings", "I am speaking at",
            "Hello, this is a voice sample", "I can read your medication reminders and health tips clearly",
            "Today's schedule", "Upcoming appointments", "You have no upcoming appointments",
            "Today's medications", "No medications scheduled for today",
            "Fasting Timer features", "Nutrition Tracking features", "Appointment Management features"
        ]
        
        var translatedText = text
        
        // Try to translate each common key
        for key in commonKeys {
            if translatedText.contains(key) {
                let localizedValue = langBundle.localizedString(forKey: key, value: key, table: nil)
                if localizedValue != key {
                    translatedText = translatedText.replacingOccurrences(of: key, with: localizedValue)
                    print("DEBUG: Translated '\(key)' to '\(localizedValue)'")
                }
            }
        }
        
        return translatedText
    }
    
    // Map app language code to speech synthesis identifier
    private func getSpeechLocaleIdentifier(for appLanguage: String) -> String {
        switch appLanguage {
        case "en": return "en-US"
        case "es": return "es-ES"
        case "fr": return "fr-FR"
        case "he": return "he-IL"
        default: return "en-US"
        }
    }
}

extension VoiceManager: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
            
            // Call completion handler if exists
            if let completion = completionHandlers[utterance] {
                completion(true)
                completionHandlers.removeValue(forKey: utterance)
            }
        }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = false
            
            // Call completion handler if exists, indicating cancellation
            if let completion = completionHandlers[utterance] {
                completion(false)
                completionHandlers.removeValue(forKey: utterance)
            }
        }
    }
} 