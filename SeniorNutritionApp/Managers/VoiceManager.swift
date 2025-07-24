import Foundation
import AVFoundation
import SwiftUI
import Combine

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
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("DEBUG: Audio session configured for playback")
        } catch {
            print("ERROR: Could not configure audio session: \(error)")
        }
    }
    
    func speak(_ text: String, userSettings: UserSettings? = nil, completion: ((Bool) -> Void)? = nil) {
        // Ensure audio session is properly configured for playback
        setupAudioSession()
        Task { @MainActor in
            // Stop any ongoing speech
            if isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
                isSpeaking = false
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
            // Immediately update the state for UI responsiveness
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
        
        // Get the appropriate language bundle
        guard let langPath = Bundle.main.path(forResource: currentLang, ofType: "lproj"),
              let langBundle = Bundle(path: langPath) else {
            print("DEBUG: Could not find language bundle for \(currentLang)")
            return text
        }
        
        // Common phrases that might appear in voice synthesis - use localization files
        let commonKeys = [
            "Good morning", "Good afternoon", "Good evening", "Good night",
            "Medication Reminders", "No medications scheduled for today",
            "in", "minutes", "hours", "hour", "minute",
            "And your fasting status", "Time remaining", "percent remain",
            "This is a test of the voice settings", "I am speaking at", "rate",
            "Hello, this is a voice sample", 
            "I can read your medication reminders and health tips clearly"
        ]
        
        var translatedText = text
        
        // Apply translations from localization files
        for key in commonKeys {
            if translatedText.contains(key) {
                let localizedValue = langBundle.localizedString(forKey: key, value: key, table: nil)
                if localizedValue != key {
                    translatedText = translatedText.replacingOccurrences(of: key, with: localizedValue, options: .caseInsensitive)
                    print("DEBUG: Translated '\(key)' to '\(localizedValue)'")
                }
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

@MainActor
class TTSRouter: ObservableObject {
    static let shared = TTSRouter()
    @AppStorage("selectedVoiceEngine") var selectedVoiceEngine: VoiceEngine = .system
    @Published var elevenLabsTTS = ElevenLabsTTS()
    @Published var isSpeaking = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to voice manager and eleven labs state changes
        VoiceManager.shared.$isSpeaking
            .sink { [weak self] systemSpeaking in
                Task { @MainActor in
                    self?.updateSpeakingState()
                }
            }
            .store(in: &cancellables)
            
        elevenLabsTTS.$isPlaying
            .sink { [weak self] elevenLabsSpeaking in
                Task { @MainActor in
                    self?.updateSpeakingState()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateSpeakingState() {
        isSpeaking = VoiceManager.shared.isSpeaking || elevenLabsTTS.isPlaying
    }
    
    func speak(_ text: String, userSettings: UserSettings? = nil, completion: ((Bool) -> Void)? = nil) {
        let lang = LanguageManager.shared.currentLanguage
        if lang == "he" {
            VoiceManager.shared.speak(text, userSettings: userSettings, completion: completion)
            return
        }
        if selectedVoiceEngine == .elevenLabs && canUseHumanLikeVoice {
            elevenLabsTTS.speak(text: text) { success in
                if success {
                    // ElevenLabs succeeded
                    completion?(true)
                } else {
                    // ElevenLabs failed, fallback to system voice
                    print("DEBUG: ElevenLabs failed, falling back to system voice")
                    VoiceManager.shared.speak(text, userSettings: userSettings, completion: completion)
                }
            }
        } else {
            VoiceManager.shared.speak(text, userSettings: userSettings, completion: completion)
        }
    }
    
    func stopSpeaking() {
        // Stop both voice systems to ensure clean state
        VoiceManager.shared.stopSpeaking()
        elevenLabsTTS.stop()
        
        // Immediately update our local state for UI responsiveness
        isSpeaking = false
    }
} 

typealias ElevenLabsVoiceLabels = [String: String]
struct ElevenLabsVoice: Identifiable, Codable {
    let voice_id: String
    let name: String
    let labels: ElevenLabsVoiceLabels
    var id: String { voice_id }
}
typealias ElevenLabsVoicesResponse = [String: [ElevenLabsVoice]]

class ElevenLabsTTS: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @AppStorage("elevenLabsSelectedVoiceId") var selectedVoiceId: String = "21m00Tcm4TlvDq8ikWAM" // Rachel (English)
    @Published var availableVoices: [ElevenLabsVoice] = []
    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    let apiKey = "sk_7af8c15f9bf82108f037ba22f8704eda0d385ed99c150d26"
    
    // Audio cache for frequently used text
    private var audioCache = NSCache<NSString, NSData>()
    private var currentTask: URLSessionDataTask?
    private var completionHandler: ((Bool) -> Void)?
    
    // Optimized URLSession for better performance
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0 // 10 second timeout
        config.timeoutIntervalForResource = 30.0 // 30 second resource timeout
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpMaximumConnectionsPerHost = 4
        return URLSession(configuration: config)
    }()

    override init() {
        super.init()
        // Configure cache
        audioCache.totalCostLimit = 50 * 1024 * 1024 // 50MB cache limit
        audioCache.countLimit = 100 // Max 100 cached items
        fetchVoices()
    }

    func fetchVoices() {
        guard let url = URL(string: "https://api.elevenlabs.io/v1/voices") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")
        request.timeoutInterval = 10.0 // 10 second timeout
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let voicesArr = json?["voices"] as? [[String: Any]] {
                    let voices = voicesArr.compactMap { dict -> ElevenLabsVoice? in
                        guard let voice_id = dict["voice_id"] as? String,
                              let name = dict["name"] as? String,
                              let labels = dict["labels"] as? [String: String] else { return nil }
                        return ElevenLabsVoice(voice_id: voice_id, name: name, labels: labels)
                    }
                    DispatchQueue.main.async {
                        self.availableVoices = voices
                        if let first = voices.first { self.selectedVoiceId = first.voice_id }
                    }
                }
            } catch { print("Failed to parse ElevenLabs voices: \(error)") }
        }
        task.resume()
    }

    func speak(text: String, completion: ((Bool) -> Void)? = nil) {
        // Cancel any existing request
        currentTask?.cancel()
        
        // Store completion handler
        completionHandler = completion
        
        let voiceId = selectedVoiceId
        let cacheKey = "\(voiceId)_\(text.hashValue)" as NSString
        
        // Check cache first
        if let cachedData = audioCache.object(forKey: cacheKey) {
            print("DEBUG: Using cached audio for text: \(text.prefix(50))...")
            DispatchQueue.main.async {
                self.playAudio(data: cachedData as Data)
            }
            return
        }
        
        // Create optimized request
        let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/\(voiceId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("audio/mpeg", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")
        request.timeoutInterval = 15.0 // Reasonable timeout
        
        // Use turbo model for faster processing
        let body: [String: Any] = [
            "text": text,
            "model_id": "eleven_turbo_v2", // Faster model
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.75,
                "style": 0.0,
                "use_speaker_boost": true
            ] as [String: Any],
            "optimize_streaming_latency": 2, // Optimize for low latency
            "output_format": "mp3_44100_128" // Specify exact MP3 format
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("DEBUG: Sending ElevenLabs request for text: \(text.prefix(50))...")
        let startTime = Date()
        
        currentTask = urlSession.dataTask(with: request) { data, response, error in
            let elapsed = Date().timeIntervalSince(startTime)
            print("DEBUG: ElevenLabs API response received in \(elapsed) seconds")
            
            // Handle network errors
            if let error = error {
                print("ERROR: Network error: \(error.localizedDescription)")
                
                // Check if it's a cancellation (user stopped) vs network issue
                if (error as NSError).code == NSURLErrorCancelled {
                    print("DEBUG: Request was cancelled by user")
                    DispatchQueue.main.async {
                        self.isPlaying = false
                        self.completionHandler?(false)
                        self.completionHandler = nil
                    }
                } else {
                    // For other network errors, signal failure and let TTSRouter handle fallback
                    print("DEBUG: Network error occurred, will fallback to system voice")
                    DispatchQueue.main.async {
                        self.isPlaying = false
                        self.completionHandler?(false) // TTSRouter will handle fallback
                        self.completionHandler = nil
                    }
                }
                return
            }
            
            // Check HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                print("DEBUG: HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("ERROR: HTTP Error \(httpResponse.statusCode)")
                    if let data = data, let errorString = String(data: data, encoding: .utf8) {
                        print("ERROR: Response body: \(errorString)")
                        
                        // Check for quota exceeded or other API errors
                        if httpResponse.statusCode == 401 || httpResponse.statusCode == 429 {
                            print("DEBUG: ElevenLabs quota exceeded or unauthorized, will fallback to system voice")
                            DispatchQueue.main.async {
                                self.isPlaying = false
                                self.completionHandler?(false) // TTSRouter will handle fallback
                                self.completionHandler = nil
                            }
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        self.isPlaying = false
                        self.completionHandler?(false)
                        self.completionHandler = nil
                    }
                    return
                }
            }
            
            guard let data = data else {
                print("ERROR: No data received from ElevenLabs")
                DispatchQueue.main.async {
                    self.isPlaying = false
                    self.completionHandler?(false)
                    self.completionHandler = nil
                }
                return
            }
            
            // Cache the audio data
            self.audioCache.setObject(data as NSData, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.playAudio(data: data)
            }
        }
        currentTask?.resume()
    }
    
    private func playAudio(data: Data) {
        // Validate audio data
        guard data.count > 0 else {
            print("ERROR: Received empty audio data")
            self.isPlaying = false
            completionHandler?(false)
            completionHandler = nil
            return
        }
        
        print("DEBUG: Received audio data size: \(data.count) bytes")
        
        // Check if data looks like valid audio (basic validation)
        let dataPrefix = data.prefix(4)
        print("DEBUG: Audio data prefix: \(dataPrefix.map { String(format: "%02x", $0) }.joined())")
        
        do {
            // Configure audio session for playback with more specific settings
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Create audio player with better error handling
            self.audioPlayer = try AVAudioPlayer(data: data)
            self.audioPlayer?.delegate = self
            
            // Set audio player properties for better speech playback
            self.audioPlayer?.volume = 1.0
            
            guard let player = self.audioPlayer else {
                print("ERROR: Failed to create audio player")
                self.isPlaying = false
                completionHandler?(false)
                completionHandler = nil
                return
            }
            
            // Prepare and validate before playing
            guard player.prepareToPlay() else {
                print("ERROR: Audio player failed to prepare")
                self.isPlaying = false
                completionHandler?(false)
                completionHandler = nil
                return
            }
            
            print("DEBUG: Audio player prepared successfully, duration: \(player.duration) seconds")
            
            // Start playback
            guard player.play() else {
                print("ERROR: Audio player failed to start playback")
                self.isPlaying = false
                completionHandler?(false)
                completionHandler = nil
                return
            }
            
            self.isPlaying = true
            print("DEBUG: ElevenLabs audio playback started successfully")
            
        } catch let error as NSError {
            print("ERROR: Audio playback error - Code: \(error.code), Description: \(error.localizedDescription)")
            print("ERROR: Audio error domain: \(error.domain)")
            if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                print("ERROR: Underlying error: \(underlyingError)")
            }
            
            self.isPlaying = false
            completionHandler?(false)
            completionHandler = nil
            
            // Signal failure and let TTSRouter handle fallback
            print("DEBUG: Audio playback failed, will fallback to system voice")
            self.completionHandler?(false) // TTSRouter will handle fallback
            self.completionHandler = nil
        }
    }
    
    func stop() {
        // Cancel any ongoing request
        currentTask?.cancel()
        currentTask = nil
        
        // Stop audio playback
        audioPlayer?.stop()
        isPlaying = false // Immediately update state for UI responsiveness
        
        // Call completion handler if it exists
        completionHandler?(false)
        completionHandler = nil
    }
    
    // Clear audio cache to free up memory
    func clearCache() {
        audioCache.removeAllObjects()
        print("DEBUG: ElevenLabs audio cache cleared")
    }
    
    // Get cache statistics
    func getCacheStats() -> (count: Int, totalSize: String) {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB]
        formatter.countStyle = .file
        
        // Estimate cache size (this is approximate)
        let estimatedSize = audioCache.totalCostLimit / 10 // Rough estimate
        return (count: Int(audioCache.totalCostLimit), totalSize: formatter.string(fromByteCount: Int64(estimatedSize)))
    }

    // AVAudioPlayerDelegate methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        completionHandler?(flag)
        completionHandler = nil
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        completionHandler?(false)
        completionHandler = nil
    }
} 