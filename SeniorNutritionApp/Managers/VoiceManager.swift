import Foundation
import AVFoundation

@MainActor
class VoiceManager: NSObject, ObservableObject {
    static let shared = VoiceManager()
    private let synthesizer: AVSpeechSynthesizer
    @Published var isSpeaking = false
    
    private override init() {
        synthesizer = AVSpeechSynthesizer()
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ text: String) {
        Task { @MainActor in
            // Stop any ongoing speech
            if isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            }
            
            let utterance = AVSpeechUtterance(string: text)
            utterance.rate = 0.5 // Slower rate for better clarity
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            
            // Get the user's preferred voice
            if let voice = AVSpeechSynthesisVoice(language: "en-US") {
                utterance.voice = voice
            }
            
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
}

extension VoiceManager: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
        }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = false
        }
    }
} 