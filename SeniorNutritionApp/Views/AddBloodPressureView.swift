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
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Blood Pressure Reading", comment: ""))) {
                    HStack {
                        TextField(NSLocalizedString("Systolic", comment: ""), text: $systolic)
                            .keyboardType(.numberPad)
                            .focused($systolicFieldIsFocused)
                        Text("mmHg")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        TextField(NSLocalizedString("Diastolic", comment: ""), text: $diastolic)
                            .keyboardType(.numberPad)
                        Text("mmHg")
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
            .navigationTitle(NSLocalizedString("Add Blood Pressure", comment: ""))
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
                self.systolicFieldIsFocused = true
            }
        }
    }
    
    private func saveReading() {
        guard let systolicValue = Int32(systolic), systolicValue > 0 else {
            error = NSLocalizedString("Please enter a valid systolic pressure", comment: "")
            return
        }
        
        guard let diastolicValue = Int32(diastolic), diastolicValue > 0 else {
            error = NSLocalizedString("Please enter a valid diastolic pressure", comment: "")
            return
        }
        
        guard systolicValue >= diastolicValue else {
            error = NSLocalizedString("Systolic pressure must be higher than diastolic pressure", comment: "")
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
            self.error = NSLocalizedString("Failed to save. Please try again.", comment: "")
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