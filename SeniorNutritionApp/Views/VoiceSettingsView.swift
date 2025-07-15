import SwiftUI
import AVFoundation

enum VoiceEngine: String, CaseIterable, Identifiable {
    case system = "System Voice"
    case elevenLabs = "Human-like AI Voice"
    var id: String { self.rawValue }
}

// Helper functions for trial and premium gating
func isWithinFreeTrial() -> Bool {
    if let installDate = UserDefaults.standard.object(forKey: "installDate") as? Date {
        let daysSinceInstall = Calendar.current.dateComponents([.day], from: installDate, to: Date()).day ?? 0
        return daysSinceInstall < 7
    } else {
        // Set install date if not present
        UserDefaults.standard.set(Date(), forKey: "installDate")
        return true
    }
}

var isPremiumUser: Bool {
    // Replace with your actual premium check logic
    return UserDefaults.standard.bool(forKey: "isPremiumUser")
}

var canUseHumanLikeVoice: Bool {
    isWithinFreeTrial() || isPremiumUser
}

struct VoiceSettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var voiceManager = VoiceManager.shared
    @State private var showingVoiceList = false
    @AppStorage("selectedVoiceEngine") private var selectedVoiceEngine: VoiceEngine = .system
    @State private var showUpgradeAlert = false
    @StateObject private var elevenLabsTTS = ElevenLabsTTS()
    
    var body: some View {
        Form {
            Section(header: Text("Voice Engine")) {
                Picker("Voice Engine", selection: $selectedVoiceEngine) {
                    Text("System Voice").tag(VoiceEngine.system)
                    if LanguageManager.shared.currentLanguage != "he" {
                        Text("Human-like AI Voice").tag(VoiceEngine.elevenLabs)
                    }
                }
                .onChange(of: selectedVoiceEngine) { oldValue, newValue in
                    if newValue == .elevenLabs && !canUseHumanLikeVoice {
                        selectedVoiceEngine = .system
                        showUpgradeAlert = true
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .alert(isPresented: $showUpgradeAlert) {
                    Alert(
                        title: Text("Premium Feature"),
                        message: Text("Upgrade to Premium to continue using the Human-like AI Voice."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                if isWithinFreeTrial() && !isPremiumUser && LanguageManager.shared.currentLanguage != "he" {
                    Text("Try Human-like AI Voice free for 7 days!")
                        .font(.caption)
                        .foregroundColor(.green)
                } else if !isPremiumUser && LanguageManager.shared.currentLanguage != "he" {
                    Text("Premium required for Human-like AI Voice.")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                if LanguageManager.shared.currentLanguage == "he" {
                    Text("Human-like AI Voice is not available for Hebrew yet.")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            if selectedVoiceEngine == .elevenLabs {
                Section(header: Text("AI Voice (ElevenLabs)")) {
                    if elevenLabsTTS.availableVoices.isEmpty {
                        Text("Loading voices...")
                    } else {
                        Picker("AI Voice", selection: $elevenLabsTTS.selectedVoiceId) {
                            ForEach(elevenLabsTTS.availableVoices) { voice in
                                Text("\(voice.name) (\(voice.labels["gender"] ?? "") - \(voice.labels["language"] ?? ""))")
                                    .tag(voice.voice_id)
                            }
                        }
                        .onChange(of: elevenLabsTTS.selectedVoiceId) { oldValue, newValue in
                            TTSRouter.shared.elevenLabsTTS.selectedVoiceId = newValue
                        }
                    }
                }
            }
            
            Section(header: Text("Voice Help")) {
                Button(action: {
                    showingVoiceList = true
                }) {
                    HStack {
                        Image(systemName: "speaker.wave.2.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("Check Available Voices")
                                .fontWeight(.medium)
                            Text("View and test all installed voices")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                
                Button(action: {
                    let alert = UIAlertController(
                        title: "Download Enhanced Voices",
                        message: "To get more natural-sounding voices:\n\n1. Open iPhone Settings\n2. Go to Accessibility\n3. Tap Spoken Content\n4. Tap Voices\n5. Select English (or your preferred language)\n6. Look for voices marked as 'Enhanced' or 'Premium'\n7. Tap Download next to the voices you want\n\nAfter downloading, restart this app to see the new voices.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    // Present the alert
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
                        rootViewController.present(alert, animated: true)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("How to Download Better Voices")
                                .fontWeight(.medium)
                            Text("Get enhanced, more natural-sounding voices")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("Voice Settings")) {
                Picker("Voice Gender", selection: $userSettings.preferredVoiceGender) {
                    ForEach(VoiceGender.allCases) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                .onChange(of: userSettings.preferredVoiceGender) { _, newGender in
                    // When gender changes, clear preferredVoiceIdentifier so the app uses the best for that gender
                    userSettings.preferredVoiceIdentifier = nil
                }
                
                Picker("Speech Rate", selection: $userSettings.speechRate) {
                    ForEach(SpeechRate.allCases) { rate in
                        Text(rate.rawValue).tag(rate)
                    }
                }
                .onChange(of: userSettings.speechRate) { _, newRate in
                    // handle change
                }
                
                Button(action: {
                    // Use NSLocalizedString to ensure proper localization
                    let testText = String(format: NSLocalizedString("This is a test of the voice settings", comment: "") + ". " + NSLocalizedString("I am speaking at", comment: "") + " %@ " + NSLocalizedString("rate", comment: "") + ".", userSettings.speechRate.rawValue)
                    
                    if selectedVoiceEngine == .system {
                        TTSRouter.shared.speak(testText, userSettings: userSettings)
                    } else if canUseHumanLikeVoice {
                        TTSRouter.shared.elevenLabsTTS.speak(text: testText)
                    } else {
                        showUpgradeAlert = true
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: TTSRouter.shared.elevenLabsTTS.audioPlayer?.isPlaying == true || VoiceManager.shared.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if TTSRouter.shared.elevenLabsTTS.audioPlayer?.isPlaying == true || VoiceManager.shared.isSpeaking {
                            Text("Stop")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        } else {
                            Text("Test Voice")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
                .accessibilityLabel("Test Voice Settings")
                .accessibilityHint("Hear a sample of the current voice settings")
                
                Button(action: {
                    showingVoiceList = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("Show Available Voices")
                    }
                }
                
                // Debug button to test Hebrew voice detection
                Button(action: {
                    let voices = AVSpeechSynthesisVoice.speechVoices()
                    let hebrewVoices = voices.filter { voice in
                        voice.language.starts(with: "he") || voice.language.contains("IL")
                    }
                    
                    print("=== HEBREW VOICE DEBUG ===")
                    print("Total voices available: \(voices.count)")
                    print("Hebrew voices found: \(hebrewVoices.count)")
                    
                    for voice in hebrewVoices {
                        print("Hebrew Voice: \(voice.name) - Language: \(voice.language) - Quality: \(voice.quality.rawValue)")
                    }
                    
                    if hebrewVoices.isEmpty {
                        print("No Hebrew voices found. User needs to download Hebrew voices from Settings > Accessibility > Spoken Content > Voices")
                    }
                    
                    // Test Hebrew voice creation
                    if let hebrewVoice = AVSpeechSynthesisVoice(language: "he-IL") {
                        print("Successfully created he-IL voice: \(hebrewVoice.name)")
                    } else if let hebrewVoice = AVSpeechSynthesisVoice(language: "he") {
                        print("Successfully created he voice: \(hebrewVoice.name)")
                    } else {
                        print("Failed to create any Hebrew voice")
                    }
                    
                    print("=== END DEBUG ===")
                    
                    // Show alert with results
                    let alert = UIAlertController(
                        title: "Hebrew Voice Debug",
                        message: "Found \(hebrewVoices.count) Hebrew voices. Check console for details.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
                        rootViewController.present(alert, animated: true)
                    }
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Debug Hebrew Voices")
                    }
                }
                .foregroundColor(.orange)
            }
        }
        .navigationTitle("Voice Settings")
        .sheet(isPresented: $showingVoiceList) {
            VoiceListView()
        }
    }
}

struct VoiceListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var voiceManager = VoiceManager.shared
    @State private var selectedVoice: AVSpeechSynthesisVoice? = nil
    @State private var isTestingVoice = false
    @State private var showingDownloadInstructions = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Voice Guide")) {
                    VStack(alignment: .leading, spacing: 12) {
                        // Enhanced voices information
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.green)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Enhanced Voices")
                                    .font(.headline)
                                Text("Enhanced voices sound more natural and are recommended for seniors. They need to be downloaded from iPhone Settings.")
                                    .font(.caption)
                            }
                        }
                        
                        // How to test voices
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Test Each Voice")
                                    .font(.headline)
                                Text("Tap the Test button to hear how each voice sounds. The voice will read a sample text that demonstrates its clarity.")
                                    .font(.caption)
                            }
                        }
                        
                        Divider()
                        
                        // Download instructions button
                        Button(action: {
                            showingDownloadInstructions = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.green)
                                Text("How to Download Enhanced Voices")
                                    .foregroundColor(.green)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Available Voices")) {
                    let voices = AVSpeechSynthesisVoice.speechVoices()
                    
                    // Group voices by language - prioritize current app language
                    let currentLang = LanguageManager.shared.currentLanguage
                    let currentLanguageVoices = voices.filter { voice in
                        switch currentLang {
                        case "he":
                            return voice.language.hasPrefix("he") || voice.language.contains("IL")
                        case "fr":
                            return voice.language.hasPrefix("fr")
                        case "es":
                            return voice.language.hasPrefix("es")
                        default:
                            return voice.language.hasPrefix("en")
                        }
                    }
                    
                    let englishVoices = voices.filter { $0.language.hasPrefix("en") }
                    let hebrewVoices = voices.filter { $0.language.hasPrefix("he") || $0.language.contains("IL") }
                    let frenchVoices = voices.filter { $0.language.hasPrefix("fr") }
                    let spanishVoices = voices.filter { $0.language.hasPrefix("es") }
                    let otherVoices = voices.filter { voice in
                        !voice.language.hasPrefix("en") && 
                        !voice.language.hasPrefix("he") && 
                        !voice.language.contains("IL") &&
                        !voice.language.hasPrefix("fr") &&
                        !voice.language.hasPrefix("es")
                    }
                    
                    // Display message if no enhanced voices are available for current language
                    if !currentLanguageVoices.contains(where: { $0.quality == .enhanced }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.orange)
                            Text("No enhanced voices found for \(currentLang.uppercased()). Use 'How to Download Enhanced Voices' above to add better quality voices.")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Current Language Voices Section (prioritized)
                    if !currentLanguageVoices.isEmpty && currentLang != "en" {
                        Text("\(currentLang.uppercased()) Voices (Current Language)")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(currentLanguageVoices, id: \.identifier) { voice in
                            voiceRow(voice: voice)
                        }
                    }
                    
                    // Hebrew Voices Section
                    if !hebrewVoices.isEmpty && currentLang != "he" {
                        Text("Hebrew Voices")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(hebrewVoices, id: \.identifier) { voice in
                            voiceRow(voice: voice)
                        }
                    }
                    
                    // English Voices Section
                    if !englishVoices.isEmpty && currentLang != "en" {
                        Text("English Voices")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(englishVoices, id: \.identifier) { voice in
                            voiceRow(voice: voice)
                        }
                    } else if currentLang == "en" && !englishVoices.isEmpty {
                        Text("English Voices (Current Language)")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(englishVoices, id: \.identifier) { voice in
                            voiceRow(voice: voice)
                        }
                    }
                    
                    // French Voices Section
                    if !frenchVoices.isEmpty && currentLang != "fr" {
                        Text("French Voices")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(frenchVoices, id: \.identifier) { voice in
                            voiceRow(voice: voice)
                        }
                    }
                    
                    // Spanish Voices Section
                    if !spanishVoices.isEmpty && currentLang != "es" {
                        Text("Spanish Voices")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(spanishVoices, id: \.identifier) { voice in
                            voiceRow(voice: voice)
                        }
                    }
                    
                    // Other Languages Section
                    if !otherVoices.isEmpty {
                        Text("Other Languages")
                            .font(.headline)
                            .padding(.top, 12)
                        
                        ForEach(otherVoices, id: \.identifier) { voice in
                            voiceRow(voice: voice)
                        }
                    }
                }
            }
            .navigationTitle("Available Voices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if let selectedVoice = selectedVoice {
                            userSettings.preferredVoiceIdentifier = selectedVoice.identifier
                            // Optionally update gender for legacy compatibility
                            if selectedVoice.name.lowercased().contains("male") {
                                userSettings.preferredVoiceGender = .male
                            } else if selectedVoice.name.lowercased().contains("female") {
                                userSettings.preferredVoiceGender = .female
                            }
                        }
                        dismiss()
                    }
                }
            }
            .alert("Download Enhanced Voices", isPresented: $showingDownloadInstructions) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("To get more natural-sounding voices:\n\n1. Open iPhone Settings\n2. Go to Accessibility\n3. Tap Spoken Content\n4. Tap Voices\n5. Select your preferred language (English, Hebrew, French, Spanish)\n6. Look for voices marked as 'Enhanced' or 'Premium'\n7. Tap Download next to the voices you want\n\nFor Hebrew: Look for voices like 'Carmit' or other Hebrew voices\nFor best results with Hebrew text, download at least one Hebrew voice.\n\nAfter downloading, restart this app to see the new voices.")
            }
        }
    }
    
    private func testVoice(_ voice: AVSpeechSynthesisVoice) {
        // If already speaking the selected voice, stop it
        if isTestingVoice && selectedVoice?.identifier == voice.identifier {
            TTSRouter.shared.stopSpeaking()
            isTestingVoice = false
            return
        }
        
        isTestingVoice = true
        selectedVoice = voice
        
        // Create a sample utterance that demonstrates the voice characteristics
        let sampleText = NSLocalizedString("Hello, this is a voice sample", comment: "") + ". " + NSLocalizedString("I can read your medication reminders and health tips clearly", comment: "") + "."
        
        // Create a temporary settings object with the selected voice
        let tempSettings = UserSettings()
        tempSettings.speechRate = userSettings.speechRate
        tempSettings.preferredVoiceGender = voice.name.lowercased().contains("male") ? .male : .female
        tempSettings.preferredVoiceIdentifier = voice.identifier
        
        // Use the public speak method with callback for completion
        TTSRouter.shared.speak(sampleText, userSettings: tempSettings)
        self.isTestingVoice = false
    }
    
    // Add a helper function for creating voice rows
    private func voiceRow(voice: AVSpeechSynthesisVoice) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(voice.name)
                        .font(.headline)
                    
                    // Show a badge for voice quality
                    if voice.quality == .enhanced {
                        Text("Enhanced")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(4)
                    } else if voice.identifier.contains("premium") {
                        Text("Premium")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.purple.opacity(0.2))
                            .foregroundColor(.purple)
                            .cornerRadius(4)
                    }
                }
                
                Text("Language: \(formatLanguageCode(voice.language))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Gender indicator
                Text("Gender: \(getVoiceGender(voice))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Identifier: \(voice.identifier)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                
                Spacer()
                
                Button(action: {
                    selectedVoice = voice
                    testVoice(voice)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isTestingVoice && selectedVoice?.identifier == voice.identifier ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            
                        if isTestingVoice && selectedVoice?.identifier == voice.identifier {
                            Text("Stop")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        } else {
                            Text("Test")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .cornerRadius(16)
                }
                .accessibilityLabel("Test Voice")
                .accessibilityHint("Test how this voice sounds")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedVoice = voice
                userSettings.preferredVoiceIdentifier = voice.identifier
                // Set gender based on selected voice
                let gender = getVoiceGenderEnum(voice)
                userSettings.preferredVoiceGender = gender
                testVoice(voice)
            }
            .background((userSettings.preferredVoiceIdentifier == voice.identifier) ? Color.blue.opacity(0.15) : Color.clear)
            .cornerRadius(8)
        }
    }
    
    // Helper function to format language codes for readability
    private func formatLanguageCode(_ code: String) -> String {
        let languages = [
            "en-US": "English (US)",
            "en-GB": "English (UK)",
            "en-AU": "English (Australia)",
            "en-IE": "English (Ireland)",
            "en-ZA": "English (South Africa)",
            "en-IN": "English (India)",
            "fr-FR": "French",
            "de-DE": "German",
            "it-IT": "Italian",
            "es-ES": "Spanish (Spain)",
            "es-MX": "Spanish (Mexico)",
            "pt-BR": "Portuguese (Brazil)",
            "pt-PT": "Portuguese (Portugal)",
            "ru-RU": "Russian",
            "ja-JP": "Japanese",
            "ko-KR": "Korean",
            "zh-CN": "Chinese (Mainland)",
            "zh-HK": "Chinese (Hong Kong)",
            "zh-TW": "Chinese (Taiwan)",
            "he-IL": "Hebrew (Israel)",
            "he": "Hebrew",
            "ar-SA": "Arabic (Saudi Arabia)",
            "ar": "Arabic"
        ]
        
        return languages[code] ?? code
    }
    
    // Helper function to detect voice gender
    private func getVoiceGender(_ voice: AVSpeechSynthesisVoice) -> String {
        let voiceName = voice.name.lowercased()
        
        if voiceName.contains("male") && voiceName.contains("fe") {
            return "Female"
        } else if voiceName.contains("male") {
            return "Male"
        } else if voice.name.contains("Samantha") || voice.name.contains("Siri") || voice.name.contains("Karen") ||
                  voice.name.contains("Tessa") || voice.name.contains("Veena") {
            return "Female"
        } else if voice.name.contains("Alex") || voice.name.contains("Fred") || voice.name.contains("Tom") {
            return "Male"
        } else {
            return "Unknown"
        }
    }

    // Helper to get VoiceGender enum from AVSpeechSynthesisVoice
    private func getVoiceGenderEnum(_ voice: AVSpeechSynthesisVoice) -> VoiceGender {
        let voiceName = voice.name.lowercased()
        if voiceName.contains("male") {
            return .male
        } else if voiceName.contains("female") {
            return .female
        } else if voice.name.contains("Samantha") || voice.name.contains("Siri") || voice.name.contains("Karen") ||
                  voice.name.contains("Tessa") || voice.name.contains("Veena") {
            return .female
        } else if voice.name.contains("Alex") || voice.name.contains("Fred") || voice.name.contains("Tom") {
            return .male
        } else {
            return .female // Default to female if unknown
        }
    }

// Assuming these enums exist elsewhere (e.g., UserSettings.swift or a shared Enums file)
// Ensure they conform to CaseIterable, Identifiable, Codable
/*
enum VoiceGender: String, CaseIterable, Identifiable, Codable {
    case male, female, neutral // Example cases
    var id: String { self.rawValue }
}

enum SpeechRate: String, CaseIterable, Identifiable, Codable {
    case slow, normal, fast // Example cases
    var id: String { self.rawValue }
}
*/

struct VoiceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VoiceSettingsView()
                .environmentObject(UserSettings())
        }
    }
}

import Foundation
import AVFoundation

typealias ElevenLabsVoiceLabels = [String: String]
struct ElevenLabsVoice: Identifiable, Codable {
    let voice_id: String
    let name: String
    let labels: ElevenLabsVoiceLabels
    var id: String { voice_id }
}

typealias ElevenLabsVoicesResponse = [String: [ElevenLabsVoice]]

class ElevenLabsTTS: ObservableObject {
    let apiKey = "sk_7af8c15f9bf82108f037ba22f8704eda0d385ed99c150d26"
    @Published var availableVoices: [ElevenLabsVoice] = []
    @Published var selectedVoiceId: String = "21m00Tcm4TlvDq8ikWAM" // Rachel (English)
    var audioPlayer: AVAudioPlayer?

    init() {
        fetchVoices()
    }

    func fetchVoices() {
        guard let url = URL(string: "https://api.elevenlabs.io/v1/voices") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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

    func speak(text: String) {
        let voiceId = selectedVoiceId
        let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/\(voiceId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("audio/mpeg", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")

        let body: [String: Any] = [
            "text": text,
            "model_id": "eleven_monolingual_v1",
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.75
            ] as [String: Any]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                let errorMessage = error?.localizedDescription ?? "Unknown error"
                print("Error: \(errorMessage)")
                return
            }
            DispatchQueue.main.async {
                self.playAudio(data: data)
            }
        }
        task.resume()
    }

    private func playAudio(data: Data) {
        do {
            self.audioPlayer = try AVAudioPlayer(data: data)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        } catch {
            print("Audio playback error: \(error)")
        }
    }
}
