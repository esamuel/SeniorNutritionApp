import SwiftUI

struct MedicationHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "pill.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Medication Management", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Set reminders, track medications, and manage your health", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // Getting Started Section
                HelpSection(
                    title: NSLocalizedString("Getting Started", comment: ""),
                    content: [
                        NSLocalizedString("Tap the 'Medications' tab in the More section", comment: ""),
                        NSLocalizedString("Tap 'Add Medication' to create a new entry", comment: ""),
                        NSLocalizedString("Enter medication name, dosage, and frequency", comment: ""),
                        NSLocalizedString("Set reminder times for each medication", comment: ""),
                        NSLocalizedString("Add notes about side effects or special instructions", comment: "")
                    ]
                )
                
                // Key Features Section
                HelpSection(
                    title: NSLocalizedString("Key Features", comment: ""),
                    content: [
                        NSLocalizedString("Medication Database: Store all your medications in one place", comment: ""),
                        NSLocalizedString("Smart Reminders: Get notifications at the right times", comment: ""),
                        NSLocalizedString("Dosage Tracking: Log when you take each medication", comment: ""),
                        NSLocalizedString("Refill Alerts: Get notified when refills are needed", comment: ""),
                        NSLocalizedString("Medication History: Track your adherence over time", comment: ""),
                        NSLocalizedString("Export Lists: Share medication lists with healthcare providers", comment: "")
                    ]
                )
                
                // Managing Reminders Section
                HelpSection(
                    title: NSLocalizedString("Managing Reminders", comment: ""),
                    content: [
                        NSLocalizedString("Set multiple reminder times for each medication", comment: ""),
                        NSLocalizedString("Customize notification sounds and messages", comment: ""),
                        NSLocalizedString("Snooze reminders if you need more time", comment: ""),
                        NSLocalizedString("Mark medications as taken to stop reminders", comment: ""),
                        NSLocalizedString("Review missed doses and take action", comment: "")
                    ]
                )
                
                // Health Considerations Section
                HelpSection(
                    title: NSLocalizedString("Health Considerations", comment: ""),
                    content: [
                        NSLocalizedString("Never skip prescribed medications without doctor approval", comment: ""),
                        NSLocalizedString("Take medications at the same time each day when possible", comment: ""),
                        NSLocalizedString("Store medications properly and check expiration dates", comment: ""),
                        NSLocalizedString("Report side effects to your healthcare provider", comment: ""),
                        NSLocalizedString("Keep an updated medication list for emergencies", comment: "")
                    ]
                )
                
                // Troubleshooting Section
                HelpSection(
                    title: NSLocalizedString("Troubleshooting", comment: ""),
                    content: [
                        NSLocalizedString("If reminders aren't working, check notification settings", comment: ""),
                        NSLocalizedString("Edit medication details if dosages change", comment: ""),
                        NSLocalizedString("Use the search function to find specific medications", comment: ""),
                        NSLocalizedString("Export your medication list as a backup", comment: ""),
                        NSLocalizedString("Contact support if you need help with medication tracking", comment: "")
                    ]
                )
                
                // Video Tutorial Section
                HelpSection(
                    title: NSLocalizedString("Video Tutorial", comment: ""),
                    content: [
                        NSLocalizedString("Watch our step-by-step video guide for medication management", comment: ""),
                        NSLocalizedString("Learn how to set up reminders and track your medications", comment: "")
                    ]
                )
                NavigationLink(destination: VideoTutorialsView()) {
                    Text(NSLocalizedString("Watch Video Tutorial", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.blue)
                }
                
                // Medical Disclaimer Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.blue)
                        Text(NSLocalizedString("Important: This app is for tracking purposes only. Always follow your healthcare provider's instructions regarding your medications.", comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    
                    // Add citations for medication information
                    CitationsView(categories: [.medication])
                }
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Medication Management Help", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MedicationHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MedicationHelpView()
                .environmentObject(UserSettings())
        }
    }
}
