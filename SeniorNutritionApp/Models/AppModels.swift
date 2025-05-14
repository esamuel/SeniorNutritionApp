import Foundation

// MARK: - App Data Structure
struct AppData: Codable {
    var userProfile: [AppUserProfile]
    var medications: [AppMedication]
    var appointments: [AppAppointment]
    var emergencyContacts: [AppEmergencyContact]
    var bloodPressures: [AppBloodPressureEntry]
    var bloodSugars: [AppBloodSugarEntry]
    var heartRates: [AppHeartRateEntry]
    var weights: [AppWeightEntry]
}

// MARK: - User Profile
struct AppUserProfile: Codable {
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var gender: String
    var height: Double
    var weight: Double
    var medicalConditions: [String]
    var dietaryRestrictions: [String]
    var emergencyContacts: [String]
}

// MARK: - Medication
struct AppMedication: Codable {
    var id: String
    var name: String
    var dosage: String
    var schedule: String
}

// MARK: - Appointment
struct AppAppointment: Codable {
    var id: String
    var title: String
    var date: Date
    var location: String
}

// MARK: - Emergency Contact
struct AppEmergencyContact: Codable {
    var id: String
    var name: String
    var relationship: String
    var phoneNumber: String
}

// MARK: - Health Metrics
struct AppBloodPressureEntry: Codable {
    var id: String
    var systolic: Int
    var diastolic: Int
    var date: Date
}

struct AppBloodSugarEntry: Codable {
    var id: String
    var glucose: Double
    var date: Date
}

struct AppHeartRateEntry: Codable {
    var id: String
    var bpm: Int
    var date: Date
}

struct AppWeightEntry: Codable {
    var id: String
    var weight: Double
    var date: Date
} 