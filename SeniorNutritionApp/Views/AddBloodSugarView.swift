import SwiftUI

struct AddBloodSugarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var bloodSugar = ""
    @State private var date = Date()
    @State private var notes = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case bloodSugar, notes
    }
    
    var body: some View {
        Form {
            Section {
                // Health data identification
                HealthDataBrandingView(healthDataType: NSLocalizedString("Blood Sugar", comment: ""))
            }
            
            Section(header: Text(NSLocalizedString("Blood Sugar Reading", comment: ""))) {
                HStack {
                    TextField(NSLocalizedString("Blood Sugar", comment: ""), text: $bloodSugar)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .bloodSugar)
                    Text(NSLocalizedString("mg/dL", comment: ""))
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
        .navigationTitle(NSLocalizedString("Add Blood Sugar", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("Cancel", comment: "")) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(NSLocalizedString("Save", comment: "")) {
                    saveBloodSugar()
                }
                .disabled(bloodSugar.isEmpty)
            }
        }
    }
    
    private func saveBloodSugar() {
        guard let glucoseValue = Double(bloodSugar) else {
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
            print("Error saving blood sugar: \(error)")
        }
    }
}

#Preview {
    AddBloodSugarView()
        .environmentObject(UserSettings())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 