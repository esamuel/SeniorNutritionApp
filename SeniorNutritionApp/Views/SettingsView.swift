import SwiftUI
import UIKit
// Add import for our print preview views

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
                Section(header: Text("Connect with Support")) {
                    helpOptionButton(
                        icon: "phone.fill",
                        title: "Call Support",
                        description: "Speak with our dedicated senior support team",
                        action: { /* Call support action */ }
                    )
                    
                    helpOptionButton(
                        icon: "message.fill",
                        title: "Send Message",
                        description: "Send a text message for non-urgent help",
                        action: { /* Send message action */ }
                    )
                    
                    helpOptionButton(
                        icon: "video.fill",
                        title: "Video Assistance",
                        description: "Schedule a live video call for personalized help",
                        action: { /* Video chat action */ }
                    )
                }
                
                Section(header: Text("Self-Help Resources")) {
                    helpOptionButton(
                        icon: "questionmark.circle.fill",
                        title: "Interactive App Tour",
                        description: "Get a guided walkthrough of app features",
                        action: { /* Restart tour action */ }
                    )
                    
                    helpOptionButton(
                        icon: "doc.text.fill",
                        title: "Help Documentation",
                        description: "Access detailed user guides and FAQs",
                        action: { /* Open documentation action */ }
                    )
                    
                    helpOptionButton(
                        icon: "play.rectangle.fill",
                        title: "Video Tutorials",
                        description: "Watch step-by-step instructional videos",
                        action: { /* Open video tutorials action */ }
                    )
                }
                
                Section(header: Text("Health & Appointments")) {
                    helpOptionButton(
                        icon: "heart.text.square.fill",
                        title: "Health Tracking Guide",
                        description: "Learn how to monitor vitals and analyze data",
                        action: { /* Open health guide action */ }
                    )
                    
                    helpOptionButton(
                        icon: "calendar.badge.plus",
                        title: "Appointment Management",
                        description: "How to schedule and track medical visits",
                        action: { /* Open appointment guide action */ }
                    )
                    
                    helpOptionButton(
                        icon: "square.and.arrow.up",
                        title: "Sharing Health Data",
                        description: "Securely share records with healthcare providers",
                        action: { /* Open sharing guide action */ }
                    )
                }
                
                Section(header: Text("Accessibility Support")) {
                    helpOptionButton(
                        icon: "ear.fill",
                        title: "Voice Assistance",
                        description: "Get help with voice navigation settings",
                        action: { /* Voice assistance action */ }
                    )
                    
                    helpOptionButton(
                        icon: "textformat.size",
                        title: "Text Size Help",
                        description: "Adjust the app for better readability",
                        action: { /* Text size help action */ }
                    )
                    
                    helpOptionButton(
                        icon: "hand.raised.fill",
                        title: "Gesture Controls",
                        description: "Learn about simplified touch controls",
                        action: { /* Gesture controls help action */ }
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
    @State private var showPrintHelpAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // State for previews
    @State private var selectedPreview: PrintPreviewType?
    @State private var showPreview = false
    
    enum PrintPreviewType {
        case medication
        case fasting
        case meals
        case instructions
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    printOptionButton(
                        title: "Medication Schedule",
                        description: "Print your current medication schedule",
                        icon: "pill.fill",
                        action: { // Action for Medication Schedule
                            selectedPreview = .medication
                            showPreview = true
                        }
                    )
                    
                    printOptionButton(
                        title: "Fasting Guide",
                        description: "Print your fasting protocol guide",
                        icon: "timer",
                        action: { // Action for Fasting Guide
                            selectedPreview = .fasting
                            showPreview = true
                        }
                    )
                    
                    printOptionButton(
                        title: "Meal Suggestions",
                        description: "Print healthy meal suggestions",
                        icon: "fork.knife",
                        action: { // Action for Meal Suggestions
                            selectedPreview = .meals
                            showPreview = true
                        }
                    )
                    
                    printOptionButton(
                        title: "App Instructions",
                        description: "Print step-by-step app instructions",
                        icon: "doc.text.fill",
                        action: { // Action for App Instructions
                            selectedPreview = .instructions
                            showPreview = true
                        }
                    )
                }
                
                Section {
                    Button(action: {
                        showPrintHelpAlert = true
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            Text("Help with Printing")
                                .font(.system(size: userSettings.textSize.size))
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
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
            .alert("Printing Instructions", isPresented: $showPrintHelpAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(MedicationPrintService.shared.showPrintingInstructions())
            }
            .sheet(isPresented: $showPreview) {
                PrintPreviewSheet(
                    type: selectedPreview ?? .medication,
                    onPrint: {
                        switch selectedPreview {
                        case .medication:
                            let medications = userSettings.medications.isEmpty ? [] : userSettings.medications
                            MedicationPrintService.shared.printMedicationSchedule(medications: medications)
                        case .fasting:
                            MedicationPrintService.shared.printFastingProtocol(protocol: userSettings.activeFastingProtocol)
                        case .meals:
                            MedicationPrintService.shared.printMealSuggestions()
                        case .instructions:
                            MedicationPrintService.shared.printAppInstructions()
                        case .none:
                            break
                        }
                    }
                )
                .environmentObject(userSettings)
            }
        }
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

// Print Preview Sheet 
struct PrintPreviewSheet: View {
    let type: PrintOptionsView.PrintPreviewType
    let onPrint: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        switch type {
                        case .medication:
                            MedicationPrintPreview()
                                .environmentObject(userSettings)
                        case .fasting:
                            FastingProtocolPreview()
                                .environmentObject(userSettings)
                        case .meals:
                            MealSuggestionsPreview()
                        case .instructions:
                            AppInstructionsPreview()
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                HStack(spacing: 20) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.gray)
                            .font(.system(size: userSettings.textSize.size))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        onPrint()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "printer.fill")
                            Text("Print")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: userSettings.textSize.size))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle(getTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    private func getTitle() -> String {
        switch type {
        case .medication:
            return "Medication Schedule"
        case .fasting:
            return "Fasting Protocol Guide"
        case .meals:
            return "Meal Suggestions"
        case .instructions:
            return "App Instructions"
        }
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