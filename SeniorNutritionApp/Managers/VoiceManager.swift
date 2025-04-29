import Foundation
import AVFoundation
import SwiftUI

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
    
    func speak(_ text: String, userSettings: UserSettings? = nil) {
        Task { @MainActor in
            // Stop any ongoing speech
            if isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            }
            
            let utterance = AVSpeechUtterance(string: text)
            
            // Use user's preferred speech rate
            if let settings = userSettings {
                // Apply speech rate - AVSpeechUtterance rate is between 0 (slowest) and 1 (fastest)
                utterance.rate = settings.speechRate.rate
                
                // Use user's preferred voice gender
                if let voice = settings.preferredVoiceGender.getVoice() {
                    utterance.voice = voice
                    print("Using voice: \(voice.name) for gender: \(settings.preferredVoiceGender.rawValue)")
                } else {
                    print("Could not find appropriate voice for gender: \(settings.preferredVoiceGender.rawValue)")
                    if let defaultVoice = AVSpeechSynthesisVoice(language: "en-US") {
                        utterance.voice = defaultVoice
                    }
                }
                
                print("Speech rate set to: \(settings.speechRate.rawValue) (\(settings.speechRate.rate))")
            } else {
                // Default settings if user settings not available
                utterance.rate = 0.5
                if let voice = AVSpeechSynthesisVoice(language: "en-US") {
                    utterance.voice = voice
                }
            }
            
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            
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