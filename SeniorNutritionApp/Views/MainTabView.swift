import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var selectedTab = 0 // 0 = Home tab (always opens to Home regardless of language)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // In RTL languages like Hebrew, we need to reverse the tab order
            Group {
                if layoutDirection == .rightToLeft {
                    MenuView()
                        .tabItem {
                            Image(systemName: "ellipsis")
                            Text(NSLocalizedString("More", comment: ""))
                        }
                        .tag(4)
                    
                    FastingView()
                        .tabItem {
                            Image(systemName: "timer")
                            Text(NSLocalizedString("Fast", comment: ""))
                        }
                        .tag(3)
                    
                    WaterReminderView()
                        .tabItem {
                            Image(systemName: "drop.fill")
                            Text(NSLocalizedString("Water", comment: ""))
                        }
                        .tag(2)
                    
                    NutritionView()
                        .tabItem {
                            Image(systemName: "fork.knife")
                            Text(NSLocalizedString("Nutrition", comment: ""))
                        }
                        .tag(1)
                    
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text(NSLocalizedString("Home", comment: ""))
                        }
                        .tag(0)
                } else {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text(NSLocalizedString("Home", comment: ""))
                        }
                        .tag(0)
                    
                    NutritionView()
                        .tabItem {
                            Image(systemName: "fork.knife")
                            Text(NSLocalizedString("Nutrition", comment: ""))
                        }
                        .tag(1)
                    
                    WaterReminderView()
                        .tabItem {
                            Image(systemName: "drop.fill")
                            Text(NSLocalizedString("Water", comment: ""))
                        }
                        .tag(2)
                    
                    FastingView()
                        .tabItem {
                            Image(systemName: "timer")
                            Text(NSLocalizedString("Fast", comment: ""))
                        }
                        .tag(3)
                    
                    MenuView()
                        .tabItem {
                            Image(systemName: "ellipsis")
                            Text(NSLocalizedString("More", comment: ""))
                        }
                        .tag(4)
                }
            }
        }
        .environment(\.layoutDirection, layoutDirection)
        .accentColor(.blue)
        .font(.system(size: userSettings.textSize.size))
    }
}

// Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
    MainTabView()
        .environmentObject(UserSettings())
    }
} 