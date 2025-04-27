import SwiftUI

@main
struct SeniorNutritionApp: App {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var mealManager = MealManager()
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var userCommonMeals = UserCommonMeals()
    
    var body: some Scene {
        WindowGroup {
            if userSettings.isOnboardingComplete {
                MainTabView()
                    .environmentObject(userSettings)
                    .environmentObject(mealManager)
                    .environmentObject(foodDatabase)
                    .environmentObject(userCommonMeals)
            } else {
                OnboardingView()
                    .environmentObject(userSettings)
                    .environmentObject(mealManager)
                    .environmentObject(foodDatabase)
                    .environmentObject(userCommonMeals)
            }
        }
    }
}