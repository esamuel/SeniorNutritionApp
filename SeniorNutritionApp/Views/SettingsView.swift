import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var userName: String = "Jane"
    @State private var showingHelpOptions = false
    @State private var showingPrintOptions = false
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // User profile section
                Section(header: sectionHeader("Profile")) {
                    VStack(alignment: .center, spacing: 15) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.blue)
                        
                        Text(userName)
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        Button(action: {
                            // Edit profile action
                        }) {
                            Text("Edit Profile")
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
                
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
                            Image(systemName: "circle.contrast")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            Text("High Contrast Mode")
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                    .padding(.vertical, 8)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    // Voice input
                    Toggle(isOn: $userSettings.useVoiceInput) {
                        HStack {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            Text("Voice Input")
                                .font(.system(size: userSettings.textSize.size))
                        }
                    }
                    .padding(.vertical, 8)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                // Fasting protocol section
                Section(header: sectionHeader("Fasting Protocol")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Current Protocol")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                        
                        ForEach(FastingProtocol.allCases) { proto in
                            protocolButton(for: proto)
                        }
                    }
                }
                
                // Help & support section
                Section(header: sectionHeader("Help & Support")) {
                    // Video tutorials
                    settingsRow(
                        icon: "video.fill",
                        title: "Video Tutorials",
                        color: .red,
                        action: {
                            // Show video tutorials
                        }
                    )
                    
                    // Live support
                    settingsRow(
                        icon: "person.fill.questionmark",
                        title: "Get Live Support",
                        color: .green,
                        action: {
                            showingHelpOptions = true
                        }
                    )
                    
                    // Print materials
                    settingsRow(
                        icon: "printer.fill",
                        title: "Print Instructions",
                        color: .purple,
                        action: {
                            showingPrintOptions = true
                        }
                    )
                }
                
                // Additional options section
                Section(header: sectionHeader("Additional Options")) {
                    // Notifications
                    NavigationLink(destination: NotificationsSettingsView()) {
                        settingsRowContent(
                            icon: "bell.fill",
                            title: "Notifications",
                            color: .orange
                        )
                    }
                    
                    // Backup and restore
                    NavigationLink(destination: Text("Backup Settings").font(.system(size: userSettings.textSize.size))) {
                        settingsRowContent(
                            icon: "arrow.clockwise",
                            title: "Backup & Restore",
                            color: .blue
                        )
                    }
                    
                    // Reset app
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        settingsRowContent(
                            icon: "arrow.counterclockwise",
                            title: "Reset App",
                            color: .red
                        )
                    }
                }
                
                // About section
                Section(header: sectionHeader("About")) {
                    // App version
                    HStack {
                        Text("Version")
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    
                    // Privacy policy
                    NavigationLink(destination: Text("Privacy Policy").font(.system(size: userSettings.textSize.size))) {
                        Text("Privacy Policy")
                            .font(.system(size: userSettings.textSize.size))
                    }
                    .padding(.vertical, 8)
                    
                    // Terms of service
                    NavigationLink(destination: Text("Terms of Service").font(.system(size: userSettings.textSize.size))) {
                        Text("Terms of Service")
                            .font(.system(size: userSettings.textSize.size))
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(InsetGroupedListStyle())
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("Reset App?"),
                    message: Text("This will reset all settings and delete your data. This cannot be undone."),
                    primaryButton: .destructive(Text("Reset")) {
                        // Reset app action
                    },
                    secondaryButton: .cancel()
                )
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
        .padding(.vertical, 8)
    }
    
    // Helper for settings row content
    private func settingsRowContent(icon: String, title: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
    }
    
    // Fasting protocol selection button
    private func protocolButton(for proto: FastingProtocol) -> some View {
        Button(action: {
            userSettings.activeFastingProtocol = proto
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(proto.rawValue)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                    
                    Text(proto.description)
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if userSettings.activeFastingProtocol == proto {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
    }
}

// Notifications Settings View
struct NotificationsSettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
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
            
            Section(header: Text("Reminder Style").font(.system(size: userSettings.textSize.size, weight: .bold))) {
                notificationStyleButton(title: "Regular", description: "Standard notifications")
                
                notificationStyleButton(title: "Gentle", description: "Quieter, less intrusive notifications")
                
                notificationStyleButton(title: "Urgent", description: "More noticeable for important reminders")
            }
            
            Section {
                Button(action: {
                    // Save notification settings
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
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(InsetGroupedListStyle())
    }
    
    // Notification style selection button
    private func notificationStyleButton(title: String, description: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                
                Text(description)
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark")
                .foregroundColor(.blue)
                .opacity(title == "Regular" ? 1 : 0)
        }
        .padding(.vertical, 8)
    }
}

// Help Options View
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
                        action: {
                            // Call support action
                        }
                    )
                    
                    helpOptionButton(
                        icon: "message.fill",
                        title: "Send Message",
                        description: "Send us a message for help",
                        action: {
                            // Send message action
                        }
                    )
                    
                    helpOptionButton(
                        icon: "video.fill",
                        title: "Video Chat",
                        description: "Schedule a video call with support",
                        action: {
                            // Video chat action
                        }
                    )
                    
                    helpOptionButton(
                        icon: "questionmark.circle.fill",
                        title: "Guided Tour",
                        description: "Restart the app tour",
                        action: {
                            // Restart tour action
                        }
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
                    .background(Color.blue)
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
    }
}

// Print Options View
struct PrintOptionsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    printOptionButton(
                        title: "Medication Schedule",
                        description: "Print your current medication schedule",
                        icon: "pill.fill"
                    )
                    
                    printOptionButton(
                        title: "Fasting Guide",
                        description: "Print your fasting protocol guide",
                        icon: "timer"
                    )
                    
                    printOptionButton(
                        title: "Meal Suggestions",
                        description: "Print healthy meal suggestions",
                        icon: "fork.knife"
                    )
                    
                    printOptionButton(
                        title: "App Instructions",
                        description: "Print step-by-step app instructions",
                        icon: "doc.text.fill"
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
        }
    }
    
    // Print option button
    private func printOptionButton(title: String, description: String, icon: String) -> some View {
        Button(action: {
            // Print action
        }) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.purple)
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
                
                Image(systemName: "printer.fill")
                    .foregroundColor(.purple)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserSettings())
    }
} 