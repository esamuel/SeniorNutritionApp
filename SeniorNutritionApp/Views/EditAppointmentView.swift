import SwiftUI

struct EditAppointmentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var appointmentType: AppointmentType
    @State private var appointmentDate: Date
    @State private var location: String
    @State private var notes: String
    @State private var reminderEnabled: Bool
    @State private var reminderTime: ReminderTime
    
    let appointment: Appointment
    var onSave: (Appointment) -> Void
    
    init(appointment: Appointment, onSave: @escaping (Appointment) -> Void) {
        self.appointment = appointment
        self.onSave = onSave
        
        // Initialize the state variables with the appointment's values
        _title = State(initialValue: appointment.title)
        _appointmentType = State(initialValue: appointment.type)
        _appointmentDate = State(initialValue: appointment.date)
        _location = State(initialValue: appointment.location)
        _notes = State(initialValue: appointment.notes)
        _reminderEnabled = State(initialValue: appointment.reminder != .none)
        _reminderTime = State(initialValue: appointment.reminder != .none ? appointment.reminder : .oneHour)
    }
    
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
            .navigationTitle(NSLocalizedString("Edit Appointment", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Save", comment: "")) {
                        let updatedAppointment = Appointment(
                            id: appointment.id,
                            title: title,
                            type: appointmentType,
                            date: appointmentDate,
                            location: location,
                            notes: notes,
                            reminder: reminderEnabled ? reminderTime : .none,
                            isCompleted: appointment.isCompleted
                        )
                        onSave(updatedAppointment)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    EditAppointmentView(
        appointment: Appointment(
            title: "Doctor Visit",
            type: .doctor,
            date: Date(),
            location: "Medical Center",
            notes: "Annual checkup"
        )
    ) { _ in }
} 