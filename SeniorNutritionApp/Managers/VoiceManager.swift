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
            
            let utterance = AVSpeechUtterance(string: text)
            
            // Store the completion handler if provided
            if let completion = completion {
                completionHandlers[utterance] = completion
            }
            
            // IMPORTANT: Always prioritize the current app language for voice selection
            // This ensures correct language voices are used when app language changes
            let appLang = LanguageManager.shared.currentLanguage // "en", "fr", "es", "he"
            let langVoiceCode = Self.voiceLocale(for: appLang)
            
            // First try to find a voice that matches the current app language
            if let langVoice = AVSpeechSynthesisVoice(language: langVoiceCode) {
                utterance.voice = langVoice
                print("DEBUG: Using language voice for \(appLang): \(langVoice.name)")
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
                
                // If we still don't have a voice, use English as fallback
                if utterance.voice == nil, let fallback = AVSpeechSynthesisVoice(language: "en-US") {
                    utterance.voice = fallback
                    print("DEBUG: Using fallback English voice: \(fallback.name)")
                }
            }
            
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            
            print("DEBUG: Final voice used: \(utterance.voice?.name ?? "Unknown") (\(utterance.voice?.language ?? "Unknown"))")
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