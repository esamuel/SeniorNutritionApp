import SwiftUI

struct AddAppointmentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var appointmentType: AppointmentType = .doctor
    @State private var appointmentDate = Date()
    @State private var location: String = ""
    @State private var notes: String = ""
    @State private var reminderEnabled: Bool = true
    @State private var reminderTime: ReminderTime = .oneHour
    
    var onSave: (Appointment) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("APPOINTMENT INFORMATION")) {
                    TextField("Title", text: $title)
                        .accessibilityIdentifier("appointmentTitleField")
                    
                    Picker("Type", selection: $appointmentType) {
                        ForEach(AppointmentType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .accessibilityIdentifier("appointmentTypePicker")
                    
                    HStack {
                        Text("Date & Time")
                        Spacer()
                        DatePicker("", selection: $appointmentDate)
                            .labelsHidden()
                            .accessibilityIdentifier("appointmentDatePicker")
                    }
                    
                    TextField("Location", text: $location)
                        .accessibilityIdentifier("appointmentLocationField")
                }
                
                Section(header: Text("NOTES")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .accessibilityIdentifier("appointmentNotesField")
                }
                
                Section(header: Text("REMINDER")) {
                    Toggle("Set Reminder", isOn: $reminderEnabled)
                        .accessibilityIdentifier("reminderToggle")
                    
                    if reminderEnabled {
                        Picker("Remind me", selection: $reminderTime) {
                            ForEach(ReminderTime.allCases) { reminderTime in
                                Text(reminderTime.rawValue).tag(reminderTime)
                            }
                        }
                        .accessibilityIdentifier("reminderTimePicker")
                    }
                }
            }
            .navigationTitle("Add Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityIdentifier("cancelAppointmentButton")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let appointment = Appointment(
                            title: title,
                            type: appointmentType,
                            date: appointmentDate,
                            location: location,
                            notes: notes,
                            reminder: reminderEnabled ? reminderTime : .none
                        )
                        onSave(appointment)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .accessibilityIdentifier("saveAppointmentButton")
                }
            }
        }
    }
}

#Preview {
    AddAppointmentView { _ in }
} 