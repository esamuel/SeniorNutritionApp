import SwiftUI
import CoreData

struct AddBloodPressureView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var systolic = ""
    @State private var diastolic = ""
    @State private var date = Date()
    @State private var notes = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case systolic, diastolic, notes
    }
    
    var body: some View {
        Form {
            Section {
                // Health data identification
                HealthDataBrandingView(healthDataType: NSLocalizedString("Blood Pressure", comment: ""))
            }
            
            Section(header: Text(NSLocalizedString("Blood Pressure Reading", comment: ""))) {
                TextField(NSLocalizedString("Systolic", comment: ""), text: $systolic)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .systolic)
                
                TextField(NSLocalizedString("Diastolic", comment: ""), text: $diastolic)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .diastolic)
                
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
        .navigationTitle(NSLocalizedString("Add Blood Pressure", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("Cancel", comment: "")) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(NSLocalizedString("Save", comment: "")) {
                    saveBloodPressure()
                }
                .disabled(systolic.isEmpty || diastolic.isEmpty)
            }
        }
    }
    
    private func saveBloodPressure() {
        guard let systolicValue = Int32(systolic),
              let diastolicValue = Int32(diastolic) else {
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
            print("Error saving blood pressure: \(error)")
        }
    }
}

#Preview {
    AddBloodPressureView()
        .environmentObject(UserSettings())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 