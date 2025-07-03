import SwiftUI

struct AddHeartRateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @State private var heartRate = ""
    @State private var date = Date()
    @State private var error: String?
    @FocusState private var heartRateFieldIsFocused: Bool
    
    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Heart Rate Reading", comment: "Section header for heart rate reading input"))) {
                HStack {
                    TextField(NSLocalizedString("Heart Rate", comment: "Placeholder for heart rate input"), text: $heartRate)
                        .keyboardType(.numberPad)
                        .focused($heartRateFieldIsFocused)
                    Text(NSLocalizedString("BPM", comment: "Unit for heart rate"))
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
        .navigationTitle(NSLocalizedString("Add Heart Rate", comment: "Navigation title for adding heart rate entry"))
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
            heartRateFieldIsFocused = true
        }
    }
    
    private func saveReading() {
        guard let bpm = Int32(heartRate), bpm > 0 else {
            error = NSLocalizedString("Please enter a valid heart rate", comment: "Error message for invalid heart rate")
            return
        }
        
        // Validate heart rate is within reasonable range (30-220 BPM)
        guard bpm >= 30 && bpm <= 220 else {
            error = NSLocalizedString("Heart rate should be between 30 and 220 BPM", comment: "Error message for heart rate out of range")
            return
        }
        
        let entry = HeartRateEntry(context: viewContext)
        entry.id = UUID()
        entry.bpm = bpm
        entry.date = date
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            self.error = NSLocalizedString("Failed to save. Please try again.", comment: "Error message for failed save operation")
        }
    }
}

struct AddHeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        AddHeartRateView()
            .environmentObject(UserSettings())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
} 