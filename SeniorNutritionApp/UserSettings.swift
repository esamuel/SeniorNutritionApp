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
    
    private var cancellables = Set<AnyCancellable>()
    private let localDataKey = "userData"
    private var saveTimer: Timer?
    
    init() {
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
} 