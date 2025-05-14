import Foundation

// MARK: - Backup Data Structure
struct BackupAppData: Codable {
    var userProfile: BackupUserProfile?
    var medications: [BackupMedication]
    var appointments: [BackupAppointment]
    var emergencyContacts: [BackupEmergencyContact]
    var bloodPressures: [BackupBloodPressureEntry]
    var bloodSugars: [BackupBloodSugarEntry]
    var heartRates: [BackupHeartRateEntry]
    var weights: [BackupWeightEntry]
}

// MARK: - User Profile
struct BackupUserProfile: Codable {
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
struct BackupMedication: Codable {
    var id: String
    var name: String
    var dosage: String
    var schedule: String
}

// MARK: - Appointment
struct BackupAppointment: Codable {
    var id: String
    var title: String
    var date: Date
    var location: String
}

// MARK: - Emergency Contact
struct BackupEmergencyContact: Codable {
    var id: String
    var name: String
    var relationship: String
    var phoneNumber: String
}

// MARK: - Health Metrics
struct BackupBloodPressureEntry: Codable {
    var id: String
    var systolic: Int
    var diastolic: Int
    var date: Date
}

struct BackupBloodSugarEntry: Codable {
    var id: String
    var glucose: Double
    var date: Date
}

struct BackupHeartRateEntry: Codable {
    var id: String
    var bpm: Int
    var date: Date
}

struct BackupWeightEntry: Codable {
    var id: String
    var weight: Double
    var date: Date
} 