import SwiftUI

// MARK: - Health Information View
struct HealthInformationView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        Section(header: Text("Health Information").font(.system(size: userSettings.textSize.size))) {
            ProfileRow(title: "Height", value: "\(Int(userSettings.userHeight)) cm")
            ProfileRow(title: "Weight", value: "\(Int(userSettings.userWeight)) kg")
        }
    }
}

// MARK: - Health Goals View
struct HealthGoalsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        Section(header: Text("Health Goals").font(.system(size: userSettings.textSize.size))) {
            if userSettings.userHealthGoals.isEmpty {
                Text("No health goals set")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
            } else {
                ForEach(userSettings.userHealthGoals, id: \.self) { goal in
                    Text(goal)
                        .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
}

// MARK: - Dietary Restrictions View
struct DietaryRestrictionsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        Section(header: Text("Dietary Restrictions").font(.system(size: userSettings.textSize.size))) {
            if userSettings.userDietaryRestrictions.isEmpty {
                Text("No dietary restrictions set")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
            } else {
                ForEach(userSettings.userDietaryRestrictions, id: \.self) { restriction in
                    Text(ProfileTranslationUtils.translateDietaryRestriction(restriction))
                        .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
}

// MARK: - Emergency Contacts View
struct ProfileEmergencyContactsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Binding var showingEmergencyContactSheet: Bool
    
    var body: some View {
        Section(header: Text("Emergency Contact")) {
            ForEach(userSettings.userEmergencyContacts) { contact in
                VStack(alignment: .leading, spacing: 8) {
                    Text(contact.name)
                        .font(.headline)
                    Text(contact.phoneNumber)
                        .font(.subheadline)
                    Text(contact.relationship.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        if let index = userSettings.userEmergencyContacts.firstIndex(where: { $0.id == contact.id }) {
                            userSettings.userEmergencyContacts.remove(at: index)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            
            Button(action: {
                showingEmergencyContactSheet = true
            }) {
                Label("Add Emergency Contact", systemImage: "plus")
            }
        }
    }
}

// MARK: - Main Profile View
struct ProfileView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingProfileSetup = false
    @State private var showingDeleteAlert = false
    @State private var showingEditEmergencyContact = false
    @State private var contactToEdit: EmergencyContact?
    @State private var showingOnboarding = false
    @State private var refreshTrigger = false
    
    // Publisher for language change notifications
    private let languageChangePublisher = NotificationCenter.default.publisher(for: .languageDidChange)
    
    var body: some View {
        NavigationView {
            List {
                if let profile = userSettings.userProfile {
                    personalInformationSection(profile)
                    healthInformationSection(profile)
                    medicalConditionsSection(profile)
                    dietaryRestrictionsSection(profile)
                    emergencyContactsSection(profile)
                } else {
                    Text("Please set up your profile")
                        .font(.system(size: userSettings.textSize.size))
                }
            }
            .navigationTitle(NSLocalizedString("Profile", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Edit", comment: "")) {
                        showingProfileSetup = true
                    }
                }
            }
            .sheet(isPresented: $showingProfileSetup) {
                UserProfileSetupView()
            }
            .sheet(isPresented: $showingEditEmergencyContact) {
                if let contact = contactToEdit {
                    EditEmergencyContactView(isPresented: $showingEditEmergencyContact, contact: contact)
                } else {
                    EditEmergencyContactView(isPresented: $showingEditEmergencyContact)
                }
            }
            .onReceive(languageChangePublisher) { _ in
                // Force refresh when language changes to update translations
                refreshTrigger.toggle()
            }
        }
    }
    
    private func personalInformationSection(_ profile: UserProfile) -> some View {
        Section(header: Text(NSLocalizedString("Personal Information", comment: ""))
            .font(.system(size: userSettings.textSize.size, weight: .bold))
            .foregroundColor(.blue)) {
            
            profileRow(title: "Name", value: profile.fullName, iconName: "person.fill", color: .blue)
            
            // Calculate and display age from date of birth with months
            let ageComponents = Calendar.current.dateComponents([.year, .month], from: profile.dateOfBirth, to: Date())
            let years = ageComponents.year ?? 0
            let months = ageComponents.month ?? 0
            let ageText = years > 0 ? "\(years) years, \(months) months" : "\(months) months"
            profileRow(title: "Age", value: ageText, iconName: "calendar", color: .green)
            
            profileRow(title: "Date of Birth", value: formatDate(profile.dateOfBirth), iconName: "birthday.cake", color: .orange)
            profileRow(title: "Gender", value: profile.gender, iconName: "person.crop.circle", color: .purple)
        }
        .listRowBackground(Color.blue.opacity(0.05))
    }
    
    private func healthInformationSection(_ profile: UserProfile) -> some View {
        Section(header: Text(NSLocalizedString("Physical Information", comment: ""))
            .font(.system(size: userSettings.textSize.size, weight: .bold))
            .foregroundColor(.green)) {
            
            // Height with both metric and imperial
            let heightCm = profile.height
            let heightFt = UnitConverter.fromBaseUnit(heightCm, to: "ft")
            let heightIn = UnitConverter.fromBaseUnit(heightCm, to: "in")
            let heightText = "\(Int(heightCm)) cm (\(Int(heightFt))' \(Int(heightIn.truncatingRemainder(dividingBy: 12)))\""
            profileRow(title: "Height", value: heightText, iconName: "ruler", color: .teal)
            
            // Weight with both metric and imperial
            let weightKg = profile.weight
            let weightLb = UnitConverter.fromBaseUnit(weightKg * 1000, to: "lb") // Convert kg to g first, then to lb
            let weightText = "\(Int(weightKg)) kg (\(Int(weightLb)) lb)"
            profileRow(title: "Weight", value: weightText, iconName: "scalemass", color: .cyan)
            
            // BMI with category using latest weight from health data
            if let bmi = userSettings.getCurrentBMI(), let category = userSettings.getCurrentBMICategory() {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "figure.stand")
                            .foregroundColor(.mint)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("BMI")
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.secondary)
                            HStack {
                                Text(String(format: "%.1f", bmi))
                                    .font(.system(size: userSettings.textSize.size))
                                Text("(\(category.localizedTitle))")
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(category.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(category.color.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            } else {
                profileRow(title: "BMI", value: "-", iconName: "figure.stand", color: .mint)
            }
        }
        .listRowBackground(Color.green.opacity(0.05))
    }
    
    private func medicalConditionsSection(_ profile: UserProfile) -> some View {
        Group {
                Section(header: HStack {
                    Text(NSLocalizedString("Medical Conditions", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .foregroundColor(.red)
                    Spacer()
                    Button(action: {
                        showingProfileSetup = true
                    }) {
                        Image(systemName: "pencil.circle")
                            .foregroundColor(.blue)
                    }
                    Button(action: {
                        if var updatedProfile = userSettings.userProfile {
                            updatedProfile.medicalConditions = []
                            userSettings.updateProfile(updatedProfile)
                        }
                    }) {
                        Image(systemName: "trash.circle")
                            .foregroundColor(.red)
                    }
                }) {
                    if profile.medicalConditions.isEmpty {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.secondary)
                            Text(NSLocalizedString("No medical conditions added", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    } else {
                        ForEach(profile.medicalConditions, id: \.self) { condition in
                            HStack {
                                Image(systemName: "heart.text.square")
                                    .foregroundColor(.red)
                                Text(ProfileTranslationUtils.translateMedicalCondition(condition))
                                    .font(.system(size: userSettings.textSize.size))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listRowBackground(Color.red.opacity(0.05))
        }
    }
    
    private func dietaryRestrictionsSection(_ profile: UserProfile) -> some View {
        Group {
                Section(header: HStack {
                    Text(NSLocalizedString("Dietary Restrictions", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .foregroundColor(.orange)
                    Spacer()
                    Button(action: {
                        showingProfileSetup = true
                    }) {
                        Image(systemName: "pencil.circle")
                            .foregroundColor(.blue)
                    }
                    Button(action: {
                        if var updatedProfile = userSettings.userProfile {
                            updatedProfile.dietaryRestrictions = []
                            userSettings.updateProfile(updatedProfile)
                        }
                    }) {
                        Image(systemName: "trash.circle")
                            .foregroundColor(.red)
                    }
                }) {
                    if profile.dietaryRestrictions.isEmpty {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.secondary)
                            Text(NSLocalizedString("No dietary restrictions added", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    } else {
                        ForEach(profile.dietaryRestrictions, id: \.self) { restriction in
                            HStack {
                                Image(systemName: "fork.knife")
                                    .foregroundColor(.orange)
                                Text(ProfileTranslationUtils.translateDietaryRestriction(restriction))
                                    .font(.system(size: userSettings.textSize.size))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listRowBackground(Color.orange.opacity(0.05))
        }
    }
    
    private func emergencyContactsSection(_ profile: UserProfile) -> some View {
        Section(header: Text(NSLocalizedString("Emergency Contacts", comment: ""))
            .font(.system(size: userSettings.textSize.size, weight: .bold))
            .foregroundColor(.purple)) {
            
            ForEach(profile.emergencyContacts) { contact in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill.badge.checkmark")
                            .foregroundColor(.purple)
                        
                        Text(contact.name)
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            // Edit contact functionality
                            showingEditEmergencyContact = true
                            contactToEdit = contact
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 20))
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Prevent tap propagation
                        
                        Button(action: {
                            if let index = profile.emergencyContacts.firstIndex(where: { $0.id == contact.id }) {
                                var updatedProfile = profile
                                updatedProfile.emergencyContacts.remove(at: index)
                                userSettings.updateProfile(updatedProfile)
                            }
                        }) {
                            Image(systemName: "trash.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Prevent tap propagation
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text(contact.phoneNumber)
                            .font(.system(size: userSettings.textSize.size))
                    }
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                        Text(contact.relationship.rawValue)
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Button(action: {
                showingProfileSetup = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                    Text("Add Emergency Contact")
                        .foregroundColor(.green)
                }
                .font(.system(size: userSettings.textSize.size))
            }
            .padding(.top, 8)
        }
        .listRowBackground(Color.purple.opacity(0.05))
    }
    
    // Helper function to format dates nicely
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func profileRow(title: String, value: String, iconName: String, color: Color) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: userSettings.textSize.size))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Supporting Views
struct ProfileRow: View {
    @EnvironmentObject private var userSettings: UserSettings
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: userSettings.textSize.size))
            Spacer()
            Text(value)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var selectedGender: String = "Male"
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var selectedHealthGoals: Set<String> = []
    @State private var selectedDietaryRestrictions: Set<String> = []
    
    private let genders = ["Male", "Female", "Other"]
    private let healthGoalOptions = [
        "Weight Management",
        "Muscle Building",
        "Heart Health",
        "Diabetes Management",
        "Bone Health",
        "Energy Boost",
        "Better Sleep",
        "Stress Reduction"
    ]
    
    private let dietaryRestrictionOptions = ProfileTranslationUtils.dietaryRestrictionsEnglish
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information").font(.system(size: userSettings.textSize.size))) {
                    TextField("Name", text: $name)
                        .font(.system(size: userSettings.textSize.size))
                    TextField("Age", text: $age)
                        .font(.system(size: userSettings.textSize.size))
                        .keyboardType(.numberPad)
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Health Information").font(.system(size: userSettings.textSize.size))) {
                    TextField("Height (cm)", text: $height)
                        .font(.system(size: userSettings.textSize.size))
                        .keyboardType(.decimalPad)
                    TextField("Weight (kg)", text: $weight)
                        .font(.system(size: userSettings.textSize.size))
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Health Goals").font(.system(size: userSettings.textSize.size))) {
                    ForEach(healthGoalOptions, id: \.self) { goal in
                        MultipleSelectionRow(title: goal, isSelected: selectedHealthGoals.contains(goal)) {
                            if selectedHealthGoals.contains(goal) {
                                selectedHealthGoals.remove(goal)
                            } else {
                                selectedHealthGoals.insert(goal)
                            }
                        }
                    }
                }
                
                Section(header: Text("Dietary Restrictions").font(.system(size: userSettings.textSize.size))) {
                    ForEach(dietaryRestrictionOptions, id: \.self) { restriction in
                        MultipleSelectionRow(title: ProfileTranslationUtils.translateDietaryRestriction(restriction), isSelected: selectedDietaryRestrictions.contains(restriction)) {
                            if selectedDietaryRestrictions.contains(restriction) {
                                selectedDietaryRestrictions.remove(restriction)
                            } else {
                                selectedDietaryRestrictions.insert(restriction)
                            }
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Edit Profile", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        isPresented = false
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Save", comment: "")) {
                        saveChanges()
                        isPresented = false
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .onAppear {
                name = userSettings.userName
                age = String(userSettings.userAge)
                selectedGender = userSettings.userGender
                height = String(userSettings.userHeight)
                weight = String(userSettings.userWeight)
                selectedHealthGoals = Set(userSettings.userHealthGoals)
                selectedDietaryRestrictions = Set(userSettings.userDietaryRestrictions)
            }
        }
    }
    
    private func saveChanges() {
        userSettings.userName = name
        if let ageInt = Int(age) {
            userSettings.userAge = ageInt
        }
        userSettings.userGender = selectedGender
        if let heightDouble = Double(height) {
            userSettings.userHeight = heightDouble
        }
        if let weightDouble = Double(weight) {
            userSettings.userWeight = weightDouble
        }
        userSettings.userHealthGoals = Array(selectedHealthGoals)
        userSettings.userDietaryRestrictions = Array(selectedDietaryRestrictions)
    }
}

struct MultipleSelectionRow: View {
    @EnvironmentObject private var userSettings: UserSettings
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .foregroundColor(.primary)
    }
}

// MARK: - Edit Emergency Contact View
struct EditEmergencyContactView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var selectedRelationship: Relationship = .spouse
    @State private var phoneNumber: String = ""
    @State private var contactId: UUID
    @State private var isEditMode: Bool = false
    
    init(isPresented: Binding<Bool>, contact: EmergencyContact? = nil) {
        _isPresented = isPresented
        
        if let contact = contact {
            // Edit mode
            _name = State(initialValue: contact.name)
            _selectedRelationship = State(initialValue: contact.relationship)
            _phoneNumber = State(initialValue: contact.phoneNumber)
            _contactId = State(initialValue: contact.id)
            _isEditMode = State(initialValue: true)
        } else {
            // Create mode
            _contactId = State(initialValue: UUID())
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Emergency Contact Information").font(.system(size: userSettings.textSize.size))) {
                    TextField("Name", text: $name)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Picker("Relationship", selection: $selectedRelationship) {
                        ForEach(Relationship.allCases) { relationship in
                            Text(relationship.rawValue)
                                .font(.system(size: userSettings.textSize.size))
                                .tag(relationship)
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .font(.system(size: userSettings.textSize.size))
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle(NSLocalizedString("Emergency Contact", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        isPresented = false
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Save", comment: "")) {
                        saveContact()
                        isPresented = false
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    private func saveContact() {
        let contact = EmergencyContact(
            id: contactId,
            name: name,
            relationship: selectedRelationship,
            phoneNumber: phoneNumber
        )
        
        if isEditMode {
            // Update existing contact
            if let index = userSettings.userEmergencyContacts.firstIndex(where: { $0.id == contactId }) {
                userSettings.userEmergencyContacts[index] = contact
            }
            
            // Also update in user profile if it exists
            if var profile = userSettings.userProfile {
                if let index = profile.emergencyContacts.firstIndex(where: { $0.id == contactId }) {
                    profile.emergencyContacts[index] = contact
                    userSettings.updateProfile(profile)
                }
            }
        } else {
            // Add new contact
            userSettings.userEmergencyContacts.append(contact)
            
            // Also add to user profile if it exists
            if var profile = userSettings.userProfile {
                profile.emergencyContacts.append(contact)
                userSettings.updateProfile(profile)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserSettings())
    }
}