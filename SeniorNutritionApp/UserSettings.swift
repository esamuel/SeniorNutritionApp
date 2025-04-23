import SwiftUI
import Combine

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
    
    private let localDataKey = "userData"
    
    init() {
        loadUserData()
    }
    
    // Save user data to persistent storage
    func saveUserData() {
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
            userEmergencyContacts: userEmergencyContacts
        )
        
        // Save to persistent storage
        PersistentStorage.shared.saveData(data, forKey: localDataKey)
    }
    
    // Load user data from persistent storage
    func loadUserData() {
        if let data: PersistentData = PersistentStorage.shared.loadData(forKey: localDataKey) {
            self.updateSettings(from: data)
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
    
    // Update settings from loaded data
    private func updateSettings(from data: PersistentData) {
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
    }
    
    func updateProfile(_ profile: UserProfile) {
        self.userProfile = profile
        self.userName = profile.firstName
    }
} 