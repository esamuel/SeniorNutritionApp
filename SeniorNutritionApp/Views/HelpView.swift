import SwiftUI
import Foundation
import UIKit

struct HelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    
    var body: some View {
        List {
            // Quick Help Section
            Section(header: Text(NSLocalizedString("QUICK HELP", comment: ""))
                .font(Font.system(size: userSettings.textSize.size, weight: .bold))) {
                
                NavigationLink(destination: AppTourView()) {
                    helpButtonContent(
                        title: NSLocalizedString("App Tour", comment: ""),
                        subtitle: NSLocalizedString("Take a guided tour of the app", comment: ""),
                        icon: "map.fill",
                        color: .blue
                    )
                }
                
                NavigationLink(destination: VoiceAssistanceHelpView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Voice Assistance", comment: ""),
                        subtitle: NSLocalizedString("Learn how to use voice commands", comment: ""),
                        icon: "mic.fill",
                        color: .purple
                    )
                }
            }
            
            // Feature Guides Section
            Section(header: Text(NSLocalizedString("FEATURE GUIDES", comment: ""))
                .font(Font.system(size: userSettings.textSize.size, weight: .bold))) {
                
                NavigationLink(destination: NutritionTrackingHelpView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Nutrition Tracking", comment: ""),
                        subtitle: NSLocalizedString("Learn about meal logging and nutrition analysis", comment: ""),
                        icon: "fork.knife",
                        color: .green
                    )
                }
                
                NavigationLink(destination: FastingTimerHelpView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Fasting Timer", comment: ""),
                        subtitle: NSLocalizedString("Understanding fasting protocols and timer features", comment: ""),
                        icon: "timer",
                        color: .orange
                    )
                }
                
                NavigationLink(destination: WaterTrackingHelpView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Water Tracking", comment: ""),
                        subtitle: NSLocalizedString("How to track and manage hydration", comment: ""),
                        icon: "drop.fill",
                        color: .blue
                    )
                }
                
                NavigationLink(destination: MedicationsHelpView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Medications", comment: ""),
                        subtitle: NSLocalizedString("Managing medications and reminders", comment: ""),
                        icon: "pill.fill",
                        color: .red
                    )
                }
            }
            
            // Support Options Section
            Section(header: Text(NSLocalizedString("SUPPORT OPTIONS", comment: ""))
                .font(Font.system(size: userSettings.textSize.size, weight: .bold))) {
                
                NavigationLink(destination: ContactSupportView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Contact Support", comment: ""),
                        subtitle: NSLocalizedString("Get help from our support team", comment: ""),
                        icon: "envelope.fill",
                        color: .blue
                    )
                }
                
                NavigationLink(destination: VideoTutorialsView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Video Tutorials", comment: ""),
                        subtitle: NSLocalizedString("Learn through guided videos", comment: ""),
                        icon: "play.rectangle.fill",
                        color: .green
                    )
                }
                
                NavigationLink(destination: FAQView()) {
                    helpButtonContent(
                        title: NSLocalizedString("FAQ", comment: ""),
                        subtitle: NSLocalizedString("Frequently asked questions", comment: ""),
                        icon: "questionmark.circle.fill",
                        color: .gray
                    )
                }
            }
            
            // Legal Section
            Section(header: Text(NSLocalizedString("LEGAL", comment: ""))
                .font(Font.system(size: userSettings.textSize.size, weight: .bold))) {
                
                NavigationLink(destination: PrivacyPolicyView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Privacy Policy", comment: ""),
                        subtitle: NSLocalizedString("How we protect your data", comment: ""),
                        icon: "lock.shield.fill",
                        color: .indigo
                    )
                }
                
                NavigationLink(destination: TermsOfUseView()) {
                    helpButtonContent(
                        title: NSLocalizedString("Terms of Use", comment: ""),
                        subtitle: NSLocalizedString("App usage agreement", comment: ""),
                        icon: "doc.text.fill",
                        color: .gray
                    )
                }
            }
            
            // Emergency Help Section
            Section(header: Text(NSLocalizedString("EMERGENCY", comment: ""))
                .font(Font.system(size: userSettings.textSize.size, weight: .bold))) {
                
                Button(action: {
                    // Call emergency number
                    if let url = URL(string: "tel:\(AppConfig.Emergency.emergencyNumber)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Emergency Help", comment: ""))
                                .font(Font.system(size: userSettings.textSize.size, weight: .semibold))
                            Text(NSLocalizedString("Call emergency services", comment: ""))
                                .font(Font.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle(NSLocalizedString("Help & Support", comment: ""))
    }
    
    private func helpButtonContent(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(Font.system(size: userSettings.textSize.size, weight: .semibold))
                Text(subtitle)
                    .font(Font.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .foregroundColor(.primary)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HelpView()
                .environmentObject(UserSettings())
        }
    }
} 