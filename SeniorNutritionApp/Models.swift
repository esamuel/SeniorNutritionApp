import SwiftUI
import Combine
import CloudKit

// Emergency contact information
struct EmergencyContact: Identifiable, Codable {
    var id: UUID
    var name: String
    var relationship: Relationship
    var phoneNumber: String
    
    init(id: UUID = UUID(), name: String, relationship: Relationship, phoneNumber: String) {
        self.id = id
        self.name = name
        self.relationship = relationship
        self.phoneNumber = phoneNumber
    }
}

// Relationship options for emergency contact
enum Relationship: String, CaseIterable, Identifiable, Codable {
    case spouse = "Spouse"
    case child = "Child"
    case parent = "Parent"
    case sibling = "Sibling"
    case friend = "Friend"
    case neighbor = "Neighbor"
    case caregiver = "Caregiver"
    case other = "Other"
    
    var id: String { self.rawValue }
}

// Fasting protocol options
enum FastingProtocol: String, CaseIterable, Identifiable, Codable {
    case twelveTwelve = "12:12 (Gentle)"
    case fourteenTen = "14:10 (Moderate)"
    case sixteenEight = "16:8 (Standard)"
    case custom = "Custom Protocol"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .twelveTwelve: 
            return "Fast for 12 hours, eat within a 12-hour window. Ideal for beginners."
        case .fourteenTen:
            return "Fast for 14 hours, eat within a 10-hour window. Moderate intensity."
        case .sixteenEight:
            return "Fast for 16 hours, eat within an 8-hour window. Standard protocol."
        case .custom:
            return "Custom fasting protocol with your preferred hours."
        }
    }
    
    var fastingHours: Int {
        switch self {
        case .twelveTwelve: return 12
        case .fourteenTen: return 14
        case .sixteenEight: return 16
        case .custom: return UserDefaults.standard.integer(forKey: "customFastingHours")
        }
    }
    
    var eatingHours: Int {
        switch self {
        case .twelveTwelve: return 12
        case .fourteenTen: return 10
        case .sixteenEight: return 8
        case .custom: return UserDefaults.standard.integer(forKey: "customEatingHours")
        }
    }
    
    static func setCustomProtocol(fastingHours: Int, eatingHours: Int) {
        UserDefaults.standard.set(fastingHours, forKey: "customFastingHours")
        UserDefaults.standard.set(eatingHours, forKey: "customEatingHours")
    }
    
    static func getCustomProtocol() -> (fastingHours: Int, eatingHours: Int) {
        let fastingHours = UserDefaults.standard.integer(forKey: "customFastingHours")
        let eatingHours = UserDefaults.standard.integer(forKey: "customEatingHours")
        return (fastingHours, eatingHours)
    }
}

// Pill shape options
enum PillShape: String, CaseIterable, Identifiable, Codable {
    case round = "Round"
    case oval = "Oval"
    case capsule = "Capsule"
    case rectangle = "Rectangle"
    case diamond = "Diamond"
    case triangle = "Triangle"
    case other = "Other"
    
    var id: String { self.rawValue }
}

// MARK: - Medication Scheduling Enums & Structs

/// Defines the type of frequency for medication schedules.
enum FrequencyType: String, Codable, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case interval = "Every X Days"
    case monthly = "Monthly"
    var id: String { self.rawValue }
}

/// Represents the days of the week.
enum Weekday: Int, Codable, CaseIterable, Identifiable, Comparable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var id: Int { self.rawValue }
    
    var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }

    // Comparable conformance
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// Represents a specific time of day (hour and minute).
struct TimeOfDay: Codable, Hashable, Comparable {
    var hour: Int // 0-23
    var minute: Int // 0-59

    // Comparable conformance
    static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        if lhs.hour != rhs.hour {
            return lhs.hour < rhs.hour
        } else {
            return lhs.minute < rhs.minute
        }
    }
    
    // Helper to convert to Date for DatePicker binding
    var dateRepresentation: Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }
    
    // Initializer ensures values are valid (optional: add validation)
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
}

/// Holds the specific details for different schedule frequencies.
enum ScheduleDetails: Codable, Hashable {
    case daily // Represents taking it every day at specified times
    case weekly(days: Set<Weekday>) // Specific days of the week
    case interval(days: Int, startDate: Date) // Every X days, starting from a specific date
    case monthly(day: Int) // Specific day of the month (1-31)
    // TODO: Add support for relative monthly dates (e.g., first Monday) later if needed
}

// Medication model
struct Medication: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var dosage: String
    var frequency: ScheduleDetails // NEW: Use the detailed schedule enum
    var timesOfDay: [TimeOfDay] // NEW: Store specific times (sorted)
    var takeWithFood: Bool
    var notes: String?
    var color: Color? // Requires custom Codable handling if not inherently Codable
    var shape: PillShape? // Requires PillShape to be Codable
    
    /// Checks if the medication is scheduled to be taken on a specific date based on its frequency.
    /// Note: This checks the *day* frequency, not the specific timesOfDay.
    func isDue(on date: Date, calendar: Calendar = .current) -> Bool {
        switch frequency {
        case .daily:
            return true // Always due if frequency is daily
        case .weekly(let scheduledDays):
            let weekday = calendar.component(.weekday, from: date) // 1 = Sun, 2 = Mon, ..., 7 = Sat
            // Convert calendar weekday to our Weekday enum raw value (adjusting for 1-based vs 0-based)
            guard let currentDay = Weekday(rawValue: weekday - 1) else { return false }
            return scheduledDays.contains(currentDay)
        case .interval(let intervalDays, let startDate):
            // Ensure start date is not in the future relative to the check date
            guard date >= calendar.startOfDay(for: startDate) else { return false }
            let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: calendar.startOfDay(for: date))
            guard let daysSinceStart = components.day else { return false }
            return daysSinceStart % intervalDays == 0
        case .monthly(let dayOfMonth):
            let day = calendar.component(.day, from: date)
            // Handle potential invalid day for shorter months (e.g., 31st in Feb)
            if let range = calendar.range(of: .day, in: .month, for: date) {
                 return day == dayOfMonth && range.contains(dayOfMonth)
            } else {
                return false // Should not happen with valid calendar/date
            }
        }
    }
    
    // Custom init for creating a medication with a specific UUID
    init(id: UUID = UUID(), name: String, dosage: String, frequency: ScheduleDetails, timesOfDay: [TimeOfDay], takeWithFood: Bool, notes: String? = nil, color: Color? = nil, shape: PillShape? = nil) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.timesOfDay = timesOfDay.sorted() // Ensure times are stored sorted
        self.takeWithFood = takeWithFood
        self.notes = notes
        self.color = color
        self.shape = shape
    }
    
    // Custom coding keys for Codable conformance
    enum CodingKeys: String, CodingKey {
        // Define keys for all properties, including nested keys for ScheduleDetails
        case id, name, dosage, takeWithFood, notes, colorHex, shape, timesOfDay
        case frequencyType // Key to determine which ScheduleDetails case
        case frequencyData // Key for associated data of ScheduleDetails
    }
    
    // Custom decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        guard let decodedId = UUID(uuidString: idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Invalid UUID string")
        }
        self.id = decodedId
        self.name = try container.decode(String.self, forKey: .name)
        self.dosage = try container.decode(String.self, forKey: .dosage)
        self.takeWithFood = try container.decode(Bool.self, forKey: .takeWithFood)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        
        // Decode Color (assuming custom handling via hex string)
        if let hex = try container.decodeIfPresent(String.self, forKey: .colorHex) {
            self.color = Color(hex: hex) // Assumes Color(hex:) initializer exists
        } else {
            self.color = nil
        }
        
        // Decode PillShape (assuming it's Codable)
        self.shape = try container.decodeIfPresent(PillShape.self, forKey: .shape)
        
        // Decode Times of Day
        self.timesOfDay = try container.decode([TimeOfDay].self, forKey: .timesOfDay).sorted()
        
        // Decode ScheduleDetails (complex enum)
        let freqType = try container.decode(FrequencyType.self, forKey: .frequencyType)
        switch freqType {
        case .daily:
            self.frequency = .daily
        case .weekly:
            let days = try container.decode(Set<Weekday>.self, forKey: .frequencyData)
            self.frequency = .weekly(days: days)
        case .interval:
            // Decode nested data for interval
            struct IntervalData: Codable { let days: Int; let startDate: Date }
            let data = try container.decode(IntervalData.self, forKey: .frequencyData)
            self.frequency = .interval(days: data.days, startDate: data.startDate)
        case .monthly:
            // Decode nested data for monthly
            struct MonthlyData: Codable { let day: Int }
            let data = try container.decode(MonthlyData.self, forKey: .frequencyData)
            self.frequency = .monthly(day: data.day)
        }
    }
    
    // Custom encoding function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dosage, forKey: .dosage)
        try container.encode(takeWithFood, forKey: .takeWithFood)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(color?.toHex(), forKey: .colorHex) // Assumes Color().toHex() exists
        try container.encodeIfPresent(shape, forKey: .shape) // Assumes PillShape is Codable
        try container.encode(timesOfDay, forKey: .timesOfDay)
        
        // Encode ScheduleDetails (complex enum)
        switch frequency {
        case .daily:
            try container.encode(FrequencyType.daily, forKey: .frequencyType)
            // No associated data for daily
        case .weekly(let days):
            try container.encode(FrequencyType.weekly, forKey: .frequencyType)
            try container.encode(days, forKey: .frequencyData)
        case .interval(let days, let startDate):
            try container.encode(FrequencyType.interval, forKey: .frequencyType)
            // Encode nested data
            struct IntervalData: Codable { let days: Int; let startDate: Date }
            try container.encode(IntervalData(days: days, startDate: startDate), forKey: .frequencyData)
        case .monthly(let day):
            try container.encode(FrequencyType.monthly, forKey: .frequencyType)
            // Encode nested data
            struct MonthlyData: Codable { let day: Int }
            try container.encode(MonthlyData(day: day), forKey: .frequencyData)
        }
    }
    
    // Conform to Hashable (necessary if used in Sets or as Dictionary keys)
    static func == (lhs: Medication, rhs: Medication) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// User settings data structure
struct PersistentData: Codable {
    let textSize: TextSize
    let highContrastMode: Bool
    let useVoiceInput: Bool
    let activeFastingProtocol: FastingProtocol
    let medications: [Medication]
    let isOnboardingComplete: Bool
    let userName: String
    let userAge: Int
    let userGender: String
    let userHeight: Double
    let userWeight: Double
    let userHealthGoals: [String]
    let userDietaryRestrictions: [String]
    let userEmergencyContacts: [EmergencyContact]
    let preferredVoiceGender: VoiceGender
    let speechRate: SpeechRate
}

// User profile model
struct UserProfile: Codable {
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var gender: String
    var height: Double
    var weight: Double
    var medicalConditions: [String]
    var dietaryRestrictions: [String]
    var emergencyContacts: [EmergencyContact]
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return ageComponents.year ?? 0
    }
}

// MARK: - UserProfileAnalyzable Conformance 
extension UserProfile: UserProfileAnalyzable {
    // UserProfile already has the required properties:
    // - medicalConditions: [String]
    // - dietaryRestrictions: [String] 
    // - weight: Double
} 

// MARK: - Color Codable Helper
extension Color {
    // Initialize Color from a hex string (e.g., "#FF0000")
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

    // Convert Color to a hex string
    func toHex() -> String? {
        guard let components = cgColor?.components, components.count >= 3 else {
            // Attempt to handle standard colors or non-RGB colors gracefully
            // This might need refinement based on how you use colors
            return nil // Or return a default hex like "#000000"
        }

        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)

        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}