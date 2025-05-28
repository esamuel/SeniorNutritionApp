import SwiftUI
import UserNotifications

class AppointmentManager: ObservableObject {
    @Published var appointments: [Appointment] = []
    private let saveKey = "savedAppointments"
    
    init() {
        loadAppointments()
    }
    
    // Upcoming appointments sorted by date
    var upcomingAppointments: [Appointment] {
        let currentDate = Date()
        return appointments
            .filter { !$0.isCompleted && $0.date > currentDate }
            .sorted { $0.date < $1.date }
    }
    
    // Past appointments sorted by most recent
    var pastAppointments: [Appointment] {
        let currentDate = Date()
        return appointments
            .filter { $0.isCompleted || $0.date <= currentDate }
            .sorted { $0.date > $1.date }
    }
    
    func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
        
        // Schedule notification if reminder is enabled
        if appointment.reminder != .none {
            scheduleNotification(for: appointment)
        }
        
        saveAppointments()
    }
    
    func deleteAppointment(at indexSet: IndexSet, from appointmentList: [Appointment]) {
        for index in indexSet {
            if let appointmentIndex = appointments.firstIndex(where: { $0.id == appointmentList[index].id }) {
                // Remove notification before deleting appointment
                cancelNotification(for: appointmentList[index])
                appointments.remove(at: appointmentIndex)
            }
        }
        saveAppointments()
    }
    
    func markAsCompleted(_ appointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            var updatedAppointment = appointment
            updatedAppointment.isCompleted = true
            appointments[index] = updatedAppointment
            
            // Cancel notification since it's completed
            cancelNotification(for: appointment)
            
            saveAppointments()
        }
    }
    
    func updateAppointment(_ updatedAppointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == updatedAppointment.id }) {
            // Cancel old notification if it exists
            cancelNotification(for: appointments[index])
            
            // Update the appointment
            appointments[index] = updatedAppointment
            
            // Schedule new notification if needed
            if updatedAppointment.reminder != .none {
                scheduleNotification(for: updatedAppointment)
            }
            
            saveAppointments()
        }
    }
    
    // MARK: - Persistence Methods
    
    private func saveAppointments() {
        do {
            let data = try JSONEncoder().encode(appointments)
            UserDefaults.standard.set(data, forKey: saveKey)
            print("Saved \(appointments.count) appointments to UserDefaults")
        } catch {
            print("Failed to save appointments: \(error.localizedDescription)")
        }
    }
    
    private func loadAppointments() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            print("No saved appointments found")
            return
        }
        
        do {
            appointments = try JSONDecoder().decode([Appointment].self, from: data)
            print("Loaded \(appointments.count) appointments from UserDefaults")
        } catch {
            print("Failed to load appointments: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Notification Methods
    
    private func scheduleNotification(for appointment: Appointment) {
        let center = UNUserNotificationCenter.current()
        
        // Request permission if not already granted
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                self.createNotification(for: appointment)
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    private func createNotification(for appointment: Appointment) {
        let center = UNUserNotificationCenter.current()
        
        // Calculate notification time based on reminder setting
        let notificationTime = appointment.date.addingTimeInterval(-appointment.reminder.timeInterval)
        
        // Only schedule if the notification time is in the future
        guard notificationTime > Date() else { return }
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Appointment Reminder", comment: "")
        content.body = String(format: NSLocalizedString("%@ - %@ in %@", comment: ""), appointment.title, appointment.type.localizedName, appointment.reminder.localizedName)
        content.sound = .default
        
        // Create trigger using date components
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create and add the request
        let request = UNNotificationRequest(
            identifier: "appointment-\(appointment.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func cancelNotification(for appointment: Appointment) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["appointment-\(appointment.id.uuidString)"])
    }
}

struct AppointmentsView: View {
    @EnvironmentObject var appointmentManager: AppointmentManager
    @State private var showingAddAppointment = false
    @State private var showingAllAppointments = false
    @State private var appointmentToEdit: Appointment?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: 
                    HStack {
                        Text("Upcoming Appointments")
                        Spacer()
                        Button("See All") {
                            showingAllAppointments = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                ) {
                    if appointmentManager.upcomingAppointments.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 10) {
                                Text("No upcoming appointments")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Button("Add Appointment") {
                                    showingAddAppointment = true
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 20)
                        .listRowBackground(Color.clear)
                    } else {
                        ForEach(appointmentManager.upcomingAppointments.prefix(5)) { appointment in
                            AppointmentRow(appointment: appointment)
                                .contextMenu {
                                    Button(action: {
                                        appointmentToEdit = appointment
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    Button(role: .destructive, action: {
                                        if let index = appointmentManager.upcomingAppointments.firstIndex(where: { $0.id == appointment.id }) {
                                            appointmentManager.deleteAppointment(at: IndexSet([index]), from: appointmentManager.upcomingAppointments)
                                        }
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onLongPressGesture {
                                    appointmentToEdit = appointment
                                }
                        }
                        .onDelete { indexSet in
                            appointmentManager.deleteAppointment(at: indexSet, from: appointmentManager.upcomingAppointments)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Appointments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddAppointment = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAppointment) {
                AddAppointmentView { newAppointment in
                    appointmentManager.addAppointment(newAppointment)
                }
            }
            .sheet(isPresented: $showingAllAppointments) {
                AllAppointmentsView()
            }
            .sheet(item: $appointmentToEdit) { appointment in
                EditAppointmentView(appointment: appointment) { updatedAppointment in
                    appointmentManager.updateAppointment(updatedAppointment)
                }
            }
        }
    }
}

struct AllAppointmentsView: View {
    @EnvironmentObject var appointmentManager: AppointmentManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddAppointment = false
    @State private var appointmentToEdit: Appointment?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Upcoming Appointments")) {
                    if appointmentManager.upcomingAppointments.isEmpty {
                        Text("No upcoming appointments")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                    } else {
                        ForEach(appointmentManager.upcomingAppointments) { appointment in
                            AppointmentRow(appointment: appointment)
                                .contextMenu {
                                    Button(action: {
                                        appointmentToEdit = appointment
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    Button(role: .destructive, action: {
                                        if let index = appointmentManager.upcomingAppointments.firstIndex(where: { $0.id == appointment.id }) {
                                            appointmentManager.deleteAppointment(at: IndexSet([index]), from: appointmentManager.upcomingAppointments)
                                        }
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onLongPressGesture {
                                    appointmentToEdit = appointment
                                }
                        }
                        .onDelete { indexSet in
                            appointmentManager.deleteAppointment(at: indexSet, from: appointmentManager.upcomingAppointments)
                        }
                    }
                }
                
                Section(header: Text("Past Appointments")) {
                    if appointmentManager.pastAppointments.isEmpty {
                        Text("No past appointments")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                    } else {
                        ForEach(appointmentManager.pastAppointments) { appointment in
                            AppointmentRow(appointment: appointment)
                                .contextMenu {
                                    Button(action: {
                                        appointmentToEdit = appointment
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    Button(role: .destructive, action: {
                                        if let index = appointmentManager.pastAppointments.firstIndex(where: { $0.id == appointment.id }) {
                                            appointmentManager.deleteAppointment(at: IndexSet([index]), from: appointmentManager.pastAppointments)
                                        }
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onLongPressGesture {
                                    appointmentToEdit = appointment
                                }
                        }
                        .onDelete { indexSet in
                            appointmentManager.deleteAppointment(at: indexSet, from: appointmentManager.pastAppointments)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("All Appointments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddAppointment = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAppointment) {
                AddAppointmentView { newAppointment in
                    appointmentManager.addAppointment(newAppointment)
                }
            }
            .sheet(item: $appointmentToEdit) { appointment in
                EditAppointmentView(appointment: appointment) { updatedAppointment in
                    appointmentManager.updateAppointment(updatedAppointment)
                }
            }
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(appointment.title)
                    .font(.headline)
                
                Spacer()
                
                Text(daysUntilAppointment(appointment.date))
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(dateFormatter.string(from: appointment.date))
                    .font(.subheadline)
            }
            
            if !appointment.location.isEmpty {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text(appointment.location)
                        .font(.subheadline)
                }
            }
            
            Text(appointment.type.localizedName)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(typeColor(for: appointment.type))
                .cornerRadius(4)
        }
        .padding(.vertical, 4)
    }
    
    func typeColor(for type: AppointmentType) -> Color {
        switch type {
        case .doctor:
            return .blue
        case .dentist:
            return .teal
        case .lab:
            return .purple
        case .therapy:
            return .green
        case .nutrition:
            return .orange
        case .pharmacy:
            return .red
        case .specialist:
            return .indigo
        case .physicalTherapy:
            return .mint
        case .other:
            return .gray
        }
    }
    
    func daysUntilAppointment(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }
        
        let components = calendar.dateComponents([.day], from: now, to: date)
        if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s")"
        } else {
            return "Past"
        }
    }
}

#Preview {
    AppointmentsView()
} 