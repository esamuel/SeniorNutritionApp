import SwiftUI
import Combine

// User settings management
@MainActor
class UserSettings: ObservableObject {
    // User preferences
    @Published var textSize: TextSize = .medium
    @Published var highContrastMode: Bool = false
    @Published var useVoiceInput: Bool = true
    @Published var activeFastingProtocol: FastingProtocol = .sixteenEight
    
    // User medications
    @Published var medications: [Medication] = []
    @Published var isShowingMedicationSheet: Bool = false
    @Published var medicationToEdit: Medication? = nil
    
    // Onboarding state
    @Published var isOnboardingComplete: Bool = false
    
    // User profile data
    @Published var userName: String = "User"
    @Published var userAge: Int = 65
    @Published var userGender: String = "Other"
    @Published var userHeight: Double = 170.0  // in cm
    @Published var userWeight: Double = 70.0   // in kg
    @Published var userHealthGoals: [String] = []
    @Published var userDietaryRestrictions: [String] = []
    @Published var userEmergencyContacts: [EmergencyContact] = []
    
    @Published var userProfile: UserProfile? {
        didSet {
            if let encoded = try? JSONEncoder().encode(userProfile) {
                UserDefaults.standard.set(encoded, forKey: "userProfile")
            }
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
    
    private var cancellables = Set<AnyCancellable>()
    private let localDataKey = "userData"
    private var saveTimer: Timer?
    
    init() {
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        
        // Handle both string and integer legacy values for text size
        if let savedTextSize = UserDefaults.standard.string(forKey: "textSize"),
           let textSize = TextSize(rawValue: savedTextSize) {
            self.textSize = textSize
        } else if let savedTextSize = UserDefaults.standard.integer(forKey: "textSize") as Int? {
            // Legacy integer values
            switch savedTextSize {
            case 16: self.textSize = .small
            case 18: self.textSize = .medium
            case 20: self.textSize = .large
            case 22: self.textSize = .extraLarge
            default: self.textSize = .medium
            }
        } else {
            self.textSize = .medium
        }
        
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        if let savedProfile = UserDefaults.standard.data(forKey: "userProfile"),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: savedProfile) {
            self.userProfile = decodedProfile
        }
        
        setupSubscribers()
        loadUserData()
    }
    
    private func setupSubscribers() {
        // Monitor properties for changes and schedule a save
        $textSize.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $highContrastMode.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $useVoiceInput.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $activeFastingProtocol.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $medications.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $isOnboardingComplete.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userName.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userAge.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userGender.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userHeight.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userWeight.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userHealthGoals.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userDietaryRestrictions.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
        $userEmergencyContacts.sink { [weak self] _ in self?.scheduleSave() }.store(in: &cancellables)
    }
    
    private func scheduleSave() {
        // Invalidate existing timer if any
        saveTimer?.invalidate()
        
        // Create new timer that will save after 1 second of no changes
        saveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.saveUserData()
            }
        }
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