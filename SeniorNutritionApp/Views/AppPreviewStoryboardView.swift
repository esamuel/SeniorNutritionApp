import SwiftUI

/// Storyboard guide for recording app preview videos
struct AppPreviewStoryboardView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var previewManager = AppPreviewManager.shared
    @State private var selectedStoryboard: StoryboardType = .overview
    
    enum StoryboardType: String, CaseIterable {
        case overview = "App Overview"
        case nutrition = "Nutrition Tracking"
        case medication = "Medication Management"
        case health = "Health Monitoring"
        
        var duration: String {
            switch self {
            case .overview: return "25-30 seconds"
            case .nutrition: return "20-25 seconds"
            case .medication: return "15-20 seconds"
            case .health: return "20-25 seconds"
            }
        }
        
        var description: String {
            switch self {
            case .overview:
                return "Show the main features and navigation of the app"
            case .nutrition:
                return "Demonstrate meal logging and nutritional analysis"
            case .medication:
                return "Show medication reminders and tracking"
            case .health:
                return "Display health monitoring and data visualization"
            }
        }
        
        var steps: [StoryboardStep] {
            switch self {
            case .overview:
                return overviewSteps
            case .nutrition:
                return nutritionSteps
            case .medication:
                return medicationSteps
            case .health:
                return healthSteps
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Storyboard selector
                Picker("Storyboard", selection: $selectedStoryboard) {
                    ForEach(StoryboardType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Storyboard content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        storyboardHeader
                        
                        // Steps
                        ForEach(Array(selectedStoryboard.steps.enumerated()), id: \.offset) { index, step in
                            StoryboardStepView(step: step, stepNumber: index + 1)
                        }
                        
                        // Recording tips
                        recordingTipsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("App Preview Storyboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start Recording") {
                        previewManager.startRecording()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    private var storyboardHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(selectedStoryboard.rawValue)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(selectedStoryboard.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Label(selectedStoryboard.duration, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Label("\(selectedStoryboard.steps.count) steps", systemImage: "list.number")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var recordingTipsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recording Tips")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                tipRow("📱", "Hold device steady and record in good lighting")
                tipRow("⏱️", "Practice the flow 2-3 times before recording")
                tipRow("🎯", "Focus on smooth, deliberate gestures")
                tipRow("🔇", "Most users watch with sound off - rely on visuals")
                tipRow("✨", "Demo mode will show realistic sample data")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func tipRow(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(icon)
                .font(.title3)
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct StoryboardStepView: View {
    let step: StoryboardStep
    let stepNumber: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Step number
            Text("\(stepNumber)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(step.color)
                .clipShape(Circle())
            
            // Step content
            VStack(alignment: .leading, spacing: 8) {
                Text(step.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(step.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                if !step.actions.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Actions:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        ForEach(step.actions, id: \.self) { action in
                            HStack {
                                Text("•")
                                    .foregroundColor(.blue)
                                Text(action)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                HStack {
                    Label(step.duration, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    if !step.screen.isEmpty {
                        Label(step.screen, systemImage: "iphone")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct StoryboardStep {
    let title: String
    let description: String
    let actions: [String]
    let duration: String
    let screen: String
    let color: Color
}

// MARK: - Storyboard Definitions
extension AppPreviewStoryboardView {
    static let overviewSteps: [StoryboardStep] = [
        StoryboardStep(
            title: "App Launch & Welcome",
            description: "Show the app launching and the welcoming home screen with user's name",
            actions: ["Open app", "Show personalized greeting", "Display current date"],
            duration: "3 seconds",
            screen: "Home",
            color: .blue
        ),
        StoryboardStep(
            title: "Main Navigation",
            description: "Demonstrate the main tab navigation between key features",
            actions: ["Tap Nutrition tab", "Tap Water tab", "Tap Fasting tab", "Return to Home"],
            duration: "5 seconds",
            screen: "Tab Bar",
            color: .green
        ),
        StoryboardStep(
            title: "Meal Logging",
            description: "Show how easy it is to log a meal with the food database",
            actions: ["Tap Add Meal", "Search for food", "Select item", "Add to meal"],
            duration: "6 seconds",
            screen: "Nutrition",
            color: .orange
        ),
        StoryboardStep(
            title: "Health Monitoring",
            description: "Display the health tracking dashboard with vital signs",
            actions: ["Navigate to Health", "Show blood pressure", "Show weight tracking"],
            duration: "4 seconds",
            screen: "Health",
            color: .red
        ),
        StoryboardStep(
            title: "Medication Reminders",
            description: "Demonstrate the medication management and reminder system",
            actions: ["Show medication list", "Display reminder notification", "Mark as taken"],
            duration: "4 seconds",
            screen: "Medications",
            color: .purple
        ),
        StoryboardStep(
            title: "Accessibility Features",
            description: "Highlight senior-friendly features like large text and voice assistance",
            actions: ["Show large text", "Demonstrate voice reading", "Display clear icons"],
            duration: "3 seconds",
            screen: "Settings",
            color: .teal
        )
    ]
    
    static let nutritionSteps: [StoryboardStep] = [
        StoryboardStep(
            title: "Nutrition Dashboard",
            description: "Show the comprehensive nutrition tracking dashboard",
            actions: ["Open Nutrition tab", "Display daily summary", "Show macro breakdown"],
            duration: "4 seconds",
            screen: "Nutrition Dashboard",
            color: .green
        ),
        StoryboardStep(
            title: "Add Meal",
            description: "Demonstrate the intuitive meal logging process",
            actions: ["Tap Add Meal", "Select meal type (Breakfast)", "Choose from favorites"],
            duration: "5 seconds",
            screen: "Add Meal",
            color: .orange
        ),
        StoryboardStep(
            title: "Food Search",
            description: "Show the extensive food database and search functionality",
            actions: ["Search for 'salmon'", "Select grilled salmon", "Adjust portion size"],
            duration: "6 seconds",
            screen: "Food Search",
            color: .blue
        ),
        StoryboardStep(
            title: "Nutritional Analysis",
            description: "Display the detailed nutritional breakdown and recommendations",
            actions: ["View meal analysis", "Show protein/carb/fat breakdown", "Display vitamins"],
            duration: "5 seconds",
            screen: "Meal Analysis",
            color: .purple
        ),
        StoryboardStep(
            title: "Progress Tracking",
            description: "Show daily and weekly nutrition progress visualization",
            actions: ["View daily goals", "Show progress bars", "Display weekly trends"],
            duration: "5 seconds",
            screen: "Progress",
            color: .teal
        )
    ]
    
    static let medicationSteps: [StoryboardStep] = [
        StoryboardStep(
            title: "Medication List",
            description: "Display the comprehensive medication management interface",
            actions: ["Open Medications", "Show current medications", "Display next doses"],
            duration: "3 seconds",
            screen: "Medications",
            color: .red
        ),
        StoryboardStep(
            title: "Add Medication",
            description: "Demonstrate adding a new medication with 3D pill visualization",
            actions: ["Tap Add Medication", "Enter medication name", "Select pill shape and color"],
            duration: "6 seconds",
            screen: "Add Medication",
            color: .blue
        ),
        StoryboardStep(
            title: "Reminder Setup",
            description: "Show setting up customized medication reminders",
            actions: ["Set reminder times", "Choose notification style", "Set lead time"],
            duration: "4 seconds",
            screen: "Reminder Settings",
            color: .orange
        ),
        StoryboardStep(
            title: "Taking Medication",
            description: "Show the process of marking medication as taken",
            actions: ["Receive reminder notification", "Mark as taken", "Log side effects if any"],
            duration: "3 seconds",
            screen: "Take Medication",
            color: .green
        )
    ]
    
    static let healthSteps: [StoryboardStep] = [
        StoryboardStep(
            title: "Health Overview",
            description: "Display the comprehensive health monitoring dashboard",
            actions: ["Open Health tab", "Show vital signs overview", "Display recent trends"],
            duration: "4 seconds",
            screen: "Health Dashboard",
            color: .red
        ),
        StoryboardStep(
            title: "Blood Pressure Tracking",
            description: "Demonstrate blood pressure logging and visualization",
            actions: ["Tap Add Blood Pressure", "Enter systolic/diastolic", "View trend graph"],
            duration: "6 seconds",
            screen: "Blood Pressure",
            color: .blue
        ),
        StoryboardStep(
            title: "Weight Monitoring",
            description: "Show weight tracking with BMI calculation",
            actions: ["Add weight entry", "View BMI calculation", "See weight trend"],
            duration: "5 seconds",
            screen: "Weight Tracking",
            color: .green
        ),
        StoryboardStep(
            title: "Health Reports",
            description: "Display comprehensive health reports and insights",
            actions: ["Generate health report", "View weekly summary", "Show recommendations"],
            duration: "5 seconds",
            screen: "Health Reports",
            color: .purple
        )
    ]
}

#if DEBUG
struct AppPreviewStoryboardView_Previews: PreviewProvider {
    static var previews: some View {
        AppPreviewStoryboardView()
    }
}
#endif 