import SwiftUI

struct FastingView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        FastingTimerView()
            .environmentObject(userSettings)
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