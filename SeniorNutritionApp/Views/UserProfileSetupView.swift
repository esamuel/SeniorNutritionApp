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
    
    // Emergency contact states
    @State private var emergencyContacts: [EmergencyContact] = []
    @State private var emergencyContactName: String = ""
    @State private var emergencyContactRelationship: Relationship = .other
    @State private var emergencyContactPhone: String = ""
    @State private var showingAddContactAlert = false
    
    // Color theme for a happier UI
    private let sectionColors: [Color] = [.blue.opacity(0.1), .green.opacity(0.1), .orange.opacity(0.1), .purple.opacity(0.1), .pink.opacity(0.1)]
    
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
                Section(header: Text("Personal Information")
                        .font(.headline)
                        .foregroundColor(.blue)) {
                    TextField("First Name", text: $firstName)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("Last Name", text: $lastName)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .datePickerLTR()
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    // Display calculated age from date of birth
                    let tempProfile = UserProfile(
                        firstName: firstName,
                        lastName: lastName,
                        dateOfBirth: dateOfBirth,
                        gender: gender,
                        height: Double(height) ?? 0,
                        weight: Double(weight) ?? 0,
                        medicalConditions: medicalConditions,
                        dietaryRestrictions: dietaryRestrictions,
                        emergencyContacts: emergencyContacts
                    )
                    let ageText = tempProfile.age > 0 ? "\(tempProfile.age) years, \(tempProfile.ageMonths) months" : "\(tempProfile.ageMonths) months"
                    Text("Age: \(ageText)")
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("Physical Information")
                        .font(.headline)
                        .foregroundColor(.green)) {
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("Medical Conditions")
                        .font(.headline)
                        .foregroundColor(.orange)) {
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
                        .padding(8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("Dietary Restrictions")
                        .font(.headline)
                        .foregroundColor(.purple)) {
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
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .listRowBackground(Color.clear)
                
                // Enhanced Emergency Contacts Section with list of current contacts
                Section(header: Text("Emergency Contacts")
                        .font(.headline)
                        .foregroundColor(.pink)) {
                    
                    // Show existing emergency contacts
                    ForEach(emergencyContacts) { contact in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundColor(.pink)
                                Text(contact.name)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button(action: {
                                    // Remove this contact
                                    emergencyContacts.removeAll { $0.id == contact.id }
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 20))
                                }
                            }
                            
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                Text(contact.phoneNumber)
                            }
                            
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.blue)
                                Text(contact.relationship.rawValue)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(8)
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Add new contact form
                    TextField("Contact Name", text: $emergencyContactName)
                        .padding(8)
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(8)
                    
                    Picker("Relationship", selection: $emergencyContactRelationship) {
                        ForEach(Relationship.allCases, id: \.self) { relationship in
                            Text(relationship.rawValue).tag(relationship)
                        }
                    }
                    .padding(8)
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(8)
                    
                    TextField("Phone Number", text: $emergencyContactPhone)
                        .keyboardType(.phonePad)
                        .padding(8)
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(8)
                    
                    Button(action: {
                        addEmergencyContact()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Contact")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(
                            (!emergencyContactName.isEmpty && !emergencyContactPhone.isEmpty) ? 
                                Color.pink : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(8)
                    }
                    .disabled(emergencyContactName.isEmpty || emergencyContactPhone.isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle(NSLocalizedString("Profile Setup", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Save", comment: "")) {
                        saveProfile()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || height.isEmpty || weight.isEmpty)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .onAppear {
                loadExistingProfile()
            }
        }
    }
    
    // Function to add a new emergency contact
    private func addEmergencyContact() {
        let newContact = EmergencyContact(
            name: emergencyContactName,
            relationship: emergencyContactRelationship,
            phoneNumber: emergencyContactPhone
        )
        
        emergencyContacts.append(newContact)
        
        // Clear form for next entry
        emergencyContactName = ""
        emergencyContactRelationship = .other
        emergencyContactPhone = ""
    }
    
    // Load existing profile data when editing
    private func loadExistingProfile() {
        if let profile = userSettings.userProfile {
            // Populate fields with existing data
            firstName = profile.firstName
            lastName = profile.lastName
            dateOfBirth = profile.dateOfBirth
            gender = profile.gender
            height = String(Int(profile.height))
            weight = String(Int(profile.weight))
            medicalConditions = profile.medicalConditions
            dietaryRestrictions = profile.dietaryRestrictions
            emergencyContacts = profile.emergencyContacts
            
            print("DEBUG: Loaded existing profile - \(profile.firstName) \(profile.lastName) with \(profile.emergencyContacts.count) contacts")
        } else {
            print("DEBUG: No existing profile found, using default values")
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
            emergencyContacts: emergencyContacts
        )
        
        print("DEBUG: Saving profile with \(emergencyContacts.count) emergency contacts")
        
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