import SwiftUI

struct UserProfileSetupView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String
    @State private var lastName: String
    @State private var dateOfBirth: Date
    @State private var gender: String
    @State private var height: String
    @State private var weight: String
    @State private var medicalConditions: [String]
    @State private var dietaryRestrictions: [String]
    @State private var emergencyContactName: String
    @State private var emergencyContactRelationship: Relationship
    @State private var emergencyContactPhone: String
    
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
    
    init() {
        let profile = UserSettings().userProfile
        
        _firstName = State(initialValue: profile?.firstName ?? "")
        _lastName = State(initialValue: profile?.lastName ?? "")
        _dateOfBirth = State(initialValue: profile?.dateOfBirth ?? Calendar.current.date(byAdding: .year, value: -65, to: Date()) ?? Date())
        _gender = State(initialValue: profile?.gender ?? "Other")
        _height = State(initialValue: profile?.height.map { String(Int($0)) } ?? "")
        _weight = State(initialValue: profile?.weight.map { String(Int($0)) } ?? "")
        _medicalConditions = State(initialValue: profile?.medicalConditions ?? [])
        _dietaryRestrictions = State(initialValue: profile?.dietaryRestrictions ?? [])
        _emergencyContactName = State(initialValue: profile?.emergencyContact?.name ?? "")
        _emergencyContactRelationship = State(initialValue: profile?.emergencyContact?.relationship ?? .other)
        _emergencyContactPhone = State(initialValue: profile?.emergencyContact?.phoneNumber ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information").font(.system(size: userSettings.textSize.size))) {
                    TextField("First Name", text: $firstName)
                        .font(.system(size: userSettings.textSize.size))
                    TextField("Last Name", text: $lastName)
                        .font(.system(size: userSettings.textSize.size))
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                        .font(.system(size: userSettings.textSize.size))
                    Picker("Gender", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).font(.system(size: userSettings.textSize.size))
                        }
                    }
                }
                
                Section(header: Text("Health Information").font(.system(size: userSettings.textSize.size))) {
                    HStack {
                        TextField("Height (cm)", text: $height)
                            .font(.system(size: userSettings.textSize.size))
                            .keyboardType(.decimalPad)
                        Text("cm")
                            .font(.system(size: userSettings.textSize.size))
                    }
                    HStack {
                        TextField("Weight (kg)", text: $weight)
                            .font(.system(size: userSettings.textSize.size))
                            .keyboardType(.decimalPad)
                        Text("kg")
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
                
                Section(header: Text("Medical Conditions").font(.system(size: userSettings.textSize.size))) {
                    ForEach(medicalConditions, id: \.self) { condition in
                        Text(condition)
                            .font(.system(size: userSettings.textSize.size))
                    }
                    .onDelete(perform: deleteMedicalCondition)
                    
                    Picker("Add Condition", selection: $newMedicalCondition) {
                        Text("Select a condition").tag("")
                        ForEach(medicalConditionOptions, id: \.self) { condition in
                            Text(condition).tag(condition)
                        }
                    }
                    .onChange(of: newMedicalCondition) { newValue in
                        if !newValue.isEmpty {
                            addMedicalCondition()
                        }
                    }
                }
                
                Section(header: Text("Dietary Restrictions").font(.system(size: userSettings.textSize.size))) {
                    ForEach(dietaryRestrictions, id: \.self) { restriction in
                        Text(restriction)
                            .font(.system(size: userSettings.textSize.size))
                    }
                    .onDelete(perform: deleteDietaryRestriction)
                    
                    Picker("Add Restriction", selection: $newDietaryRestriction) {
                        Text("Select a restriction").tag("")
                        ForEach(dietaryRestrictionOptions, id: \.self) { restriction in
                            Text(restriction).tag(restriction)
                        }
                    }
                    .onChange(of: newDietaryRestriction) { newValue in
                        if !newValue.isEmpty {
                            addDietaryRestriction()
                        }
                    }
                }
                
                Section(header: Text("Emergency Contact").font(.system(size: userSettings.textSize.size))) {
                    TextField("Name", text: $emergencyContactName)
                        .font(.system(size: userSettings.textSize.size))
                    Picker("Relationship", selection: $emergencyContactRelationship) {
                        ForEach(Relationship.allCases, id: \.self) { relationship in
                            Text(relationship.rawValue).tag(relationship)
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                    TextField("Phone Number", text: $emergencyContactPhone)
                        .font(.system(size: userSettings.textSize.size))
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle(userSettings.userProfile == nil ? "New Profile" : "Edit Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    @State private var newMedicalCondition: String = ""
    @State private var newDietaryRestriction: String = ""
    
    private func addMedicalCondition() {
        let condition = newMedicalCondition.trimmingCharacters(in: .whitespacesAndNewlines)
        if !condition.isEmpty && !medicalConditions.contains(condition) {
            medicalConditions.append(condition)
            newMedicalCondition = ""
        }
    }
    
    private func deleteMedicalCondition(at offsets: IndexSet) {
        medicalConditions.remove(atOffsets: offsets)
    }
    
    private func addDietaryRestriction() {
        let restriction = newDietaryRestriction.trimmingCharacters(in: .whitespacesAndNewlines)
        if !restriction.isEmpty && !dietaryRestrictions.contains(restriction) {
            dietaryRestrictions.append(restriction)
            newDietaryRestriction = ""
        }
    }
    
    private func deleteDietaryRestriction(at offsets: IndexSet) {
        dietaryRestrictions.remove(atOffsets: offsets)
    }
    
    private func saveProfile() {
        let emergencyContact = EmergencyContact(
            name: emergencyContactName,
            relationship: emergencyContactRelationship,
            phoneNumber: emergencyContactPhone
        )
        
        let profile = UserProfile(
            id: userSettings.userProfile?.id ?? UUID(),
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            height: Double(height),
            weight: Double(weight),
            medicalConditions: medicalConditions,
            dietaryRestrictions: dietaryRestrictions,
            emergencyContact: emergencyContact
        )
        
        userSettings.updateProfile(profile)
        dismiss()
    }
}

struct UserProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileSetupView()
            .environmentObject(UserSettings())
    }
} 