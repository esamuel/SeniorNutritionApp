import SwiftUI
import Foundation

struct WaterTrackingHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HelpComponents.HelpTopic(
                    title: NSLocalizedString("Water Tracking", comment: ""),
                    description: NSLocalizedString("How to track and manage hydration", comment: ""),
                    content: ""
                )
                
                // Introduction Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Importance of Hydration", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Proper hydration is essential for overall health, especially for seniors. It helps with:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    bulletPoint(text: NSLocalizedString("Maintaining body temperature", comment: ""))
                    bulletPoint(text: NSLocalizedString("Lubricating joints", comment: ""))
                    bulletPoint(text: NSLocalizedString("Preventing infections", comment: ""))
                    bulletPoint(text: NSLocalizedString("Delivering nutrients to cells", comment: ""))
                    bulletPoint(text: NSLocalizedString("Keeping organs functioning properly", comment: ""))
                    bulletPoint(text: NSLocalizedString("Improving cognitive function", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Using Water Tracker Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Using the Water Tracker", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Our water tracking feature helps you monitor your daily fluid intake:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    helpStep(number: 1, text: NSLocalizedString("Tap the 'Water' tab at the bottom of your screen", comment: ""))
                    helpStep(number: 2, text: NSLocalizedString("View your daily water goal and current progress", comment: ""))
                    helpStep(number: 3, text: NSLocalizedString("Tap the '+' button to log water consumption", comment: ""))
                    helpStep(number: 4, text: NSLocalizedString("Select the amount of water you've consumed", comment: ""))
                    helpStep(number: 5, text: NSLocalizedString("The app will update your daily progress", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Setting Goals Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Setting Hydration Goals", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("You can personalize your daily water intake goal:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    helpStep(number: 1, text: NSLocalizedString("Go to the 'Water' tab", comment: ""))
                    helpStep(number: 2, text: NSLocalizedString("Tap the settings icon in the top corner", comment: ""))
                    helpStep(number: 3, text: NSLocalizedString("Select 'Set Daily Goal'", comment: ""))
                    helpStep(number: 4, text: NSLocalizedString("Choose your preferred measurement unit (oz or ml)", comment: ""))
                    helpStep(number: 5, text: NSLocalizedString("Enter your target daily water intake", comment: ""))
                    helpStep(number: 6, text: NSLocalizedString("Tap 'Save' to confirm your new goal", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Tips Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Hydration Tips", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    bulletPoint(text: NSLocalizedString("Start your day with a glass of water", comment: ""))
                    bulletPoint(text: NSLocalizedString("Carry a water bottle with you throughout the day", comment: ""))
                    bulletPoint(text: NSLocalizedString("Set reminders to drink water regularly", comment: ""))
                    bulletPoint(text: NSLocalizedString("Eat water-rich foods like fruits and vegetables", comment: ""))
                    bulletPoint(text: NSLocalizedString("Limit caffeine and alcohol, which can cause dehydration", comment: ""))
                    bulletPoint(text: NSLocalizedString("Increase water intake during hot weather or when exercising", comment: ""))
                }
                
                // Video Tutorial Link
                NavigationLink(destination: VideoTutorialView(
                    videoName: "WaterTracking",
                    videoDescription: NSLocalizedString("A visual guide to using the water tracking features", comment: "")
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
        .navigationTitle(NSLocalizedString("Water Help", comment: ""))
    }
    
    private func helpStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Color.blue)
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
                .foregroundColor(.blue)
            
            Text(text)
                .font(.system(size: userSettings.textSize.size))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

struct WaterTrackingHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WaterTrackingHelpView()
                .environmentObject(UserSettings())
        }
    }
}
