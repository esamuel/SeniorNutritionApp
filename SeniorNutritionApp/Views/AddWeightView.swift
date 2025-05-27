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
                Section(header: Text(NSLocalizedString("Weight Reading", comment: ""))) {
                    HStack {
                        TextField(NSLocalizedString("Weight", comment: ""), text: $weight)
                            .keyboardType(.decimalPad)
                            .focused($weightFieldIsFocused)
                        Text("kg")
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
            }
            .navigationTitle(NSLocalizedString("Add Weight", comment: ""))
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
                self.weightFieldIsFocused = true
            }
        }
    }
    
    private func saveReading() {
        guard let weightValue = Double(weight.replacingOccurrences(of: ",", with: ".")), weightValue > 0 else {
            error = NSLocalizedString("Please enter a valid weight", comment: "")
            return
        }
        
        // Validate weight is within reasonable range (20-300 kg)
        guard weightValue >= 20 && weightValue <= 300 else {
            error = NSLocalizedString("Weight should be between 20 and 300 kg", comment: "")
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
            self.error = NSLocalizedString("Failed to save. Please try again.", comment: "")
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