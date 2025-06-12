import SwiftUI
import Foundation

struct VideoTutorialsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    // List of available tutorials
    private let tutorials = [
        Tutorial(
            id: "getting_started",
            title: NSLocalizedString("Getting Started", comment: ""),
            description: NSLocalizedString("Learn how to use the basic features of the app", comment: ""),
            videoName: "GettingStarted"
        ),
        Tutorial(
            id: "profile_setup",
            title: NSLocalizedString("Profile", comment: ""),
            description: NSLocalizedString("How to set up and manage your profile", comment: ""),
            videoName: "ProfileSetup"
        ),
        Tutorial(
            id: "medication_management",
            title: NSLocalizedString("Medication Management", comment: ""),
            description: NSLocalizedString("How to track and manage your medications", comment: ""),
            videoName: "MedicationManagement"
        ),
        Tutorial(
            id: "fasting_timer",
            title: NSLocalizedString("Fasting Timer", comment: ""),
            description: NSLocalizedString("How to use the fasting timer feature", comment: ""),
            videoName: "FastingTimer"
        ),
        Tutorial(
            id: "nutrition_tracking",
            title: NSLocalizedString("Nutrition Tracking", comment: ""),
            description: NSLocalizedString("How to log and analyze your meals", comment: ""),
            videoName: "NutritionTracking"
        ),
        Tutorial(
            id: "accessibility",
            title: NSLocalizedString("Accessibility Features", comment: ""),
            description: NSLocalizedString("How to customize the app for your needs", comment: ""),
            videoName: "AccessibilityFeatures"
        )
    ]
    
    var body: some View {
        List {
            // Developer note section
            Section(header: Text(NSLocalizedString("Developer Notes", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("Video Requirements", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    
                    Text(NSLocalizedString("Videos should be placed in the Resources/Videos directory in MP4 or MOV format. Video filenames should match the videoName property without spaces (e.g., 'GettingStarted.mp4').", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            // Tutorials section
            Section(header: Text(NSLocalizedString("Available Tutorials", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))) {
                
                ForEach(tutorials) { tutorial in
                    NavigationLink(destination: VideoTutorialView(
                        videoName: tutorial.videoName,
                        videoDescription: tutorial.description
                    )) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tutorial.title)
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            
                            Text(tutorial.description)
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(NSLocalizedString("Video Tutorials", comment: ""))
    }
}

// Tutorial model
struct Tutorial: Identifiable {
    let id: String
    let title: String
    let description: String
    let videoName: String
}

struct VideoTutorialsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VideoTutorialsView()
                .environmentObject(UserSettings())
        }
    }
}
