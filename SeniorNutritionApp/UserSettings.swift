import SwiftUI
import Combine
import UserNotifications
import Foundation

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
    
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "AppLanguage") ?? LanguageManager.shared.currentLanguage {
        didSet {
            if selectedLanguage != LanguageManager.shared.currentLanguage {
                print("UserSettings: selectedLanguage changed to \(selectedLanguage), updating LanguageManager")
                LanguageManager.shared.setLanguage(selectedLanguage)
            }
        }
    }
    
    @Published var dailyCalorieGoal: Int = 2000
    @Published var macroGoalsEnabled: Bool = false
    @Published var dailyProteinGoal: Int = 75
    @Published var dailyCarbGoal: Int = 250
    @Published var dailyFatGoal: Int = 70
    
    let supportedLanguages: [String] = ["en", "es", "fr", "he"]
    
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
            speechRate: speechRate
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
                    speechRate: speechRate
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
        
        // Load heavy data in background first, then mark as loaded
        DispatchQueue.global(qos: .userInitiated).async {
            Task {
                // Load lightweight settings
                DispatchQueue.main.async {
                    if let savedProfile = UserDefaults.standard.data(forKey: "userProfile"),
                       let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedProfile) {
                        self.userProfile = decodedProfile
                    }
                    self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
                    self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                }
                
                // Load persistent data
                if let data: PersistentData = PersistentStorage.shared.loadData(forKey: self.localDataKey) {
                    DispatchQueue.main.async {
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
                        
                        // Add a small delay to show the loading screen with old man image
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.isLoaded = true
                            let elapsed = Date().timeIntervalSince(loadStart)
                            print("DEBUG: User data loaded in \(elapsed) seconds")
                        }
                    }
                } else {
                    print("DEBUG: No saved user data found")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.isLoaded = true
                        let elapsed = Date().timeIntervalSince(loadStart)
                        print("DEBUG: User data load (empty) in \(elapsed) seconds")
                    }
                }
            }
        }
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
}

// Notification style enum
enum NotificationStyle: String, CaseIterable, Identifiable, Codable {
    case regular = "Regular"
    case gentle = "Gentle"
    case urgent = "Urgent"
    var id: String { self.rawValue }
}