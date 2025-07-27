import SwiftUI

struct AddWeightView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var weight = ""
    @State private var date = Date()
    @State private var notes = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case weight, notes
    }
    
    var body: some View {
        Form {
            Section {
                // Health data identification
                HealthDataBrandingView(healthDataType: NSLocalizedString("Weight", comment: ""))
            }
            
            Section(header: Text(NSLocalizedString("Weight Reading", comment: ""))) {
                HStack {
                    TextField(NSLocalizedString("Weight", comment: ""), text: $weight)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .weight)
                    Text(NSLocalizedString("kg", comment: ""))
                        .foregroundColor(.secondary)
                }
                
                DatePicker(
                    NSLocalizedString("Date", comment: ""),
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            Section(header: Text(NSLocalizedString("Notes", comment: ""))) {
                TextField(NSLocalizedString("Optional notes", comment: ""), text: $notes)
                    .focused($focusedField, equals: .notes)
            }
        }
        .navigationTitle(NSLocalizedString("Add Weight", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("Cancel", comment: "")) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(NSLocalizedString("Save", comment: "")) {
                    saveWeight()
                }
                .disabled(weight.isEmpty)
            }
        }
    }
    
    private func saveWeight() {
        guard let weightValue = Double(weight) else {
            return
        }
        
        let entry = WeightEntry(context: viewContext)
        entry.id = UUID()
        entry.weight = weightValue
        entry.date = date
        
        // Update user profile with the latest weight
        updateUserProfileWeight(newWeight: weightValue)
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving weight: \(error)")
        }
    }
    
    private func updateUserProfileWeight(newWeight: Double) {
        guard var userProfile = userSettings.userProfile else {
            print("❌ AddWeightView: No user profile found to update")
            return
        }
        
        let oldWeight = userProfile.weight
        print("🔄 AddWeightView: Updating profile weight from \(oldWeight) kg to \(newWeight) kg")
        
        // Update the weight in the user profile
        userProfile.weight = newWeight
        
        // Force save the updated profile immediately
        userSettings.userProfile = userProfile
        
        // Also update the legacy userWeight property for backward compatibility
        userSettings.userWeight = newWeight
        
        // The userProfile setter should automatically save to UserDefaults
        
        print("✅ AddWeightView: Successfully updated profile weight to: \(newWeight) kg")
        print("📊 AddWeightView: Legacy userWeight also updated to: \(userSettings.userWeight) kg")
        
        // Verify the update took effect
        if let updatedProfile = userSettings.userProfile {
            print("🔍 AddWeightView: Verification - profile weight is now: \(updatedProfile.weight) kg")
        }
        
        // Force objectWillChange to trigger UI refresh
        DispatchQueue.main.async {
            userSettings.objectWillChange.send()
        }
        
        // Post notification that weight has been updated for BMI recalculation
        NotificationCenter.default.post(
            name: NSNotification.Name("UserWeightUpdated"),
            object: nil,
            userInfo: ["newWeight": newWeight, "profile": userProfile]
        )
        
        print("📢 AddWeightView: Posted UserWeightUpdated notification and forced UI refresh")
    }
}

#Preview {
    AddWeightView()
        .environmentObject(UserSettings())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 