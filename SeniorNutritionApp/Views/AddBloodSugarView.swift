import SwiftUI

struct AddBloodSugarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var bloodSugar = ""
    @State private var date = Date()
    @State private var error: String?
    @FocusState private var bloodSugarFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Blood Sugar Reading", comment: ""))) {
                    HStack {
                        TextField(NSLocalizedString("Blood Sugar", comment: ""), text: $bloodSugar)
                            .keyboardType(.decimalPad)
                            .focused($bloodSugarFieldIsFocused)
                        Text("mg/dL")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    DatePicker(
                        NSLocalizedString("Date and Time", comment: ""),
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                if let error = error {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("Target Ranges:", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                        Text(NSLocalizedString("Before meals: 80-130 mg/dL", comment: ""))
                        Text(NSLocalizedString("After meals: Less than 180 mg/dL", comment: ""))
                        Text(NSLocalizedString("Bedtime: 100-140 mg/dL", comment: ""))
                    }
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle(NSLocalizedString("Add Blood Sugar", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Save", comment: "")) {
                        saveReading()
                    }
                }
            }
        }
        .font(.system(size: userSettings.textSize.size))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.bloodSugarFieldIsFocused = true
            }
        }
    }
    
    private func saveReading() {
        guard let glucoseValue = Double(bloodSugar.replacingOccurrences(of: ",", with: ".")), glucoseValue > 0 else {
            error = NSLocalizedString("Please enter a valid blood sugar reading", comment: "")
            return
        }
        
        // Validate blood sugar is within reasonable range (20-600 mg/dL)
        guard glucoseValue >= 20 && glucoseValue <= 600 else {
            error = NSLocalizedString("Blood sugar should be between 20 and 600 mg/dL", comment: "")
            return
        }
        
        let entry = BloodSugarEntry(context: viewContext)
        entry.id = UUID()
        entry.glucose = glucoseValue
        entry.date = date
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            self.error = NSLocalizedString("Failed to save. Please try again.", comment: "")
        }
    }
}

struct AddBloodSugarView_Previews: PreviewProvider {
    static var previews: some View {
        AddBloodSugarView()
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 