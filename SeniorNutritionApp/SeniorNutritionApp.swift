import SwiftUI

@main
struct SeniorNutritionApp: App {
    @StateObject private var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            if userSettings.isOnboardingComplete {
                MainTabView()
                    .environmentObject(userSettings)
            } else {
                OnboardingView()
                    .environmentObject(userSettings)
            }
        }
    }
} 