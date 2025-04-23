import SwiftUI
import UserNotifications

@main
struct SeniorNutritionApp: App {
    @StateObject private var userSettings = UserSettings()
    
    init() {
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
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