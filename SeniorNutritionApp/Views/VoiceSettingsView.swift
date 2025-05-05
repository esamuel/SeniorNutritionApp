import SwiftUI
import AVFoundation

struct VoiceSettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var voiceManager = VoiceManager.shared
    @State private var showingVoiceList = false
    
    var body: some View {
        Form {
            Section(header: Text("Voice Settings")) {
                Picker("Voice Gender", selection: $userSettings.preferredVoiceGender) {
                    ForEach(VoiceGender.allCases) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                
                Picker("Speech Rate", selection: $userSettings.speechRate) {
                    ForEach(SpeechRate.allCases) { rate in
                        Text(rate.rawValue).tag(rate)
                    }
                }
                
                Button(action: {
                    voiceManager.speak("This is a test of the voice settings. I am speaking at \(userSettings.speechRate.rawValue) rate.", userSettings: userSettings)
                }) {
                    HStack {
                        Image(systemName: "speaker.wave.2")
                        Text("Test Voice Settings")
                    }
                }
                
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
    @State private var selectedVoice: AVSpeechSynthesisVoice?
    @State private var isTestingVoice = false
    @State private var showingDownloadInstructions = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        showingDownloadInstructions = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.blue)
                            Text("How to Download Enhanced Voices")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Available Voices")) {
                    let voices = AVSpeechSynthesisVoice.speechVoices()
                    ForEach(voices, id: \.identifier) { voice in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(voice.name)
                                    .font(.headline)
                                Text("Language: \(voice.language)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Quality: \(voice.identifier.contains("premium") ? "Enhanced" : "Standard")")
                                    .font(.subheadline)
                                    .foregroundColor(voice.identifier.contains("premium") ? .green : .gray)
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
                                Image(systemName: isTestingVoice && selectedVoice?.identifier == voice.identifier ? "speaker.wave.2.fill" : "speaker.wave.2")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedVoice = voice
                            testVoice(voice)
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
                            // Update user settings based on the selected voice
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
                Text("To get more natural-sounding voices:\n\n1. Open iPhone Settings\n2. Go to Siri & Search\n3. Tap Siri Voice\n4. Under English (United States), tap the voice you want\n5. Wait for the download to complete\n\nEnhanced voices will appear in green in this list once downloaded.")
            }
        }
    }
    
    private func testVoice(_ voice: AVSpeechSynthesisVoice) {
        isTestingVoice = true
        
        // Create a temporary settings object with the selected voice
        let tempSettings = UserSettings()
        tempSettings.speechRate = userSettings.speechRate
        tempSettings.preferredVoiceGender = voice.name.lowercased().contains("male") ? .male : .female
        
        // Use the public speak method
        voiceManager.speak("This is a test of the selected voice. How does it sound?", userSettings: tempSettings)
        
        // Reset the testing state after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isTestingVoice = false
        }
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
