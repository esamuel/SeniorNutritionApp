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
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Spacer()
                    }
                    .onAppear {
                        let start = Date()
                        print("DEBUG: App appeared at \(start)")
                        userSettings.loadUserDataIfNeeded(startTime: start)
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
                }
            }
        }
    }
}
