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

// Medication model
struct Medication: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dosage: String
    var schedule: [Date]
    var takeWithFood: Bool
    var notes: String?
    
    // Custom init for creating a medication with a specific UUID
    init(id: UUID = UUID(), name: String, dosage: String, schedule: [Date], takeWithFood: Bool, notes: String? = nil) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.schedule = schedule
        self.takeWithFood = takeWithFood
        self.notes = notes
    }
    
    // Custom coding keys to include UUID in encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, name, dosage, schedule, takeWithFood, notes
    }
    
    // Implement encode to ensure UUID is preserved
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dosage, forKey: .dosage)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(takeWithFood, forKey: .takeWithFood)
        try container.encode(notes, forKey: .notes)
    }
    
    // Implement init from decoder to properly restore UUID
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        id = UUID(uuidString: idString) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        dosage = try container.decode(String.self, forKey: .dosage)
        schedule = try container.decode([Date].self, forKey: .schedule)
        takeWithFood = try container.decode(Bool.self, forKey: .takeWithFood)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
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