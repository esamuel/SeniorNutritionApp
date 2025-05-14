import SwiftUI
import CoreData

@main
struct SeniorNutritionApp: App {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var mealManager = MealManager()
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var userCommonMeals = UserCommonMeals()
    @StateObject private var appointmentManager = AppointmentManager()
    @StateObject private var languageManager = LanguageManager.shared
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !userSettings.isLoaded {
                    VStack {
                        Spacer()
                        ProgressView(NSLocalizedString("Loading", comment: ""))
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Spacer()
                    }
                    .onAppear {
                        let start = Date()
                        print("DEBUG: App appeared at \(start)")
                        userSettings.loadUserDataIfNeeded(startTime: start)
                        
                        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage") {
                            print("App startup: Refreshing saved language: \(savedLanguage)")
                            languageManager.setLanguage(savedLanguage)
                        }
                    }
                } else if userSettings.isOnboardingComplete {
                    MainTabView()
                        .environmentObject(userSettings)
                        .environmentObject(mealManager)
                        .environmentObject(foodDatabase)
                        .environmentObject(userCommonMeals)
                        .environmentObject(appointmentManager)
                        .environmentObject(languageManager)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environment(\.layoutDirection, languageManager.layoutDirection)
                        .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
                        .id(languageManager.currentLanguage)
                } else {
                    OnboardingView()
                        .environmentObject(userSettings)
                        .environmentObject(mealManager)
                        .environmentObject(foodDatabase)
                        .environmentObject(userCommonMeals)
                        .environmentObject(appointmentManager)
                        .environmentObject(languageManager)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environment(\.layoutDirection, languageManager.layoutDirection)
                        .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
                        .id(languageManager.currentLanguage)
                }
            }
        }
    }
}
