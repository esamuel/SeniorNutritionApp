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
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUserData()
        setupMedicationObservers()
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
                
                try await PersistentStorage.shared.saveData(data, forKey: localDataKey)
            } catch {
                print("Error saving user data: \(error)")
            }
        }
    }
    
    // Load user data from persistent storage
    private func loadUserData() {
        Task {
            do {
                if let data: PersistentData = try await PersistentStorage.shared.loadData(forKey: localDataKey) {
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
                }
            } catch {
                print("Error loading user data: \(error)")
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
} 