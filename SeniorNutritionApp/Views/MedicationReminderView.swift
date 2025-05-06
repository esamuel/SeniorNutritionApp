import SwiftUI

struct MedicationReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingPermissionAlert = false
    @State private var notificationsEnabled = false
    
    var body: some View {
        NavigationView {
            List {
                // Header Section
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Medication Reminders")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        Text("Get notified when it's time to take your medications")
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                // Notification Permission Section
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Notifications")
                                .font(.system(size: userSettings.textSize.size))
                            
                            Text(notificationsEnabled ? "Enabled" : "Disabled")
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(notificationsEnabled ? .green : .red)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if notificationsEnabled {
                                // Open settings to let user disable notifications
                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsURL)
                                }
                            } else {
                                // Request notification permission
                                requestNotificationPermission()
                            }
                        }) {
                            Text(notificationsEnabled ? "Settings" : "Enable")
                                .font(.system(size: userSettings.textSize.size - 2))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(notificationsEnabled ? Color.blue.opacity(0.1) : Color.blue, in: RoundedRectangle(cornerRadius: 8))
                                .foregroundColor(notificationsEnabled ? .blue : .white)
                        }
                    }
                }
                
                // Medications with Reminders
                if !userSettings.medications.isEmpty {
                    Section(header: Text("Your Medications")) {
                        ForEach(userSettings.medications) { medication in
                            NavigationLink(destination: MedicationReminderDetailView(medication: medication)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(medication.name)
                                        .font(.system(size: userSettings.textSize.size))
                                    
                                    if !medication.timesOfDay.isEmpty {
                                        Text("Reminders: " + formatTimesOfDay(medication.timesOfDay))
                                            .font(.system(size: userSettings.textSize.size - 2))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
                
                // Information Section
                Section {
                    InfoRow(systemImage: "bell.fill", text: "You will receive a reminder 30 minutes before each scheduled time")
                    InfoRow(systemImage: "gear", text: "You can customize reminder times when adding or editing medications")
                    InfoRow(systemImage: "exclamationmark.triangle", text: "Make sure notifications are enabled in your device settings")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Medication Reminders", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") { dismiss() })
            .onAppear(perform: checkNotificationStatus)
            .alert(isPresented: $showingPermissionAlert) {
                Alert(
                    title: Text("Notifications Required"),
                    message: Text("To receive medication reminders, you need to enable notifications in your device settings."),
                    primaryButton: .default(Text("Open Settings")) {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    notificationsEnabled = true
                } else {
                    showingPermissionAlert = true
                }
            }
        }
    }
    
    private func formatTimesOfDay(_ times: [TimeOfDay]) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let calendar = Calendar.current
        
        return times.sorted().map { timeOfDay -> String in
            var components = DateComponents()
            components.hour = timeOfDay.hour
            components.minute = timeOfDay.minute
            if let date = calendar.date(from: components) {
                return formatter.string(from: date)
            } else {
                return String(format: "%02d:%02d", timeOfDay.hour, timeOfDay.minute)
            }
        }.joined(separator: ", ")
    }
}

// Helper Views
struct InfoRow: View {
    let systemImage: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct MedicationReminderDetailView: View {
    let medication: Medication
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingEditMedication = false
    
    var body: some View {
        List {
            // Medication Information
            Section(header: Text("Information")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(medication.name)
                        .foregroundColor(.secondary)
                }
                
                if !medication.dosage.isEmpty {
                    HStack {
                        Text("Dosage")
                        Spacer()
                        Text(medication.dosage)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Take with Food")
                    Spacer()
                    Text(medication.takeWithFood ? "Yes" : "No")
                        .foregroundColor(.secondary)
                }
            }
            
            // Reminder Schedule
            Section(header: Text("Schedule")) {
                VStack(alignment: .leading, spacing: 8) {
                    // Display frequency
                    switch medication.frequency {
                    case .daily:
                        Text("Frequency: Daily")
                    case .weekly(let days):
                        Text("Frequency: Weekly")
                        Text("Days: \(days.map { $0.shortName }.sorted().joined(separator: ", "))")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    case .interval(let days, let startDate):
                        Text("Frequency: Every \(days) days")
                        Text("Starting: \(formattedDate(startDate))")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    case .monthly(let day):
                        Text("Frequency: Monthly on day \(day)")
                    }
                }
                
                // Display reminder times
                ForEach(medication.timesOfDay.sorted(), id: \.self) { timeOfDay in
                    HStack {
                        Text(formatTime(timeOfDay))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("Reminder set")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            
            // Actions
            Section {
                Button {
                    showingEditMedication = true
                } label: {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Medication")
                    }
                    .foregroundColor(.blue)
                }
                
                Button {
                    scheduleMedicationNotifications(for: medication)
                } label: {
                    HStack {
                        Image(systemName: "bell.badge")
                        Text("Reset Notifications")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Reminder Details")
        .sheet(isPresented: $showingEditMedication) {
            EditMedicationView(medication: medication)
        }
    }
    
    private func formatTime(_ timeOfDay: TimeOfDay) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.hour = timeOfDay.hour
        components.minute = timeOfDay.minute
        if let date = calendar.date(from: components) {
            return formatter.string(from: date)
        } else {
            return String(format: "%02d:%02d", timeOfDay.hour, timeOfDay.minute)
        }
    }
    
    private func scheduleMedicationNotifications(for medication: Medication) {
        // Remove existing notifications for this medication
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [medication.id.uuidString])
        
        // Check if notification permission is granted
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            
            // Schedule new notifications
            let calendar = Calendar.current
            let now = Date()
            
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "Medication Reminder"
            content.body = "Time to take your \(medication.name) (\(medication.dosage))"
            content.sound = .default
            
            // Schedule notifications
            for timeOfDay in medication.timesOfDay {
                // Convert TimeOfDay to DateComponents
                var components = DateComponents()
                components.hour = timeOfDay.hour
                components.minute = timeOfDay.minute
                
                // Create trigger
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                // Create request with unique identifier per medication and time
                let requestID = "\(medication.id.uuidString)-\(timeOfDay.hour)-\(timeOfDay.minute)"
                let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)
                
                // Add the notification request
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
} 