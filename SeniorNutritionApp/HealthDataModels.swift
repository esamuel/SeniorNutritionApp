import Foundation

// Enum for common medical conditions
enum MedicalConditionType: String, Codable, CaseIterable, Identifiable {
    case diabetes, hypertension, heartDisease, obesity, other
    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .diabetes: return "Diabetes"
        case .hypertension: return "Hypertension"
        case .heartDisease: return "Heart Disease"
        case .obesity: return "Obesity"
        case .other: return "Other"
        }
    }
}

// The following structs are commented out because they are now Core Data entities.
// Remove or comment out these definitions to avoid conflicts with NSManagedObject subclasses.

/*
// Blood Pressure Entry
struct BloodPressureEntry: Identifiable, Codable {
    let id: UUID
    var systolic: Int
    var diastolic: Int
    var date: Date
    
    init(systolic: Int, diastolic: Int, date: Date = Date()) {
        self.id = UUID()
        self.systolic = systolic
        self.diastolic = diastolic
        self.date = date
    }
}

// Blood Sugar Entry
struct BloodSugarEntry: Identifiable, Codable {
    let id: UUID
    var glucose: Double
    var date: Date
    
    init(glucose: Double, date: Date = Date()) {
        self.id = UUID()
        self.glucose = glucose
        self.date = date
    }
}

// Heart Rate Entry
struct HeartRateEntry: Identifiable, Codable {
    let id: UUID
    var bpm: Int
    var date: Date
    
    init(bpm: Int, date: Date = Date()) {
        self.id = UUID()
        self.bpm = bpm
        self.date = date
    }
}

// Weight Entry
struct WeightEntry: Identifiable, Codable {
    let id: UUID
    var weight: Double
    var date: Date
    
    init(weight: Double, date: Date = Date()) {
        self.id = UUID()
        self.weight = weight
        self.date = date
    }
}
*/

// Medical Condition
struct MedicalCondition: Identifiable, Codable {
    let id: UUID
    var type: MedicalConditionType
    var notes: String?
    var dateDiagnosed: Date
    
    init(type: MedicalConditionType, notes: String? = nil, dateDiagnosed: Date = Date()) {
        self.id = UUID()
        self.type = type
        self.notes = notes
        self.dateDiagnosed = dateDiagnosed
    }
} 