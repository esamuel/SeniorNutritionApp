import SwiftUI

struct AddWeightView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var weight = ""
    @State private var date = Date()
    @State private var error: String?
    @FocusState private var weightFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Weight Reading", comment: "Section header for weight reading input"))) {
                    HStack {
                        TextField(NSLocalizedString("Weight", comment: "Placeholder for weight input"), text: $weight)
                            .keyboardType(.decimalPad)
                            .focused($weightFieldIsFocused)
                        Text(NSLocalizedString("kg", comment: "Unit for weight"))
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    DatePicker(
                        NSLocalizedString("Date and Time", comment: "Label for date and time picker"),
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
            }
            .navigationTitle(NSLocalizedString("Add Weight", comment: "Navigation title for adding weight entry"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Cancel", comment: "Cancel button text")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Save", comment: "Save button text")) {
                        saveReading()
                    }
                }
            }
        }
        .font(.system(size: userSettings.textSize.size))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.weightFieldIsFocused = true
            }
        }
    }
    
    private func saveReading() {
        guard let weightValue = Double(weight.replacingOccurrences(of: ",", with: ".")), weightValue > 0 else {
            error = NSLocalizedString("Please enter a valid weight", comment: "Error message for invalid weight")
            return
        }
        
        // Validate weight is within reasonable range (20-300 kg)
        guard weightValue >= 20 && weightValue <= 300 else {
            error = NSLocalizedString("Weight should be between 20 and 300 kg", comment: "Error message for weight out of range")
            return
        }
        
        let entry = WeightEntry(context: viewContext)
        entry.id = UUID()
        entry.weight = weightValue
        entry.date = date
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            self.error = NSLocalizedString("Failed to save. Please try again.", comment: "Error message for failed save operation")
        }
    }
}

struct AddWeightView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeightView()
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 