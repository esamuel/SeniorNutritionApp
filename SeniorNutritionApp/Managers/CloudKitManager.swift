import Foundation
import CloudKit

class CloudKitManager {
    static let shared = CloudKitManager()
    private let container = CKContainer.default()
    private let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - User Profile
    func saveUserProfile(_ profile: AppUserProfile, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "UserProfile")
        record["firstName"] = profile.firstName as CKRecordValue
        record["lastName"] = profile.lastName as CKRecordValue
        record["dateOfBirth"] = profile.dateOfBirth as CKRecordValue
        record["gender"] = profile.gender as CKRecordValue
        record["height"] = profile.height as CKRecordValue
        record["weight"] = profile.weight as CKRecordValue
        record["medicalConditions"] = profile.medicalConditions as CKRecordValue
        record["dietaryRestrictions"] = profile.dietaryRestrictions as CKRecordValue
        // Emergency contacts can be saved as a JSON string or separate records
        // For now, skip emergencyContacts or serialize as needed
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }
    
    func fetchUserProfile(with recordID: CKRecord.ID, completion: @escaping (Result<AppUserProfile, Error>) -> Void) {
        privateDB.fetch(withRecordID: recordID) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let record = record {
                    let profile = AppUserProfile(
                        firstName: record["firstName"] as? String ?? "",
                        lastName: record["lastName"] as? String ?? "",
                        dateOfBirth: record["dateOfBirth"] as? Date ?? Date(),
                        gender: record["gender"] as? String ?? "",
                        height: record["height"] as? Double ?? 0.0,
                        weight: record["weight"] as? Double ?? 0.0,
                        medicalConditions: record["medicalConditions"] as? [String] ?? [],
                        dietaryRestrictions: record["dietaryRestrictions"] as? [String] ?? [],
                        emergencyContacts: [] // Deserialize if stored
                    )
                    completion(.success(profile))
                }
            }
        }
    }
    
    func deleteUserProfile(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        privateDB.delete(withRecordID: recordID) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - Medication
    struct MedicationCK: Identifiable {
        let id: UUID
        var name: String
        var dosage: String
        var schedule: String // You can expand this to match your app's model
    }

    func saveMedication(_ med: MedicationCK, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Medication", recordID: CKRecord.ID(recordName: med.id.uuidString))
        record["name"] = med.name as CKRecordValue
        record["dosage"] = med.dosage as CKRecordValue
        record["schedule"] = med.schedule as CKRecordValue
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }
    func fetchMedication(with id: UUID, completion: @escaping (Result<MedicationCK, Error>) -> Void) {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        privateDB.fetch(withRecordID: recordID) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let record = record {
                    let med = MedicationCK(
                        id: id,
                        name: record["name"] as? String ?? "",
                        dosage: record["dosage"] as? String ?? "",
                        schedule: record["schedule"] as? String ?? ""
                    )
                    completion(.success(med))
                }
            }
        }
    }
    func deleteMedication(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        privateDB.delete(withRecordID: recordID) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - Appointment
    struct AppointmentCK: Identifiable {
        let id: UUID
        var title: String
        var date: Date
        var location: String
    }

    func saveAppointment(_ appt: AppointmentCK, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Appointment", recordID: CKRecord.ID(recordName: appt.id.uuidString))
        record["title"] = appt.title as CKRecordValue
        record["date"] = appt.date as CKRecordValue
        record["location"] = appt.location as CKRecordValue
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }
    func fetchAppointment(with id: UUID, completion: @escaping (Result<AppointmentCK, Error>) -> Void) {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        privateDB.fetch(withRecordID: recordID) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let record = record {
                    let appt = AppointmentCK(
                        id: id,
                        title: record["title"] as? String ?? "",
                        date: record["date"] as? Date ?? Date(),
                        location: record["location"] as? String ?? ""
                    )
                    completion(.success(appt))
                }
            }
        }
    }
    func deleteAppointment(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        privateDB.delete(withRecordID: recordID) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - EmergencyContact
    struct EmergencyContactCK: Identifiable {
        let id: UUID
        var name: String
        var relationship: String
        var phoneNumber: String
    }

    func saveEmergencyContact(_ contact: EmergencyContactCK, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "EmergencyContact", recordID: CKRecord.ID(recordName: contact.id.uuidString))
        record["name"] = contact.name as CKRecordValue
        record["relationship"] = contact.relationship as CKRecordValue
        record["phoneNumber"] = contact.phoneNumber as CKRecordValue
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }
    func fetchEmergencyContact(with id: UUID, completion: @escaping (Result<EmergencyContactCK, Error>) -> Void) {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        privateDB.fetch(withRecordID: recordID) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let record = record {
                    let contact = EmergencyContactCK(
                        id: id,
                        name: record["name"] as? String ?? "",
                        relationship: record["relationship"] as? String ?? "",
                        phoneNumber: record["phoneNumber"] as? String ?? ""
                    )
                    completion(.success(contact))
                }
            }
        }
    }
    func deleteEmergencyContact(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        privateDB.delete(withRecordID: recordID) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - Fetch All Records
    func fetchAllUserProfiles(completion: @escaping (Result<[AppUserProfile], Error>) -> Void) {
        let query = CKQuery(recordType: "UserProfile", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var profiles: [AppUserProfile] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let profile = AppUserProfile(
                                firstName: record["firstName"] as? String ?? "",
                                lastName: record["lastName"] as? String ?? "",
                                dateOfBirth: record["dateOfBirth"] as? Date ?? Date(),
                                gender: record["gender"] as? String ?? "",
                                height: record["height"] as? Double ?? 0.0,
                                weight: record["weight"] as? Double ?? 0.0,
                                medicalConditions: record["medicalConditions"] as? [String] ?? [],
                                dietaryRestrictions: record["dietaryRestrictions"] as? [String] ?? [],
                                emergencyContacts: [] // Deserialize if stored
                            )
                            profiles.append(profile)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    _ = profiles
                    completion(.success(profiles))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchAllMedications(completion: @escaping (Result<[MedicationCK], Error>) -> Void) {
        let query = CKQuery(recordType: "Medication", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var medications: [MedicationCK] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let med = MedicationCK(
                                id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
                                name: record["name"] as? String ?? "",
                                dosage: record["dosage"] as? String ?? "",
                                schedule: record["schedule"] as? String ?? ""
                            )
                            medications.append(med)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    _ = medications
                    completion(.success(medications))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchAllAppointments(completion: @escaping (Result<[AppointmentCK], Error>) -> Void) {
        let query = CKQuery(recordType: "Appointment", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var appointments: [AppointmentCK] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let appt = AppointmentCK(
                                id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
                                title: record["title"] as? String ?? "",
                                date: record["date"] as? Date ?? Date(),
                                location: record["location"] as? String ?? ""
                            )
                            appointments.append(appt)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    _ = appointments
                    completion(.success(appointments))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchAllEmergencyContacts(completion: @escaping (Result<[EmergencyContactCK], Error>) -> Void) {
        let query = CKQuery(recordType: "EmergencyContact", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var contacts: [EmergencyContactCK] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let contact = EmergencyContactCK(
                                id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
                                name: record["name"] as? String ?? "",
                                relationship: record["relationship"] as? String ?? "",
                                phoneNumber: record["phoneNumber"] as? String ?? ""
                            )
                            contacts.append(contact)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    _ = contacts
                    completion(.success(contacts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - iCloud Account Status
    func checkiCloudAccountStatus(completion: @escaping (CKAccountStatus) -> Void) {
        container.accountStatus { status, _ in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }

    func restoreAllData(completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        var restoreError: Error?

        group.enter()
        fetchAllUserProfiles { result in
            switch result {
            case .success(_):
                // Update local storage with fetched profiles
                // Example: self.userProfiles = profiles
                print("Successfully restored user profiles from iCloud.")
            case .failure(let error):
                print("Failed to restore user profiles: \(error.localizedDescription)")
                restoreError = error
            }
            group.leave()
        }

        group.enter()
        fetchAllMedications { result in
            switch result {
            case .success(_):
                // Update local storage with fetched medications
                // Example: self.medications = medications
                print("Successfully restored medications from iCloud.")
            case .failure(let error):
                print("Failed to restore medications: \(error.localizedDescription)")
                restoreError = error
            }
            group.leave()
        }

        group.enter()
        fetchAllAppointments { result in
            switch result {
            case .success(_):
                // Update local storage with fetched appointments
                // Example: self.appointments = appointments
                print("Successfully restored appointments from iCloud.")
            case .failure(let error):
                print("Failed to restore appointments: \(error.localizedDescription)")
                restoreError = error
            }
            group.leave()
        }

        group.enter()
        fetchAllEmergencyContacts { result in
            switch result {
            case .success(_):
                // Update local storage with fetched contacts
                // Example: self.emergencyContacts = contacts
                print("Successfully restored emergency contacts from iCloud.")
            case .failure(let error):
                print("Failed to restore emergency contacts: \(error.localizedDescription)")
                restoreError = error
            }
            group.leave()
        }

        group.notify(queue: .main) {
            if let error = restoreError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Health Data
    struct BloodPressureCK: Identifiable {
        let id: UUID
        var systolic: Int
        var diastolic: Int
        var date: Date
    }
    struct BloodSugarCK: Identifiable {
        let id: UUID
        var glucose: Double
        var date: Date
    }
    struct HeartRateCK: Identifiable {
        let id: UUID
        var bpm: Int
        var date: Date
    }
    struct WeightCK: Identifiable {
        let id: UUID
        var weight: Double
        var date: Date
    }

    // MARK: - Save Health Data
    func saveBloodPressure(_ entry: BloodPressureCK, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "BloodPressure", recordID: CKRecord.ID(recordName: entry.id.uuidString))
        record["systolic"] = entry.systolic as CKRecordValue
        record["diastolic"] = entry.diastolic as CKRecordValue
        record["date"] = entry.date as CKRecordValue
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }
    func saveBloodSugar(_ entry: BloodSugarCK, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "BloodSugar", recordID: CKRecord.ID(recordName: entry.id.uuidString))
        record["glucose"] = entry.glucose as CKRecordValue
        record["date"] = entry.date as CKRecordValue
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }
    func saveHeartRate(_ entry: HeartRateCK, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "HeartRate", recordID: CKRecord.ID(recordName: entry.id.uuidString))
        record["bpm"] = entry.bpm as CKRecordValue
        record["date"] = entry.date as CKRecordValue
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }
    func saveWeight(_ entry: WeightCK, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Weight", recordID: CKRecord.ID(recordName: entry.id.uuidString))
        record["weight"] = entry.weight as CKRecordValue
        record["date"] = entry.date as CKRecordValue
        privateDB.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    completion(.success(savedRecord))
                }
            }
        }
    }

    // MARK: - Fetch All Health Data
    func fetchAllBloodPressure(completion: @escaping (Result<[BloodPressureCK], Error>) -> Void) {
        let query = CKQuery(recordType: "BloodPressure", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var entries: [BloodPressureCK] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let entry = BloodPressureCK(
                                id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
                                systolic: record["systolic"] as? Int ?? 0,
                                diastolic: record["diastolic"] as? Int ?? 0,
                                date: record["date"] as? Date ?? Date()
                            )
                            entries.append(entry)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    completion(.success(entries))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    func fetchAllBloodSugar(completion: @escaping (Result<[BloodSugarCK], Error>) -> Void) {
        let query = CKQuery(recordType: "BloodSugar", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var entries: [BloodSugarCK] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let entry = BloodSugarCK(
                                id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
                                glucose: record["glucose"] as? Double ?? 0.0,
                                date: record["date"] as? Date ?? Date()
                            )
                            entries.append(entry)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    completion(.success(entries))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    func fetchAllHeartRate(completion: @escaping (Result<[HeartRateCK], Error>) -> Void) {
        let query = CKQuery(recordType: "HeartRate", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var entries: [HeartRateCK] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let entry = HeartRateCK(
                                id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
                                bpm: record["bpm"] as? Int ?? 0,
                                date: record["date"] as? Date ?? Date()
                            )
                            entries.append(entry)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    completion(.success(entries))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    func fetchAllWeight(completion: @escaping (Result<[WeightCK], Error>) -> Void) {
        let query = CKQuery(recordType: "Weight", predicate: NSPredicate(value: true))
        privateDB.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 50) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (matchResults, _)):
                    var entries: [WeightCK] = []
                    matchResults.forEach { recordID, result in
                        switch result {
                        case .success(let record):
                            let entry = WeightCK(
                                id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
                                weight: record["weight"] as? Double ?? 0.0,
                                date: record["date"] as? Date ?? Date()
                            )
                            entries.append(entry)
                        case .failure(let error):
                            print("Error fetching record \(recordID): \(error)")
                        }
                    }
                    completion(.success(entries))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Backup/Restore All Data
    func backupAllData(
        profile: AppUserProfile?,
        medications: [MedicationCK],
        appointments: [AppointmentCK],
        contacts: [EmergencyContactCK],
        bloodPressure: [BloodPressureCK],
        bloodSugar: [BloodSugarCK],
        heartRate: [HeartRateCK],
        weight: [WeightCK],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let group = DispatchGroup()
        var backupError: Error?
        if let profile = profile {
            group.enter()
            saveUserProfile(profile) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        for med in medications {
            group.enter()
            saveMedication(med) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        for appt in appointments {
            group.enter()
            saveAppointment(appt) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        for contact in contacts {
            group.enter()
            saveEmergencyContact(contact) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        for entry in bloodPressure {
            group.enter()
            saveBloodPressure(entry) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        for entry in bloodSugar {
            group.enter()
            saveBloodSugar(entry) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        for entry in heartRate {
            group.enter()
            saveHeartRate(entry) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        for entry in weight {
            group.enter()
            saveWeight(entry) { result in
                if case .failure(let error) = result { backupError = error }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            if let error = backupError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func restoreAllHealthData(completion: @escaping (Result<(bloodPressure: [BloodPressureCK], bloodSugar: [BloodSugarCK], heartRate: [HeartRateCK], weight: [WeightCK]), Error>) -> Void) {
        let group = DispatchGroup()
        var bp: [BloodPressureCK] = []
        var bs: [BloodSugarCK] = []
        var hr: [HeartRateCK] = []
        var wt: [WeightCK] = []
        var restoreError: Error?
        group.enter()
        fetchAllBloodPressure { result in
            if case .success(let arr) = result { bp = arr } else if case .failure(let error) = result { restoreError = error }
            group.leave()
        }
        group.enter()
        fetchAllBloodSugar { result in
            if case .success(let arr) = result { bs = arr } else if case .failure(let error) = result { restoreError = error }
            group.leave()
        }
        group.enter()
        fetchAllHeartRate { result in
            if case .success(let arr) = result { hr = arr } else if case .failure(let error) = result { restoreError = error }
            group.leave()
        }
        group.enter()
        fetchAllWeight { result in
            if case .success(let arr) = result { wt = arr } else if case .failure(let error) = result { restoreError = error }
            group.leave()
        }
        group.notify(queue: .main) {
            if let error = restoreError {
                completion(.failure(error))
            } else {
                completion(.success((bp, bs, hr, wt)))
            }
        }
    }
} 