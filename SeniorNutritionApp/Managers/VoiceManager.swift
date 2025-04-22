import Foundation
import AVFoundation

class VoiceManager: NSObject, ObservableObject {
    static let shared = VoiceManager()
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    
    private override init() {
        super.init()
    }
    
    func speak(_ text: String) {
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
        
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
}

extension VoiceManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
} 