import SwiftUI

struct HealthMonitoringHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.pink)
                        
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Health Data Tracking", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Monitor vital signs and track your health progress", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // Available Metrics Section
                HelpSection(
                    title: NSLocalizedString("Available Health Metrics", comment: ""),
                    content: [
                        NSLocalizedString("Blood Pressure: Track systolic and diastolic readings", comment: ""),
                        NSLocalizedString("Blood Sugar: Monitor glucose levels for diabetes management", comment: ""),
                        NSLocalizedString("Heart Rate: Record resting and active heart rates", comment: ""),
                        NSLocalizedString("Weight: Track body weight changes over time", comment: ""),
                        NSLocalizedString("Body Mass Index (BMI): Automatic calculation from height and weight", comment: "")
                    ]
                )
                
                // Getting Started Section
                HelpSection(
                    title: NSLocalizedString("Getting Started", comment: ""),
                    content: [
                        NSLocalizedString("Tap the 'Health' tab at the bottom of your screen", comment: ""),
                        NSLocalizedString("Select the health metric you want to track", comment: ""),
                        NSLocalizedString("Tap 'Add' to enter a new reading", comment: ""),
                        NSLocalizedString("Enter your measurement and any notes", comment: ""),
                        NSLocalizedString("View your history and trends over time", comment: "")
                    ]
                )
                
                // Features Section
                HelpSection(
                    title: NSLocalizedString("Key Features", comment: ""),
                    content: [
                        NSLocalizedString("Data Entry: Easy input forms for each health metric", comment: ""),
                        NSLocalizedString("History Tracking: View all your past readings", comment: ""),
                        NSLocalizedString("Trend Analysis: See patterns and changes over time", comment: ""),
                        NSLocalizedString("Target Ranges: Set personal health goals", comment: ""),
                        NSLocalizedString("Export Data: Share with healthcare providers", comment: ""),
                        NSLocalizedString("Reminders: Get notifications for regular check-ins", comment: "")
                    ]
                )
                
                // Health Tips Section
                HelpSection(
                    title: NSLocalizedString("Health Monitoring Tips", comment: ""),
                    content: [
                        NSLocalizedString("Take measurements at the same time each day", comment: ""),
                        NSLocalizedString("Use proper equipment for accurate readings", comment: ""),
                        NSLocalizedString("Record any factors that might affect your readings", comment: ""),
                        NSLocalizedString("Share your data with your healthcare provider", comment: ""),
                        NSLocalizedString("Set realistic health goals with your doctor", comment: "")
                    ]
                )
                
                // Privacy Section
                HelpSection(
                    title: NSLocalizedString("Privacy & Security", comment: ""),
                    content: [
                        NSLocalizedString("Your health data is stored locally on your device", comment: ""),
                        NSLocalizedString("Data is encrypted and secure", comment: ""),
                        NSLocalizedString("You control what data to share", comment: ""),
                        NSLocalizedString("No health data is sent to third parties", comment: ""),
                        NSLocalizedString("You can export or delete your data anytime", comment: "")
                    ]
                )
                
                // Troubleshooting Section
                HelpSection(
                    title: NSLocalizedString("Troubleshooting", comment: ""),
                    content: [
                        NSLocalizedString("If readings seem unusual, double-check your measurements", comment: ""),
                        NSLocalizedString("Use the notes field to record any special circumstances", comment: ""),
                        NSLocalizedString("Set up reminders to maintain consistent tracking", comment: ""),
                        NSLocalizedString("Export your data regularly as a backup", comment: ""),
                        NSLocalizedString("Contact support if you need help with data entry", comment: "")
                    ]
                )
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Health Data Help", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HealthMonitoringHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HealthMonitoringHelpView()
                .environmentObject(UserSettings())
        }
    }
} 