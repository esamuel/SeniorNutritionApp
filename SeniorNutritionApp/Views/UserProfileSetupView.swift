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
    @State private var heightUnit: String = "cm"
    @State private var weightUnit: String = "kg"
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
    // Empty arrays for medical conditions and dietary restrictions
    // Users can add their own real information
    @State private var newMedicalCondition: String = ""
    @State private var newDietaryRestriction: String = ""
    
    // Comprehensive list of medical conditions (English keys for storage)
    private let medicalConditionOptions = ProfileTranslationUtils.medicalConditionsEnglish
    
    // Comprehensive list of dietary restrictions (English keys for storage)
    private let dietaryRestrictionOptions = ProfileTranslationUtils.dietaryRestrictionsEnglish
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Personal Information", comment: ""))
                        .font(.headline)
                        .foregroundColor(.blue)) {
                    TextField(NSLocalizedString("First Name", comment: ""), text: $firstName)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField(NSLocalizedString("Last Name", comment: ""), text: $lastName)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    DatePicker(NSLocalizedString("Date of Birth", comment: ""), selection: $dateOfBirth, displayedComponents: .date)
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
                
                Section(header: Text(NSLocalizedString("Physical Information", comment: ""))
                        .font(.headline)
                        .foregroundColor(.green)) {
                    
                    // Height input with unit selection
                    HStack {
                        TextField(NSLocalizedString("Height", comment: ""), text: $height)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    
                        Picker("Height Unit", selection: $heightUnit) {
                            Text("cm").tag("cm")
                            Text("ft").tag("ft")
                            Text("in").tag("in")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120)
                    }
                    
                    // Weight input with unit selection
                    HStack {
                        TextField(NSLocalizedString("Weight", comment: ""), text: $weight)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        
                        Picker("Weight Unit", selection: $weightUnit) {
                            Text("kg").tag("kg")
                            Text("lb").tag("lb")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 80)
                    }
                    
                    // Show converted values for reference
                    if !height.isEmpty || !weight.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            if !height.isEmpty, let heightValue = Double(height) {
                                let heightCm = UnitConverter.convert(heightValue, from: heightUnit, to: "cm")
                                let heightFt = UnitConverter.fromBaseUnit(heightCm, to: "ft")
                                let heightIn = UnitConverter.fromBaseUnit(heightCm, to: "in")
                                Text("Height: \(String(format: "%.1f", heightCm)) cm (\(Int(heightFt))' \(Int(heightIn.truncatingRemainder(dividingBy: 12)))\")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            if !weight.isEmpty, let weightValue = Double(weight) {
                                let weightKg = UnitConverter.convert(weightValue, from: weightUnit, to: "kg")
                                let weightLb = UnitConverter.fromBaseUnit(weightKg * 1000, to: "lb")
                                Text("Weight: \(String(format: "%.1f", weightKg)) kg (\(Int(weightLb)) lb)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Show BMI calculation if both values are available
                            if !height.isEmpty && !weight.isEmpty,
                               let heightValue = Double(height),
                               let weightValue = Double(weight) {
                                let heightCm = UnitConverter.convert(heightValue, from: heightUnit, to: "cm")
                                let weightKg = UnitConverter.convert(weightValue, from: weightUnit, to: "kg")
                                
                                if heightCm > 0 && weightKg > 0 {
                                    let heightMeters = heightCm / 100.0
                                    let bmi = weightKg / (heightMeters * heightMeters)
                                    let category = BMICategory.from(bmi: bmi)
                                    
                                    HStack {
                                        Text("BMI: \(String(format: "%.1f", bmi))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("(\(category.localizedTitle))")
                                            .font(.caption)
                                            .foregroundColor(category.color)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(category.color.opacity(0.2))
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(Color.green.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text(NSLocalizedString("Medical Conditions", comment: ""))
                        .font(.headline)
                        .foregroundColor(.orange)) {
                    
                    // Display existing medical conditions with delete option
                    ForEach(medicalConditions, id: \.self) { condition in
                        HStack {
                            Text(ProfileTranslationUtils.translateMedicalCondition(condition))
                            Spacer()
                            Button(action: {
                                medicalConditions.removeAll { $0 == condition }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Add new medical condition
                    HStack {
                        TextField(NSLocalizedString("Add medical condition", comment: ""), text: $newMedicalCondition)
                        Button(action: {
                            if !newMedicalCondition.isEmpty && !medicalConditions.contains(newMedicalCondition) {
                                medicalConditions.append(newMedicalCondition)
                                newMedicalCondition = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .disabled(newMedicalCondition.isEmpty)
                    }
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Common medical conditions list
                    Text(NSLocalizedString("Select from common conditions:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    
                    ForEach(medicalConditionOptions, id: \.self) { condition in
                        Button(action: {
                            if medicalConditions.contains(condition) {
                                medicalConditions.removeAll { $0 == condition }
                            } else {
                                medicalConditions.append(condition)
                            }
                        }) {
                            HStack {
                                Text(ProfileTranslationUtils.translateMedicalCondition(condition))
                                    .foregroundColor(.primary)
                                Spacer()
                                if medicalConditions.contains(condition) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(8)
                        .background(medicalConditions.contains(condition) ? Color.orange.opacity(0.15) : Color.orange.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text(NSLocalizedString("Dietary Restrictions", comment: ""))
                        .font(.headline)
                        .foregroundColor(.purple)) {
                    
                    // Display existing dietary restrictions with delete option
                    ForEach(dietaryRestrictions, id: \.self) { restriction in
                        HStack {
                            Text(ProfileTranslationUtils.translateDietaryRestriction(restriction))
                            Spacer()
                            Button(action: {
                                dietaryRestrictions.removeAll { $0 == restriction }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Add new dietary restriction
                    HStack {
                        TextField(NSLocalizedString("Add dietary restriction", comment: ""), text: $newDietaryRestriction)
                        Button(action: {
                            if !newDietaryRestriction.isEmpty && !dietaryRestrictions.contains(newDietaryRestriction) {
                                dietaryRestrictions.append(newDietaryRestriction)
                                newDietaryRestriction = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .disabled(newDietaryRestriction.isEmpty)
                    }
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Common dietary restrictions list
                    Text(NSLocalizedString("Select from common restrictions:", comment: ""))
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    
                    ForEach(dietaryRestrictionOptions, id: \.self) { restriction in
                        Button(action: {
                            if dietaryRestrictions.contains(restriction) {
                                dietaryRestrictions.removeAll { $0 == restriction }
                            } else {
                                dietaryRestrictions.append(restriction)
                            }
                        }) {
                            HStack {
                                Text(ProfileTranslationUtils.translateDietaryRestriction(restriction))
                                    .foregroundColor(.primary)
                                Spacer()
                                if dietaryRestrictions.contains(restriction) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(8)
                        .background(dietaryRestrictions.contains(restriction) ? Color.purple.opacity(0.15) : Color.purple.opacity(0.05))
                        .cornerRadius(8)
                    }

                }
                .listRowBackground(Color.clear)
                
                // Enhanced Emergency Contacts Section with list of current contacts
                Section(header: Text(NSLocalizedString("Emergency Contacts", comment: ""))
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
            
            // Load height and weight with default units (cm and kg)
            height = String(format: "%.1f", profile.height)
            weight = String(format: "%.1f", profile.weight)
            heightUnit = "cm"
            weightUnit = "kg"
            
            medicalConditions = profile.medicalConditions
            dietaryRestrictions = profile.dietaryRestrictions
            emergencyContacts = profile.emergencyContacts
            
            print("DEBUG: Loaded existing profile - \(profile.firstName) \(profile.lastName) with \(profile.emergencyContacts.count) contacts")
        } else {
            print("DEBUG: No existing profile found, using default values")
        }
    }
    
    private func saveProfile() {
        // Convert height and weight to metric units for storage
        let heightCm = UnitConverter.convert(Double(height) ?? 0, from: heightUnit, to: "cm")
        let weightKg = UnitConverter.convert(Double(weight) ?? 0, from: weightUnit, to: "kg")
        
        let profile = UserProfile(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            height: heightCm,
            weight: weightKg,
            medicalConditions: medicalConditions,
            dietaryRestrictions: dietaryRestrictions,
            emergencyContacts: emergencyContacts
        )
        
        print("DEBUG: Saving profile with \(emergencyContacts.count) emergency contacts")
        
        userSettings.userProfile = profile
        userSettings.isOnboardingComplete = true
        // Also mark app tour as completed to avoid showing multiple onboarding screens
        userSettings.markAppTourCompleted()
        dismiss()
    }
}

struct UserProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileSetupView()
            .environmentObject(UserSettings())
    }
} 