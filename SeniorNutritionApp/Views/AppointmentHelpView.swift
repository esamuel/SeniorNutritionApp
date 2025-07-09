import SwiftUI

struct AppointmentHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 40))
                            .foregroundColor(.purple)
                        
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Appointment Management", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Organize and track your medical appointments", comment: ""))
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
                        NSLocalizedString("Tap the 'More' tab and select 'Appointments'", comment: ""),
                        NSLocalizedString("Tap 'Add Appointment' to create a new entry", comment: ""),
                        NSLocalizedString("Enter appointment details including date, time, and provider", comment: ""),
                        NSLocalizedString("Add notes about what to discuss or prepare", comment: ""),
                        NSLocalizedString("Set reminders to ensure you don't miss appointments", comment: "")
                    ]
                )
                
                // Features Section
                HelpSection(
                    title: NSLocalizedString("Key Features", comment: ""),
                    content: [
                        NSLocalizedString("Appointment Scheduling: Add new appointments with full details", comment: ""),
                        NSLocalizedString("Provider Information: Store doctor and facility contact details", comment: ""),
                        NSLocalizedString("Reminder System: Get notifications before appointments", comment: ""),
                        NSLocalizedString("Notes & Preparation: Add important information to discuss", comment: ""),
                        NSLocalizedString("Calendar View: See all appointments in chronological order", comment: ""),
                        NSLocalizedString("History Tracking: Keep records of past appointments", comment: ""),
                        NSLocalizedString("Location Details: Store addresses and directions", comment: "")
                    ]
                )
                
                // Best Practices Section
                HelpSection(
                    title: NSLocalizedString("Best Practices", comment: ""),
                    content: [
                        NSLocalizedString("Add appointments as soon as you schedule them", comment: ""),
                        NSLocalizedString("Include provider contact information for easy access", comment: ""),
                        NSLocalizedString("Set reminders 1-2 days before appointments", comment: ""),
                        NSLocalizedString("Add notes about questions to ask or symptoms to discuss", comment: ""),
                        NSLocalizedString("Record appointment outcomes and follow-up instructions", comment: ""),
                        NSLocalizedString("Keep a list of medications to bring to appointments", comment: "")
                    ]
                )
                
                // Organization Tips Section
                HelpSection(
                    title: NSLocalizedString("Organization Tips", comment: ""),
                    content: [
                        NSLocalizedString("Use consistent naming for providers and facilities", comment: ""),
                        NSLocalizedString("Add appointment type (checkup, specialist, test, etc.)", comment: ""),
                        NSLocalizedString("Include insurance information if needed", comment: ""),
                        NSLocalizedString("Note any special instructions (fasting, bring records, etc.)", comment: ""),
                        NSLocalizedString("Set different reminder times for different appointment types", comment: "")
                    ]
                )
                
                // Integration Section
                HelpSection(
                    title: NSLocalizedString("Integration with Other Features", comment: ""),
                    content: [
                        NSLocalizedString("Link appointments with medication reminders", comment: ""),
                        NSLocalizedString("Prepare health data to share with providers", comment: ""),
                        NSLocalizedString("Track symptoms before appointments", comment: ""),
                        NSLocalizedString("Record doctor's recommendations in notes", comment: ""),
                        NSLocalizedString("Set follow-up reminders based on appointment outcomes", comment: "")
                    ]
                )
                
                // Troubleshooting Section
                HelpSection(
                    title: NSLocalizedString("Troubleshooting", comment: ""),
                    content: [
                        NSLocalizedString("If reminders aren't working, check notification settings", comment: ""),
                        NSLocalizedString("Use the search function to find specific appointments", comment: ""),
                        NSLocalizedString("Export appointment data to share with caregivers", comment: ""),
                        NSLocalizedString("Backup your appointment data regularly", comment: ""),
                        NSLocalizedString("Contact support if you need help with calendar sync", comment: "")
                    ]
                )
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Appointments Help", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppointmentHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppointmentHelpView()
                .environmentObject(UserSettings())
        }
    }
} 