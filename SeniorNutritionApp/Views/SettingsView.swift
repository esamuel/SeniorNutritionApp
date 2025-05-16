import SwiftUI
import CoreData
// Add import for our print preview views

// Main Settings View
struct SettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var showingHelpOptions = false
    @State private var showingPrintOptions = false
    @State private var showingResetAlert = false
    @State private var showingBackupInfoAlert = false // For backup/restore info
    @State private var showingOnboarding = false // NEW: controls onboarding sheet
    @State private var showingTranslationUtility = false
    enum BackupAlert: Identifiable {
        var id: String {
            switch self {
            case .backup: return "backup"
            case .restore: return "restore"
            }
        }
        case backup(message: String)
        case restore(message: String)
    }

    @State private var backupAlert: BackupAlert?
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var appointmentManager: AppointmentManager

    var body: some View {
        NavigationView {
            List {
                // Accessibility section
                Section(header: sectionHeader(NSLocalizedString("Accessibility", comment: ""))) {
                    // Text size picker
                    HStack {
                        Image(systemName: "textformat.size")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        Text(NSLocalizedString("Text Size", comment: ""))
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
                            
                            Text(NSLocalizedString("High Contrast Mode", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                    .padding(.vertical, 8)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    // Voice Settings Navigation
                    NavigationLink(destination: VoiceSettingsView()) {
                        settingsRowContent(
                            icon: "waveform.circle.fill", // Icon for voice settings
                            title: NSLocalizedString("Voice Settings", comment: ""),
                            color: .blue
                        )
                    }
                    
                    // Dark Mode Toggle
                    Toggle(isOn: $userSettings.isDarkMode) {
                        HStack {
                            Image(systemName: "moon.fill") // Icon for Dark Mode
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            Text(NSLocalizedString("Dark Mode", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                    .padding(.vertical, 8)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                // Language section
                Section(header: Text(NSLocalizedString("Language", comment: "")).font(.system(size: userSettings.textSize.size, weight: .bold))) {
                    Picker("App Language", selection: $userSettings.selectedLanguage) {
                        ForEach(userSettings.supportedLanguages, id: \.self) { code in
                            Text(languageDisplayName(for: code)).tag(code)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.system(size: userSettings.textSize.size))
                    .onChange(of: userSettings.selectedLanguage) { newLang in
                        LanguageManager.shared.setLanguage(newLang)
                    }
                    Button(action: {
                        // Explicitly force a refresh of the language system
                        Bundle.setLanguage(userSettings.selectedLanguage)
                        LanguageManager.shared.forceRefreshLocalization()
                        
                        // This will add a tiny delay to allow the refresh to propagate
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            // Create a small UI indication that something happened
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }
                    }) {
                        Label("Fix Language Issues", systemImage: "arrow.triangle.2.circlepath")
                            .padding(.vertical, 8)
                    }
                    Button("Reset to System Language") {
                        print("SettingsView: Reset to System Language pressed")
                        // First, reset in LanguageManager (which will handle removing from UserDefaults)
                        LanguageManager.shared.resetToSystemLanguage()
                        // Then ensure our view's state is updated
                        DispatchQueue.main.async {
                            // This ensures the UI reflects the change
                            userSettings.selectedLanguage = LanguageManager.shared.currentLanguage
                            print("SettingsView: selectedLanguage updated to: \(userSettings.selectedLanguage)")
                        }
                    }
                    .foregroundColor(.blue)
                    Text("Current app language: \(languageManager.currentLanguage)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Help & support section
                Section(header: sectionHeader(NSLocalizedString("Help & Support", comment: ""))) {
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
                Section(header: sectionHeader(NSLocalizedString("Additional Options", comment: ""))) {
                    NavigationLink(destination: NotificationsSettingsView()) {
                        settingsRowContent(
                            icon: "bell.fill",
                            title: NSLocalizedString("Notifications", comment: ""),
                            color: .orange
                        )
                    }
                    
                    // Revisit Onboarding Button
                    Button(action: { showingOnboarding = true }) {
                        settingsRowContent(
                            icon: "questionmark.circle.fill",
                            title: "Show Onboarding Again",
                            color: .blue
                        )
                    }
                    .sheet(isPresented: $showingOnboarding) {
                        OnboardingView(isFirstLaunch: false)
                            .environmentObject(userSettings)
                    }
                    
                    // Backup Data Section updated for local backup
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Local Backup")
                            .font(.headline)
                        Button(action: { exportLocalBackup() }) {
                            Text("Export Backup")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        Divider().padding(.vertical, 8)
                        Button(action: { importLocalBackup() }) {
                            Text("Import Backup")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Reset app Button
                    Button(action: { showingResetAlert = true }) {
                        settingsRowContent(
                            icon: "arrow.counterclockwise",
                            title: NSLocalizedString("Reset App", comment: ""),
                            color: .red
                        )
                    }
                }
                
                // About section
                Section(header: sectionHeader(NSLocalizedString("About", comment: ""))) {
                    HStack {
                        Text(NSLocalizedString("Version", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                        Spacer()
                        Text("1.0.0") // Example version
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text(NSLocalizedString("Privacy Policy", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: TermsOfUseView()) {
                        Text(NSLocalizedString("Terms of Service", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .padding(.vertical, 8)
                    }
                }
                
                // Add a button to trigger food translations in the settings
                Section(header: Text(NSLocalizedString("Development & Testing", comment: ""))) {
                    Button(action: {
                        // Present the translation utility
                        showingTranslationUtility = true
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                            Text(NSLocalizedString("Translate Food Database", comment: ""))
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Settings", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .listStyle(InsetGroupedListStyle())
            .alert("ARE YOU ABSOLUTELY SURE?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset App", role: .destructive) {
                    userSettings.resetAllSettings()
                    // TODO: Add reset actions for other data managers if needed
                }
            } message: {
                Text("Resetting the app will permanently delete ALL your data, including profile, medications, fasting history, and settings. This action cannot be undone.")
            }
            .alert("Backup & Restore Info", isPresented: $showingBackupInfoAlert) {
                Button("OK") { }
            } message: {
                Text("Your app data (settings, medications, etc.) is typically included in your device's standard backups (iCloud or computer backups) if you have enabled them in your device settings. Restore data by restoring your device from a backup.")
            }
            // New unified alert for backup and restore results
            .alert(item: $backupAlert) { alert in
                switch alert {
                case .backup(let message):
                    return Alert(title: Text("Backup Complete"), message: Text(message), dismissButton: .default(Text("OK")))
                case .restore(let message):
                    return Alert(title: Text("Restore Complete"), message: Text(message), dismissButton: .default(Text("OK")))
                }
            }
            .sheet(isPresented: $showingHelpOptions) {
                HelpOptionsView()
            }
            .sheet(isPresented: $showingPrintOptions) {
                PrintOptionsView()
            }
            .sheet(isPresented: $showingTranslationUtility) {
                TranslateAllFoodsView()
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
    
    // Helper function for language display names
    private func languageDisplayName(for code: String) -> String {
        switch code {
        case "en": return "English"
        case "es": return "Español"
        case "fr": return "Français"
        case "he": return "עברית"
        default: return code
        }
    }
    
    private func exportLocalBackup() {
        // For demonstration, using a stub for appData. Replace with actual app data retrieval as needed.
        let appData = AppData(userProfile: [], medications: [], appointments: [], emergencyContacts: [], bloodPressures: [], bloodSugars: [], heartRates: [], weights: [])
        do {
            try LocalDataManager.shared.backup(appData: appData)
            backupAlert = .backup(message: "Local backup exported successfully.")
        } catch {
            backupAlert = .backup(message: "Export backup failed: \(error)")
        }
    }
    
    private func importLocalBackup() {
        do {
            let restoredData = try LocalDataManager.shared.restore()
            backupAlert = .restore(message: "Local backup restored successfully. Restored data: \(restoredData)")
        } catch {
            backupAlert = .restore(message: "Import backup failed: \(error)")
        }
    }
}

// Notifications Settings View (Restored)
struct NotificationsSettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showSaveConfirmation = false
    
    var body: some View {
        List {
            Section(header: Text("Notification Settings").font(.system(size: userSettings.textSize.size, weight: .bold))) {
                Toggle("Medication Reminders", isOn: $userSettings.medicationRemindersEnabled)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
                if userSettings.medicationRemindersEnabled {
                    HStack {
                        Text("Reminder Lead Time")
                            .font(.system(size: userSettings.textSize.size - 2))
                        Spacer()
                        Picker("Lead Time", selection: $userSettings.medicationReminderLeadTime) {
                            ForEach([0, 5, 10, 15, 30, 45, 60, 90, 120], id: \ .self) { min in
                                Text("\(min) min").tag(min)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                    }
                }
                Toggle("Fasting Start/End Reminders", isOn: $userSettings.fastingRemindersEnabled)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
                Toggle("Meal Window Reminders", isOn: $userSettings.mealWindowRemindersEnabled)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
                Toggle("Daily Health Tips", isOn: $userSettings.dailyTipsEnabled)
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.vertical, 8)
            }
            Section(header: Text("Reminder Style").font(.system(size: userSettings.textSize.size, weight: .bold))) {
                Picker("Style", selection: $userSettings.notificationStyle) {
                    ForEach(NotificationStyle.allCases) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .tint(Color.blue)
            }
            Section {
                Button(action: {
                    NotificationManager.shared.updateAllNotifications(userSettings: userSettings)
                    showSaveConfirmation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSaveConfirmation = false
                    }
                }) {
                    Text("Save Settings")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.vertical, 8)
                if showSaveConfirmation {
                    HStack {
                        Spacer()
                        Text("Settings Saved!")
                            .foregroundColor(.green)
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        Spacer()
                    }
                    .transition(.opacity)
                }
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(InsetGroupedListStyle())
    }
}

// Help Options View (Restored)
struct HelpOptionsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(NSLocalizedString("Connect with Support", comment: ""))) {
                    helpOptionButton(
                        icon: "phone.fill",
                        title: NSLocalizedString("Call Support", comment: ""),
                        description: NSLocalizedString("Speak with our dedicated senior support team", comment: ""),
                        action: { /* Call support action */ }
                    )
                    
                    helpOptionButton(
                        icon: "message.fill",
                        title: NSLocalizedString("Send Message", comment: ""),
                        description: NSLocalizedString("Send a text message for non-urgent help", comment: ""),
                        action: { /* Send message action */ }
                    )
                    
                    helpOptionButton(
                        icon: "video.fill",
                        title: NSLocalizedString("Video Assistance", comment: ""),
                        description: NSLocalizedString("Schedule a live video call for personalized help", comment: ""),
                        action: { /* Video chat action */ }
                    )
                }
                
                Section(header: Text(NSLocalizedString("Self-Help Resources", comment: ""))) {
                    helpOptionButton(
                        icon: "questionmark.circle.fill",
                        title: NSLocalizedString("Interactive App Tour", comment: ""),
                        description: NSLocalizedString("Get a guided walkthrough of app features", comment: ""),
                        action: { /* Restart tour action */ }
                    )
                    
                    helpOptionButton(
                        icon: "doc.text.fill",
                        title: NSLocalizedString("Help Documentation", comment: ""),
                        description: NSLocalizedString("Access detailed user guides and FAQs", comment: ""),
                        action: { /* Open documentation action */ }
                    )
                    
                    helpOptionButton(
                        icon: "play.rectangle.fill",
                        title: NSLocalizedString("Video Tutorials", comment: ""),
                        description: NSLocalizedString("Watch step-by-step instructional videos", comment: ""),
                        action: { /* Open video tutorials action */ }
                    )
                }
                
                Section(header: Text(NSLocalizedString("Health & Appointments", comment: ""))) {
                    helpOptionButton(
                        icon: "heart.text.square.fill",
                        title: NSLocalizedString("Health Tracking Guide", comment: ""),
                        description: NSLocalizedString("Learn how to monitor vitals and analyze data", comment: ""),
                        action: { /* Open health guide action */ }
                    )
                    
                    helpOptionButton(
                        icon: "calendar.badge.plus",
                        title: NSLocalizedString("Appointment Management", comment: ""),
                        description: NSLocalizedString("How to schedule and track medical visits", comment: ""),
                        action: { /* Open appointment guide action */ }
                    )
                    
                    helpOptionButton(
                        icon: "square.and.arrow.up",
                        title: NSLocalizedString("Sharing Health Data", comment: ""),
                        description: NSLocalizedString("Securely share records with healthcare providers", comment: ""),
                        action: { /* Open sharing guide action */ }
                    )
                }
                
                Section(header: Text(NSLocalizedString("Accessibility Support", comment: ""))) {
                    helpOptionButton(
                        icon: "ear.fill",
                        title: NSLocalizedString("Voice Assistance", comment: ""),
                        description: NSLocalizedString("Get help with voice navigation settings", comment: ""),
                        action: { /* Voice assistance action */ }
                    )
                    
                    helpOptionButton(
                        icon: "textformat.size",
                        title: NSLocalizedString("Text Size Help", comment: ""),
                        description: NSLocalizedString("Adjust the app for better readability", comment: ""),
                        action: { /* Text size help action */ }
                    )
                    
                    helpOptionButton(
                        icon: "hand.raised.fill",
                        title: NSLocalizedString("Gesture Controls", comment: ""),
                        description: NSLocalizedString("Learn about simplified touch controls", comment: ""),
                        action: { /* Gesture controls help action */ }
                    )
                }
            }
            .navigationTitle(NSLocalizedString("Get Help", comment: ""))
            .navigationBarTitleDisplayMode(.large)
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "")) {
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

// Print Preview Sheet with direct printing functionality
struct PrintPreviewSheet: View {
    let type: PrintOptionsView.PrintPreviewType
    let onPrint: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var userSettings: UserSettings
    
    // State to control the print action sheet
    @State private var showingPrintOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        switch type {
                        case .medication:
                            MedicationPrintPreview()
                                .environmentObject(userSettings)
                                .id("medicationPreview") // Add id for printing reference
                        case .fasting:
                            FastingProtocolPreview()
                                .environmentObject(userSettings)
                                .id("fastingPreview")
                        case .meals:
                            MealSuggestionsPreview()
                                .id("mealsPreview")
                        case .instructions:
                            AppInstructionsPreview()
                                .id("instructionsPreview")
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
                        // Show the print options directly
                        showingPrintOptions = true
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
            .background(
                // This is a hidden view that handles the actual printing
                PrintingBridge(isPresented: $showingPrintOptions, content: getContentForPrinting())
            )
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
    
    private func getContentForPrinting() -> AnyView {
        switch type {
        case .medication:
            return AnyView(MedicationPrintPreview().environmentObject(userSettings))
        case .fasting:
            return AnyView(FastingProtocolPreview().environmentObject(userSettings))
        case .meals:
            return AnyView(MealSuggestionsPreview())
        case .instructions:
            return AnyView(AppInstructionsPreview())
        }
    }
}

// UIKit bridge for printing SwiftUI views
struct PrintingBridge: UIViewRepresentable {
    @Binding var isPresented: Bool
    let content: AnyView

    // Diagnostic state for fallback alert
    class Coordinator: NSObject {
        var didShowPrint = false
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if isPresented {
            // Reset the flag
            isPresented = false
            
            // Create a hosting controller for the SwiftUI content
            let hostingController = UIHostingController(rootView: content)
            let printContent = hostingController.view!
            
            // Set a reasonable size for the content
            let pageWidth = UIScreen.main.bounds.width
            printContent.frame = CGRect(x: 0, y: 0, width: pageWidth, height: 1000)
            printContent.backgroundColor = .white
            
            // Allow the view to layout its contents
            printContent.layoutIfNeeded()
            
            // Create a print info object
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .general
            printInfo.jobName = "Senior Nutrition App Document"
            
            // Create a print controller
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.printFormatter = printContent.viewPrintFormatter()
            
            // Find the top-most view controller
            let topController = topMostViewController()
            print("[Print Debug] Top-most VC: \(String(describing: topController))")
            
            DispatchQueue.main.async {
                if let topVC = topController {
                    print("[Print Debug] Presenting print dialog from top-most VC")
                    printController.present(from: topVC.view.bounds, in: topVC.view, animated: true, completionHandler: { (controller, completed, error) in
                        if let error = error {
                            print("[Print Debug] Printing error: \(error.localizedDescription)")
                        }
                        if completed {
                            print("[Print Debug] Print dialog was shown successfully.")
                        } else {
                            print("[Print Debug] Print dialog was NOT shown (user cancelled or error)")
                        }
                    })
                } else {
                    print("[Print Debug] No top-most VC found. Falling back to present(animated:)")
                    printController.present(animated: true, completionHandler: { (controller, completed, error) in
                        if let error = error {
                            print("[Print Debug] Printing error: \(error.localizedDescription)")
                        }
                        if completed {
                            print("[Print Debug] Print dialog was shown successfully.")
                        } else {
                            print("[Print Debug] Print dialog was NOT shown (user cancelled or error)")
                        }
                    })
                }
            }
        }
    }

    // Helper to get the top-most UIViewController
    private func topMostViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }
        return base
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