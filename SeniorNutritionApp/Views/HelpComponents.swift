import SwiftUI
import Foundation

// Reusable help components for consistent UI across the app
struct HelpComponents {
    
    // Standard help button styling for consistent appearance
    struct HelpButton: View {
        let title: String
        let subtitle: String
        let icon: String
        let color: Color
        let action: () -> Void
        @EnvironmentObject private var userSettings: UserSettings
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(color)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        Text(subtitle)
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .foregroundColor(.primary)
        }
    }
    
    // Popup for contextual help throughout the app
    struct ContextualHelpPopup: View {
        let title: String
        let message: String
        let isShowing: Binding<Bool>
        @EnvironmentObject private var userSettings: UserSettings
        
        var body: some View {
            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                
                Text(message)
                    .font(.system(size: userSettings.textSize.size))
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    withAnimation {
                        isShowing.wrappedValue = false
                    }
                }) {
                    Text(NSLocalizedString("Got it", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
        }
    }
    
    // Consistent section header styling for help topics
    struct HelpSectionHeader: View {
        let title: String
        @EnvironmentObject private var userSettings: UserSettings
        
        var body: some View {
            Text(title)
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 10)
        }
    }
    
    // Component for feature guides and tutorials
    struct HelpTopic: View {
        let title: String
        let description: String
        let content: String
        @EnvironmentObject private var userSettings: UserSettings
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                Text(description)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text(content)
                    .font(.system(size: userSettings.textSize.size))
                    .lineSpacing(4)
            }
            .padding()
        }
    }
}
