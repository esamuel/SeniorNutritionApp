import Foundation

// The model definitions for your live app data are in Models/AppModels.swift
// The backup-specific model definitions are in Models/BackupModels.swift

// Manager for local storage backup and restore
class LocalDataManager {
    static let shared = LocalDataManager()
    private init() {}
    
    private let backupFilename = "app_backup.json"
    
    // URL for local backup file in the documents directory
    private var backupURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(backupFilename)
    }
    
    // MARK: - Mapping Functions
    private func convertToBackupAppData(from appData: AppData) -> BackupAppData {
        // Convert the first AppUserProfile into a BackupUserProfile using the extension method
        let backupUserProfile: BackupUserProfile = appData.userProfile.first?.toBackupUserProfile() ?? BackupUserProfile(
            firstName: "",
            lastName: "",
            dateOfBirth: Date(),
            gender: "",
            height: 0.0,
            weight: 0.0,
            medicalConditions: [],
            dietaryRestrictions: [],
            emergencyContacts: []
        )
        
        let backupMedications = appData.medications.map { med in
            BackupMedication(id: med.id, name: med.name, dosage: med.dosage, schedule: med.schedule)
        }
        
        let backupAppointments = appData.appointments.map { appt in
            BackupAppointment(id: appt.id, title: appt.title, date: appt.date, location: appt.location)
        }
        
        let backupEmergencyContacts = appData.emergencyContacts.map { contact in
            BackupEmergencyContact(id: contact.id, name: contact.name, relationship: contact.relationship, phoneNumber: contact.phoneNumber)
        }
        
        let backupBloodPressures = appData.bloodPressures.map { bp in
            BackupBloodPressureEntry(id: bp.id, systolic: bp.systolic, diastolic: bp.diastolic, date: bp.date)
        }
        
        let backupBloodSugars = appData.bloodSugars.map { bs in
            BackupBloodSugarEntry(id: bs.id, glucose: bs.glucose, date: bs.date)
        }
        
        let backupHeartRates = appData.heartRates.map { hr in
            BackupHeartRateEntry(id: hr.id, bpm: hr.bpm, date: hr.date)
        }
        
        let backupWeights = appData.weights.map { wt in
            BackupWeightEntry(id: wt.id, weight: wt.weight, date: wt.date)
        }
        
        return BackupAppData(
            userProfile: backupUserProfile,
            medications: backupMedications,
            appointments: backupAppointments,
            emergencyContacts: backupEmergencyContacts,
            bloodPressures: backupBloodPressures,
            bloodSugars: backupBloodSugars,
            heartRates: backupHeartRates,
            weights: backupWeights
        )
    }
    
    private func convertToAppData(from backup: BackupAppData) -> AppData {
        // Convert the BackupUserProfile to an AppUserProfile
        let bp = backup.userProfile ?? BackupUserProfile(
            firstName: "",
            lastName: "",
            dateOfBirth: Date(),
            gender: "",
            height: 0.0,
            weight: 0.0,
            medicalConditions: [],
            dietaryRestrictions: [],
            emergencyContacts: []
        )
        let appProfile = AppUserProfile(
            firstName: bp.firstName,
            lastName: bp.lastName,
            dateOfBirth: bp.dateOfBirth,
            gender: bp.gender,
            height: bp.height,
            weight: bp.weight,
            medicalConditions: bp.medicalConditions,
            dietaryRestrictions: bp.dietaryRestrictions,
            emergencyContacts: bp.emergencyContacts
        )
        let appUserProfile = [appProfile]
        
        let medications = backup.medications.map { med in
            AppMedication(id: med.id, name: med.name, dosage: med.dosage, schedule: med.schedule)
        }
        
        let appointments = backup.appointments.map { appt in
            AppAppointment(id: appt.id, title: appt.title, date: appt.date, location: appt.location)
        }
        
        let emergencyContacts = backup.emergencyContacts.map { contact in
            AppEmergencyContact(id: contact.id, name: contact.name, relationship: contact.relationship, phoneNumber: contact.phoneNumber)
        }
        
        let bloodPressures = backup.bloodPressures.map { bp in
            AppBloodPressureEntry(id: bp.id, systolic: bp.systolic, diastolic: bp.diastolic, date: bp.date)
        }
        
        let bloodSugars = backup.bloodSugars.map { bs in
            AppBloodSugarEntry(id: bs.id, glucose: bs.glucose, date: bs.date)
        }
        
        let heartRates = backup.heartRates.map { hr in
            AppHeartRateEntry(id: hr.id, bpm: hr.bpm, date: hr.date)
        }
        
        let weights = backup.weights.map { wt in
            AppWeightEntry(id: wt.id, weight: wt.weight, date: wt.date)
        }
        
        return AppData(
            userProfile: appUserProfile,
            medications: medications,
            appointments: appointments,
            emergencyContacts: emergencyContacts,
            bloodPressures: bloodPressures,
            bloodSugars: bloodSugars,
            heartRates: heartRates,
            weights: weights
        )
    }
    
    // MARK: - Backup/Restore Functions
    func backup(appData: AppData) throws {
        let backupData = convertToBackupAppData(from: appData)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(backupData)
        print("[LocalDataManager] Writing backup data to: \(backupURL.path)")
        try data.write(to: backupURL, options: Data.WritingOptions.atomic)
        print("[LocalDataManager] Backup written successfully.")
    }
    
    func restore() throws -> AppData {
        print("[LocalDataManager] Reading backup data from: \(backupURL.path)")
        let data = try Data(contentsOf: backupURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let backupData = try decoder.decode(BackupAppData.self, from: data)
        print("[LocalDataManager] Backup restored successfully.")
        return convertToAppData(from: backupData)
    }
    
    // Export backup to an external location selected by the user
    func exportBackup(to destinationURL: URL) throws {
        if FileManager.default.fileExists(atPath: backupURL.path) {
            try FileManager.default.copyItem(at: backupURL, to: destinationURL)
            print("Backup exported to \(destinationURL)")
        } else {
            throw NSError(domain: "LocalDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "No backup file exists to export."])
        }
    }
    
    // Import backup from an external file selected by the user
    func importBackup(from sourceURL: URL) throws {
        try FileManager.default.copyItem(at: sourceURL, to: backupURL)
        print("Backup imported from \(sourceURL)")
    }
} 