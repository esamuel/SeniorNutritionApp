import SwiftUI

// Import CloudKitManager to access MedicationCK, AppointmentCK, EmergencyContactCK
enum CloudKitManagerTypes {
    typealias MedicationCK = CloudKitManager.MedicationCK
    typealias AppointmentCK = CloudKitManager.AppointmentCK
    typealias EmergencyContactCK = CloudKitManager.EmergencyContactCK
}

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var userProfiles: [UserProfile] = []
    @State private var medications: [CloudKitManager.MedicationCK] = []
    @State private var appointments: [CloudKitManager.AppointmentCK] = []
    @State private var emergencyContacts: [CloudKitManager.EmergencyContactCK] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
            Button("Restore Data") {
                restoreDataAndUpdateApp()
            }
            // Display restored user profiles
            List(userProfiles.indices, id: \ .self) { idx in
                let profile = userProfiles[idx]
                Text("\(profile.fullName)")
            }
            // Display medications
            List(medications, id: \ .id) { med in
                Text("Medication: \(med.name), Dosage: \(med.dosage)")
            }
            // Display appointments
            List(appointments, id: \ .id) { appt in
                Text("Appointment: \(appt.title) at \(appt.location)")
            }
            // Display emergency contacts
            List(emergencyContacts, id: \ .id) { contact in
                Text("Contact: \(contact.name), Phone: \(contact.phoneNumber)")
            }
        }
        .onAppear {
            restoreDataAndUpdateApp()
        }
    }

    private func restoreDataAndUpdateApp() {
        // Restore user profile
        CloudKitManager.shared.fetchAllUserProfiles { result in
            switch result {
            case .success(let appProfiles):
                // Convert AppUserProfile to UserProfile
                let profiles = appProfiles.map { appProfile in
                    convertToUserProfile(appProfile)
                }
                userProfiles = profiles
                if let profile = profiles.first {
                    DispatchQueue.main.async {
                        userSettings.updateProfile(profile)
                        userSettings.userProfile = profile
                        userSettings.userName = profile.firstName
                        userSettings.userAge = profile.age
                        userSettings.userGender = profile.gender
                        userSettings.userHeight = profile.height
                        userSettings.userWeight = profile.weight
                        userSettings.userDietaryRestrictions = profile.dietaryRestrictions
                        userSettings.userEmergencyContacts = profile.emergencyContacts
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
        // Restore medications
        CloudKitManager.shared.fetchAllMedications { result in
            switch result {
            case .success(let meds):
                medications = meds
                // Map MedicationCK to Medication and update UserSettings
                let mappedMeds = meds.map { med in
                    Medication(
                        name: med.name,
                        dosage: med.dosage,
                        frequency: .daily, // You may want to map schedule string to your ScheduleDetails type
                        timesOfDay: [], // Not available in CK, set empty or parse if you add it
                        takeWithFood: false, // Not available in CK, set default
                        notes: nil,
                        color: .blue,
                        shape: .capsule
                    )
                }
                DispatchQueue.main.async {
                    userSettings.medications = mappedMeds
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
        // Restore appointments (not mapped to UserSettings in your code, just update local state)
        CloudKitManager.shared.fetchAllAppointments { result in
            switch result {
            case .success(let appts):
                appointments = appts
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
        // Restore emergency contacts
        CloudKitManager.shared.fetchAllEmergencyContacts { result in
            switch result {
            case .success(let contacts):
                emergencyContacts = contacts
                // Map EmergencyContactCK to EmergencyContact and update UserSettings
                let mappedContacts = contacts.map { contact in
                    EmergencyContact(
                        id: contact.id,
                        name: contact.name,
                        relationship: Relationship(rawValue: contact.relationship) ?? .other,
                        phoneNumber: contact.phoneNumber
                    )
                }
                DispatchQueue.main.async {
                    userSettings.userEmergencyContacts = mappedContacts
                    // Also update in userProfile if it exists
                    if var profile = userSettings.userProfile {
                        profile.emergencyContacts = mappedContacts
                        userSettings.updateProfile(profile)
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Converts an AppUserProfile to a UserProfile
    private func convertToUserProfile(_ appProfile: AppUserProfile) -> UserProfile {
        return UserProfile(
            firstName: appProfile.firstName,
            lastName: appProfile.lastName,
            dateOfBirth: appProfile.dateOfBirth,
            gender: appProfile.gender,
            height: appProfile.height,
            weight: appProfile.weight,
            medicalConditions: appProfile.medicalConditions,
            dietaryRestrictions: appProfile.dietaryRestrictions,
            emergencyContacts: [] // Fill with proper emergency contacts if needed
        )
    }
} 