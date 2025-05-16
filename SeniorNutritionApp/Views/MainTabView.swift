import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var appointmentManager: AppointmentManager
    @State private var selectedTab = 0
    @State private var showingMoreOptions = false
    
    // Define a color for each tab
    private let tabColors: [Color] = [
        .blue,    // Home
        .orange,  // Fasting
        .cyan,    // Water
        .green,   // Nutrition
        .gray     // More
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(NSLocalizedString("Home", comment: ""), systemImage: "house.fill")
                }
                .tag(0)
            
            FastingTimerView()
                .tabItem {
                    Label(NSLocalizedString("Fasting", comment: ""), systemImage: "timer")
                }
                .tag(1)
            
            WaterReminderView()
                .tabItem {
                    Label(NSLocalizedString("Water", comment: ""), systemImage: "drop.fill")
                }
                .tag(2)
            
            NutritionView()
                .tabItem {
                    Label(NSLocalizedString("Nutrition", comment: ""), systemImage: "fork.knife")
                }
                .tag(3)
            
            MoreTabView()
                .tabItem {
                    Label(NSLocalizedString("More", comment: ""), systemImage: "ellipsis")
                }
                .tag(4)
        }
        .tint(tabColors[selectedTab])
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MoreTabView: View {
    @EnvironmentObject var appointmentManager: AppointmentManager
    @State private var showingModalView: MoreViewOption?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Health & Wellness")) {
                    NavigationLink(destination: MedicationView()) {
                        MoreOptionRow(icon: "pills.fill", title: "Medications", color: .purple)
                    }
                    
                    NavigationLink(destination: AppointmentsView()) {
                        MoreOptionRow(icon: "calendar", title: "Appointments", color: .blue)
                    }
                    
                    NavigationLink(destination: HealthDataTabView()) {
                        MoreOptionRow(icon: "heart.fill", title: "Health", color: .red)
                    }
                }
                
                Section(header: Text("Account & Settings")) {
                    NavigationLink(destination: ProfileView()) {
                        MoreOptionRow(icon: "person.circle.fill", title: "Profile", color: .indigo)
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        MoreOptionRow(icon: "gearshape.fill", title: "Settings", color: .gray)
                    }
                }
                
                Section(header: Text("Help & Support")) {
                    Button(action: {
                        showingModalView = .help
                    }) {
                        MoreOptionRow(icon: "questionmark.circle", title: "Help", color: .teal)
                    }
                    
                    Button(action: {
                        showingModalView = .emergency
                    }) {
                        MoreOptionRow(icon: "phone.fill", title: "Emergency Contacts", color: .red)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("More", comment: ""))
            .sheet(item: $showingModalView) { option in
                switch option {
                case .help:
                    HelpGuideView()
                case .emergency:
                    EmergencyContactsView()
                }
            }
        }
    }
}

enum MoreViewOption: String, Identifiable {
    case help, emergency
    var id: String { self.rawValue }
}

struct MoreOptionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(title)
                .font(.system(size: 16))
            
            Spacer()
        }
    }
}

// Assumed HelpGuideView exists elsewhere in the codebase
struct HelpGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text(NSLocalizedString("How can we help you?", comment: ""))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    // App Navigation Help
                    HelpSectionView(
                        title: NSLocalizedString("Navigating the App", comment: ""),
                        items: [
                            HelpItem(icon: "house.fill", title: NSLocalizedString("Home", comment: ""), description: NSLocalizedString("Dashboard with fasting status and daily overview", comment: "")),
                            HelpItem(icon: "timer", title: NSLocalizedString("Fasting", comment: ""), description: NSLocalizedString("Track and manage your fasting schedule", comment: "")),
                            HelpItem(icon: "drop.fill", title: NSLocalizedString("Water", comment: ""), description: NSLocalizedString("Track your daily hydration", comment: "")),
                            HelpItem(icon: "fork.knife", title: NSLocalizedString("Nutrition", comment: ""), description: NSLocalizedString("Log and analyze your meals", comment: "")),
                            HelpItem(icon: "ellipsis", title: NSLocalizedString("More", comment: ""), description: NSLocalizedString("Access additional features and settings", comment: ""))
                        ]
                    )
                    
                    // Common Tasks
                    HelpSectionView(
                        title: "Common Tasks",
                        items: [
                            HelpItem(icon: "plus.circle", title: "Add a Meal", description: "Tap the + button in the Nutrition tab"),
                            HelpItem(icon: "pill.fill", title: "Manage Medications", description: "Go to More > Medications"),
                            HelpItem(icon: "calendar", title: "Schedule Appointment", description: "Go to More > Appointments > Add"),
                            HelpItem(icon: "person.fill", title: "Update Profile", description: "Go to More > Profile")
                        ]
                    )
                    
                    // Appointments & Calendar
                    HelpSectionView(
                        title: "Appointments & Calendar",
                        items: [
                            HelpItem(icon: "calendar", title: "View Appointments", description: "See all upcoming medical visits"),
                            HelpItem(icon: "bell", title: "Set Reminders", description: "Get alerts before appointments"),
                            HelpItem(icon: "location.fill", title: "Save Locations", description: "Store doctor's office addresses"),
                            HelpItem(icon: "square.and.arrow.up", title: "Share Details", description: "Send appointment info to family")
                        ]
                    )
                    
                    // Health Tracking
                    HelpSectionView(
                        title: "Health Monitoring",
                        items: [
                            HelpItem(icon: "heart.fill", title: "Track Vitals", description: "Record blood pressure, heart rate, and more"),
                            HelpItem(icon: "waveform.path.ecg", title: "View Trends", description: "See your health data visualized over time"),
                            HelpItem(icon: "drop.fill", title: "Blood Sugar", description: "Monitor glucose levels and see patterns"),
                            HelpItem(icon: "scale.3d", title: "Weight Tracking", description: "Track weight changes with detailed analysis")
                        ]
                    )
                    
                    // Troubleshooting
                    HelpSectionView(
                        title: "Troubleshooting",
                        items: [
                            HelpItem(icon: "exclamationmark.circle", title: "App Not Responding", description: "Close and restart the app"),
                            HelpItem(icon: "bell.slash", title: "Missing Notifications", description: "Check notification settings"),
                            HelpItem(icon: "slider.horizontal.3", title: "Fasting Timer Issues", description: "Try resetting your fasting protocol"),
                            HelpItem(icon: "arrow.clockwise", title: "Data Not Updating", description: "Pull down to refresh or restart app")
                        ]
                    )
                    
                    // Contact Support
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Still Need Help?")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Button(action: {
                            // Action to call support
                        }) {
                            HelpContactRow(icon: "phone.fill", title: "Call Support", color: .green)
                        }
                        
                        Button(action: {
                            // Action to send email
                        }) {
                            HelpContactRow(icon: "envelope.fill", title: "Email Support", color: .blue)
                        }
                        
                        Button(action: {
                            // Action to view tutorials
                        }) {
                            HelpContactRow(icon: "video.fill", title: "Video Tutorials", color: .red)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Help Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Help Section Component
struct HelpSectionView: View {
    let title: String
    let items: [HelpItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .adaptiveHelpGuideLayout()
            
            VStack(spacing: 12) {
                ForEach(items) { item in
                    HelpItemRow(item: item)
                }
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Help Item Model
struct HelpItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

// Help Item Row Component
struct HelpItemRow: View {
    let item: HelpItem
    @State private var showDetailView = false
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    
    var body: some View {
        Button(action: {
            // Set state with a small delay to ensure proper presentation
            DispatchQueue.main.async {
                showDetailView = true
            }
        }) {
            HStack(spacing: 15) {
                Image(systemName: item.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.blue)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(item.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .adaptiveHelpGuideLayout()
                
                Spacer()
                
                // In RTL mode, use chevron.left to visually indicate the same "forward" direction
                Image(systemName: layoutDirection == .rightToLeft ? "chevron.left" : "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showDetailView) {
            // Using fullScreenCover instead of sheet for more reliability
            // This onDismiss handler is called when the view is dismissed
            showDetailView = false
        } content: {
            // Pass binding to ensure proper state management
            DetailedHelpView(item: item, isPresented: $showDetailView)
                .environmentObject(userSettings)
        }
    }
}

// Detailed Help View
struct DetailedHelpView: View {
    let item: HelpItem
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var voiceManager = VoiceManager.shared
    @Binding var isPresented: Bool
    
    init(item: HelpItem, isPresented: Binding<Bool>) {
        self.item = item
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Help: \(item.title)", comment: ""))
                    .font(.largeTitle)
                    .bold()
                
                Button(action: {
                    if voiceManager.isSpeaking {
                        voiceManager.stopSpeaking()
                    } else {
                        readHelpContent()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.blue)
                        
                        if voiceManager.isSpeaking {
                            Text(NSLocalizedString("Stop", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.blue)
                        } else {
                            Text(NSLocalizedString("Read", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .accessibilityLabel(NSLocalizedString("Read Help Content", comment: ""))
                .accessibilityHint(NSLocalizedString("Reads out the entire help guide", comment: ""))
                
                Spacer()
            }
            .padding()
            
            ScrollView {
                if item.title == NSLocalizedString("Home", comment: "") {
                    homeDetailContent
                } else if item.title == NSLocalizedString("Fasting", comment: "") {
                    fastingDetailContent
                } else if item.title == NSLocalizedString("Water", comment: "") {
                    waterDetailContent
                } else if item.title == NSLocalizedString("Nutrition", comment: "") {
                    nutritionDetailContent
                } else if item.title == NSLocalizedString("More", comment: "") {
                    moreDetailContent
                }
            }
            
            Button(action: {
                isPresented = false
            }) {
                Text(NSLocalizedString("Close", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
    
    // Function to read help content based on selected section
    private func readHelpContent() {
        var contentToRead = NSLocalizedString("Help guide for \(item.title)", comment: "")
        
        if item.title == NSLocalizedString("Home", comment: "") {
            contentToRead += NSLocalizedString("The Home dashboard provides a complete overview of your daily health information. Here you can see your fasting status, upcoming medications, water intake progress, and recent meals all in one place.", comment: "")
        } else if item.title == NSLocalizedString("Fasting", comment: "") {
            contentToRead += NSLocalizedString("The Fasting Timer provides a complete visualization of your intermittent fasting schedule. It shows your current fasting status, remaining time, and daily schedule in an easy-to-understand format.", comment: "")
        } else if item.title == NSLocalizedString("Water", comment: "") {
            contentToRead += NSLocalizedString("The Water Tracking feature helps you monitor and maintain proper hydration throughout the day. Staying hydrated is crucial for seniors to support overall health and well-being.", comment: "")
        } else if item.title == NSLocalizedString("Nutrition", comment: "") {
            contentToRead += NSLocalizedString("The Nutrition section helps you track your meals, monitor nutrient intake, and maintain a balanced diet suited for your health needs.", comment: "")
        } else if item.title == NSLocalizedString("More", comment: "") {
            contentToRead += NSLocalizedString("The More section provides access to essential app settings, your profile, help resources, and additional tools.", comment: "")
        }
        
        // Force using the current language from LanguageManager
        // This ensures the speech uses the correct language voice
        _ = LanguageManager.shared.currentLanguage
        print("Speaking in language: \(LanguageManager.shared.currentLanguage)")
        
        voiceManager.speak(contentToRead, userSettings: userSettings)
    }
    
    private var homeDetailContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Overview
            helpSection(
                title: NSLocalizedString("Dashboard Overview", comment: ""),
                icon: "rectangle.3.group.fill",
                content: NSLocalizedString("The Home dashboard provides a complete overview of your daily health information. Here you can see your fasting status, upcoming medications, water intake progress, and recent meals all in one place.", comment: "")
            )
            
            // Main features
            helpSection(
                title: NSLocalizedString("Main Features", comment: ""),
                icon: "star.fill",
                bulletPoints: [
                    NSLocalizedString("Health Status Cards: Quick view of vital health metrics", comment: ""),
                    NSLocalizedString("Fasting Timer: Current fasting status and progress", comment: ""),
                    NSLocalizedString("Medication Reminders: Upcoming medication alerts", comment: ""),
                    NSLocalizedString("Water Tracking: Daily hydration progress", comment: ""),
                    NSLocalizedString("Recent Meals: Latest nutrition entries", comment: "")
                ]
            )
            
            // How to use
            helpSection(
                title: NSLocalizedString("How to Use", comment: ""),
                icon: "hand.tap.fill",
                bulletPoints: [
                    NSLocalizedString("Tap any card to access detailed information for that feature", comment: ""),
                    NSLocalizedString("Pull down to refresh dashboard data", comment: ""),
                    NSLocalizedString("Use quick action buttons to record meals, medications or water", comment: ""),
                    NSLocalizedString("View summary graphs for health trends at a glance", comment: "")
                ]
            )
            
            // Tips for seniors
            helpSection(
                title: NSLocalizedString("Senior-Friendly Tips", comment: ""),
                icon: "person.fill.checkmark",
                bulletPoints: [
                    NSLocalizedString("Increase text size in Settings if needed for better visibility", comment: ""),
                    NSLocalizedString("Use voice commands by tapping the microphone icon", comment: ""),
                    NSLocalizedString("Enable high contrast mode for improved readability", comment: ""),
                    NSLocalizedString("Set up medication reminders to never miss a dose", comment: ""),
                    NSLocalizedString("Check water intake regularly to ensure proper hydration", comment: "")
                ]
            )
            
            // Customization options
            helpSection(
                title: NSLocalizedString("Customization", comment: ""),
                icon: "slider.horizontal.3",
                bulletPoints: [
                    NSLocalizedString("Rearrange dashboard cards by long-pressing and dragging", comment: ""),
                    NSLocalizedString("Hide specific metrics you don't use from Settings", comment: ""),
                    NSLocalizedString("Adjust goal values for water, nutrition, and activity", comment: ""),
                    NSLocalizedString("Change color theme and contrast settings", comment: "")
                ]
            )
            
            // Screenshots with explanations
            VStack(alignment: .leading, spacing: 10) {
                Text(NSLocalizedString("Visual Guide", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .padding(.horizontal)
                
                Text(NSLocalizedString("The Home screen is organized into clearly labeled sections for easy navigation:", comment: ""))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                Image(systemName: "iphone.gen3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Text(NSLocalizedString("(Screenshot representation of the Home screen)", comment: ""))
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.secondary)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .adaptiveHelpGuideLayout()
            
            // Support info
            helpSection(
                title: NSLocalizedString("Need More Help?", comment: ""),
                icon: "questionmark.circle.fill",
                content: NSLocalizedString("For additional assistance with the Home dashboard, tap the Support button in Settings or use the voice assistant by tapping the microphone icon at the top of the screen.", comment: "")
            )
        }
        .padding(.bottom, 20)
    }
    
    private var fastingDetailContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Overview
            helpSection(
                title: NSLocalizedString("Dashboard Overview", comment: ""),
                icon: "timer",
                content: NSLocalizedString("The Fasting Timer provides a complete visualization of your intermittent fasting schedule. It shows your current fasting status, remaining time, and daily schedule in an easy-to-understand format. The circular timer gives you an immediate visual indicator of your progress.", comment: "")
            )
            
            // Main features
            helpSection(
                title: NSLocalizedString("Main Features", comment: ""),
                icon: "star.fill",
                bulletPoints: [
                    NSLocalizedString("Fasting Protocols: Choose from multiple pre-set protocols (12:12, 14:10, 16:8) or create your custom protocol", comment: ""),
                    NSLocalizedString("Real-time Timer: Circular timer showing percentage and time remaining in current window", comment: ""),
                    NSLocalizedString("Today's Schedule: Overview of fasting and eating windows", comment: ""),
                    NSLocalizedString("Medication Integration: View medications scheduled during fasting/eating periods", comment: ""),
                    NSLocalizedString("Emergency Override: One-tap option to safely end fasting early if needed", comment: ""),
                    NSLocalizedString("Custom Protocol Setup: Create your own personalized fasting/eating schedule", comment: "")
                ]
            )
            
            // How to use
            helpSection(
                title: NSLocalizedString("How to Use", comment: ""),
                icon: "hand.tap.fill",
                bulletPoints: [
                    NSLocalizedString("Change Protocol: Tap the protocol name in the top-right to select a different fasting schedule", comment: ""),
                    NSLocalizedString("Start/End Fasting: Use the green/red button at the bottom to start or end your fasting period", comment: ""),
                    NSLocalizedString("Adjust Times: Tap on \"Last Meal\" or \"Next Meal\" to adjust your specific timing", comment: ""),
                    NSLocalizedString("View Schedule: The \"Today's Schedule\" card shows your full day timeline", comment: ""),
                    NSLocalizedString("Emergency Override: If you need to end a fast early, use the red \"Emergency Override\" button", comment: "")
                ]
            )
            
            // Health Tips for Seniors
            helpSection(
                title: NSLocalizedString("Health Tips for Seniors", comment: ""),
                icon: "heart.fill",
                bulletPoints: [
                    NSLocalizedString("Stay Hydrated: Always drink plenty of water during your fasting periods", comment: ""),
                    NSLocalizedString("Monitor Your Health: If you feel dizzy, weak, or unwell, end your fast immediately", comment: ""),
                    NSLocalizedString("Consult Your Doctor: Discuss fasting with your healthcare provider, especially if you have chronic conditions", comment: ""),
                    NSLocalizedString("Start Gradually: If you're new to fasting, begin with shorter fasting periods (12:12) before advancing", comment: ""),
                    NSLocalizedString("Take Medications As Prescribed: Never skip medications - adjust your eating window if necessary", comment: "")
                ]
            )
            
            // Protocol Guide header
            Text(NSLocalizedString("Protocol Guide", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .padding(.horizontal)
            
            // 12:12 Protocol
            protocolSection(
                title: NSLocalizedString("12:12 Protocol", comment: ""),
                bestFor: NSLocalizedString("Beginners, those with medication schedules, active social lives", comment: ""),
                benefits: NSLocalizedString("Gentle introduction to fasting, better sleep, minimal disruption to routines", comment: ""),
                howItWorks: NSLocalizedString("Fast for 12 hours (often overnight), eat during a 12-hour window", comment: "")
            )
            
            // 14:10 Protocol
            protocolSection(
                title: NSLocalizedString("14:10 Protocol", comment: ""),
                bestFor: NSLocalizedString("Those with some fasting experience seeking more benefits", comment: ""),
                benefits: NSLocalizedString("Enhanced fat burning, improved metabolic flexibility, better appetite control", comment: ""),
                howItWorks: NSLocalizedString("Fast for 14 hours, eat during a 10-hour window", comment: "")
            )
            
            // 16:8 Protocol
            protocolSection(
                title: NSLocalizedString("16:8 Protocol", comment: ""),
                bestFor: NSLocalizedString("Experienced fasters seeking maximum benefits", comment: ""),
                benefits: NSLocalizedString("Maximum autophagy, significant fat burning, improved insulin sensitivity", comment: ""),
                howItWorks: NSLocalizedString("Fast for 16 hours, eat during an 8-hour window", comment: "")
            )
            
            // Custom Protocol
            protocolSection(
                title: NSLocalizedString("Custom Protocol", comment: ""),
                bestFor: NSLocalizedString("Those with unique scheduling needs or specific health considerations", comment: ""),
                benefits: NSLocalizedString("Tailored to your specific lifestyle and needs", comment: ""),
                howItWorks: NSLocalizedString("Set your own fasting and eating hours (must total 24 hours)", comment: "")
            )
            
            // Troubleshooting
            helpSection(
                title: NSLocalizedString("Troubleshooting", comment: ""),
                icon: "wrench.fill",
                bulletPoints: [
                    NSLocalizedString("Timer Not Updating: Pull down to refresh or restart the app", comment: ""),
                    NSLocalizedString("Protocol Reset: If your protocol settings are lost, simply reselect your preferred protocol", comment: ""),
                    NSLocalizedString("Time Adjustment: If you need to correct your last meal time, tap on \"Last Meal\" to adjust", comment: ""),
                    NSLocalizedString("Medication Conflicts: Review your medication schedule in the Medications section if you notice conflicts", comment: "")
                ]
            )
            
            // Using with Other Features
            helpSection(
                title: NSLocalizedString("Using with Other Features", comment: ""),
                icon: "link",
                bulletPoints: [
                    NSLocalizedString("Water Tracking: Remember to maintain hydration during fasting periods", comment: ""),
                    NSLocalizedString("Medication Management: The app will help you schedule medications appropriately during eating windows when possible", comment: ""),
                    NSLocalizedString("Nutrition Tracking: Track meals during your eating window to ensure balanced nutrition", comment: "")
                ]
            )
        }
        .padding(.bottom, 20)
    }
    
    private var waterDetailContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Overview
            helpSection(
                title: NSLocalizedString("Feature Overview", comment: ""),
                icon: "drop.fill",
                content: NSLocalizedString("The Water Tracking feature helps you monitor and maintain proper hydration throughout the day. Staying hydrated is crucial for seniors to support overall health and well-being, aid digestion, regulate body temperature, and prevent urinary tract infections.", comment: "")
            )
            
            // Main features
            helpSection(
                title: NSLocalizedString("Main Features", comment: ""),
                icon: "star.fill",
                bulletPoints: [
                    NSLocalizedString("Daily Water Goal: Customizable daily hydration target based on your needs", comment: ""),
                    NSLocalizedString("One-Tap Tracking: Quickly record water intake with preset amounts", comment: ""),
                    NSLocalizedString("Visual Progress: Clear visual indicators of your daily hydration progress", comment: ""),
                    NSLocalizedString("Custom Amounts: Add specific water quantities for precise tracking", comment: ""),
                    NSLocalizedString("Hydration Reminders: Customizable alerts to help you stay on track", comment: ""),
                    NSLocalizedString("History View: See your hydration patterns over time", comment: "")
                ]
            )
            
            // How to use
            helpSection(
                title: NSLocalizedString("How to Use", comment: ""),
                icon: "hand.tap.fill",
                bulletPoints: [
                    NSLocalizedString("Add Water: Tap the quick-add buttons (150ml, 250ml, etc.) to log water intake", comment: ""),
                    NSLocalizedString("Custom Amount: Tap \"Add Custom Amount\" to enter a specific quantity", comment: ""),
                    NSLocalizedString("Set Daily Goal: Adjust your daily water target in Settings", comment: ""),
                    NSLocalizedString("Configure Reminders: Set up hydration reminders with your preferred frequency", comment: ""),
                    NSLocalizedString("Track Progress: View your daily progress with the circular indicator", comment: ""),
                    NSLocalizedString("View History: Swipe to see your hydration history and patterns", comment: "")
                ]
            )
            
            // Hydration tips for seniors
            helpSection(
                title: NSLocalizedString("Hydration Tips for Seniors", comment: ""),
                icon: "heart.fill",
                bulletPoints: [
                    NSLocalizedString("Drink Before You're Thirsty: Thirst sensation decreases with age, so drink regularly", comment: ""),
                    NSLocalizedString("Morning Routine: Start each day with a glass of water before breakfast", comment: ""),
                    NSLocalizedString("Carry Water: Keep a water bottle with you throughout the day", comment: ""),
                    NSLocalizedString("Set Reminders: Use the app's reminder feature as your sense of thirst may be diminished", comment: ""),
                    NSLocalizedString("Monitor Color: Check your urine - pale yellow indicates good hydration", comment: ""),
                    NSLocalizedString("Limit Caffeine & Alcohol: These can contribute to dehydration", comment: "")
                ]
            )
            
            // Understanding hydration needs
            helpSection(
                title: NSLocalizedString("Understanding Hydration Needs", comment: ""),
                icon: "drop.triangle.fill",
                bulletPoints: [
                    NSLocalizedString("Individual Needs Vary: Your water needs depend on weight, activity level, and climate", comment: ""),
                    NSLocalizedString("Medications Matter: Some medications may increase hydration needs", comment: ""),
                    NSLocalizedString("Activity Adjustments: Increase water intake during physical activity", comment: ""),
                    NSLocalizedString("Seasonal Changes: You need more water in hot weather or heated indoor environments", comment: ""),
                    NSLocalizedString("Medical Conditions: Heart failure, kidney disease and other conditions may require specific fluid intake - consult your doctor", comment: "")
                ]
            )
            
            // Beyond plain water
            helpSection(
                title: NSLocalizedString("Beyond Plain Water", comment: ""),
                icon: "cup.and.saucer.fill",
                bulletPoints: [
                    NSLocalizedString("Hydrating Foods: Fruits like watermelon, oranges, and vegetables like cucumber contribute to hydration", comment: ""),
                    NSLocalizedString("Herbal Teas: Caffeine-free herbal teas count toward daily fluid intake", comment: ""),
                    NSLocalizedString("Milk & Alternatives: Milk, fortified plant milks provide hydration plus nutrients", comment: ""),
                    NSLocalizedString("Soup & Broth: Clear soups and broths are excellent hydration sources", comment: ""),
                    NSLocalizedString("Flavor Your Water: Add slices of fruit for taste without added sugar", comment: "")
                ]
            )
            
            // Signs of dehydration
            helpSection(
                title: NSLocalizedString("Signs of Dehydration", comment: ""),
                icon: "exclamationmark.triangle.fill",
                bulletPoints: [
                    NSLocalizedString("Increased Thirst: Persistent thirst or dry mouth", comment: ""),
                    NSLocalizedString("Dark Urine: Dark yellow or amber-colored urine", comment: ""),
                    NSLocalizedString("Fatigue: Unusual tiredness or lethargy", comment: ""),
                    NSLocalizedString("Dizziness: Feeling lightheaded, especially when standing", comment: ""),
                    NSLocalizedString("Confusion: Mental fogginess or unusual confusion", comment: ""),
                    NSLocalizedString("Dry Skin: Skin that lacks elasticity when pinched", comment: ""),
                    NSLocalizedString("Headache: Persistent headache that doesn't respond to pain relievers", comment: "")
                ]
            )
            
            // Emergency info
            helpSection(
                title: NSLocalizedString("Emergency Information", comment: ""),
                icon: "exclamationmark.shield.fill",
                content: NSLocalizedString("Severe dehydration requires medical attention. Seek immediate help if you experience extreme thirst, no urination, shriveled skin, confusion, irritability, or dizziness. For seniors, dehydration can become dangerous quickly, especially during illness or hot weather.", comment: "")
            )
            
            // Troubleshooting
            helpSection(
                title: NSLocalizedString("Troubleshooting", comment: ""),
                icon: "wrench.fill",
                bulletPoints: [
                    NSLocalizedString("Progress Not Updating: Pull down to refresh the screen", comment: ""),
                    NSLocalizedString("Reminders Not Working: Check notification permissions in device settings", comment: ""),
                    NSLocalizedString("Goal Adjustments: If you can't reach your goal consistently, try lowering it temporarily", comment: ""),
                    NSLocalizedString("Data Discrepancies: If history doesn't match your entries, restart the app", comment: ""),
                    NSLocalizedString("Custom Amount Problems: If custom amounts aren't saving, try using preset buttons", comment: "")
                ]
            )
            
            // Integration with other features
            helpSection(
                title: NSLocalizedString("Using with Other Features", comment: ""),
                icon: "link.circle.fill",
                bulletPoints: [
                    NSLocalizedString("Fasting Integration: The app will remind you to stay hydrated during fasting periods", comment: ""),
                    NSLocalizedString("Medication Reminders: Water reminders can be synchronized with medication times", comment: ""),
                    NSLocalizedString("Health Tracking: Your hydration status contributes to your overall health assessment", comment: ""),
                    NSLocalizedString("Reports: Hydration data is included in health reports you can share with providers", comment: "")
                ]
            )
        }
        .padding(.bottom, 20)
    }
    
    private var nutritionDetailContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Overview
            helpSection(
                title: NSLocalizedString("Feature Overview", comment: ""),
                icon: "fork.knife",
                content: NSLocalizedString("The Nutrition section helps you track your meals, monitor nutrient intake, and maintain a balanced diet suited for your health needs. This guide explains how to use all features in the Nutrition tab.", comment: "")
            )
            
            // Main Sections
            helpSection(
                title: NSLocalizedString("Main Sections", comment: ""),
                icon: "list.bullet",
                content: [
                    NSLocalizedString("Dashboard: View your daily nutrient intake with visualizations", comment: ""),
                    NSLocalizedString("Meals: Log and manage your daily meals and access common meals", comment: ""),
                    NSLocalizedString("Food Database: Browse detailed nutrition information for thousands of foods", comment: ""),
                    NSLocalizedString("Nutrition Tips: Get personalized advice based on your health profile", comment: "")
                ].joined(separator: "\n\n")
            )
            
            // Dashboard Features
            helpSection(
                title: NSLocalizedString("Dashboard Features", comment: ""),
                icon: "chart.bar.fill",
                content: NSLocalizedString("The Dashboard provides a visual overview of your daily nutrition with easy-to-read charts and progress indicators.", comment: ""),
                bulletPoints: [
                    NSLocalizedString("Date Selector: Navigate between days to see nutrition history", comment: ""),
                    NSLocalizedString("Daily Summary: Shows your calorie intake versus your daily goal", comment: ""),
                    NSLocalizedString("Macronutrients: Tracks protein, carbohydrates, and fat intake", comment: ""),
                    NSLocalizedString("Vitamins & Minerals: Monitors essential micronutrients important for seniors", comment: "")
                ]
            )
            
            // Using the Dashboard
            helpSection(
                title: NSLocalizedString("Using the Dashboard", comment: ""),
                icon: "hand.tap.fill",
                bulletPoints: [
                    NSLocalizedString("View Daily Summary: The top card shows your current calorie intake compared to your goal", comment: ""),
                    NSLocalizedString("Check Macronutrients: Progress bars show how close you are to your protein, carbs, and fat goals", comment: ""),
                    NSLocalizedString("Monitor Micronutrients: Circular indicators show vitamin and mineral intake", comment: ""),
                    NSLocalizedString("Change Date: Use the arrows in the date selector to view different days", comment: "")
                ]
            )
            
            // Meals Section
            helpSection(
                title: NSLocalizedString("Meals Section", comment: ""),
                icon: "square.grid.2x2.fill",
                content: NSLocalizedString("The Meals section lets you log and manage your daily meals, access commonly eaten items, and view nutrition tips.", comment: ""),
                bulletPoints: [
                    NSLocalizedString("Today's Meals: Lists all meals logged for the current day", comment: ""),
                    NSLocalizedString("Common Meals: Quick access to your frequently eaten meals", comment: ""),
                    NSLocalizedString("Nutrition Tips: Provides advice tailored to your health profile", comment: ""),
                    NSLocalizedString("Food Database: Access to detailed nutritional information", comment: "")
                ]
            )
            
            // Managing Meals
            helpSection(
                title: NSLocalizedString("Managing Meals", comment: ""),
                icon: "pencil.circle.fill",
                bulletPoints: [
                    NSLocalizedString("Add a Meal: Tap the + button in the header or the Add button in Today's Meals", comment: ""),
                    NSLocalizedString("Edit a Meal: Tap on any meal in your Today's Meals list to edit it", comment: ""),
                    NSLocalizedString("Use Common Meals: Tap any meal in the Common Meals section to quickly add it to today", comment: ""),
                    NSLocalizedString("Add to Common Meals: Long-press on a meal and select Add to Common Meals", comment: ""),
                    NSLocalizedString("Delete a Meal: Long-press on a meal and select Delete", comment: "")
                ]
            )
            
            // Adding a New Meal
            helpSection(
                title: NSLocalizedString("Adding a New Meal", comment: ""),
                icon: "plus.circle.fill",
                content: NSLocalizedString("When adding a meal, follow these steps:", comment: ""),
                bulletPoints: [
                    NSLocalizedString("Search for Food: Tap 'Search Food Database' to find foods", comment: ""),
                    NSLocalizedString("Enter Meal Details: Add a name, select meal type (breakfast, lunch, dinner, or snack)", comment: ""),
                    NSLocalizedString("Set Portion Size: Choose small, medium, or large to adjust calories accordingly", comment: ""),
                    NSLocalizedString("Add Notes: Optionally add notes about the meal", comment: ""),
                    NSLocalizedString("Analyze Nutrition: View detailed nutritional breakdown before saving", comment: ""),
                    NSLocalizedString("Save Meal: Tap 'Save Meal' to add it to your day", comment: "")
                ]
            )
            
            // Finding Foods
            helpSection(
                title: NSLocalizedString("Finding Foods", comment: ""),
                icon: "magnifyingglass.circle.fill",
                content: NSLocalizedString("The food search feature helps you quickly find foods and their nutritional information:", comment: ""),
                bulletPoints: [
                    NSLocalizedString("Search Bar: Type food names to filter results", comment: ""),
                    NSLocalizedString("Category Filter: Use category buttons to narrow down options", comment: ""),
                    NSLocalizedString("Food Selection: Tap any food item to select it", comment: ""),
                    NSLocalizedString("Food Details: View calories, protein, carbs, and fat for each food", comment: ""),
                    NSLocalizedString("Custom Foods: Items marked 'Custom Food' are ones you've added yourself", comment: "")
                ]
            )
            
            // Food Database
            helpSection(
                title: NSLocalizedString("Food Database", comment: ""),
                icon: "rectangle.grid.2x2.fill",
                content: NSLocalizedString("The Food Database section provides detailed nutritional information for thousands of foods:", comment: ""),
                bulletPoints: [
                    NSLocalizedString("Access the Database: Scroll down in the Meals tab and tap the Food Database card", comment: ""),
                    NSLocalizedString("Browse Foods: Search or filter by category to find specific items", comment: ""),
                    NSLocalizedString("View Details: Tap any food to see complete nutritional information", comment: ""),
                    NSLocalizedString("Detailed Nutrients: See macronutrients, vitamins, minerals, and serving information", comment: ""),
                    NSLocalizedString("Return to Meals: Tap the back button to go back to the Meals section", comment: "")
                ]
            )
            
            // Nutrition Tips
            helpSection(
                title: NSLocalizedString("Nutrition Tips", comment: ""),
                icon: "lightbulb.fill",
                content: NSLocalizedString("Access personalized nutrition recommendations based on your health profile:", comment: ""),
                bulletPoints: [
                    NSLocalizedString("View Tips: See general tips directly in the Meals section", comment: ""),
                    NSLocalizedString("Personalized Advice: Tap 'View More Tips' for recommendations tailored to your health conditions", comment: ""),
                    NSLocalizedString("Medical Condition Tips: Get advice specific to conditions you've entered in your profile", comment: ""),
                    NSLocalizedString("Dietary Restriction Tips: Receive guidance for your specific dietary needs", comment: ""),
                    NSLocalizedString("Supplement Recommendations: Learn about supplements that may benefit your health", comment: "")
                ]
            )
            
            // Tips for Seniors
            helpSection(
                title: NSLocalizedString("Tips for Seniors", comment: ""),
                icon: "person.fill.checkmark",
                content: NSLocalizedString("Senior-Friendly Nutrition Tips:", comment: ""),
                bulletPoints: [
                    NSLocalizedString("Focus on protein-rich foods to maintain muscle mass", comment: ""),
                    NSLocalizedString("Choose nutrient-dense foods over empty calories", comment: ""),
                    NSLocalizedString("Stay well-hydrated throughout the day", comment: ""),
                    NSLocalizedString("Include calcium and vitamin D for bone health", comment: ""),
                    NSLocalizedString("Eat fiber-rich foods for digestive health", comment: ""),
                    NSLocalizedString("Incorporate omega-3 fatty acids for heart and brain health", comment: "")
                ]
            )
            
            // Troubleshooting
            helpSection(
                title: NSLocalizedString("Troubleshooting", comment: ""),
                icon: "wrench.fill",
                bulletPoints: [
                    NSLocalizedString("Meals Not Appearing: Pull down to refresh if recently added meals don't show", comment: ""),
                    NSLocalizedString("Search Not Working: Try simplifying your search terms or use category filters", comment: ""),
                    NSLocalizedString("Nutrient Goals: Your nutrient goals are based on your profile information", comment: ""),
                    NSLocalizedString("Adding Custom Foods: If you can't find a food, you can add custom entries", comment: ""),
                    NSLocalizedString("Meal History: View past days using the date selector in the Dashboard", comment: "")
                ]
            )
            
            // Need More Help?
            helpSection(
                title: NSLocalizedString("Need More Help?", comment: ""),
                icon: "questionmark.circle.fill",
                content: NSLocalizedString("For additional assistance with the Nutrition features, tap the Support button in Settings or use the voice assistant by tapping the microphone icon at the top of the screen.", comment: "")
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var moreDetailContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            // Overview
            helpSection(
                title: NSLocalizedString("Feature Overview", comment: ""),
                icon: "ellipsis.circle",
                content: NSLocalizedString("The More section provides access to essential app settings, your profile, help resources, and additional tools. This centralized hub lets you customize the app experience and access important information.", comment: "")
            )
            
            // Main Features
            helpSection(
                title: NSLocalizedString("Main Features", comment: ""),
                icon: "list.bullet",
                content: [
                    NSLocalizedString("Settings: Customize app appearance, notifications, and preferences", comment: ""),
                    NSLocalizedString("Profile: View and update your personal health information", comment: ""),
                    NSLocalizedString("Help & Support: Access guides, tutorials, and contact support", comment: ""),
                    NSLocalizedString("About: View app version, privacy policy, and terms of service", comment: ""),
                    NSLocalizedString("Print Materials: Generate printable health summaries and reports", comment: "")
                ].joined(separator: "\n\n")
            )
            
            // Settings Options
            helpSection(
                title: NSLocalizedString("Settings Options", comment: ""),
                icon: "gear",
                content: NSLocalizedString("The Settings section allows you to customize how the app works and looks:", comment: "") + "\n\n" + [
                    NSLocalizedString("Text Size: Adjust text size for better readability", comment: ""),
                    NSLocalizedString("Voice Settings: Configure voice assistant and reading features", comment: ""),
                    NSLocalizedString("Appearance: Toggle dark mode, high contrast, and other visual options", comment: ""),
                    NSLocalizedString("Language: Change the app language (English, Spanish, French, German, Hebrew)", comment: ""),
                    NSLocalizedString("Notifications: Customize alert types, sounds, and timing", comment: ""),
                    NSLocalizedString("Data Management: Back up and restore your app data", comment: "")
                ].joined(separator: "\n\n")
            )
            
            // Profile Management
            helpSection(
                title: NSLocalizedString("Profile Management", comment: ""),
                icon: "person.crop.circle",
                content: NSLocalizedString("Your profile contains important information that helps personalize the app:", comment: "") + "\n\n" + [
                    NSLocalizedString("Personal Information: Name, age, gender, and contact details", comment: ""),
                    NSLocalizedString("Medical Conditions: Health conditions that affect recommendations", comment: ""),
                    NSLocalizedString("Dietary Restrictions: Food allergies, intolerances, and preferences", comment: ""),
                    NSLocalizedString("Medications: Current medication list that integrates with reminders", comment: ""),
                    NSLocalizedString("Emergency Contacts: People to contact in case of emergency", comment: "")
                ].joined(separator: "\n\n")
            )
            
            // Help & Support
            helpSection(
                title: NSLocalizedString("Help & Support Options", comment: ""),
                icon: "questionmark.circle",
                content: NSLocalizedString("Find assistance with using the app through various resources:", comment: "") + "\n\n" + [
                    NSLocalizedString("Help Guides: Detailed instructions for each app section", comment: ""),
                    NSLocalizedString("Video Tutorials: Step-by-step visual guides for key features", comment: ""),
                    NSLocalizedString("Contact Support: Email, phone, or in-app messaging options", comment: ""),
                    NSLocalizedString("Interactive Tour: Guided walkthrough of app features", comment: ""),
                    NSLocalizedString("FAQ: Answers to common questions", comment: "")
                ].joined(separator: "\n\n")
            )
            
            // Printing
            helpSection(
                title: NSLocalizedString("Print Materials", comment: ""),
                icon: "printer",
                content: NSLocalizedString("Generate printer-friendly documents for various purposes:", comment: "") + "\n\n" + [
                    NSLocalizedString("Health Summary: Comprehensive overview of your health data", comment: ""),
                    NSLocalizedString("Medication List: Detailed list of current medications", comment: ""),
                    NSLocalizedString("Nutrition Report: Summary of your dietary intake and patterns", comment: ""),
                    NSLocalizedString("Appointment Schedule: List of upcoming medical appointments", comment: ""),
                    NSLocalizedString("Fasting Protocol: Details of your current fasting schedule", comment: "")
                ].joined(separator: "\n\n")
            )
            
            // Tips
            helpSection(
                title: NSLocalizedString("Tips for Seniors", comment: ""),
                icon: "lightbulb",
                content: NSLocalizedString("Make the most of the More section with these helpful tips:", comment: "") + "\n\n" + [
                    NSLocalizedString("Customize First: Take time to adjust text size and contrast for optimal viewing", comment: ""),
                    NSLocalizedString("Set Up Voice: Configure voice features for hands-free navigation", comment: ""),
                    NSLocalizedString("Emergency Contacts: Keep your emergency contact list updated", comment: ""),
                    NSLocalizedString("Regular Backups: Use the backup feature to protect your data", comment: ""),
                    NSLocalizedString("Print Key Info: Consider printing your medication list to keep in your wallet", comment: "")
                ].joined(separator: "\n\n")
            )
            
            // Troubleshooting
            helpSection(
                title: NSLocalizedString("Troubleshooting", comment: ""),
                icon: "wrench",
                content: [
                    NSLocalizedString("Settings Not Saving: Restart the app if settings aren't being applied", comment: ""),
                    NSLocalizedString("Profile Updates: Make sure to tap Save after changing profile information", comment: ""),
                    NSLocalizedString("Printing Problems: Ensure your device is connected to a printer or sharing service", comment: ""),
                    NSLocalizedString("Language Issues: If text appears cut off after changing language, restart the app", comment: ""),
                    NSLocalizedString("Help Videos: If videos won't play, check your internet connection", comment: "")
                ].joined(separator: "\n\n")
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func protocolSection(title: String, bestFor: String, benefits: String, howItWorks: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: userSettings.textSize.size - 1, weight: .bold))
                
                Spacer()
                
                // Add voice reading button for protocol section
                Button(action: {
                    if voiceManager.isSpeaking {
                        voiceManager.stopSpeaking()
                    } else {
                        let textToRead = "\(title). \(NSLocalizedString("Best for", comment: "")): \(bestFor). \(NSLocalizedString("Benefits", comment: "")): \(benefits). \(NSLocalizedString("How it works", comment: "")): \(howItWorks)."
                        
                        // Force using the correct language - this is what makes it work in other parts of the app
                        _ = LanguageManager.shared.currentLanguage
                        voiceManager.speak(textToRead, userSettings: userSettings)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            .foregroundColor(.blue)
                            .imageScale(.medium)
                        
                        if voiceManager.isSpeaking {
                            Text(NSLocalizedString("Stop", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 4))
                                .foregroundColor(.blue)
                        } else {
                            Text(NSLocalizedString("Read", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 4))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .accessibilityLabel(NSLocalizedString("Read Protocol Information", comment: ""))
                .accessibilityHint(NSLocalizedString("Reads out protocol details", comment: ""))
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(NSLocalizedString("Best for", comment: "") + ": " + bestFor)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                
                Text(NSLocalizedString("Benefits", comment: "") + ": " + benefits)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                
                Text(NSLocalizedString("How it works", comment: "") + ": " + howItWorks)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.vertical, 5)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(8)
        .padding(.horizontal)
        .adaptiveHelpGuideLayout()
    }
    
    private func helpSection(title: String, icon: String, content: String? = nil, bulletPoints: [String]? = nil) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                Spacer()
                
                // Add voice reading button for each section
                if content != nil || bulletPoints != nil {
                    Button(action: {
                        if voiceManager.isSpeaking {
                            voiceManager.stopSpeaking()
                        } else {
                            var textToRead = title + ". "
                            
                            if let contentText = content {
                                textToRead += contentText + " "
                            }
                            
                            if let points = bulletPoints {
                                textToRead += points.joined(separator: ". ") 
                            }
                            
                            // Force using the correct language - this is what makes it work in other parts of the app
                            _ = LanguageManager.shared.currentLanguage
                            voiceManager.speak(textToRead, userSettings: userSettings)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: voiceManager.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                                .foregroundColor(.blue)
                                .imageScale(.medium)
                            
                            if voiceManager.isSpeaking {
                                Text(NSLocalizedString("Stop", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 4))
                                    .foregroundColor(.blue)
                            } else {
                                Text(NSLocalizedString("Read", comment: ""))
                                    .font(.system(size: userSettings.textSize.size - 4))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .accessibilityLabel(NSLocalizedString("Read Section Information", comment: ""))
                    .accessibilityHint(NSLocalizedString("Reads out section content", comment: ""))
                }
            }
            .padding(.horizontal)
            
            if let content = content {
                Text(content)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            if let bulletPoints = bulletPoints {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(bulletPoints, id: \.self) { point in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.blue)
                                .padding(.top, 8)
                            
                            Text(point)
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .adaptiveHelpGuideLayout()
    }
}

// Help Contact Row Component
struct HelpContactRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(color)
                .cornerRadius(8)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MainTabView()
        .environmentObject(UserSettings())
        .environmentObject(AppointmentManager())
} 