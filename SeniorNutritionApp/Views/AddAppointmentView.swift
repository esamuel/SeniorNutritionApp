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
                Section(header: Text(NSLocalizedString("APPOINTMENT INFORMATION", comment: ""))) {
                    TextField(NSLocalizedString("Title", comment: ""), text: $title)
                        .accessibilityIdentifier("appointmentTitleField")
                    
                    Picker(NSLocalizedString("Type", comment: ""), selection: $appointmentType) {
                        ForEach(AppointmentType.allCases) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    .accessibilityIdentifier("appointmentTypePicker")
                    
                    HStack {
                        Text(NSLocalizedString("Date & Time", comment: ""))
                        Spacer()
                        DatePicker("", selection: $appointmentDate)
                            .labelsHidden()
                            .datePickerLTR()
                            .accessibilityIdentifier("appointmentDatePicker")
                    }
                    
                    TextField(NSLocalizedString("Location", comment: ""), text: $location)
                        .accessibilityIdentifier("appointmentLocationField")
                }
                
                Section(header: Text(NSLocalizedString("NOTES", comment: ""))) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .accessibilityIdentifier("appointmentNotesField")
                }
                
                Section(header: Text(NSLocalizedString("REMINDER", comment: ""))) {
                    Toggle(NSLocalizedString("Set Reminder", comment: ""), isOn: $reminderEnabled)
                        .accessibilityIdentifier("reminderToggle")
                    
                    if reminderEnabled {
                        Picker(NSLocalizedString("Remind me", comment: ""), selection: $reminderTime) {
                            ForEach(ReminderTime.allCases) { reminderTime in
                                Text(reminderTime.localizedName).tag(reminderTime)
                            }
                        }
                        .accessibilityIdentifier("reminderTimePicker")
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Add Appointment", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        dismiss()
                    }
                    .accessibilityIdentifier("cancelAppointmentButton")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("Save", comment: "")) {
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