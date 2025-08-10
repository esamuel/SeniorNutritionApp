import SwiftUI
import Combine
import UserNotifications
import Foundation
import CoreData

// User settings management
@MainActor
class UserSettings: ObservableObject {
    // User preferences
    @Published var textSize: TextSize = .medium {
        didSet {
            saveUserData()
        }
    }
    @Published var highContrastMode: Bool = false {
        didSet {
            saveUserData()
        }
    }
    @Published var useVoiceInput: Bool = true {
        didSet {
            saveUserData()
        }
    }
    @Published var activeFastingProtocol: FastingProtocol = .sixteenEight {
        didSet {
            saveUserData()
        }
    }
    
    // User medications
    @Published var medications: [Medication] = [] {
        didSet {
            saveUserData()
        }
    }
    @Published var isShowingMedicationSheet: Bool = false
    @Published var medicationToEdit: Medication? = nil
    
    // Onboarding state
    @Published var isOnboardingComplete: Bool = false {
        didSet {
            saveUserData()
        }
    }
    
    // Feature Flags - For App Store submission control
    @Published var enableAIFeatures: Bool = false {
        didSet {
            saveUserData()
        }
    }
    
    // First-time user guide state
    @Published var isFirstTimeGuideComplete: Bool = false {
        didSet {
            UserDefaults.standard.set(isFirstTimeGuideComplete, forKey: "isFirstTimeGuideComplete")
        }
    }
    
    // App Tour state
    @Published var hasSeenAppTour: Bool = false {
        didSet {
            UserDefaults.standard.set(hasSeenAppTour, forKey: "hasSeenAppTour")
        }
    }
    @Published var appTourVersion: String = "1.0" {
        didSet {
            UserDefaults.standard.set(appTourVersion, forKey: "appTourVersion")
        }
    }
    
    // User profile data
    @Published var userName: String = "User" {
        didSet {
            saveUserData()
        }
    }
    @Published var userAge: Int = 65 {
        didSet {
            saveUserData()
        }
    }
    @Published var userGender: String = "Other" {
        didSet {
            saveUserData()
        }
    }
    @Published var userHeight: Double = 170.0 {
        didSet {
            saveUserData()
        }
    }
    @Published var userWeight: Double = 70.0 {
        didSet {
            saveUserData()
        }
    }
    @Published var userHealthGoals: [String] = [] {
        didSet {
            saveUserData()
        }
    }
    @Published var userDietaryRestrictions: [String] = [] {
        didSet {
            saveUserData()
        }
    }
    @Published var userEmergencyContacts: [EmergencyContact] = [] {
        didSet {
            saveUserData()
        }
    }
    
    @Published var userProfile: UserProfile? {
        didSet {
            if let encoded = try? JSONEncoder().encode(userProfile) {
                UserDefaults.standard.set(encoded, forKey: "userProfile")
            }
            saveUserData()
        }
    }
    
    @Published var isDarkMode: Bool = false {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    @Published var notificationsEnabled: Bool = true {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    
    // Voice settings
    @Published var preferredVoiceGender: VoiceGender = .female {
        didSet {
            saveUserData()
        }
    }
    @Published var preferredVoiceIdentifier: String? {
        didSet {
            saveUserData()
        }
    }
    @Published var speechRate: SpeechRate = .normal {
        didSet {
            saveUserData()
        }
    }
    
    // Add notification settings
    @Published var medicationRemindersEnabled: Bool = true {
        didSet { saveUserData() }
    }
    @Published var medicationReminderLeadTime: Int = 0 {
        didSet { saveUserData() }
    }
    @Published var mealWindowRemindersEnabled: Bool = true {
        didSet { saveUserData() }
    }
    @Published var fastingRemindersEnabled: Bool = true {
        didSet { saveUserData() }
    }
    @Published var dailyTipsEnabled: Bool = true {
        didSet { saveUserData() }
    }
    @Published var notificationStyle: NotificationStyle = .regular {
        didSet { saveUserData() }
    }
    
    // Emergency number settings
    @Published var customEmergencyNumber: String? {
        didSet {
            UserDefaults.standard.set(customEmergencyNumber, forKey: "customEmergencyNumber")
            saveUserData()
        }
    }
    @Published var useCustomEmergencyNumber: Bool = false {
        didSet {
            UserDefaults.standard.set(useCustomEmergencyNumber, forKey: "useCustomEmergencyNumber")
            saveUserData()
        }
    }
    
    @Published var isLoaded: Bool = false
    @Published var isDemoMode: Bool = false // For app preview recordings
    
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? LanguageManager.shared.currentLanguage {
        didSet {
            if selectedLanguage != LanguageManager.shared.currentLanguage {
                print("UserSettings: selectedLanguage changed to \(selectedLanguage), updating LanguageManager")
                LanguageManager.shared.setLanguage(selectedLanguage)
            }
        }
    }
    
    @Published var dailyCalorieGoal: Int = 2000
    @Published var useCalculatedCalories: Bool = true  // Whether to use calculated vs manual calorie goals
    @Published var macroGoalsEnabled: Bool = false
    @Published var dailyProteinGoal: Int = 75
    @Published var dailyCarbGoal: Int = 250
    @Published var dailyFatGoal: Int = 70
    
    let supportedLanguages: [String] = ["en", "es", "fr", "he"]
    
    // MARK: - Health Data Access
    
    /// Get the latest weight from health data
    func getLatestWeight() -> Double? {
        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<WeightEntry>(entityName: "WeightEntry")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)]
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first?.weight
        } catch {
            print("Error fetching latest weight: \(error)")
            return nil
        }
    }
    
    /// Get the latest BMI using current weight from health data and profile height
    func getCurrentBMI() -> Double? {
        guard let profile = userProfile else { return nil }
        let latestWeight = getLatestWeight()
        return profile.calculateBMI(latestWeight: latestWeight)
    }
    
    /// Get the current BMI category using latest weight
    func getCurrentBMICategory() -> BMICategory? {
        guard let profile = userProfile else { return nil }
        let latestWeight = getLatestWeight()
        return profile.getBMICategory(latestWeight: latestWeight)
    }
    
    // MARK: - Calorie Goal Management
    
    /// Get the effective daily calorie goal (calculated or manual)
    func getEffectiveDailyCalorieGoal() -> Int {
        if useCalculatedCalories, let profile = userProfile {
            let latestWeight = getLatestWeight()
            if let calculatedGoal = profile.getRecommendedCalorieGoal(healthGoals: userHealthGoals, latestWeight: latestWeight) {
                return calculatedGoal
            }
        }
        return dailyCalorieGoal
    }
    
    /// Get the calculated daily calorie goal (if profile exists)
    func getCalculatedDailyCalorieGoal() -> Int? {
        guard let profile = userProfile else { return nil }
        let latestWeight = getLatestWeight()
        return profile.getRecommendedCalorieGoal(healthGoals: userHealthGoals, latestWeight: latestWeight)
    }
    
    /// Get calorie calculation explanation text
    func getCalorieCalculationExplanation() -> String? {
        guard let profile = userProfile else { return nil }
        let latestWeight = getLatestWeight()
        return profile.getCalorieGoalExplanation(healthGoals: userHealthGoals, latestWeight: latestWeight)
    }
    
    /// Update calorie goal to use calculated value
    func useCalculatedCalorieGoal() {
        if let calculatedGoal = getCalculatedDailyCalorieGoal() {
            dailyCalorieGoal = calculatedGoal
            useCalculatedCalories = true
            saveUserData()
        }
    }
    
    /// Update calorie goal to use manual value
    func useManualCalorieGoal(_ manualGoal: Int) {
        dailyCalorieGoal = manualGoal
        useCalculatedCalories = false
        saveUserData()
    }
    
    /// Check if calculated calorie goal is available
    func hasCalculatedCalorieGoal() -> Bool {
        return getCalculatedDailyCalorieGoal() != nil
    }
    
    /// Get BMR value if profile exists
    func getCurrentBMR() -> Double? {
        guard let profile = userProfile else { return nil }
        let latestWeight = getLatestWeight()
        return profile.calculateBMR(latestWeight: latestWeight)
    }
    
    /// Get TDEE value if profile exists
    func getCurrentTDEE() -> Double? {
        guard let profile = userProfile else { return nil }
        let latestWeight = getLatestWeight()
        return profile.calculateTDEE(latestWeight: latestWeight)
    }
    
    private let localDataKey = "userData"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUserData()
        setupMedicationObservers()
        
        // Initialize emergency number settings
        self.customEmergencyNumber = UserDefaults.standard.string(forKey: "customEmergencyNumber")
        self.useCustomEmergencyNumber = UserDefaults.standard.bool(forKey: "useCustomEmergencyNumber")
        
        // Initialize app tour settings
        self.hasSeenAppTour = UserDefaults.standard.bool(forKey: "hasSeenAppTour")
        self.appTourVersion = UserDefaults.standard.string(forKey: "appTourVersion") ?? "1.0"
        
        // Initialize first-time guide settings
        self.isFirstTimeGuideComplete = UserDefaults.standard.bool(forKey: "isFirstTimeGuideComplete")
        
        // Synchronize selectedLanguage with LanguageManager
        if let saved = UserDefaults.standard.string(forKey: "AppLanguage") {
            print("UserSettings: Found saved language: \(saved)")
            selectedLanguage = saved
            LanguageManager.shared.setLanguage(saved)
        } else {
            print("UserSettings: No saved language, using system language")
            selectedLanguage = LanguageManager.shared.currentLanguage
        }
        // Observe changes to selectedLanguage and keep LanguageManager in sync
        $selectedLanguage
            .sink { newLang in
                if LanguageManager.shared.currentLanguage != newLang {
                    print("UserSettings: selectedLanguage changed to \(newLang), updating LanguageManager")
                    LanguageManager.shared.setLanguage(newLang)
                }
            }
            .store(in: &cancellables)
        // Observe LanguageManager and update selectedLanguage if it changes externally
        LanguageManager.shared.objectWillChange.sink { [weak self] in
            let lang = LanguageManager.shared.currentLanguage
            print("UserSettings: LanguageManager changed to \(lang)")
            if self?.selectedLanguage != lang {
                print("UserSettings: Updating selectedLanguage to match LanguageManager: \(lang)")
                self?.selectedLanguage = lang
            }
        }.store(in: &cancellables)
        
        // Observe language changes to trigger profile data migration if needed
        NotificationCenter.default.publisher(for: .languageDidChange)
            .sink { [weak self] _ in
                Task { @MainActor in
                    self?.handleLanguageChange()
                }
            }
            .store(in: &cancellables)
        
        // Perform initial migration check
        Task { @MainActor in
            await performInitialMigration()
        }
    }
    
    // Force save user data synchronously
    @MainActor
    func forceSaveUserData() async {
        print("DEBUG: Force saving medications count: \(medications.count)")
        for medication in medications {
            print("DEBUG: Force saving medication: \(medication.name) with frequency: \(medication.frequency)")
        }
        
        let data = PersistentData(
            textSize: textSize,
            highContrastMode: highContrastMode,
            useVoiceInput: useVoiceInput,
            activeFastingProtocol: activeFastingProtocol,
            medications: medications,
            isOnboardingComplete: isOnboardingComplete,
            userName: userName,
            userAge: userAge,
            userGender: userGender,
            userHeight: userHeight,
            userWeight: userWeight,
            userHealthGoals: userHealthGoals,
            userDietaryRestrictions: userDietaryRestrictions,
            userEmergencyContacts: userEmergencyContacts,
            preferredVoiceGender: preferredVoiceGender,
            speechRate: speechRate,
            enableAIFeatures: enableAIFeatures
        )
        
        do {
            try await PersistentStorage.shared.saveData(data, forKey: localDataKey)
            print("DEBUG: Successfully force saved user data")
        } catch {
            print("Error force saving user data: \(error)")
        }
    }
    
    private func setupMedicationObservers() {
        $medications
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveUserData()
            }
            .store(in: &cancellables)
    }
    
    // Save user data to persistent storage
    private func saveUserData() {
        Task {
            do {
                print("DEBUG: Saving medications count: \(medications.count)")
                for medication in medications {
                    print("DEBUG: Saving medication: \(medication.name) with frequency: \(medication.frequency)")
                }
                
                let data = PersistentData(
                    textSize: textSize,
                    highContrastMode: highContrastMode,
                    useVoiceInput: useVoiceInput,
                    activeFastingProtocol: activeFastingProtocol,
                    medications: medications,
                    isOnboardingComplete: isOnboardingComplete,
                    userName: userName,
                    userAge: userAge,
                    userGender: userGender,
                    userHeight: userHeight,
                    userWeight: userWeight,
                    userHealthGoals: userHealthGoals,
                    userDietaryRestrictions: userDietaryRestrictions,
                    userEmergencyContacts: userEmergencyContacts,
                    preferredVoiceGender: preferredVoiceGender,
                    speechRate: speechRate,
                    enableAIFeatures: enableAIFeatures
                )
                
                try await PersistentStorage.shared.saveData(data, forKey: localDataKey)
                print("DEBUG: Successfully saved user data")
            } catch {
                print("Error saving user data: \(error)")
            }
        }
    }
    
    // Load user data from persistent storage
    private func loadUserData(startTime: Date? = nil) {
        let loadStart = startTime ?? Date()
        
        // Simplified synchronous loading to prevent threading issues
        if let savedProfile = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedProfile) {
            self.userProfile = decodedProfile
        }
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        // Load persistent data
        if let data: PersistentData = PersistentStorage.shared.loadData(forKey: self.localDataKey) {
            self.textSize = data.textSize
            self.highContrastMode = data.highContrastMode
            self.useVoiceInput = data.useVoiceInput
            self.activeFastingProtocol = data.activeFastingProtocol
            self.medications = data.medications
            self.isOnboardingComplete = data.isOnboardingComplete
            self.userName = data.userName
            self.userAge = data.userAge
            self.userGender = data.userGender
            self.userHeight = data.userHeight
            self.userWeight = data.userWeight
            self.userHealthGoals = data.userHealthGoals
            self.userDietaryRestrictions = data.userDietaryRestrictions
            self.userEmergencyContacts = data.userEmergencyContacts
            self.preferredVoiceGender = data.preferredVoiceGender
            self.speechRate = data.speechRate
            self.enableAIFeatures = data.enableAIFeatures ?? false
        }
        
        // Mark as loaded immediately
        self.isLoaded = true
        let elapsed = Date().timeIntervalSince(loadStart)
        print("DEBUG: User data loaded in \(elapsed) seconds")
    }
    
    func updateProfile(_ profile: UserProfile) {
        self.userProfile = profile
        self.userName = profile.firstName
    }
    
    // MARK: - Emergency Number Methods
    
    /// Get the effective emergency number (custom if set and enabled, otherwise country-based)
    func getEffectiveEmergencyNumber() -> String {
        if useCustomEmergencyNumber, let custom = customEmergencyNumber, !custom.isEmpty {
            return custom
        }
        return AppConfig.Emergency.emergencyNumber
    }
    
    /// Get the effective emergency service name
    func getEffectiveEmergencyServiceName() -> String {
        if useCustomEmergencyNumber, let custom = customEmergencyNumber, !custom.isEmpty {
            return NSLocalizedString("Emergency Services", comment: "")
        }
        return AppConfig.Emergency.emergencyServiceName
    }
    
    /// Get the detected country emergency info for display purposes
    func getDetectedEmergencyInfo() -> EmergencyNumberInfo {
        return AppConfig.Emergency.currentEmergencyInfo
    }
    
    // MARK: - App Tour Methods
    
    /// Check if the app tour should be shown
    func shouldShowAppTour() -> Bool {
        // Show if user hasn't seen it yet, or if there's a new version
        return !hasSeenAppTour || appTourVersion != "1.0"
    }
    
    /// Mark the app tour as completed
    func markAppTourCompleted() {
        hasSeenAppTour = true
        appTourVersion = "1.0"
    }
    
    /// Reset app tour to show again (for testing or updates)
    func resetAppTour() {
        hasSeenAppTour = false
    }
    
    // Function to reset all settings to default
    @MainActor
    func resetAllSettings() {
        print("DEBUG: Resetting all settings to default values.")

        // Reset basic preferences
        textSize = .medium
        highContrastMode = false
        useVoiceInput = true
        activeFastingProtocol = .sixteenEight // Or whatever your default protocol is

        // Clear medications
        medications = []

        // Reset onboarding status
        isOnboardingComplete = false // Force re-onboarding if desired, or keep true if not

        // Reset profile data (to default/placeholder values)
        userName = "User"
        userAge = 65
        userGender = "Other"
        userHeight = 170.0
        userWeight = 70.0
        userHealthGoals = []
        userDietaryRestrictions = []
        userEmergencyContacts = []
        userProfile = nil // Or reset to a default profile if applicable

        // Reset appearance and notification settings stored in UserDefaults
        isDarkMode = false
        notificationsEnabled = true // Assuming notifications are enabled by default

        // Reset voice settings
        preferredVoiceGender = .female
        speechRate = .normal

        // Reset notification settings
        medicationRemindersEnabled = true
        medicationReminderLeadTime = 0
        mealWindowRemindersEnabled = true
        fastingRemindersEnabled = true
        dailyTipsEnabled = true
        notificationStyle = .regular

        // Clear UserDefaults data explicitly
        UserDefaults.standard.removeObject(forKey: "userProfile")
        UserDefaults.standard.removeObject(forKey: "isDarkMode")
        UserDefaults.standard.removeObject(forKey: "notificationsEnabled")

        // Clear persistent storage (Important!)
        PersistentStorage.shared.deleteData(forKey: self.localDataKey)
        print("DEBUG: Successfully cleared persistent storage for key: \(self.localDataKey)")

        // Trigger save of the now-default state (optional, depending on desired flow)
        // saveUserData() // Might be redundant if properties trigger saveUserData anyway

        print("DEBUG: All settings reset.")
    }
    
    func loadUserDataIfNeeded(startTime: Date? = nil) {
        if !isLoaded {
            loadUserData(startTime: startTime)
        }
    }
    
    // MARK: - Profile Translation Methods
    
    /// Performs initial migration of profile data to English keys if needed
    @MainActor
    private func performInitialMigration() async {
        // Check if migration has already been performed
        let migrationKey = "ProfileTranslationMigrationCompleted"
        if UserDefaults.standard.bool(forKey: migrationKey) {
            return
        }
        
        print("UserSettings: Performing initial profile translation migration")
        
        // Migrate UserSettings dietary restrictions
        ProfileTranslationUtils.migrateUserSettingsToEnglishKeys(self)
        
        // Migrate UserProfile if it exists
        if let profile = userProfile {
            let migratedProfile = ProfileTranslationUtils.migrateProfileToEnglishKeys(profile)
            userProfile = migratedProfile
        }
        
        // Mark migration as completed
        UserDefaults.standard.set(true, forKey: migrationKey)
        print("UserSettings: Profile translation migration completed")
    }
    
    /// Handles language changes by refreshing profile data display
    @MainActor
    private func handleLanguageChange() {
        print("UserSettings: Handling language change for profile data")
        
        // Force refresh of profile data to trigger UI updates with new translations
        if let profile = userProfile {
            // Create a copy to trigger the @Published update
            let refreshedProfile = profile
            userProfile = refreshedProfile
        }
        
        // Force refresh of user settings to trigger UI updates
        objectWillChange.send()
    }
}

// Notification style enum
enum NotificationStyle: String, CaseIterable, Identifiable, Codable {
    case regular = "Regular"
    case gentle = "Gentle"
    case urgent = "Urgent"
    var id: String { self.rawValue }
}