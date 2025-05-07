import SwiftUI
import CoreData

@main
struct SeniorNutritionApp: App {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var mealManager = MealManager()
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var userCommonMeals = UserCommonMeals()
    @StateObject private var appointmentManager = AppointmentManager()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if userSettings.isOnboardingComplete {
                MainTabView()
                    .environmentObject(userSettings)
                    .environmentObject(mealManager)
                    .environmentObject(foodDatabase)
                    .environmentObject(userCommonMeals)
                    .environmentObject(appointmentManager)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingView()
                    .environmentObject(userSettings)
                    .environmentObject(mealManager)
                    .environmentObject(foodDatabase)
                    .environmentObject(userCommonMeals)
                    .environmentObject(appointmentManager)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}