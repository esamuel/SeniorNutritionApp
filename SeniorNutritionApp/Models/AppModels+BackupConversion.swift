import Foundation

extension AppUserProfile {
    func toBackupUserProfile() -> BackupUserProfile {
        return BackupUserProfile(
            firstName: self.firstName,
            lastName: self.lastName,
            dateOfBirth: self.dateOfBirth,
            gender: self.gender,
            height: self.height,
            weight: self.weight,
            medicalConditions: self.medicalConditions,
            dietaryRestrictions: self.dietaryRestrictions,
            emergencyContacts: self.emergencyContacts
        )
    }
} 