import Foundation
import AVFoundation

// Voice gender options
enum VoiceGender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    
    var id: String { self.rawValue }
    
    var languageCode: String {
        return "en-US"
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
        
        // Filter for English voices
        let englishVoices = voices.filter { $0.language.starts(with: "en") }
        print("DEBUG: English voices: \(englishVoices.map { $0.name })")
        
        switch self {
        case .male:
            // First try to get enhanced quality male voices
            if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Daniel-premium") {
                print("DEBUG: Found enhanced Daniel voice")
                return voice
            }
            
            // Try other enhanced male voices
            let enhancedMaleVoices = englishVoices.filter { voice in
                let name = voice.name.lowercased()
                return (name.contains("daniel") || name.contains("tom") || name.contains("alex")) &&
                       (name.contains("premium") || name.contains("enhanced"))
            }
            
            if let enhancedVoice = enhancedMaleVoices.first {
                print("DEBUG: Found enhanced male voice: \(enhancedVoice.name)")
                return enhancedVoice
            }
            
            // If no enhanced voice found, try standard quality voices
            let maleVoices = englishVoices.filter { voice in
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
            
            print("DEBUG: No male voice found, using first available English voice")
            return englishVoices.first
            
        case .female:
            // First try to get enhanced quality female voices
            if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-premium") {
                print("DEBUG: Found enhanced Samantha voice")
                return voice
            }
            
            // Try other enhanced female voices
            let enhancedFemaleVoices = englishVoices.filter { voice in
                let name = voice.name.lowercased()
                return (name.contains("samantha") || name.contains("karen") || name.contains("victoria")) &&
                       (name.contains("premium") || name.contains("enhanced"))
            }
            
            if let enhancedVoice = enhancedFemaleVoices.first {
                print("DEBUG: Found enhanced female voice: \(enhancedVoice.name)")
                return enhancedVoice
            }
            
            // If no enhanced voice found, try standard quality voices
            let femaleVoices = englishVoices.filter { voice in
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
            
            print("DEBUG: No female voice found, using first available English voice")
            return englishVoices.first
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
