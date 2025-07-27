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
    @State private var activityLevel: ActivityLevel = .lightlyActive
    @State private var preferredBMRFormula: BMRFormula = .mifflinStJeor
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
    
    // Computed properties to avoid complex expressions in body
    private var tempProfile: UserProfile {
        UserProfile(
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
    }
    
    private var ageText: String {
        let profile = tempProfile
        return profile.age > 0 ? "\(profile.age) years, \(profile.ageMonths) months" : "\(profile.ageMonths) months"
    }
    
    private var shouldShowCaloriePreview: Bool {
        !height.isEmpty && !weight.isEmpty
    }
    
    private var calorieCalculationResult: (heightCm: Double, weightKg: Double, age: Int, result: CalorieCalculationResult)? {
        guard let heightValue = Double(height),
              let weightValue = Double(weight) else { return nil }
        
        let heightCm = UnitConverter.convert(heightValue, from: heightUnit, to: "cm")
        let weightKg = UnitConverter.convert(weightValue, from: weightUnit, to: "kg")
        let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 65
        
        guard CalorieCalculationService.validateInputs(weight: weightKg, height: heightCm, age: age) else { return nil }
        
        let result = CalorieCalculationService.calculateCalorieNeeds(
            weight: weightKg,
            height: heightCm,
            age: age,
            gender: gender,
            activityLevel: activityLevel,
            formula: preferredBMRFormula
        )
        
        return (heightCm, weightKg, age, result)
    }
    
    private var heightConversions: (cm: Double, ft: Double, inches: Double)? {
        guard let heightValue = Double(height) else { return nil }
        let heightCm = UnitConverter.convert(heightValue, from: heightUnit, to: "cm")
        let heightFt = UnitConverter.fromBaseUnit(heightCm, to: "ft")
        let heightIn = UnitConverter.fromBaseUnit(heightCm, to: "in")
        return (heightCm, heightFt, heightIn)
    }
    
    private var weightConversions: (kg: Double, lb: Double)? {
        guard let weightValue = Double(weight) else { return nil }
        let weightKg = UnitConverter.convert(weightValue, from: weightUnit, to: "kg")
        let weightLb = UnitConverter.fromBaseUnit(weightKg * 1000, to: "lb")
        return (weightKg, weightLb)
    }
    
    private var bmiCalculation: (bmi: Double, category: BMICategory)? {
        guard let heightValue = Double(height),
              let weightValue = Double(weight) else { return nil }
        
        let heightCm = UnitConverter.convert(heightValue, from: heightUnit, to: "cm")
        let weightKg = UnitConverter.convert(weightValue, from: weightUnit, to: "kg")
        
        guard heightCm > 0 && weightKg > 0 else { return nil }
        
        let heightMeters = heightCm / 100.0
        let bmi = weightKg / (heightMeters * heightMeters)
        let category = BMICategory.from(bmi: bmi)
        
        return (bmi, category)
    }
    
    var body: some View {
        NavigationView {
            Form {
                personalInfoSection
                physicalInfoSection
                activityLevelSection
                medicalConditionsSection
                dietaryRestrictionsSection
                emergencyContactsSection
                saveProfileSection
            }
            .navigationTitle(NSLocalizedString("Profile Setup", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
    
    // MARK: - View Sections
    
    private var personalInfoSection: some View {
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
    }
    
    private var physicalInfoSection: some View {
        Section(header: Text(NSLocalizedString("Physical Information", comment: ""))
                .font(.headline)
                .foregroundColor(.green)) {
            
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
            
            if !height.isEmpty || !weight.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    if !height.isEmpty, let heightConv = heightConversions {
                        Text("Height: \(String(format: "%.1f", heightConv.cm)) cm (\(Int(heightConv.ft))' \(Int(heightConv.inches.truncatingRemainder(dividingBy: 12)))\")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if !weight.isEmpty, let weightConv = weightConversions {
                        Text("Weight: \(String(format: "%.1f", weightConv.kg)) kg (\(Int(weightConv.lb)) lb)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if !height.isEmpty && !weight.isEmpty,
                       let bmiCalc = bmiCalculation {
                        HStack {
                            Text("BMI: \(String(format: "%.1f", bmiCalc.bmi))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("(\(bmiCalc.category.localizedTitle))")
                                .font(.caption)
                                .foregroundColor(bmiCalc.category.color)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(bmiCalc.category.color.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
                .padding(8)
                .background(Color.green.opacity(0.05))
                .cornerRadius(8)
            }
        }
        .listRowBackground(Color.clear)
    }
    
    private var activityLevelSection: some View {
        Section(header: Text(NSLocalizedString("Activity Level", comment: ""))
                .font(.headline)
                .foregroundColor(.blue)) {
            
            VStack(alignment: .leading, spacing: 12) {
                Text(NSLocalizedString("Select your typical activity level to calculate accurate calorie needs:", comment: ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ActivityLevelSelectorView(selectedLevel: $activityLevel)
                
                BMRFormulaSelectorView(selectedFormula: $preferredBMRFormula)
                
                if shouldShowCaloriePreview,
                   let calculation = calorieCalculationResult {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NSLocalizedString("Estimated Daily Calorie Needs:", comment: ""))
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        HStack {
                            Text("BMR:")
                                .font(.caption)
                            Spacer()
                            Text("\(Int(calculation.result.bmr.rounded())) cal/day")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        
                        HStack {
                            Text("TDEE:")
                                .font(.caption)
                            Spacer()
                            Text("\(Int(calculation.result.tdee.rounded())) cal/day")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .listRowBackground(Color.clear)
    }
    
    private var medicalConditionsSection: some View {
        Section(header: Text(NSLocalizedString("Medical Conditions", comment: ""))
                .font(.headline)
                .foregroundColor(.orange)) {
            
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
    }
    
    private var dietaryRestrictionsSection: some View {
        Section(header: Text(NSLocalizedString("Dietary Restrictions", comment: ""))
                .font(.headline)
                .foregroundColor(.purple)) {
            
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
    }
    
    private var emergencyContactsSection: some View {
        Section(header: Text(NSLocalizedString("Emergency Contacts", comment: ""))
                .font(.headline)
                .foregroundColor(.pink)) {
            
            ForEach(emergencyContacts) { contact in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.pink)
                        Text(contact.name)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
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
    
    private var saveProfileSection: some View {
        Section {
            VStack(spacing: 16) {
                Text(NSLocalizedString("Please review your information carefully. This data will be used to provide personalized nutrition recommendations and health tracking.", comment: ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    saveProfile()
                }) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                        Text(NSLocalizedString("Save Profile", comment: ""))
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        (firstName.isEmpty || lastName.isEmpty || height.isEmpty || weight.isEmpty) ? 
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .disabled(firstName.isEmpty || lastName.isEmpty || height.isEmpty || weight.isEmpty)
                
                Text(NSLocalizedString("Your profile data is stored securely on your device.", comment: ""))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.clear)
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
            
            // Load activity level and BMR formula
            activityLevel = profile.activityLevel
            preferredBMRFormula = profile.preferredBMRFormula
            
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
            emergencyContacts: emergencyContacts,
            activityLevel: activityLevel,
            preferredBMRFormula: preferredBMRFormula
        )
        
        print("DEBUG: Saving profile with \(emergencyContacts.count) emergency contacts")
        
        userSettings.userProfile = profile
        userSettings.isOnboardingComplete = true
        // Also mark app tour as completed to avoid showing multiple onboarding screens
        userSettings.markAppTourCompleted()
        dismiss()
    }
    
    // Helper function to get appropriate icons for activity levels
    private func getActivityIcon(for level: ActivityLevel) -> String {
        switch level {
        case .sedentary:
            return "figure.seated.side"
        case .lightlyActive:
            return "figure.walk"
        case .moderatelyActive:
            return "figure.run"
        case .veryActive:
            return "figure.strengthtraining.traditional"
        case .extraActive:
            return "figure.boxing"
        }
    }
}

// MARK: - Activity Level Selector Component
struct ActivityLevelSelectorView: View {
    @Binding var selectedLevel: ActivityLevel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(ActivityLevel.allCases) { level in
                activityLevelButton(for: level)
            }
        }
    }
    
    private func activityLevelButton(for level: ActivityLevel) -> some View {
        Button(action: {
            selectedLevel = level
        }) {
            HStack(spacing: 16) {
                activityIcon(for: level)
                activityTextContent(for: level)
                Spacer()
                selectionIndicator(for: level)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(activityBackground(for: level))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func activityIcon(for level: ActivityLevel) -> some View {
        ZStack {
            Circle()
                .fill(selectedLevel == level ? Color.blue : Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
            
            Image(systemName: getActivityIcon(for: level))
                .font(.title2)
                .foregroundColor(selectedLevel == level ? .white : .gray)
        }
    }
    
    private func activityTextContent(for level: ActivityLevel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(NSLocalizedString(level.rawValue, comment: ""))
                .font(.headline)
                .foregroundColor(selectedLevel == level ? .blue : .primary)
                .fontWeight(selectedLevel == level ? .semibold : .regular)
            
            Text(NSLocalizedString(level.description, comment: ""))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func selectionIndicator(for level: ActivityLevel) -> some View {
        Image(systemName: selectedLevel == level ? "checkmark.circle.fill" : "circle")
            .font(.title2)
            .foregroundColor(selectedLevel == level ? .blue : .gray.opacity(0.4))
    }
    
    private func activityBackground(for level: ActivityLevel) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(selectedLevel == level ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedLevel == level ? Color.blue : Color.gray.opacity(0.2), 
                           lineWidth: selectedLevel == level ? 2 : 1)
            )
    }
    
    private func getActivityIcon(for level: ActivityLevel) -> String {
        switch level {
        case .sedentary: return "figure.seated.side"
        case .lightlyActive: return "figure.walk"
        case .moderatelyActive: return "figure.run"
        case .veryActive: return "figure.strengthtraining.traditional"
        case .extraActive: return "figure.boxing"
        }
    }
}

// MARK: - BMR Formula Selector Component
struct BMRFormulaSelectorView: View {
    @Binding var selectedFormula: BMRFormula
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(NSLocalizedString("Calorie Calculation Method:", comment: ""))
                .font(.caption)
                .fontWeight(.medium)
            
            VStack(spacing: 8) {
                ForEach(BMRFormula.allCases) { formula in
                    formulaButton(for: formula)
                }
            }
        }
    }
    
    private func formulaButton(for formula: BMRFormula) -> some View {
        Button(action: {
            selectedFormula = formula
        }) {
            HStack(spacing: 12) {
                formulaIcon(for: formula)
                formulaText(for: formula)
                Spacer()
                formulaSelectionIndicator(for: formula)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(formulaBackground(for: formula))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formulaIcon(for formula: BMRFormula) -> some View {
        ZStack {
            Circle()
                .fill(selectedFormula == formula ? Color.green : Color.gray.opacity(0.2))
                .frame(width: 30, height: 30)
            
            Image(systemName: "function")
                .font(.caption)
                .foregroundColor(selectedFormula == formula ? .white : .gray)
        }
    }
    
    private func formulaText(for formula: BMRFormula) -> some View {
        Text(NSLocalizedString(formula.description, comment: ""))
            .font(.subheadline)
            .foregroundColor(selectedFormula == formula ? .green : .primary)
            .multilineTextAlignment(.leading)
    }
    
    private func formulaSelectionIndicator(for formula: BMRFormula) -> some View {
        Image(systemName: selectedFormula == formula ? "checkmark.circle.fill" : "circle")
            .font(.title3)
            .foregroundColor(selectedFormula == formula ? .green : .gray.opacity(0.4))
    }
    
    private func formulaBackground(for formula: BMRFormula) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(selectedFormula == formula ? Color.green.opacity(0.1) : Color.gray.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selectedFormula == formula ? Color.green : Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

struct UserProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileSetupView()
            .environmentObject(UserSettings())
    }
} 