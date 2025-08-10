import SwiftUI

struct WaterTrackingHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Water Tracking", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Stay hydrated and monitor your daily water intake", comment: ""))
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
                        NSLocalizedString("Tap the 'Water' tab at the bottom of your screen", comment: ""),
                        NSLocalizedString("Set your daily water intake goal (recommended 8-10 glasses)", comment: ""),
                        NSLocalizedString("Use the + button to log each glass of water you drink", comment: ""),
                        NSLocalizedString("Track your progress throughout the day", comment: "")
                    ]
                )
                
                // Features Section
                HelpSection(
                    title: NSLocalizedString("Key Features", comment: ""),
                    content: [
                        NSLocalizedString("Daily Goal Setting: Customize your hydration target", comment: ""),
                        NSLocalizedString("Quick Logging: Tap to add water with one touch", comment: ""),
                        NSLocalizedString("Progress Tracking: Visual progress bar shows daily completion", comment: ""),
                        NSLocalizedString("Reminders: Get notifications to stay hydrated", comment: ""),
                        NSLocalizedString("History: View your water intake over time", comment: "")
                    ]
                )
                
                // Tips Section
                HelpSection(
                    title: NSLocalizedString("Hydration Tips", comment: ""),
                    content: [
                        NSLocalizedString("Drink water first thing in the morning", comment: ""),
                        NSLocalizedString("Keep a water bottle nearby throughout the day", comment: ""),
                        NSLocalizedString("Drink water before, during, and after exercise", comment: ""),
                        NSLocalizedString("Listen to your body's thirst signals", comment: ""),
                        NSLocalizedString("Consider your activity level and climate", comment: "")
                    ]
                )
                
                // Health Benefits Section
                HelpSection(
                    title: NSLocalizedString("Health Benefits", comment: ""),
                    content: [
                        NSLocalizedString("Maintains body temperature and metabolism", comment: ""),
                        NSLocalizedString("Supports kidney function and waste removal", comment: ""),
                        NSLocalizedString("Improves skin health and appearance", comment: ""),
                        NSLocalizedString("Enhances cognitive function and energy levels", comment: ""),
                        NSLocalizedString("Aids digestion and nutrient absorption", comment: "")
                    ]
                )
                
                // Troubleshooting Section
                HelpSection(
                    title: NSLocalizedString("Troubleshooting", comment: ""),
                    content: [
                        NSLocalizedString("If you forget to log water, you can add it later", comment: ""),
                        NSLocalizedString("Adjust your daily goal based on your needs", comment: ""),
                        NSLocalizedString("Enable notifications to get hydration reminders", comment: ""),
                        NSLocalizedString("Check your weekly progress to see patterns", comment: "")
                    ]
                )
                
                // Medical Disclaimer Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.blue)
                        Text(NSLocalizedString("Important: This app provides general hydration guidance. Consult your healthcare provider for specific fluid intake recommendations based on your health conditions.", comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    
                    // Add citations for hydration information
                    CitationsView(categories: [.hydration])
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(NSLocalizedString("Water Tracking Help", comment: ""))
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)
            }
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