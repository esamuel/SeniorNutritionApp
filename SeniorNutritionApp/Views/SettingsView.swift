import SwiftUI

// Main Settings View
struct SettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingHelpOptions = false
    @State private var showingPrintOptions = false
    @State private var showingResetAlert = false
    @State private var showingBackupInfoAlert = false // For backup/restore info

    var body: some View {
        NavigationView {
            List {
                // Accessibility section
                Section(header: sectionHeader("Accessibility")) {
                    // Text size picker
                    HStack {
                        Image(systemName: "textformat.size")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        Text("Text Size")
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        Picker("", selection: $userSettings.textSize) {
                            ForEach(TextSize.allCases) { size in
                                Text(size.rawValue).tag(size)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.system(size: userSettings.textSize.size))
                    }
                    .padding(.vertical, 8)
                    
                    // High contrast mode
                    Toggle(isOn: $userSettings.highContrastMode) {
                        HStack {
                            Image(systemName: "circle.lefthalf.filled") // Corrected icon
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            Text("High Contrast Mode")
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                    .padding(.vertical, 8)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    // Voice Settings Navigation
                    NavigationLink(destination: VoiceSettingsView()) {
                        settingsRowContent(
                            icon: "waveform.circle.fill", // Icon for voice settings
                            title: "Voice Settings",
                            color: .blue
                        )
                    }
                    
                    // Dark Mode Toggle
                    Toggle(isOn: $userSettings.isDarkMode) {
                        HStack {
                            Image(systemName: "moon.fill") // Icon for Dark Mode
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            Text("Dark Mode")
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                    .padding(.vertical, 8)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                // Help & support section
                Section(header: sectionHeader("Help & Support")) {
                    settingsRow(
                        icon: "video.fill",
                        title: "Video Tutorials",
                        color: .red,
                        action: { /* Show video tutorials */ }
                    )
                    
                    settingsRow(
                        icon: "person.fill.questionmark",
                        title: "Get Live Support",
                        color: .green,
                        action: { showingHelpOptions = true }
                    )
                    
                    settingsRow(
                        icon: "printer.fill",
                        title: "Print Instructions",
                        color: .purple,
                        action: { showingPrintOptions = true }
                    )
                }
                
                // Additional options section
                Section(header: sectionHeader("Additional Options")) {
                    NavigationLink(destination: NotificationsSettingsView()) {
                        settingsRowContent(
                            icon: "bell.fill",
                            title: "Notifications",
                            color: .orange
                        )
                    }
                    
                    // Backup Data Button
                    Button(action: { showingBackupInfoAlert = true }) {
                        settingsRowContent(
                            icon: "arrow.clockwise", // Changed icon for consistency
                            title: "Backup Data",
                            color: .orange
                        )
                    }
                    
                    // Restore Data Button
                    Button(action: { showingBackupInfoAlert = true }) {
                        settingsRowContent(
                            icon: "arrow.clockwise", // Changed icon for consistency
                            title: "Restore Data",
                            color: .orange
                        )
                    }
                    
                    // Reset app Button
                    Button(action: { showingResetAlert = true }) {
                        settingsRowContent(
                            icon: "arrow.counterclockwise",
                            title: "Reset App",
                            color: .red
                        )
                    }
                }
                
                // About section
                Section(header: sectionHeader("About")) {
                    HStack {
                        Text("Version")
                            .font(.system(size: userSettings.textSize.size))
                        Spacer()
                        Text("1.0.0") // Example version
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                            .font(.system(size: userSettings.textSize.size))
                            .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: TermsOfUseView()) {
                        Text("Terms of Service")
                            .font(.system(size: userSettings.textSize.size))
                            .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(InsetGroupedListStyle())
            .alert("ARE YOU ABSOLUTELY SURE?", isPresented: $showingResetAlert) { // Strengthened Reset Alert
                Button("Cancel", role: .cancel) { }
                Button("Reset App", role: .destructive) {
                    userSettings.resetAllSettings()
                    // TODO: Add reset actions for other data managers if needed
                }
            } message: {
                Text("Resetting the app will permanently delete ALL your data, including profile, medications, fasting history, and settings. This action cannot be undone.")
            }
            .alert("Backup & Restore Info", isPresented: $showingBackupInfoAlert) { // Backup Info Alert
                Button("OK") { }
            } message: {
                Text("Your app data (settings, medications, etc.) is typically included in your device's standard backups (iCloud or computer backups) if you have enabled them in your device settings. Restore data by restoring your device from a backup.")
            }
            .sheet(isPresented: $showingHelpOptions) {
                HelpOptionsView()
            }
            .sheet(isPresented: $showingPrintOptions) {
                PrintOptionsView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Helper for section headers
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: userSettings.textSize.size, weight: .bold))
            .foregroundColor(.primary)
            .padding(.top, 10)
    }
    
    // Helper for setting rows with action
    private func settingsRow(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            settingsRowContent(icon: icon, title: title, color: color)
        }
    }
    
    // Helper for settings row content (used by Button and NavigationLink)
    private func settingsRowContent(icon: String, title: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Only show chevron for NavigationLinks implicitly
            // For Buttons, we don't need an explicit chevron
            // Image(systemName: "chevron.right").foregroundColor(.gray).font(.system(size: 14))
        }
        .padding(.vertical, 8) // Apply padding here for consistent row height
        .contentShape(Rectangle()) // Ensures the whole row is tappable for Buttons
    }
}

// Notifications Settings View (Restored)
struct NotificationsSettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    // Add @State vars tied to UserSettings for actual functionality
    @State private var medicationReminders = true
    @State private var fastingReminders = true
    @State private var mealWindowReminders = true
    @State private var dailyTips = true
    
    var body: some View {
        List {
            Section(header: Text("Notification Settings").font(.system(size: userSettings.textSize.size, weight: .bold))) {
                Toggle("Medication Reminders", isOn: $medicationReminders)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
                
                Toggle("Fasting Start/End", isOn: $fastingReminders)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
                
                Toggle("Meal Window Reminders", isOn: $mealWindowReminders)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
                
                Toggle("Daily Health Tips", isOn: $dailyTips)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
            }
            
            // Reminder Style section needs actual state/logic
            Section(header: Text("Reminder Style").font(.system(size: userSettings.textSize.size, weight: .bold))) {
                 notificationStyleButton(title: "Regular", description: "Standard notifications", isSelected: true) // Example selection
                 notificationStyleButton(title: "Gentle", description: "Quieter, less intrusive notifications", isSelected: false)
                 notificationStyleButton(title: "Urgent", description: "More noticeable for important reminders", isSelected: false)
            }
            
            Section {
                Button(action: { /* Save notification settings */ }) {
                    Text("Save Settings")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(InsetGroupedListStyle())
    }
    
    // Notification style selection button (needs state management)
    private func notificationStyleButton(title: String, description: String, isSelected: Bool) -> some View {
        Button(action: { /* Select this style */ }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Text(description)
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain) // Use plain style to avoid default button appearance in List
    }
}

// Help Options View (Restored)
struct HelpOptionsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    helpOptionButton(
                        icon: "phone.fill",
                        title: "Call Support",
                        description: "Speak with our support team",
                        action: { /* Call support action */ }
                    )
                    
                    helpOptionButton(
                        icon: "message.fill",
                        title: "Send Message",
                        description: "Send us a message for help",
                        action: { /* Send message action */ }
                    )
                    
                    helpOptionButton(
                        icon: "video.fill",
                        title: "Video Chat",
                        description: "Schedule a video call with support",
                        action: { /* Video chat action */ }
                    )
                    
                    helpOptionButton(
                        icon: "questionmark.circle.fill",
                        title: "Guided Tour",
                        description: "Restart the app tour",
                        action: { /* Restart tour action */ }
                    )
                }
            }
            .navigationTitle("Get Help")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    // Help option button
    private func helpOptionButton(icon: String, title: String, description: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.green) // Changed color for Help section
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// Print Options View (Incorporating previous alert changes)
struct PrintOptionsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    // State for confirmation alerts
    @State private var showMedicationPrintAlert = false
    @State private var showFastingPrintAlert = false
    @State private var showMealsPrintAlert = false
    @State private var showInstructionsPrintAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    printOptionButton(
                        title: "Medication Schedule",
                        description: "Print your current medication schedule",
                        icon: "pill.fill",
                        action: { // Action for Medication Schedule
                            alertTitle = "Print Medication Schedule?"
                            alertMessage = "This would send your medication schedule to the printer."
                            showMedicationPrintAlert = true
                        }
                    )
                    
                    printOptionButton(
                        title: "Fasting Guide",
                        description: "Print your fasting protocol guide",
                        icon: "timer",
                        action: { // Action for Fasting Guide
                            alertTitle = "Print Fasting Guide?"
                            alertMessage = "This would send your fasting guide to the printer."
                            showFastingPrintAlert = true
                        }
                    )
                    
                    printOptionButton(
                        title: "Meal Suggestions",
                        description: "Print healthy meal suggestions",
                        icon: "fork.knife",
                        action: { // Action for Meal Suggestions
                            alertTitle = "Print Meal Suggestions?"
                            alertMessage = "This would send meal suggestions to the printer."
                            showMealsPrintAlert = true
                        }
                    )
                    
                    printOptionButton(
                        title: "App Instructions",
                        description: "Print step-by-step app instructions",
                        icon: "doc.text.fill",
                        action: { // Action for App Instructions
                            alertTitle = "Print App Instructions?"
                            alertMessage = "This would send the app instructions to the printer."
                            showInstructionsPrintAlert = true
                        }
                    )
                }
            }
            .navigationTitle("Print Materials")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            // Add alerts for each print option
            .alert(alertTitle, isPresented: $showMedicationPrintAlert, actions: { printAlertActions() }, message: { Text(alertMessage) })
            .alert(alertTitle, isPresented: $showFastingPrintAlert, actions: { printAlertActions() }, message: { Text(alertMessage) })
            .alert(alertTitle, isPresented: $showMealsPrintAlert, actions: { printAlertActions() }, message: { Text(alertMessage) })
            .alert(alertTitle, isPresented: $showInstructionsPrintAlert, actions: { printAlertActions() }, message: { Text(alertMessage) })
        }
    }
    
    // Helper for alert actions
    @ViewBuilder
    private func printAlertActions() -> some View {
        Button("Cancel", role: .cancel) { }
        Button("Print") { /* Actual print logic would go here */ }
    }
    
    // Print option button (updated to include action closure)
    private func printOptionButton(title: String, description: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { // Use the passed-in action
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.purple) // Changed color for Print section
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "printer.fill") // Keep printer icon indicator
                    .foregroundColor(.purple)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// Preview Provider (Restored)
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserSettings()) // Provide environment object for preview
    }
}
#endif