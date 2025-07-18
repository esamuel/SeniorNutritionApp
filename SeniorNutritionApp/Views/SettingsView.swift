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
    @State private var showingFirstTimeGuide = false // NEW: controls first-time guide sheet
    @State private var showingTranslationUtility = false
    @State private var showingAppTourResetAlert = false
    @State private var showingVideoTutorials = false
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
                    // Language picker with navigation
                    NavigationLink(destination: LanguageSelectorView()) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(NSLocalizedString("App Language", comment: ""))
                                    .font(.system(size: userSettings.textSize.size))
                                
                                HStack {
                                    Text(getFlagEmoji(for: userSettings.selectedLanguage))
                                        .font(.title3)
                                    Text(languageDisplayName(for: userSettings.selectedLanguage))
                                        .font(.system(size: userSettings.textSize.size - 2))
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
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
                        Label(NSLocalizedString("Fix Language Issues", comment: ""), systemImage: "arrow.triangle.2.circlepath")
                            .padding(.vertical, 8)
                    }
                    
                    // Add food database translation button
                    Button(action: {
                        // Force translate all food items to current language
                        Task {
                            let foodDatabase = FoodDatabaseService()
                            _ = await foodDatabase.translateAllFoodItems()
                            
                            // Provide user feedback
                            DispatchQueue.main.async {
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                            }
                        }
                    }) {
                        Label(NSLocalizedString("Translate Food Database", comment: ""), systemImage: "globe.badge.chevron.backward")
                            .padding(.vertical, 8)
                    }
                    Button(action: {
                        print("SettingsView: Reset to System Language pressed")
                        // First, reset in LanguageManager (which will handle removing from UserDefaults)
                        LanguageManager.shared.resetToSystemLanguage()
                        // Then ensure our view's state is updated
                        DispatchQueue.main.async {
                            // This ensures the UI reflects the change
                            userSettings.selectedLanguage = LanguageManager.shared.currentLanguage
                            print("SettingsView: selectedLanguage updated to: \(userSettings.selectedLanguage)")
                        }
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                            Text(NSLocalizedString(languageManager.followSystemLanguage ? "Using System Language" : "Use System Language", comment: ""))
                                .foregroundColor(.blue)
                            if languageManager.followSystemLanguage {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    if languageManager.followSystemLanguage {
                        Text(NSLocalizedString("App language will automatically follow system language", comment: ""))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text(String(format: NSLocalizedString("Current app language: %@", comment: ""), languageManager.currentLanguage))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Emergency Number section
                Section(header: sectionHeader(NSLocalizedString("Emergency Number", comment: ""))) {
                    VStack(alignment: .leading, spacing: 12) {
                        // Show detected emergency number
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(NSLocalizedString("Detected for your region", comment: ""))
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                Text("\(userSettings.getDetectedEmergencyInfo().name): \(userSettings.getDetectedEmergencyInfo().number)")
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        
                        Divider()
                        
                        // Toggle for custom emergency number
                        Toggle(NSLocalizedString("Use Custom Emergency Number", comment: ""), isOn: $userSettings.useCustomEmergencyNumber)
                            .font(.system(size: userSettings.textSize.size))
                        
                        // Custom emergency number input
                        if userSettings.useCustomEmergencyNumber {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(NSLocalizedString("Custom Emergency Number", comment: ""))
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                TextField(NSLocalizedString("Enter emergency number", comment: ""), text: Binding(
                                    get: { userSettings.customEmergencyNumber ?? "" },
                                    set: { userSettings.customEmergencyNumber = $0.isEmpty ? nil : $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                                .font(.system(size: userSettings.textSize.size))
                                
                                Text(NSLocalizedString("Make sure this is the correct emergency number for your location", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 4))
                                    .foregroundColor(.orange)
                                    .padding(.top, 4)
                            }
                        }
                        
                        // Show currently active emergency number
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.red)
                                .frame(width: 30)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(NSLocalizedString("Currently active", comment: ""))
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                Text("\(userSettings.getEffectiveEmergencyServiceName()): \(userSettings.getEffectiveEmergencyNumber())")
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Help & support section
                Section(header: sectionHeader(NSLocalizedString("Help & Support", comment: ""))) {
                    Button(action: { showingVideoTutorials = true }) {
                        settingsRowContent(
                            icon: "video.fill",
                            title: NSLocalizedString("Video Tutorials", comment: ""),
                            color: .red
                        )
                    }
                    .sheet(isPresented: $showingVideoTutorials) {
                        VideoTutorialsView()
                            .environmentObject(userSettings)
                    }
                    
                    settingsRow(
                        icon: "printer.fill",
                        title: NSLocalizedString("Print Instructions", comment: ""),
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
                    
                    // First-Time Setup Guide Button
                    Button(action: { showingFirstTimeGuide = true }) {
                        settingsRowContent(
                            icon: "person.badge.plus",
                            title: NSLocalizedString("First-Time Setup Guide", comment: ""),
                            color: .green
                        )
                    }
                    .sheet(isPresented: $showingFirstTimeGuide) {
                        FirstTimeUserGuideView()
                            .environmentObject(userSettings)
                    }
                    
                    // Revisit Onboarding Button
                    Button(action: { showingOnboarding = true }) {
                        settingsRowContent(
                            icon: "questionmark.circle.fill",
                            title: NSLocalizedString("Show Onboarding Again", comment: ""),
                            color: .blue
                        )
                    }
                    .sheet(isPresented: $showingOnboarding) {
                        OnboardingView(isFirstLaunch: false)
                            .environmentObject(userSettings)
                    }
                    
                    // Backup Data Section updated for local backup
                    VStack(alignment: .leading, spacing: 16) {
                        Text(NSLocalizedString("Local Backup", comment: ""))
                            .font(.headline)
                        Button(action: { exportLocalBackup() }) {
                            Text(NSLocalizedString("Export Backup", comment: ""))
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        Divider().padding(.vertical, 8)
                        Button(action: { importLocalBackup() }) {
                            Text(NSLocalizedString("Import Backup", comment: ""))
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
                    NavigationLink(destination: AboutView()) {
                        settingsRowContent(
                            icon: "info.circle.fill",
                            title: NSLocalizedString("About the App", comment: ""),
                            color: .blue
                        )
                    }
                    
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
                    
                    // App Preview Recording
                    #if DEBUG
                    NavigationLink(destination: AppPreviewRecordingView()) {
                        HStack {
                            Image(systemName: "video.fill")
                                .foregroundColor(.red)
                            Text("App Preview Recording")
                        }
                    }
                    #endif
                    
                    // Debug Subscription Tier Switcher
                    #if DEBUG
                    DebugSubscriptionTierSwitcher()
                    #endif
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
            .alert("App Tour Reset", isPresented: $showingAppTourResetAlert) {
                Button("OK") { }
            } message: {
                Text("App tour has been reset. The tour will be shown again the next time you launch the app.")
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
    
    // Helper function to get flag emoji for language code
    private func getFlagEmoji(for code: String) -> String {
        switch code {
        case "en": return "🇺🇸"
        case "he": return "🇮🇱"
        case "es": return "🇪🇸"
        case "fr": return "🇫🇷"
        default: return "🌐"
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
                            ForEach([0, 5, 10, 15, 30, 45, 60, 90, 120], id: \.self) { min in
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
                
                // Explanation for each style
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("Reminder Style Explanation:", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    switch userSettings.notificationStyle {
                    case .gentle:
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "bell.slash.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(NSLocalizedString("Gentle", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 2, weight: .medium))
                                Text(NSLocalizedString("Silent notifications with visual alerts only. No sound or vibration.", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 4))
                                    .foregroundColor(.secondary)
                            }
                        }
                    case .regular:
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(NSLocalizedString("Regular", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 2, weight: .medium))
                                Text(NSLocalizedString("Standard notification sound with visual alerts. Balanced approach.", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 4))
                                    .foregroundColor(.secondary)
                            }
                        }
                    case .urgent:
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(NSLocalizedString("Urgent", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 2, weight: .medium))
                                Text(NSLocalizedString("Critical alert sound that bypasses Do Not Disturb. Use for important medications.", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 4))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section {
                Button(action: {
                    // Save settings and update notifications
                    Task { @MainActor in
                        NotificationManager.shared.updateAllNotifications(userSettings: userSettings)
                        
                        // Show confirmation
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSaveConfirmation = true
                        }
                        
                        // Hide confirmation after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSaveConfirmation = false
                            }
                        }
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
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(NSLocalizedString("Settings Saved!", comment: ""))
                                .foregroundColor(.green)
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        }
                        Spacer()
                    }
                    .transition(.opacity.combined(with: .scale))
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
                        title: NSLocalizedString("Medication Schedule", comment: ""),
                        description: NSLocalizedString("Print your current medication schedule", comment: ""),
                        icon: "pill.fill",
                        action: { // Action for Medication Schedule
                            selectedPreview = .medication
                            showPreview = true
                        }
                    )
                    
                    printOptionButton(
                        title: NSLocalizedString("Fasting Guide", comment: ""),
                        description: NSLocalizedString("Print your fasting protocol guide", comment: ""),
                        icon: "timer",
                        action: { // Action for Fasting Guide
                            selectedPreview = .fasting
                            showPreview = true
                        }
                    )
                    
                    printOptionButton(
                        title: NSLocalizedString("Meal Suggestions", comment: ""),
                        description: NSLocalizedString("Print healthy meal suggestions", comment: ""),
                        icon: "fork.knife",
                        action: { // Action for Meal Suggestions
                            selectedPreview = .meals
                            showPreview = true
                        }
                    )
                    
                    printOptionButton(
                        title: NSLocalizedString("App Instructions", comment: ""),
                        description: NSLocalizedString("Print step-by-step app instructions", comment: ""),
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
                            
                            Text(NSLocalizedString("Help with Printing", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Print Materials", comment: ""))
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
            .alert(NSLocalizedString("Help with Printing", comment: ""), isPresented: $showPrintHelpAlert) {
                Button(NSLocalizedString("OK", comment: ""), role: .cancel) { }
            } message: {
                Text(NSLocalizedString("print_instructions_help", comment: ""))
            }
            .sheet(isPresented: $showPreview) {
                PrintPreviewSheet(type: selectedPreview ?? .medication)
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
                        Text(NSLocalizedString("Cancel", comment: ""))
                            .foregroundColor(.gray)
                            .font(.system(size: userSettings.textSize.size))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Call the print service directly
                        Task { @MainActor in
                            switch type {
                            case .medication:
                                let medications = userSettings.medications.isEmpty ? [] : userSettings.medications
                                let userName = userSettings.userProfile?.firstName ?? userSettings.userName
                                MedicationPrintService.shared.printMedicationSchedule(medications: medications, userName: userName)
                            case .fasting:
                                let userName = userSettings.userProfile?.firstName ?? userSettings.userName
                                MedicationPrintService.shared.printFastingProtocolGuide(fastingProtocol: userSettings.activeFastingProtocol, userName: userName)
                            case .meals:
                                let userName = userSettings.userProfile?.firstName ?? userSettings.userName
                                MedicationPrintService.shared.printMealSuggestions(userName: userName)
                            case .instructions:
                                let userName = userSettings.userProfile?.firstName ?? userSettings.userName
                                MedicationPrintService.shared.printAppInstructions(userName: userName)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "printer.fill")
                            Text(NSLocalizedString("Print", comment: ""))
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
            return NSLocalizedString("Medication Schedule", comment: "")
        case .fasting:
            return NSLocalizedString("Fasting Guide", comment: "")
        case .meals:
            return NSLocalizedString("Meal Suggestions", comment: "")
        case .instructions:
            return NSLocalizedString("App Instructions", comment: "")
        }
    }
    

}



// Debug Subscription Tier Switcher (only available in DEBUG builds)
#if DEBUG
struct DebugSubscriptionTierSwitcher: View {
    @StateObject private var premiumManager = PremiumManager.shared
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingDebugAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Debug Mode Toggle
            Toggle(isOn: Binding(
                get: { premiumManager.isDebugMode },
                set: { newValue in
                    if newValue {
                        premiumManager.enableDebugMode()
                    } else {
                        premiumManager.disableDebugMode()
                    }
                }
            )) {
                HStack {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .foregroundColor(.orange)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Debug Mode")
                            .font(.system(size: userSettings.textSize.size))
                        Text("Enable subscription testing")
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 8)
            .toggleStyle(SwitchToggleStyle(tint: .orange))
            
            // Current Subscription Status
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(getTierColor())
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current Tier")
                        .font(.system(size: userSettings.textSize.size))
                    Text(premiumManager.currentTier.displayName)
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(getTierColor())
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                if premiumManager.isDebugMode {
                    Text("DEBUG")
                        .font(.system(size: userSettings.textSize.size - 4, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
            .padding(.vertical, 8)
            
            // Tier Selection (only visible in debug mode)
            if premiumManager.isDebugMode {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Debug Tier:")
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    ForEach(SubscriptionTier.allCases, id: \.self) { tier in
                        Button(action: {
                            premiumManager.setDebugTier(tier)
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        }) {
                            HStack {
                                Image(systemName: premiumManager.currentTier == tier ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(premiumManager.currentTier == tier ? .green : .gray)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(tier.displayName)
                                        .font(.system(size: userSettings.textSize.size))
                                        .foregroundColor(.primary)
                                    
                                    Text(tier.localizedDescription)
                                        .font(.system(size: userSettings.textSize.size - 2))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if tier != .free {
                                    Text(tier.monthlyPrice)
                                        .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Feature Access Summary
            if premiumManager.isDebugMode {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Feature Access:")
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        featureAccessItem("Analytics", premiumManager.hasAccess(to: PremiumFeature.advancedAnalytics))
                        featureAccessItem("Export", premiumManager.hasAccess(to: PremiumFeature.dataExport))
                        featureAccessItem("Voice", premiumManager.hasAccess(to: PremiumFeature.voiceAssistant))
                        featureAccessItem("Tips", premiumManager.hasAccess(to: PremiumFeature.personalizedTips))
                        featureAccessItem("Support", premiumManager.hasAccess(to: PremiumFeature.prioritySupport))
                        featureAccessItem("Coach", premiumManager.hasAccess(to: PremiumFeature.coachChat))
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .alert("Debug Mode Enabled", isPresented: $showingDebugAlert) {
            Button("OK") { }
        } message: {
            Text("You can now test different subscription tiers. This is for development only and won't affect real purchases.")
        }
    }
    
    private func getTierColor() -> Color {
        switch premiumManager.currentTier {
        case .free:
            return .gray
        case .advanced:
            return .blue
        case .premium:
            return .purple
        }
    }
    
    private func featureAccessItem(_ name: String, _ hasAccess: Bool) -> some View {
        HStack {
            Image(systemName: hasAccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(hasAccess ? .green : .red)
                .font(.system(size: 12))
            
            Text(name)
                .font(.system(size: userSettings.textSize.size - 4))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(hasAccess ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}
#endif

// Preview Provider (Restored)
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserSettings()) // Provide environment object for preview
    }
}
#endif