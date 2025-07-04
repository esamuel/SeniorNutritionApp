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
    private let healthTipsService = HealthTipsService.shared
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !userSettings.isLoaded {
                    VStack {
                        Spacer()
                        
                        // Add old man with walking stick image
                        Image("Oldman-wolking")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding(.bottom, 20)
                        
                        Text(NSLocalizedString("Hold on, I'm coming...", comment: "Loading message with old man"))
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 10)
                        
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
                    if userSettings.shouldShowAppTour() {
                        AppTourView()
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
                    }
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
