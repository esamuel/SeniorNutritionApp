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
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            FastingTimerView()
                .tabItem {
                    Label("Fasting", systemImage: "timer")
                }
                .tag(1)
            
            WaterReminderView()
                .tabItem {
                    Label("Water", systemImage: "drop.fill")
                }
                .tag(2)
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                .tag(3)
            
            MoreTabView()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
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
            .navigationTitle("More")
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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Help & Support Information")
                        .font(.headline)
                        .padding()
                    
                    Text("This is the help section for the Senior Nutrition App.")
                        .padding()
                }
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

#Preview {
    MainTabView()
        .environmentObject(UserSettings())
        .environmentObject(AppointmentManager())
} 