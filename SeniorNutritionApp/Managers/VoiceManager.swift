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
            
            // Use user's preferred speech rate
            if let settings = userSettings {
                // Apply speech rate - AVSpeechUtterance rate is between 0 (slowest) and 1 (fastest)
                utterance.rate = settings.speechRate.rate
                print("DEBUG: Setting speech rate to: \(settings.speechRate.rawValue) (\(settings.speechRate.rate))")
                
                // Use preferredVoiceIdentifier if set
                if let preferredVoiceId = settings.preferredVoiceIdentifier,
                   let exactVoice = AVSpeechSynthesisVoice(identifier: preferredVoiceId) {
                    utterance.voice = exactVoice
                    print("DEBUG: Using preferred voice identifier: \(preferredVoiceId)")
                } else {
                    // Get the preferred voice by gender
                    let preferredVoice = settings.preferredVoiceGender.getVoice()
                    print("DEBUG: Preferred voice gender: \(settings.preferredVoiceGender.rawValue)")
                    
                    if let voice = preferredVoice {
                        utterance.voice = voice
                        print("DEBUG: Using voice: \(voice.name) (identifier: \(voice.identifier))")
                    } else {
                        print("DEBUG: No preferred voice found, trying fallback options")
                        
                        // Try to get a default voice for the selected gender
                        let voices = AVSpeechSynthesisVoice.speechVoices()
                        print("DEBUG: All available voices: \(voices.map { "\($0.name) (\($0.identifier))" })")
                        
                        let englishVoices = voices.filter { $0.language.starts(with: "en") }
                        print("DEBUG: Available English voices: \(englishVoices.map { "\($0.name) (\($0.identifier))" })")
                        
                        if settings.preferredVoiceGender == .male {
                            // Try to get Daniel voice
                            if let danielVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Daniel-compact") {
                                utterance.voice = danielVoice
                                print("DEBUG: Using Daniel voice")
                            } else if let siriMaleVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-US_compact") {
                                utterance.voice = siriMaleVoice
                                print("DEBUG: Using Siri male voice")
                            } else {
                                // Try to find any male voice
                                if let maleVoice = englishVoices.first(where: { $0.name.lowercased().contains("male") }) {
                                    utterance.voice = maleVoice
                                    print("DEBUG: Using fallback male voice: \(maleVoice.name)")
                                }
                            }
                        } else {
                            // Try to get Samantha voice
                            if let samanthaVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact") {
                                utterance.voice = samanthaVoice
                                print("DEBUG: Using Samantha voice")
                            } else if let siriFemaleVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_en-US_compact") {
                                utterance.voice = siriFemaleVoice
                                print("DEBUG: Using Siri female voice")
                            } else {
                                // Try to find any female voice
                                if let femaleVoice = englishVoices.first(where: { $0.name.lowercased().contains("female") }) {
                                    utterance.voice = femaleVoice
                                    print("DEBUG: Using fallback female voice: \(femaleVoice.name)")
                                }
                            }
                        }
                        
                        // If still no voice found, use default
                        if utterance.voice == nil {
                            if let defaultVoice = AVSpeechSynthesisVoice(language: "en-US") {
                                utterance.voice = defaultVoice
                                print("DEBUG: Using default voice: \(defaultVoice.name)")
                            }
                        }
                    }
                }
            } else {
                // Default settings if user settings not available
                utterance.rate = 0.5
                if let voice = AVSpeechSynthesisVoice(language: "en-US") {
                    utterance.voice = voice
                    print("DEBUG: Using default settings - rate: 0.5, voice: \(voice.name)")
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