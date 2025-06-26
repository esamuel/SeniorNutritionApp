import SwiftUI

struct FastingView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        FastingTimerView()
            .environmentObject(userSettings)
            .environmentObject(languageManager)
    }
}

// Preview provider for SwiftUI canvas
struct FastingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FastingView()
                .environmentObject(UserSettings())
        }
    }
} 