import SwiftUI

struct FastingView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        FastingTimerView()
            .environmentObject(userSettings)
            .environmentObject(languageManager)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("Fasting Timer", comment: ""))
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .multilineTextAlignment(.center)
                }
            }
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