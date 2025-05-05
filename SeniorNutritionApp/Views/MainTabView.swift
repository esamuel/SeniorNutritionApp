import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedTab = 0
    
    // Define a color for each tab
    private let tabColors: [Color] = [
        .blue,    // Home
        .orange,  // Fasting
        .cyan,    // Water
        .green,   // Nutrition
        .purple,  // Medication
        .indigo   // Profile
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
            
            MedicationView()
                .tabItem {
                    Label("Medication", systemImage: "pills.fill")
                }
                .tag(4)
            
            HealthDataTabView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }
                .tag(5)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(6)
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

#Preview {
    MainTabView()
        .environmentObject(UserSettings())
} 