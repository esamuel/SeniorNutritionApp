import SwiftUI

struct NutritionHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Nutrition Tracking", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Track meals, analyze nutrition, and monitor daily intake", comment: ""))
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
                        NSLocalizedString("Tap the 'Nutrition' tab at the bottom of your screen", comment: ""),
                        NSLocalizedString("Tap 'Add Meal' to log your food", comment: ""),
                        NSLocalizedString("Search for foods or add custom items", comment: ""),
                        NSLocalizedString("Enter portion sizes and meal time", comment: ""),
                        NSLocalizedString("Review nutrition analysis for each meal", comment: "")
                    ]
                )
                
                // Key Features Section
                HelpSection(
                    title: NSLocalizedString("Key Features", comment: ""),
                    content: [
                        NSLocalizedString("Extensive Food Database: Thousands of foods and recipes", comment: ""),
                        NSLocalizedString("Custom Foods: Add your own recipes and items", comment: ""),
                        NSLocalizedString("Photo Logging: Take pictures of your meals", comment: ""),
                        NSLocalizedString("Nutrition Analysis: See calories, macros, and micronutrients", comment: ""),
                        NSLocalizedString("Daily & Weekly Reports: Track trends and progress", comment: ""),
                        NSLocalizedString("Personalized Goals: Set calorie and nutrient targets", comment: "")
                    ]
                )
                
                // Logging Tips Section
                HelpSection(
                    title: NSLocalizedString("Meal Logging Tips", comment: ""),
                    content: [
                        NSLocalizedString("Log meals as soon as you eat for best accuracy", comment: ""),
                        NSLocalizedString("Use the barcode scanner for packaged foods (if available)", comment: ""),
                        NSLocalizedString("Estimate portions using household measures or a food scale", comment: ""),
                        NSLocalizedString("Add notes for special meals or recipes", comment: ""),
                        NSLocalizedString("Review your daily summary to spot missing entries", comment: "")
                    ]
                )
                
                // Nutrition Analysis Section
                HelpSection(
                    title: NSLocalizedString("Understanding Nutrition Analysis", comment: ""),
                    content: [
                        NSLocalizedString("Calories: Total energy for each meal and day", comment: ""),
                        NSLocalizedString("Macronutrients: Protein, carbohydrates, and fats breakdown", comment: ""),
                        NSLocalizedString("Micronutrients: Vitamins and minerals tracked", comment: ""),
                        NSLocalizedString("Daily Goals: Compare intake to your personalized targets", comment: ""),
                        NSLocalizedString("Charts: Visualize trends over time", comment: "")
                    ]
                )
                
                // Reports Section
                HelpSection(
                    title: NSLocalizedString("Weekly & Monthly Reports", comment: ""),
                    content: [
                        NSLocalizedString("View weekly and monthly nutrition summaries", comment: ""),
                        NSLocalizedString("Identify trends in calories and nutrients", comment: ""),
                        NSLocalizedString("Export reports to share with your doctor or caregiver", comment: ""),
                        NSLocalizedString("Use reports to adjust your goals and habits", comment: "")
                    ]
                )
                
                // Troubleshooting Section
                HelpSection(
                    title: NSLocalizedString("Troubleshooting", comment: ""),
                    content: [
                        NSLocalizedString("If a food is missing, add it as a custom item", comment: ""),
                        NSLocalizedString("Edit or delete meals from your daily log", comment: ""),
                        NSLocalizedString("Check your portion sizes for accuracy", comment: ""),
                        NSLocalizedString("Contact support if you need help with food entries", comment: "")
                    ]
                )
                
                // Video Tutorial Section
                HelpSection(
                    title: NSLocalizedString("Video Tutorial", comment: ""),
                    content: [
                        NSLocalizedString("Watch our step-by-step video guide for nutrition tracking", comment: ""),
                        NSLocalizedString("Find more tutorials in the Help section", comment: "")
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
        .navigationTitle(NSLocalizedString("Nutrition Help", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NutritionHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NutritionHelpView()
                .environmentObject(UserSettings())
        }
    }
}
