import SwiftUI

// MARK: - Profile Header View
struct ProfileHeaderView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(userSettings.userName)
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                Text("Age: \(userSettings.userAge)")
                    .font(.system(size: userSettings.textSize.size))
                
                Text(userSettings.userGender)
                    .font(.system(size: userSettings.textSize.size))
            }
            .padding(.leading, 10)
        }
        .padding(.vertical, 10)
    }
}

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
                    Text(restriction)
                        .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
}

// MARK: - Emergency Contacts View
struct EmergencyContactsView: View {
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
    
    var body: some View {
        NavigationView {
            List {
                if let profile = userSettings.userProfile {
                    personalInformationSection(profile)
                    healthInformationSection(profile)
                    medicalConditionsSection(profile)
                    dietaryRestrictionsSection(profile)
                    emergencyContactsSection(profile)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingProfileSetup = true
                    }
                }
            }
            .sheet(isPresented: $showingProfileSetup) {
                UserProfileSetupView()
            }
        }
    }
    
    private func personalInformationSection(_ profile: UserProfile) -> some View {
        Section(header: Text("Personal Information").font(.system(size: userSettings.textSize.size))) {
            profileRow(title: "Name", value: profile.fullName)
            profileRow(title: "Age", value: "\(profile.age) years")
            profileRow(title: "Gender", value: profile.gender)
        }
    }
    
    private func healthInformationSection(_ profile: UserProfile) -> some View {
        Section(header: Text("Health Information").font(.system(size: userSettings.textSize.size))) {
            profileRow(title: "Height", value: "\(Int(profile.height)) cm")
            profileRow(title: "Weight", value: "\(Int(profile.weight)) kg")
        }
    }
    
    private func medicalConditionsSection(_ profile: UserProfile) -> some View {
        Group {
            if !profile.medicalConditions.isEmpty {
                Section(header: Text("Medical Conditions").font(.system(size: userSettings.textSize.size))) {
                    ForEach(profile.medicalConditions, id: \.self) { condition in
                        Text(condition)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
        }
    }
    
    private func dietaryRestrictionsSection(_ profile: UserProfile) -> some View {
        Group {
            if !profile.dietaryRestrictions.isEmpty {
                Section(header: Text("Dietary Restrictions").font(.system(size: userSettings.textSize.size))) {
                    ForEach(profile.dietaryRestrictions, id: \.self) { restriction in
                        Text(restriction)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
        }
    }
    
    private func emergencyContactsSection(_ profile: UserProfile) -> some View {
        Section(header: Text("Emergency Contacts").font(.system(size: userSettings.textSize.size))) {
            ForEach(profile.emergencyContacts) { contact in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(contact.name)
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            // TODO: Implement edit contact functionality
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 20))
                        }
                        
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
                    }
                    
                    Text(contact.phoneNumber)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Text(contact.relationship.rawValue)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            Button(action: {
                showingProfileSetup = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Emergency Contact")
                }
                .foregroundColor(.blue)
                .font(.system(size: userSettings.textSize.size))
            }
            .padding(.top, 8)
        }
    }
    
    private func profileRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: userSettings.textSize.size))
            Spacer()
            Text(value)
                .font(.system(size: userSettings.textSize.size))
        }
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
        "Halal"
    ]
    
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
                        MultipleSelectionRow(title: restriction, isSelected: selectedDietaryRestrictions.contains(restriction)) {
                            if selectedDietaryRestrictions.contains(restriction) {
                                selectedDietaryRestrictions.remove(restriction)
                            } else {
                                selectedDietaryRestrictions.insert(restriction)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
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
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
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
            .navigationTitle("Emergency Contact")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
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
            name: name,
            relationship: selectedRelationship,
            phoneNumber: phoneNumber
        )
        userSettings.userEmergencyContacts.append(contact)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserSettings())
    }
} 