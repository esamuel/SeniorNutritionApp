import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    
    var body: some View {
        TabView {
            // In RTL languages like Hebrew, we need to reverse the tab order
            Group {
                if layoutDirection == .rightToLeft {
                    MenuView()
                .tabItem {
                            Image(systemName: "ellipsis")
                            Text(NSLocalizedString("More", comment: ""))
                        }
                    
                    FastingView()
                        .tabItem {
                            Image(systemName: "timer")
                            Text(NSLocalizedString("Fast", comment: ""))
                        }
                    
                    WaterView()
                        .tabItem {
                            Image(systemName: "drop.fill")
                            Text(NSLocalizedString("Water", comment: ""))
                        }
                    
                    NutritionView()
                        .tabItem {
                            Image(systemName: "fork.knife")
                            Text(NSLocalizedString("Nutrition", comment: ""))
                        }
                    
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text(NSLocalizedString("Home", comment: ""))
                        }
                } else {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text(NSLocalizedString("Home", comment: ""))
                        }
                    
                    NutritionView()
                        .tabItem {
                            Image(systemName: "fork.knife")
                            Text(NSLocalizedString("Nutrition", comment: ""))
                        }
                    
                    WaterView()
                        .tabItem {
                            Image(systemName: "drop.fill")
                            Text(NSLocalizedString("Water", comment: ""))
                        }
                    
                    FastingView()
                        .tabItem {
                            Image(systemName: "timer")
                            Text(NSLocalizedString("Fast", comment: ""))
                        }
                    
                    MenuView()
                        .tabItem {
                            Image(systemName: "ellipsis")
                            Text(NSLocalizedString("More", comment: ""))
                        }
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