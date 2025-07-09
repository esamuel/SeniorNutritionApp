import SwiftUI

struct AddBloodPressureView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var systolic = ""
    @State private var diastolic = ""
    @State private var date = Date()
    @State private var error: String?
    @FocusState private var systolicFieldIsFocused: Bool
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Blood Pressure Reading", comment: "Section header for blood pressure reading input"))) {
                HStack {
                    TextField(NSLocalizedString("Systolic", comment: "Placeholder for systolic blood pressure input"), text: $systolic)
                        .keyboardType(.numberPad)
                        .focused($systolicFieldIsFocused)
                    Text(NSLocalizedString("mmHg", comment: "Unit for blood pressure"))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    TextField(NSLocalizedString("Diastolic", comment: "Placeholder for diastolic blood pressure input"), text: $diastolic)
                        .keyboardType(.numberPad)
                    Text(NSLocalizedString("mmHg", comment: "Unit for blood pressure"))
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
        .navigationTitle(NSLocalizedString("Add Blood Pressure", comment: "Navigation title for adding blood pressure entry"))
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
        .font(.system(size: userSettings.textSize.size))
        .onAppear {
            systolicFieldIsFocused = true
        }
    }
    
    private func saveReading() {
        guard let systolicValue = Int32(systolic), systolicValue > 0 else {
            error = NSLocalizedString("Please enter a valid systolic pressure", comment: "Error message for invalid systolic pressure")
            return
        }
        
        guard let diastolicValue = Int32(diastolic), diastolicValue > 0 else {
            error = NSLocalizedString("Please enter a valid diastolic pressure", comment: "Error message for invalid diastolic pressure")
            return
        }
        
        guard systolicValue >= diastolicValue else {
            error = NSLocalizedString("Systolic pressure must be higher than diastolic pressure", comment: "Error message when systolic is not higher than diastolic")
            return
        }
        
        let entry = BloodPressureEntry(context: viewContext)
        entry.id = UUID()
        entry.systolic = systolicValue
        entry.diastolic = diastolicValue
        entry.date = date
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            self.error = NSLocalizedString("Failed to save. Please try again.", comment: "Error message for failed save operation")
        }
    }
}

struct AddBloodPressureView_Previews: PreviewProvider {
    static var previews: some View {
        AddBloodPressureView()
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 