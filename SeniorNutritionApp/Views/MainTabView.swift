import SwiftUI
import Speech

struct MainTabView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var voiceAssistant: VoiceAssistantManager
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var selectedTab = 0 // 0 = Home tab (always opens to Home regardless of language)
    
    // Handle voice navigation commands
    private let tabNavigationPublisher = NotificationCenter.default.publisher(for: Notification.Name("NavigateToTab"))
    private let destinationNavigationPublisher = NotificationCenter.default.publisher(for: Notification.Name("NavigateTo"))
    private let voiceActionPublisher = NotificationCenter.default.publisher(for: Notification.Name("VoiceAction"))
    private let voiceInfoPublisher = NotificationCenter.default.publisher(for: Notification.Name("VoiceInfo"))
    
    var body: some View {
        ZStack {
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
            // Handle tab navigation commands
            .onReceive(tabNavigationPublisher) { notification in
                if let tabName = notification.userInfo?["tab"] as? String {
                    navigateToTab(named: tabName)
                }
            }
            // Handle specific destination navigation commands
            .onReceive(destinationNavigationPublisher) { notification in
                if let destination = notification.userInfo?["destination"] as? String {
                    handleNavigateToDestination(destination)
                }
            }
            // Handle voice actions
            .onReceive(voiceActionPublisher) { notification in
                if let action = notification.userInfo?["action"] as? String {
                    handleVoiceAction(action)
                }
            }
            // Handle voice info requests
            .onReceive(voiceInfoPublisher) { notification in
                if let info = notification.userInfo?["info"] as? String {
                    handleVoiceInfo(info)
                }
            }
            
            // Add the voice assistant button as an overlay
            VoiceAssistantButton()
                .frame(width: 36, height: 36)
                .position(
                    x: layoutDirection == .rightToLeft ? 30 : UIScreen.main.bounds.width - 30, 
                    y: 80
                )
                .zIndex(100)
        }
        .onAppear {
            // Set up direct notification observers for more reliable handling
            setupNotificationObservers()
            print("MainTabView appeared - notification observers set up")
        }
    }
}

// MARK: - Notification Handling
extension MainTabView {
    /// Set up direct notification observers for more reliable handling
    func setupNotificationObservers() {
        // Remove any existing observers to prevent duplicates
        NotificationCenter.default.removeObserver(self)
        
        // Set up observers for all voice command notification types
        NotificationCenter.default.addObserver(
            forName: Notification.Name("NavigateToTab"),
            object: nil,
            queue: .main
        ) { notification in
            guard let tabName = notification.userInfo?["tab"] as? String else { return }
            print("Received NavigateToTab notification: \(tabName)")
            self.navigateToTab(named: tabName)
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("NavigateTo"),
            object: nil,
            queue: .main
        ) { notification in
            guard let destination = notification.userInfo?["destination"] as? String else { return }
            print("Received NavigateTo notification: \(destination)")
            self.handleNavigateToDestination(destination)
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("VoiceAction"),
            object: nil,
            queue: .main
        ) { notification in
            guard let action = notification.userInfo?["action"] as? String else { return }
            print("Received VoiceAction notification: \(action)")
            self.handleVoiceAction(action)
        }
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name("VoiceInfo"),
            object: nil,
            queue: .main
        ) { notification in
            guard let info = notification.userInfo?["info"] as? String else { return }
            print("Received VoiceInfo notification: \(info)")
            self.handleVoiceInfo(info)
        }
    }
}

// MARK: - Navigation
extension MainTabView {
    /// Navigate to a specific tab based on its name
    func navigateToTab(named tabName: String) {
        // Convert tab name to tab index
        switch tabName.lowercased() {
        case "home":
            selectedTab = 0
        case "nutrition":
            selectedTab = 1
        case "water":
            selectedTab = 2
        case "fasting", "fast":
            selectedTab = 3
        case "settings", "more":
            selectedTab = 4
        case "medication", "medications":
            // Navigate to medications in the settings tab
            selectedTab = 4
            // We'll need to handle deeper navigation in the MenuView
            NotificationCenter.default.post(name: Notification.Name("OpenMedications"), object: nil)
        default:
            print("Unknown tab name: \(tabName)")
        }
    }
    
    /// Handle navigation to specific destinations
    func handleNavigateToDestination(_ destination: String) {
        switch destination.lowercased() {
        case "help":
            // Navigate to help section
            selectedTab = 4 // Go to More tab first
            // Post notification to open help from the MenuView
            NotificationCenter.default.post(name: Notification.Name("OpenHelp"), object: nil)
        case "medication", "medications":
            // Navigate to medications
            selectedTab = 4
            NotificationCenter.default.post(name: Notification.Name("OpenMedications"), object: nil)
        case "settings":
            selectedTab = 4
        default:
            print("Unknown destination: \(destination)")
        }
    }
    
    /// Handle voice actions
    func handleVoiceAction(_ action: String) {
        switch action.lowercased() {
        case "addwater":
            // Navigate to water tab and trigger add water action
            selectedTab = 2
            NotificationCenter.default.post(name: Notification.Name("AddWater"), object: nil)
        case "logmeal":
            // Navigate to nutrition tab and trigger log meal action
            selectedTab = 1
            NotificationCenter.default.post(name: Notification.Name("LogMeal"), object: nil)
        case "startfast":
            // Navigate to fasting tab and trigger start fast action
            selectedTab = 3
            NotificationCenter.default.post(name: Notification.Name("StartFast"), object: nil)
        case "setreminder":
            // Navigate to appropriate tab and trigger set reminder action
            selectedTab = 0 // Assuming reminders are set from home tab
            NotificationCenter.default.post(name: Notification.Name("SetReminder"), object: nil)
        default:
            print("Unknown action: \(action)")
        }
    }
    
    /// Handle voice info requests
    func handleVoiceInfo(_ info: String) {
        switch info.lowercased() {
        case "progresssummary":
            // Navigate to home tab to show progress summary
            selectedTab = 0
            NotificationCenter.default.post(name: Notification.Name("ShowProgressSummary"), object: nil)
        case "waterintake":
            // Navigate to water tab to show water intake
            selectedTab = 2
            NotificationCenter.default.post(name: Notification.Name("ShowWaterIntake"), object: nil)
        case "nextmedication":
            // Navigate to medications to show next medication
            selectedTab = 4
            NotificationCenter.default.post(name: Notification.Name("ShowNextMedication"), object: nil)
        case "fastingstatus":
            // Navigate to fasting tab to show fasting status
            selectedTab = 3
            NotificationCenter.default.post(name: Notification.Name("ShowFastingStatus"), object: nil)
        default:
            print("Unknown info request: \(info)")
        }
    }
}

// Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
    MainTabView()
        .environmentObject(UserSettings())
        .environmentObject(VoiceAssistantManager())
    }
}
