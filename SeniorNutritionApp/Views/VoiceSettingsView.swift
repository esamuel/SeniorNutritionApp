import SwiftUI
import AVFoundation

struct VoiceSettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var voiceManager = VoiceManager.shared
    @State private var showingVoiceList = false
    
    var body: some View {
        Form {
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
                .onChange(of: userSettings.preferredVoiceGender) { newGender in
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
                    voiceManager.speak("This is a test of the voice settings. I am speaking at \(userSettings.speechRate.rawValue) rate.", userSettings: userSettings)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.white)
                            .imageScale(.large)
                        
                        if voiceManager.isSpeaking {
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
                    
                    // Group voices by language
                    let englishVoices = voices.filter { $0.language.hasPrefix("en") }
                    let otherVoices = voices.filter { !$0.language.hasPrefix("en") }
                    
                    // Display message if no enhanced voices are available
                    if !englishVoices.contains(where: { $0.quality == .enhanced }) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.orange)
                            Text("No enhanced voices found. Use 'How to Download Enhanced Voices' above to add better quality voices.")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // English Voices Section
                    if !englishVoices.isEmpty {
                        Text("English Voices")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        ForEach(englishVoices, id: \.identifier) { voice in
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
                Text("To get more natural-sounding voices:\n\n1. Open iPhone Settings\n2. Go to Accessibility\n3. Tap Spoken Content\n4. Tap Voices\n5. Select English (or your preferred language)\n6. Look for voices marked as 'Enhanced' or 'Premium'\n7. Tap Download next to the voices you want\n\nAfter downloading, restart this app to see the new voices.")
            }
        }
    }
    
    private func testVoice(_ voice: AVSpeechSynthesisVoice) {
        // If already speaking the selected voice, stop it
        if isTestingVoice && selectedVoice?.identifier == voice.identifier {
            voiceManager.stopSpeaking()
            isTestingVoice = false
            return
        }
        
        isTestingVoice = true
        selectedVoice = voice
        
        // Create a sample utterance that demonstrates the voice characteristics
        let sampleText = "Hello, this is a voice sample. I can read your medication reminders and health tips clearly."
        
        // Create a temporary settings object with the selected voice
        let tempSettings = UserSettings()
        tempSettings.speechRate = userSettings.speechRate
        tempSettings.preferredVoiceGender = voice.name.lowercased().contains("male") ? .male : .female
        tempSettings.preferredVoiceIdentifier = voice.identifier
        
        // Use the public speak method with callback for completion
        voiceManager.speak(sampleText, userSettings: tempSettings) { finished in
            if finished {
                DispatchQueue.main.async {
                    self.isTestingVoice = false
                }
            }
        }
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
            "zh-TW": "Chinese (Taiwan)"
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
