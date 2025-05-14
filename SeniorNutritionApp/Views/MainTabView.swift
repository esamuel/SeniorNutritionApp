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
    
    var body: some View {
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
            
            Spacer()
        }
        .padding(.horizontal)
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