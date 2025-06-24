import SwiftUI

struct VideoTutorialsView: View {
    @EnvironmentObject private var userSettings: UserSettings

    private let tutorials = [
        VideoTutorial(titleKey: "video_title_getting_started", descriptionKey: "video_desc_getting_started", videoName: "GettingStarted", videoType: "mov"),
        VideoTutorial(titleKey: "video_title_profile", descriptionKey: "video_desc_profile", videoName: "ProfileSetup", videoType: "mp4"),
        VideoTutorial(titleKey: "video_title_medication", descriptionKey: "video_desc_medication", videoName: "MedicationManagement", videoType: "mp4"),
        VideoTutorial(titleKey: "video_title_fasting", descriptionKey: "video_desc_fasting", videoName: "FastingTimer", videoType: "mp4"),
        VideoTutorial(titleKey: "video_title_nutrition", descriptionKey: "video_desc_nutrition", videoName: "NutritionTracking", videoType: "mp4"),
        VideoTutorial(titleKey: "video_title_accessibility", descriptionKey: "video_desc_accessibility", videoName: "AccessibilityFeatures", videoType: "mp4")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HelpSectionHeader(title: NSLocalizedString("video_tutorials_title", comment: "Video Tutorials"))
                
                Text(NSLocalizedString("video_tutorials_intro", comment: "Introductory text for video tutorials."))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .padding(.bottom)

                ForEach(tutorials) { tutorial in
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString(tutorial.titleKey, comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        Text(NSLocalizedString(tutorial.descriptionKey, comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                        VideoTutorialView(videoName: tutorial.videoName, videoType: tutorial.videoType)
                    }
                    Divider()
                }
                
                devNotes
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("video_tutorials_title", comment: "Video Tutorials"))
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private var devNotes: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Developer Notes:")
                .font(.caption.bold())
            Text("• Make sure the video files (e.g., 'GettingStarted.mov') are placed in the 'Resources/Videos/' directory.")
                .font(.caption)
            Text("• Do NOT add the video files to the Xcode project target to avoid 'multiple commands produce' build errors.")
                .font(.caption)
        }
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(8)
    }
}

struct VideoTutorial: Identifiable {
    let id = UUID()
    let titleKey: String
    let descriptionKey: String
    let videoName: String
    let videoType: String
}

struct VideoTutorialsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VideoTutorialsView()
                .environmentObject(UserSettings())
        }
    }
}
