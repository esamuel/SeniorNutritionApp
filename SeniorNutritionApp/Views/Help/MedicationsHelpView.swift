import SwiftUI
import Foundation

struct MedicationsHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HelpComponents.HelpTopic(
                    title: NSLocalizedString("Medications", comment: ""),
                    description: NSLocalizedString("Managing medications and reminders", comment: ""),
                    content: ""
                )
                
                // Introduction Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Medication Management", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("The Medication Management feature helps you keep track of your prescriptions and ensures you take them on time. Here's how to use it:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                }
                .padding(.bottom, 10)
                
                // Adding Medications Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Adding Medications", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    helpStep(number: 1, text: NSLocalizedString("Go to the 'More' tab and select 'Medications'", comment: ""))
                    helpStep(number: 2, text: NSLocalizedString("Tap the '+' button to add a new medication", comment: ""))
                    helpStep(number: 3, text: NSLocalizedString("Enter the medication name, dosage, and instructions", comment: ""))
                    helpStep(number: 4, text: NSLocalizedString("Set the schedule (daily, weekly, as needed, etc.)", comment: ""))
                    helpStep(number: 5, text: NSLocalizedString("Add specific times for reminders", comment: ""))
                    helpStep(number: 6, text: NSLocalizedString("Optionally, add a photo of the medication", comment: ""))
                    helpStep(number: 7, text: NSLocalizedString("Tap 'Save' to confirm", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Setting Reminders Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Medication Reminders", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("The app will send you notifications when it's time to take your medications:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    bulletPoint(text: NSLocalizedString("Make sure notifications are enabled in your device settings", comment: ""))
                    bulletPoint(text: NSLocalizedString("Tap on a notification to mark the medication as taken", comment: ""))
                    bulletPoint(text: NSLocalizedString("You can snooze reminders if needed", comment: ""))
                    bulletPoint(text: NSLocalizedString("The app will send follow-up reminders if you miss a dose", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Tracking Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Tracking Medication Adherence", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Monitor your medication adherence with these features:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    bulletPoint(text: NSLocalizedString("Calendar View: See your medication history by day", comment: ""))
                    bulletPoint(text: NSLocalizedString("Adherence Stats: View your compliance percentage", comment: ""))
                    bulletPoint(text: NSLocalizedString("Missed Doses: Track any medications you forgot to take", comment: ""))
                    bulletPoint(text: NSLocalizedString("Reports: Generate reports to share with your healthcare provider", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Printing Schedule Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Printing Your Medication Schedule", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("You can print a physical copy of your medication schedule:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    helpStep(number: 1, text: NSLocalizedString("Go to the Medications screen", comment: ""))
                    helpStep(number: 2, text: NSLocalizedString("Tap the menu icon (three dots) in the top corner", comment: ""))
                    helpStep(number: 3, text: NSLocalizedString("Select 'Print Schedule'", comment: ""))
                    helpStep(number: 4, text: NSLocalizedString("Choose your preferred format (daily, weekly, or monthly view)", comment: ""))
                    helpStep(number: 5, text: NSLocalizedString("Tap 'Print' to send to your printer or save as PDF", comment: ""))
                }
                
                // Video Tutorial Link
                NavigationLink(destination: VideoTutorialView(
                    videoName: "MedicationManagement",
                    videoDescription: NSLocalizedString("A visual guide to managing your medications", comment: "")
                )) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.blue)
                        Text(NSLocalizedString("Watch Video Tutorial", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Medication Help", comment: ""))
    }
    
    private func helpStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Color.red)
                .cornerRadius(13)
            
            Text(text)
                .font(.system(size: userSettings.textSize.size))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    private func bulletPoint(text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.system(size: userSettings.textSize.size + 4))
                .foregroundColor(.red)
            
            Text(text)
                .font(.system(size: userSettings.textSize.size))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct MedicationsHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MedicationsHelpView()
                .environmentObject(UserSettings())
        }
    }
}
