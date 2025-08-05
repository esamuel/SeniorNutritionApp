import SwiftUI
import Foundation

struct AboutView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // App Logo and Version
                VStack(spacing: 10) {
                    Image(systemName: "heart.text.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    Text(NSLocalizedString("Senior Nutrition", comment: "App name"))
                        .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                    
                    Text(NSLocalizedString("Version 1.0.0", comment: "App version"))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                
                // About the App
                sectionTitle(NSLocalizedString("About the App", comment: "Section title"))
                Text(NSLocalizedString("about_app_description", comment: "App description"))
                    .font(.system(size: userSettings.textSize.size))
                
                // Vision and Purpose
                sectionTitle(NSLocalizedString("Our Vision", comment: "Section title"))
                Text(NSLocalizedString("about_vision_description", comment: "Vision description"))
                    .font(.system(size: userSettings.textSize.size))
                
                // Key Features
                sectionTitle(NSLocalizedString("Key Features", comment: "Section title"))
                featuresList([
                    NSLocalizedString("about_feature_nutrition", comment: "Feature description"),
                    NSLocalizedString("about_feature_fasting", comment: "Feature description"),
                    NSLocalizedString("about_feature_medication", comment: "Feature description"),
                    NSLocalizedString("about_feature_languages", comment: "Feature description"),
                    NSLocalizedString("about_feature_accessibility", comment: "Feature description"),
                    NSLocalizedString("about_feature_voice", comment: "Feature description")
                ])
                
                // The Story Behind
                sectionTitle(NSLocalizedString("The Story Behind", comment: "Section title"))
                Text(NSLocalizedString("about_story_description", comment: "Story description"))
                    .font(.system(size: userSettings.textSize.size))
                
                // Safety First
                sectionTitle(NSLocalizedString("Safety First", comment: "Section title"))
                Text(NSLocalizedString("about_safety_description", comment: "Safety description"))
                    .font(.system(size: userSettings.textSize.size))
                
                // Contact Information
                sectionTitle(NSLocalizedString("Contact Us", comment: "Section title"))
                VStack(alignment: .leading, spacing: 10) {
                    contactRow(icon: "envelope.fill", text: "support@seniornutritionapp.com")
                    contactRow(icon: "globe", text: "www.seniornutritionapp.com")
                    contactRow(icon: "phone.fill", text: "+1 (800) 123-4567")
                }
                
                
                // Disclaimer
                Text(NSLocalizedString("about_disclaimer", comment: "Legal disclaimer"))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("About", comment: "Navigation title"))
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
            .padding(.vertical, 5)
    }
    
    private func featuresList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(item)
                        .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    private func contactRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.system(size: userSettings.textSize.size))
        }
    }
}

#Preview {
    NavigationView {
        AboutView()
            .environmentObject(UserSettings())
    }
} 