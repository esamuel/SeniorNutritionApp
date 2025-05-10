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
    @Published var medicationReminderLeadTime: Int = 30 {
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
    
    @Published var isLoaded: Bool = false
    
    @Published var selectedLanguage: String = Locale.current.languageCode ?? "en" // Default to system or English
    
    let supportedLanguages: [String] = ["en", "es", "fr", "de", "he"]
    
    private let localDataKey = "userData"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupMedicationObservers()
        self.medications = []
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
        Task {
            do {
                if let data: PersistentData = try await PersistentStorage.shared.loadData(forKey: localDataKey) {
                    print("DEBUG: Loading medications count: \(data.medications.count)")
                    for medication in data.medications {
                        print("DEBUG: Loading medication: \(medication.name) with frequency: \(medication.frequency)")
                    }
                    
                    textSize = data.textSize
                    highContrastMode = data.highContrastMode
                    useVoiceInput = data.useVoiceInput
                    activeFastingProtocol = data.activeFastingProtocol
                    medications = data.medications
                    isOnboardingComplete = data.isOnboardingComplete
                    userName = data.userName
                    userAge = data.userAge
                    userGender = data.userGender
                    userHeight = data.userHeight
                    userWeight = data.userWeight
                    userHealthGoals = data.userHealthGoals
                    userDietaryRestrictions = data.userDietaryRestrictions
                    userEmergencyContacts = data.userEmergencyContacts
                    preferredVoiceGender = data.preferredVoiceGender
                    speechRate = data.speechRate
                    isLoaded = true
                    let elapsed = Date().timeIntervalSince(loadStart)
                    print("DEBUG: User data loaded in \(elapsed) seconds")
                } else {
                    print("DEBUG: No saved user data found")
                    isLoaded = true
                    let elapsed = Date().timeIntervalSince(loadStart)
                    print("DEBUG: User data load (empty) in \(elapsed) seconds")
                }
            } catch {
                print("Error loading user data: \(error)")
                isLoaded = true
                let elapsed = Date().timeIntervalSince(loadStart)
                print("DEBUG: User data load failed after \(elapsed) seconds")
            }
        }
        
        // Load user profile
        if let savedProfile = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedProfile) {
            self.userProfile = decodedProfile
        }
        
        // Load other settings
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
    
    func updateProfile(_ profile: UserProfile) {
        self.userProfile = profile
        self.userName = profile.firstName
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
        medicationReminderLeadTime = 30
        mealWindowRemindersEnabled = true
        fastingRemindersEnabled = true
        dailyTipsEnabled = true
        notificationStyle = .regular

        // Clear UserDefaults data explicitly
        UserDefaults.standard.removeObject(forKey: "userProfile")
        UserDefaults.standard.removeObject(forKey: "isDarkMode")
        UserDefaults.standard.removeObject(forKey: "notificationsEnabled")

        // Clear persistent storage (Important!)
        Task {
            do {
                try await PersistentStorage.shared.deleteData(forKey: localDataKey)
                print("DEBUG: Successfully cleared persistent storage for key: \(localDataKey)")
            } catch {
                print("Error clearing persistent storage: \(error)")
            }
        }

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