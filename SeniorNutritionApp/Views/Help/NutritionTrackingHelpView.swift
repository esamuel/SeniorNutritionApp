import SwiftUI
import Foundation

struct NutritionTrackingHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HelpComponents.HelpTopic(
                    title: NSLocalizedString("Nutrition Tracking", comment: ""),
                    description: NSLocalizedString("Learn how to log and analyze your meals", comment: ""),
                    content: ""
                )
                
                // Getting Started Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Getting Started", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("The Nutrition Tracking feature helps you monitor your daily food intake and nutritional balance. Here's how to use it:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    helpStep(number: 1, text: NSLocalizedString("Tap the 'Nutrition' tab at the bottom of your screen", comment: ""))
                    helpStep(number: 2, text: NSLocalizedString("Select 'Add Meal' to record what you've eaten", comment: ""))
                    helpStep(number: 3, text: NSLocalizedString("Choose from common foods or search for specific items", comment: ""))
                    helpStep(number: 4, text: NSLocalizedString("Add portion sizes and save your meal", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Meal Logging Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Meal Logging Tips", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    bulletPoint(text: NSLocalizedString("Log meals as soon as possible after eating for better accuracy", comment: ""))
                    bulletPoint(text: NSLocalizedString("Use the camera icon to take a photo of your meal for reference", comment: ""))
                    bulletPoint(text: NSLocalizedString("Estimate portion sizes using common household measures (cups, tablespoons)", comment: ""))
                    bulletPoint(text: NSLocalizedString("Save frequent meals as favorites for quicker logging", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Nutrition Analysis Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Understanding Nutrition Analysis", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("The app provides detailed nutritional information for your meals:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    bulletPoint(text: NSLocalizedString("Calories: Total energy content of your food", comment: ""))
                    bulletPoint(text: NSLocalizedString("Macronutrients: Breakdown of proteins, fats, and carbohydrates", comment: ""))
                    bulletPoint(text: NSLocalizedString("Micronutrients: Essential vitamins and minerals", comment: ""))
                    bulletPoint(text: NSLocalizedString("Daily Goals: Progress toward your personalized nutrition targets", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Weekly Reports Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Weekly Reports", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("View your weekly nutrition summary to track patterns and progress:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    bulletPoint(text: NSLocalizedString("Tap 'Reports' in the Nutrition section", comment: ""))
                    bulletPoint(text: NSLocalizedString("See daily averages and trends", comment: ""))
                    bulletPoint(text: NSLocalizedString("Identify nutritional gaps to improve your diet", comment: ""))
                    bulletPoint(text: NSLocalizedString("Share reports with healthcare providers if needed", comment: ""))
                }
                
                // Video Tutorial Link
                NavigationLink(destination: VideoTutorialView(
                    videoName: "NutritionTracking",
                    videoDescription: NSLocalizedString("A visual guide to using the nutrition tracking features", comment: "")
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
        .navigationTitle(NSLocalizedString("Nutrition Help", comment: ""))
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

struct NutritionTrackingHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NutritionTrackingHelpView()
                .environmentObject(UserSettings())
        }
    }
}
