import SwiftUI
import CoreData
import UIKit
import Combine
import Speech
import AVFoundation

@main
struct SeniorNutritionApp: App {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var mealManager = MealManager()
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var userCommonMeals = UserCommonMeals()
    @StateObject private var appointmentManager = AppointmentManager()
    @StateObject private var languageManager = LanguageManager.shared
    @StateObject private var voiceAssistant = VoiceAssistantManager()
    @State private var isAppReady = false
    private let healthTipsService = HealthTipsService.shared
    let persistenceController = PersistenceController.shared
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Initialize localization and appearance
                let _ = initializeApp()
                
                // Main content view
                if !userSettings.isLoaded {
                    loadingView
                } else if userSettings.isOnboardingComplete {
                    mainContentView
                } else {
                    onboardingView
                }
            }
            .environment(\.locale, Locale(identifier: languageManager.currentLanguage))
            .environment(\.layoutDirection, languageManager.layoutDirection)
            .environment(\.sizeCategory, .large) // Support Dynamic Type
            .onAppear(perform: setupAppLifecycleObservers)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                // Refresh UI when app comes to foreground
                LocalizationUtils.updateLayoutDirection()
            }
        }
    }
    
    // MARK: - View Builders
    
    private var loadingView: some View {
        VStack {
            Spacer()
            
            // Add old man with walking stick image
            Image("Oldman-wolking")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.bottom, 20)
            
            ProgressView(NSLocalizedString("Loading", comment: ""))
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
        .onAppear {
            let start = Date()
            print("DEBUG: App appeared at \(start)")
            userSettings.loadUserDataIfNeeded(startTime: start)
            
            // Initialize language settings
            initializeLanguageSettings()
        }
    }
    
    private var mainContentView: some View {
        MainTabView()
            .environmentObject(userSettings)
            .environmentObject(mealManager)
            .environmentObject(foodDatabase)
            .environmentObject(userCommonMeals)
            .environmentObject(appointmentManager)
            .environmentObject(languageManager)
            .environmentObject(voiceAssistant)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.layoutDirection, languageManager.layoutDirection)
            .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
            .id(languageManager.currentLanguage)
    }
    
    private var onboardingView: some View {
        OnboardingView()
            .environmentObject(userSettings)
            .environmentObject(mealManager)
            .environmentObject(foodDatabase)
            .environmentObject(userCommonMeals)
            .environmentObject(appointmentManager)
            .environmentObject(languageManager)
            .environmentObject(voiceAssistant)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.layoutDirection, languageManager.layoutDirection)
            .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
            .id(languageManager.currentLanguage)
    }
}

// MARK: - Private Methods

private extension SeniorNutritionApp {
    /// Initializes the app's core functionality
    @discardableResult
    private func initializeApp() -> some View {
        // Force initialization of LocalizationUtils
        _ = LocalizationUtils.self
        
        // Set up UI appearance
        setupAppearance()
        
        return EmptyView()
    }
    
    /// Initializes language settings
    private func initializeLanguageSettings() {
        // Load saved language or use system default
        let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage")
        let languageToUse = savedLanguage ?? Locale.preferredLanguages.first?.prefix(2).description ?? "en"
        
        // Validate and set the language
        let supportedLanguages = ["en", "he", "fr", "es"]
        let validLanguage = supportedLanguages.contains(languageToUse) ? languageToUse : "en"
        
        if languageManager.currentLanguage != validLanguage {
            print("App startup: Setting language to \(validLanguage)")
            languageManager.currentLanguage = validLanguage
        }
        
        // Force update layout direction
        LocalizationUtils.updateLayoutDirection()
    }
    
    /// Sets up app lifecycle observers
    private func setupAppLifecycleObservers() {
        // Set up notification observers
        setupNotificationObservers()
        
        // Initialize language settings if not already done
        if !userSettings.isLoaded {
            initializeLanguageSettings()
        }
    }
    
    /// Sets up the app's appearance
    func setupAppearance() {
        // Set up navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
        
        // Set up tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        // Set up text field appearance
        UITextField.appearance().textAlignment = LocalizationUtils.isRTL ? .right : .left
        UITextView.appearance().textAlignment = LocalizationUtils.isRTL ? .right : .left
    }
    
    /// Sets up notification observers for language changes
    private func setupNotificationObservers() {
        // Remove any existing observers to prevent duplicates
        NotificationCenter.default.removeObserver(self)
        
        // Store a reference to the language manager to avoid capture list issues
        let languageManager = self.languageManager
        
        // Add observer for language changes
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("LanguageDidChange"),
            object: nil,
            queue: .main
        ) { _ in
            // Update UI when language changes
            DispatchQueue.main.async {
                // Update all connected scenes
                for scene in UIApplication.shared.connectedScenes {
                    if let windowScene = scene as? UIWindowScene {
                        for window in windowScene.windows {
                            window.semanticContentAttribute = languageManager.isRTL ? .forceRightToLeft : .forceLeftToRight
                            
                            // Force refresh all views
                            window.subviews.forEach { view in
                                view.removeFromSuperview()
                                window.addSubview(view)
                            }
                        }
                    }
                }
                
                // Update text alignment for text fields and views
                UITextField.appearance().textAlignment = languageManager.isRTL ? .right : .left
                UITextView.appearance().textAlignment = languageManager.isRTL ? .right : .left
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct AppPreview: View {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var mealManager = MealManager()
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var userCommonMeals = UserCommonMeals()
    @StateObject private var appointmentManager = AppointmentManager()
    @StateObject private var languageManager = LanguageManager.shared
    
    init() {
        userSettings.isOnboardingComplete = true
    }
    
    var body: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(userSettings)
            .environmentObject(mealManager)
            .environmentObject(foodDatabase)
            .environmentObject(userCommonMeals)
            .environmentObject(appointmentManager)
            .environmentObject(languageManager)
    }
}

struct SeniorNutritionApp_Previews: PreviewProvider {
    static var previews: some View {
        AppPreview()
    }
}
#endif
