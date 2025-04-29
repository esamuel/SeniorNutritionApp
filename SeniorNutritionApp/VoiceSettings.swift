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
    
    // Get the appropriate voice based on gender
    func getVoice() -> AVSpeechSynthesisVoice? {
        // Get all available voices
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        // Filter for English voices
        let englishVoices = voices.filter { $0.language.starts(with: "en") }
        
        switch self {
        case .male:
            // Try to find a male voice
            let maleVoices = englishVoices.filter { 
                $0.name.lowercased().contains("male") || 
                $0.name.lowercased().contains("daniel") || 
                $0.name.lowercased().contains("tom") || 
                $0.name.lowercased().contains("alex")
            }
            return maleVoices.first ?? englishVoices.first
            
        case .female:
            // Try to find a female voice
            let femaleVoices = englishVoices.filter { 
                $0.name.lowercased().contains("female") || 
                $0.name.lowercased().contains("samantha") || 
                $0.name.lowercased().contains("karen") || 
                $0.name.lowercased().contains("siri") && !$0.name.lowercased().contains("male")
            }
            return femaleVoices.first ?? englishVoices.first
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
