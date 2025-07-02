import Foundation
import AVFoundation

// Voice gender options
enum VoiceGender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    
    var id: String { self.rawValue }
    
    var languageCode: String {
        // Get the current app language and return appropriate voice locale
        let currentLang = LanguageManager.shared.currentLanguage
        switch currentLang {
        case "he": return "he-IL"
        case "fr": return "fr-FR"
        case "es": return "es-ES"
        default: return "en-US"
        }
    }
    
    // Debug function to list all available voices
    static func listAvailableVoices() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        print("\n=== Available Voices ===")
        for voice in voices {
            let quality = voice.identifier.contains("premium") ? "Enhanced" : "Standard"
            print("Name: \(voice.name)")
            print("Language: \(voice.language)")
            print("Quality: \(quality)")
            print("Identifier: \(voice.identifier)")
            print("---")
        }
    }
    
    // Get the appropriate voice based on gender
    func getVoice() -> AVSpeechSynthesisVoice? {
        // Get all available voices
        let voices = AVSpeechSynthesisVoice.speechVoices()
        print("DEBUG: Available voices: \(voices.map { $0.name })")
        
        // Get current app language
        let currentLang = LanguageManager.shared.currentLanguage
        let targetLanguageCode = languageCode
        
        // Filter for voices in the current app language
        let languageVoices = voices.filter { voice in
            voice.language.starts(with: targetLanguageCode.prefix(2)) ||
            (currentLang == "he" && (voice.language.contains("he") || voice.language.contains("IL")))
        }
        print("DEBUG: \(currentLang) voices: \(languageVoices.map { $0.name })")
        
        // If no voices found for the current language, fall back to English
        let voicesToUse = languageVoices.isEmpty ? voices.filter { $0.language.starts(with: "en") } : languageVoices
        print("DEBUG: Using voices: \(voicesToUse.map { $0.name })")
        
        switch self {
        case .male:
            // For Hebrew, try Hebrew-specific male voices first
            if currentLang == "he" {
                let hebrewMaleVoices = voicesToUse.filter { voice in
                    let name = voice.name.lowercased()
                    return name.contains("male") || 
                           name.contains("avi") ||  // Common Hebrew male voice name
                           name.contains("david") ||
                           name.contains("moshe") ||
                           !name.contains("female")
                }
                
                if let hebrewMaleVoice = hebrewMaleVoices.first {
                    print("DEBUG: Found Hebrew male voice: \(hebrewMaleVoice.name)")
                    return hebrewMaleVoice
                }
                
                // If no specific male voice, use first available Hebrew voice
                if let hebrewVoice = voicesToUse.first {
                    print("DEBUG: Using first available Hebrew voice: \(hebrewVoice.name)")
                    return hebrewVoice
                }
            }
            
            // For English and other languages, use existing logic
            // First try to get enhanced quality male voices
            if currentLang == "en", let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Daniel-premium") {
                print("DEBUG: Found enhanced Daniel voice")
                return voice
            }
            
            // Try other enhanced male voices
            let enhancedMaleVoices = voicesToUse.filter { voice in
                let name = voice.name.lowercased()
                return (name.contains("daniel") || name.contains("tom") || name.contains("alex")) &&
                       (name.contains("premium") || name.contains("enhanced"))
            }
            
            if let enhancedVoice = enhancedMaleVoices.first {
                print("DEBUG: Found enhanced male voice: \(enhancedVoice.name)")
                return enhancedVoice
            }
            
            // If no enhanced voice found, try standard quality voices
            let maleVoices = voicesToUse.filter { voice in
                let name = voice.name.lowercased()
                return name.contains("male") || 
                       name.contains("daniel") || 
                       name.contains("tom") || 
                       name.contains("alex") ||
                       name.contains("david") ||
                       name.contains("fred")
            }
            
            if let maleVoice = maleVoices.first {
                print("DEBUG: Found standard male voice: \(maleVoice.name)")
                return maleVoice
            }
            
            print("DEBUG: No male voice found, using first available voice")
            return voicesToUse.first
            
        case .female:
            // For Hebrew, try Hebrew-specific female voices first
            if currentLang == "he" {
                let hebrewFemaleVoices = voicesToUse.filter { voice in
                    let name = voice.name.lowercased()
                    return name.contains("female") || 
                           name.contains("carmit") ||  // Common Hebrew female voice name
                           name.contains("rachel") ||
                           name.contains("sarah") ||
                           name.contains("michal") ||
                           !name.contains("male")
                }
                
                if let hebrewFemaleVoice = hebrewFemaleVoices.first {
                    print("DEBUG: Found Hebrew female voice: \(hebrewFemaleVoice.name)")
                    return hebrewFemaleVoice
                }
                
                // If no specific female voice, use first available Hebrew voice
                if let hebrewVoice = voicesToUse.first {
                    print("DEBUG: Using first available Hebrew voice: \(hebrewVoice.name)")
                    return hebrewVoice
                }
            }
            
            // For English and other languages, use existing logic
            // First try to get enhanced quality female voices
            if currentLang == "en", let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-premium") {
                print("DEBUG: Found enhanced Samantha voice")
                return voice
            }
            
            // Try other enhanced female voices
            let enhancedFemaleVoices = voicesToUse.filter { voice in
                let name = voice.name.lowercased()
                return (name.contains("samantha") || name.contains("karen") || name.contains("victoria")) &&
                       (name.contains("premium") || name.contains("enhanced"))
            }
            
            if let enhancedVoice = enhancedFemaleVoices.first {
                print("DEBUG: Found enhanced female voice: \(enhancedVoice.name)")
                return enhancedVoice
            }
            
            // If no enhanced voice found, try standard quality voices
            let femaleVoices = voicesToUse.filter { voice in
                let name = voice.name.lowercased()
                return name.contains("female") || 
                       name.contains("samantha") || 
                       name.contains("karen") || 
                       name.contains("siri") && !name.contains("male") ||
                       name.contains("victoria") ||
                       name.contains("zoe")
            }
            
            if let femaleVoice = femaleVoices.first {
                print("DEBUG: Found standard female voice: \(femaleVoice.name)")
                return femaleVoice
            }
            
            print("DEBUG: No female voice found, using first available voice")
            return voicesToUse.first
        }
    }
}

// Speech rate options
enum SpeechRate: String, CaseIterable, Identifiable, Codable {
    case verySlow = "Very Slow"
    case slow = "Slow"
    case normal = "Normal"
    case fast = "Fast"
    case veryFast = "Very Fast"
    
    var id: String { self.rawValue }
    
    var rate: Float {
        switch self {
        case .verySlow: return 0.25  // Much slower
        case .slow: return 0.35      // Slower
        case .normal: return 0.45    // Normal
        case .fast: return 0.55      // Faster
        case .veryFast: return 0.65  // Much faster
        }
    }
}
