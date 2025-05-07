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
            .navigationTitle("Edit Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityIdentifier("cancelEditAppointmentButton")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
                    .accessibilityIdentifier("saveEditedAppointmentButton")
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