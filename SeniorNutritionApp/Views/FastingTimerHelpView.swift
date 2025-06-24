import SwiftUI

struct FastingTimerHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "timer")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Fasting Timer", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Manage intermittent fasting schedules and track progress", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // What is Intermittent Fasting Section
                HelpSection(
                    title: NSLocalizedString("What is Intermittent Fasting?", comment: ""),
                    content: [
                        NSLocalizedString("Intermittent fasting cycles between eating and fasting periods", comment: ""),
                        NSLocalizedString("Common protocols: 16:8 (16 hours fasting, 8 hours eating)", comment: ""),
                        NSLocalizedString("Other options: 18:6, 20:4, or custom schedules", comment: ""),
                        NSLocalizedString("May help with weight management and metabolic health", comment: ""),
                        NSLocalizedString("Always consult your doctor before starting any fasting plan", comment: "")
                    ]
                )
                
                // Getting Started Section
                HelpSection(
                    title: NSLocalizedString("Getting Started", comment: ""),
                    content: [
                        NSLocalizedString("Tap the 'Fasting' tab at the bottom of your screen", comment: ""),
                        NSLocalizedString("Choose a fasting protocol or create a custom schedule", comment: ""),
                        NSLocalizedString("Set your fasting start time and duration", comment: ""),
                        NSLocalizedString("Tap 'Start Fasting' to begin your fasting period", comment: ""),
                        NSLocalizedString("The timer will track your progress automatically", comment: "")
                    ]
                )
                
                // Key Features Section
                HelpSection(
                    title: NSLocalizedString("Key Features", comment: ""),
                    content: [
                        NSLocalizedString("Multiple Protocols: 16:8, 18:6, 20:4, and custom schedules", comment: ""),
                        NSLocalizedString("Visual Timer: See your fasting progress in real-time", comment: ""),
                        NSLocalizedString("Notifications: Get alerts for start, end, and milestone times", comment: ""),
                        NSLocalizedString("Progress Tracking: View your fasting history and streaks", comment: ""),
                        NSLocalizedString("Emergency Stop: End fasting early if needed", comment: ""),
                        NSLocalizedString("Statistics: Track your fasting patterns over time", comment: "")
                    ]
                )
                
                // Safety Guidelines Section
                HelpSection(
                    title: NSLocalizedString("Safety Guidelines", comment: ""),
                    content: [
                        NSLocalizedString("Consult your healthcare provider before starting fasting", comment: ""),
                        NSLocalizedString("Stay hydrated during fasting periods", comment: ""),
                        NSLocalizedString("Listen to your body and stop if you feel unwell", comment: ""),
                        NSLocalizedString("Don't skip prescribed medications without doctor approval", comment: ""),
                        NSLocalizedString("Start with shorter fasting periods and gradually increase", comment: ""),
                        NSLocalizedString("Eat nutritious foods during your eating window", comment: "")
                    ]
                )
                
                // Notifications Section
                HelpSection(
                    title: NSLocalizedString("Notifications & Reminders", comment: ""),
                    content: [
                        NSLocalizedString("Fasting Start: Notification when your fast begins", comment: ""),
                        NSLocalizedString("Fasting End: Alert when it's time to eat", comment: ""),
                        NSLocalizedString("Halfway Point: Motivation at the midpoint", comment: ""),
                        NSLocalizedString("Custom Reminders: Set your own notification times", comment: ""),
                        NSLocalizedString("Emergency Alerts: Quick access to stop fasting", comment: "")
                    ]
                )
                
                // Troubleshooting Section
                HelpSection(
                    title: NSLocalizedString("Troubleshooting", comment: ""),
                    content: [
                        NSLocalizedString("If you need to stop fasting early, tap 'Stop Fasting'", comment: ""),
                        NSLocalizedString("Adjust your fasting schedule in the settings", comment: ""),
                        NSLocalizedString("Check notification permissions if alerts aren't working", comment: ""),
                        NSLocalizedString("Contact support if you have technical issues", comment: "")
                    ]
                )
                
                // Video Tutorial Section
                HelpSection(
                    title: NSLocalizedString("Video Tutorial", comment: ""),
                    content: [
                        NSLocalizedString("Watch our step-by-step video guide for fasting timer", comment: ""),
                        NSLocalizedString("Learn about different fasting protocols and safety tips", comment: "")
                    ]
                )
                NavigationLink(destination: VideoTutorialsView()) {
                    Text(NSLocalizedString("Watch Video Tutorial", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Fasting Timer Help", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FastingTimerHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FastingTimerHelpView()
                .environmentObject(UserSettings())
        }
    }
}
