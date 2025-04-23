import SwiftUI

struct UserProfileSetupView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -65, to: Date()) ?? Date()
    @State private var gender: String = "Other"
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var medicalConditions: [String] = []
    @State private var dietaryRestrictions: [String] = []
    @State private var emergencyContactName: String = ""
    @State private var emergencyContactRelationship: Relationship = .other
    @State private var emergencyContactPhone: String = ""
    
    private let genderOptions = ["Male", "Female", "Other"]
    private let medicalConditionOptions = [
        "High Blood Pressure",
        "Diabetes",
        "Heart Disease",
        "Arthritis",
        "Osteoporosis",
        "Asthma",
        "COPD",
        "Cancer",
        "Stroke",
        "Alzheimer's",
        "Parkinson's",
        "Other"
    ]
    
    private let dietaryRestrictionOptions = [
        "Vegetarian",
        "Vegan",
        "Gluten-Free",
        "Dairy-Free",
        "Nut-Free",
        "Low Sodium",
        "Low Sugar",
        "Low Fat",
        "Kosher",
        "Halal",
        "Pescatarian",
        "Keto",
        "Paleo",
        "Other"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                }
                
                Section(header: Text("Physical Information")) {
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Medical Conditions")) {
                    ForEach(medicalConditionOptions, id: \.self) { condition in
                        Toggle(condition, isOn: Binding(
                            get: { medicalConditions.contains(condition) },
                            set: { isOn in
                                if isOn {
                                    medicalConditions.append(condition)
                                } else {
                                    medicalConditions.removeAll { $0 == condition }
                                }
                            }
                        ))
                    }
                }
                
                Section(header: Text("Dietary Restrictions")) {
                    ForEach(dietaryRestrictionOptions, id: \.self) { restriction in
                        Toggle(restriction, isOn: Binding(
                            get: { dietaryRestrictions.contains(restriction) },
                            set: { isOn in
                                if isOn {
                                    dietaryRestrictions.append(restriction)
                                } else {
                                    dietaryRestrictions.removeAll { $0 == restriction }
                                }
                            }
                        ))
                    }
                }
                
                Section(header: Text("Emergency Contact")) {
                    TextField("Name", text: $emergencyContactName)
                    Picker("Relationship", selection: $emergencyContactRelationship) {
                        ForEach(Relationship.allCases, id: \.self) { relationship in
                            Text(relationship.rawValue).tag(relationship)
                        }
                    }
                    TextField("Phone Number", text: $emergencyContactPhone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Profile Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || height.isEmpty || weight.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveProfile() {
        let profile = UserProfile(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            height: Double(height) ?? 0,
            weight: Double(weight) ?? 0,
            medicalConditions: medicalConditions,
            dietaryRestrictions: dietaryRestrictions,
            emergencyContacts: [
                EmergencyContact(
                    name: emergencyContactName,
                    relationship: emergencyContactRelationship,
                    phoneNumber: emergencyContactPhone
                )
            ]
        )
        
        userSettings.userProfile = profile
        userSettings.isOnboardingComplete = true
        dismiss()
    }
}

struct UserProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileSetupView()
            .environmentObject(UserSettings())
    }
} 