import SwiftUI

struct VoiceSettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings

    var body: some View {
        List {
            Section(header: Text("General").font(.system(size: userSettings.textSize.size, weight: .bold))) {
                // Enable Voice Input Toggle
                Toggle("Enable Voice Input", isOn: $userSettings.useVoiceInput)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
                    .tint(.blue) // Apply tint for consistency
            }
            
            Section(header: Text("Voice Preferences").font(.system(size: userSettings.textSize.size, weight: .bold))) {
                // Voice Gender Picker
                Picker("Preferred Voice", selection: $userSettings.preferredVoiceGender) {
                    ForEach(VoiceGender.allCases) { gender in
                        Text(gender.rawValue.capitalized).tag(gender)
                    }
                }
                .font(.system(size: userSettings.textSize.size))
                .padding(.vertical, 8)

                // Speech Rate Picker
                Picker("Speech Rate", selection: $userSettings.speechRate) {
                    ForEach(SpeechRate.allCases) { rate in
                        Text(rate.rawValue.capitalized).tag(rate)
                    }
                }
                .font(.system(size: userSettings.textSize.size))
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Voice Settings")
        .navigationBarTitleDisplayMode(.inline) // Use inline for sub-views
        .listStyle(InsetGroupedListStyle())
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
        NavigationView { // Wrap in NavigationView for preview
            VoiceSettingsView()
                .environmentObject(UserSettings())
        }
    }
}
