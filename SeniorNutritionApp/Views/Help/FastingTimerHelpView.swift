import SwiftUI
import Foundation

struct FastingTimerHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HelpComponents.HelpTopic(
                    title: NSLocalizedString("Fasting Timer", comment: ""),
                    description: NSLocalizedString("Understanding fasting protocols and timer features", comment: ""),
                    content: ""
                )
                
                // Introduction Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("What is Intermittent Fasting?", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Intermittent fasting is an eating pattern that cycles between periods of fasting and eating. It doesn't specify which foods to eat but rather when you should eat them. Common fasting protocols include:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    bulletPoint(text: NSLocalizedString("16:8 - Fast for 16 hours, eat during an 8-hour window", comment: ""))
                    bulletPoint(text: NSLocalizedString("18:6 - Fast for 18 hours, eat during a 6-hour window", comment: ""))
                    bulletPoint(text: NSLocalizedString("20:4 - Fast for 20 hours, eat during a 4-hour window", comment: ""))
                    bulletPoint(text: NSLocalizedString("5:2 - Eat normally for 5 days, restrict calories for 2 days", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Using the Timer Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Using the Fasting Timer", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Our fasting timer helps you track your fasting periods:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    helpStep(number: 1, text: NSLocalizedString("Tap the 'Fast' tab at the bottom of your screen", comment: ""))
                    helpStep(number: 2, text: NSLocalizedString("Select your preferred fasting protocol", comment: ""))
                    helpStep(number: 3, text: NSLocalizedString("Tap 'Start Fast' when you begin your fasting period", comment: ""))
                    helpStep(number: 4, text: NSLocalizedString("The timer will count down until your eating window", comment: ""))
                    helpStep(number: 5, text: NSLocalizedString("Tap 'End Fast' when you break your fast", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Timer Features Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Timer Features", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    bulletPoint(text: NSLocalizedString("Progress Circle: Visual representation of your fasting progress", comment: ""))
                    bulletPoint(text: NSLocalizedString("Milestone Markers: Shows key points in your fasting journey", comment: ""))
                    bulletPoint(text: NSLocalizedString("Notifications: Receive alerts at important fasting milestones", comment: ""))
                    bulletPoint(text: NSLocalizedString("History: View your past fasting sessions and statistics", comment: ""))
                    bulletPoint(text: NSLocalizedString("Notes: Add comments about how you feel during your fast", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Health Considerations Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Health Considerations", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Important health notes about fasting:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    bulletPoint(text: NSLocalizedString("Always consult with your healthcare provider before starting any fasting regimen", comment: ""))
                    bulletPoint(text: NSLocalizedString("Stay hydrated during fasting periods", comment: ""))
                    bulletPoint(text: NSLocalizedString("If you feel unwell, it's okay to end your fast early", comment: ""))
                    bulletPoint(text: NSLocalizedString("Certain medications should be taken with food - check with your doctor", comment: ""))
                    bulletPoint(text: NSLocalizedString("Fasting is not recommended for pregnant women or individuals with certain health conditions", comment: ""))
                }
                
                // Video Tutorial Link
                NavigationLink(destination: VideoTutorialView(
                    videoName: "FastingTimer",
                    videoDescription: NSLocalizedString("A visual guide to using the fasting timer features", comment: "")
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
        .navigationTitle(NSLocalizedString("Fasting Help", comment: ""))
    }
    
    private func helpStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Color.orange)
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
                .foregroundColor(.orange)
            
            Text(text)
                .font(.system(size: userSettings.textSize.size))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
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
