import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            FastingTimerView()
                .tabItem {
                    Label("Fasting", systemImage: "timer")
                }
                .tag(1)
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                .tag(2)
            
            MedicationView()
                .tabItem {
                    Label("Medication", systemImage: "pills")
                }
                .tag(3)
        }
        .onAppear {
            // Set up tab bar appearance
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