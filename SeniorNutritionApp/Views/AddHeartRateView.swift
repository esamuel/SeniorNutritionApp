import SwiftUI

struct AddHeartRateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var heartRate = ""
    @State private var date = Date()
    @State private var notes = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case heartRate, notes
    }
    
    var body: some View {
        Form {
            Section {
                // Health data identification
                HealthDataBrandingView(healthDataType: NSLocalizedString("Heart Rate", comment: ""))
            }
            
            Section(header: Text(NSLocalizedString("Heart Rate Reading", comment: ""))) {
                HStack {
                    TextField(NSLocalizedString("Heart Rate", comment: ""), text: $heartRate)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .heartRate)
                    Text(NSLocalizedString("BPM", comment: ""))
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
        .navigationTitle(NSLocalizedString("Add Heart Rate", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("Cancel", comment: "")) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(NSLocalizedString("Save", comment: "")) {
                    saveHeartRate()
                }
                .disabled(heartRate.isEmpty)
            }
        }
    }
    
    private func saveHeartRate() {
        guard let bpmValue = Int32(heartRate) else {
            return
        }
        
        let entry = HeartRateEntry(context: viewContext)
        entry.id = UUID()
        entry.bpm = bpmValue
        entry.date = date
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving heart rate: \(error)")
        }
    }
}

#Preview {
    AddHeartRateView()
        .environmentObject(UserSettings())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 