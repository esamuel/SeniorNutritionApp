import SwiftUI

struct HelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    
    var body: some View {
        List {
            // Quick Help Section
            Section(header: Text(NSLocalizedString("Quick Help", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                
                helpButton(
                    title: NSLocalizedString("App Tour", comment: ""),
                    subtitle: NSLocalizedString("Take a guided tour of the app", comment: ""),
                    icon: "map.fill",
                    color: .blue
                )
                
                helpButton(
                    title: NSLocalizedString("Voice Assistance", comment: ""),
                    subtitle: NSLocalizedString("Learn how to use voice commands", comment: ""),
                    icon: "mic.fill",
                    color: .purple
                )
            }
            
            // Feature Guides Section
            Section(header: Text(NSLocalizedString("Feature Guides", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                
                helpButton(
                    title: NSLocalizedString("Nutrition Tracking", comment: ""),
                    subtitle: NSLocalizedString("Learn about meal logging and nutrition analysis", comment: ""),
                    icon: "fork.knife",
                    color: .green
                )
                
                helpButton(
                    title: NSLocalizedString("Fasting Timer", comment: ""),
                    subtitle: NSLocalizedString("Understanding fasting protocols and timer features", comment: ""),
                    icon: "timer",
                    color: .orange
                )
                
                helpButton(
                    title: NSLocalizedString("Water Tracking", comment: ""),
                    subtitle: NSLocalizedString("How to track and manage hydration", comment: ""),
                    icon: "drop.fill",
                    color: .blue
                )
                
                helpButton(
                    title: NSLocalizedString("Medications", comment: ""),
                    subtitle: NSLocalizedString("Managing medications and reminders", comment: ""),
                    icon: "pill.fill",
                    color: .red
                )
            }
            
            // Support Options Section
            Section(header: Text(NSLocalizedString("Support Options", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                
                helpButton(
                    title: NSLocalizedString("Contact Support", comment: ""),
                    subtitle: NSLocalizedString("Get help from our support team", comment: ""),
                    icon: "envelope.fill",
                    color: .blue
                )
                
                helpButton(
                    title: NSLocalizedString("Video Chat", comment: ""),
                    subtitle: NSLocalizedString("Schedule a video call with support", comment: ""),
                    icon: "video.fill",
                    color: .green
                )
                
                helpButton(
                    title: NSLocalizedString("FAQ", comment: ""),
                    subtitle: NSLocalizedString("Frequently asked questions", comment: ""),
                    icon: "questionmark.circle.fill",
                    color: .gray
                )
            }
            
            // Emergency Help Section
            Section(header: Text(NSLocalizedString("Emergency", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                
                Button(action: {
                    // Emergency help action
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
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle(NSLocalizedString("Help & Support", comment: ""))
    }
    
    private func helpButton(title: String, subtitle: String, icon: String, color: Color) -> some View {
        Button(action: {
            // Help topic action
        }) {
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