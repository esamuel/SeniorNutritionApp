import SwiftUI

@MainActor
class FastingManager: ObservableObject {
    static let shared = FastingManager()
    
    @Published private(set) var fastingState: FastingState = .fasting
    @Published private(set) var currentTime: Date = Date()
    @Published var lastMealTime: Date {
        didSet {
            UserDefaults.standard.set(lastMealTime, forKey: "lastMealTime")
            Task { @MainActor in
                await updateNextMealTime()
            }
        }
    }
    @Published var nextMealTime: Date {
        didSet {
            UserDefaults.standard.set(nextMealTime, forKey: "nextMealTime")
        }
    }
    
    private var timer: Timer?
    private var userSettings: UserSettings?
    
    enum FastingState {
        case fasting, eating
        
        var color: Color {
            switch self {
            case .fasting: return .red
            case .eating: return .green
            }
        }
        
        var title: String {
            switch self {
            case .fasting: return "Fasting"
            case .eating: return "Eating Window"
            }
        }
    }
    
    private init() {
        // First initialize the stored properties
        let savedLastMealTime = UserDefaults.standard.object(forKey: "lastMealTime") as? Date ?? Date()
        self.lastMealTime = savedLastMealTime
        
        let savedNextMealTime = UserDefaults.standard.object(forKey: "nextMealTime") as? Date
        if let nextMeal = savedNextMealTime {
            self.nextMealTime = nextMeal
        } else {
            // Default to 16:8 protocol if no saved time
            let calendar = Calendar.current
            self.nextMealTime = calendar.date(byAdding: .hour, value: 16, to: savedLastMealTime) ?? Date()
        }
        
        // After initialization, start the timer and update state
        startTimer()
        updateFastingState()
    }
    
    func setUserSettings(_ settings: UserSettings) {
        self.userSettings = settings
        Task { @MainActor in
            await updateNextMealTime()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.updateProgress()
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateProgress() async {
        currentTime = Date()
        updateFastingState()
    }
    
    func updateNextMealTime() async {
        let calendar = Calendar.current
        let fastingHours = userSettings?.activeFastingProtocol.fastingHours ?? 16 // Default to 16 if settings not available
        nextMealTime = calendar.date(byAdding: .hour, value: fastingHours, to: lastMealTime) ?? lastMealTime
        updateFastingState()
    }
    
    func updateLastMealTime(_ newTime: Date) {
        lastMealTime = newTime
    }
    
    private func updateFastingState() {
        let now = Date()
        let calendar = Calendar.current
        
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        let lastMealMinutes = calendar.component(.hour, from: lastMealTime) * 60 + calendar.component(.minute, from: lastMealTime)
        let nextMealMinutes = calendar.component(.hour, from: nextMealTime) * 60 + calendar.component(.minute, from: nextMealTime)
        
        if nextMealMinutes > lastMealMinutes {
            // Same day comparison
            fastingState = (currentMinutes >= lastMealMinutes && currentMinutes < nextMealMinutes) ? .fasting : .eating
        } else {
            // Crosses midnight
            fastingState = (currentMinutes >= lastMealMinutes || currentMinutes < nextMealMinutes) ? .fasting : .eating
        }
    }
    
    deinit {
        Task { @MainActor in
            stopTimer()
        }
    }
} 