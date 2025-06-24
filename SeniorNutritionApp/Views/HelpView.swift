import SwiftUI

struct HelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.openURL) var openURL

    var body: some View {
        List {
            // Getting Started Section
            Section(header: Text(NSLocalizedString("Getting Started", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                NavigationLink(destination: AppTourView()) {
                    HelpCardView(
                        title: NSLocalizedString("App Tour", comment: ""),
                        subtitle: NSLocalizedString("Take a guided tour of the app", comment: ""),
                        icon: "map.fill",
                        color: .blue
                    )
                }
                
                NavigationLink(destination: FAQView()) {
                    HelpCardView(
                        title: NSLocalizedString("FAQ", comment: ""),
                        subtitle: NSLocalizedString("Frequently asked questions", comment: ""),
                        icon: "questionmark.circle.fill",
                        color: .gray
                    )
                }
            }

            // Core Features Section
            Section(header: Text(NSLocalizedString("Core Features", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                NavigationLink(destination: NutritionHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Nutrition Tracking", comment: ""),
                        subtitle: NSLocalizedString("Track meals, analyze nutrition, and monitor daily intake", comment: ""),
                        icon: "fork.knife",
                        color: .green
                    )
                }
                
                NavigationLink(destination: FastingTimerHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Fasting Timer", comment: ""),
                        subtitle: NSLocalizedString("Manage intermittent fasting schedules and track progress", comment: ""),
                        icon: "timer",
                        color: .orange
                    )
                }
                
                NavigationLink(destination: WaterTrackingHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Water Tracking", comment: ""),
                        subtitle: NSLocalizedString("Monitor daily hydration and set water intake goals", comment: ""),
                        icon: "drop.fill",
                        color: .blue
                    )
                }
                
                NavigationLink(destination: MedicationHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Medication Management", comment: ""),
                        subtitle: NSLocalizedString("Set reminders, track medications, and manage your health", comment: ""),
                        icon: "pill.fill",
                        color: .red
                    )
                }
            }

            // Health Monitoring Section
            Section(header: Text(NSLocalizedString("Health Monitoring", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                NavigationLink(destination: HealthMonitoringHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Health Data", comment: ""),
                        subtitle: NSLocalizedString("Track blood pressure, blood sugar, heart rate, and weight", comment: ""),
                        icon: "heart.fill",
                        color: .pink
                    )
                }
                
                NavigationLink(destination: AppointmentHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Appointments", comment: ""),
                        subtitle: NSLocalizedString("Manage medical appointments and reminders", comment: ""),
                        icon: "calendar",
                        color: .purple
                    )
                }
            }

            // Accessibility Section
            Section(header: Text(NSLocalizedString("Accessibility", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                NavigationLink(destination: VoiceAssistanceHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Voice Assistance", comment: ""),
                        subtitle: NSLocalizedString("Use voice commands to navigate and control the app", comment: ""),
                        icon: "mic.fill",
                        color: .purple
                    )
                }
                
                NavigationLink(destination: AccessibilityHelpView()) {
                    HelpCardView(
                        title: NSLocalizedString("Accessibility Features", comment: ""),
                        subtitle: NSLocalizedString("Text size, contrast, and other accessibility options", comment: ""),
                        icon: "accessibility",
                        color: .indigo
                    )
                }
            }

            // Support Options Section
            Section(header: Text(NSLocalizedString("Support Options", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                if let url = URL(string: "mailto:\(AppConfig.Support.email)") {
                    Link(destination: url) {
                        HelpCardView(
                            title: NSLocalizedString("Contact Support", comment: ""),
                            subtitle: NSLocalizedString("Get help from our support team", comment: ""),
                            icon: "envelope.fill",
                            color: .blue
                        )
                    }
                }
                
                if let url = URL(string: "mailto:\(AppConfig.Support.email)?subject=Video%20Chat%20Request") {
                    Link(destination: url) {
                        HelpCardView(
                            title: NSLocalizedString("Video Chat", comment: ""),
                            subtitle: NSLocalizedString("Schedule a video call with support", comment: ""),
                            icon: "video.fill",
                            color: .green
                        )
                    }
                }
                
                NavigationLink(destination: VideoTutorialsView()) {
                    HelpCardView(
                        title: NSLocalizedString("Video Tutorials", comment: ""),
                        subtitle: NSLocalizedString("Watch step-by-step video guides", comment: ""),
                        icon: "play.rectangle.fill",
                        color: .red
                    )
                }
            }
            
            // Legal Section
            Section(header: Text(NSLocalizedString("Legal", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                NavigationLink(destination: PrivacyPolicyView()) {
                    HelpCardView(
                        title: NSLocalizedString("Privacy Policy", comment: ""), 
                        subtitle: NSLocalizedString("Read our privacy policy", comment: ""), 
                        icon: "lock.shield.fill", 
                        color: .gray
                    )
                }
                NavigationLink(destination: TermsOfUseView()) {
                    HelpCardView(
                        title: NSLocalizedString("Terms of Use", comment: ""), 
                        subtitle: NSLocalizedString("Read our terms of use", comment: ""), 
                        icon: "doc.text.fill", 
                        color: .gray
                    )
                }
            }

            // Emergency Help Section
            Section(header: Text(NSLocalizedString("Emergency", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                Button(action: {
                    if let url = URL(string: "tel://\(AppConfig.Emergency.emergencyNumber)"), UIApplication.shared.canOpenURL(url) {
                        openURL(url)
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
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            Text(NSLocalizedString("Call emergency services", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .navigationTitle(NSLocalizedString("Help & Support", comment: ""))
    }
}

private struct HelpCardView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                Text(subtitle)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
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