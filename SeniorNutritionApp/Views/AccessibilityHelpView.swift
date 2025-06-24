import SwiftUI

struct AccessibilityHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "accessibility")
                            .font(.system(size: 40))
                            .foregroundColor(.indigo)
                        
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Accessibility Features", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Make the app easier to use with accessibility options", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // Text Size Section
                HelpSection(
                    title: NSLocalizedString("Text Size Options", comment: ""),
                    content: [
                        NSLocalizedString("Small: Compact text for more information on screen", comment: ""),
                        NSLocalizedString("Medium: Standard text size (default)", comment: ""),
                        NSLocalizedString("Large: Easier to read for vision challenges", comment: ""),
                        NSLocalizedString("Extra Large: Maximum readability for low vision", comment: ""),
                        NSLocalizedString("Change text size in Settings > Accessibility", comment: "")
                    ]
                )
                
                // High Contrast Section
                HelpSection(
                    title: NSLocalizedString("High Contrast Mode", comment: ""),
                    content: [
                        NSLocalizedString("Enhances text and button visibility", comment: ""),
                        NSLocalizedString("Increases contrast between elements", comment: ""),
                        NSLocalizedString("Makes the app easier to navigate", comment: ""),
                        NSLocalizedString("Helpful for users with vision impairments", comment: ""),
                        NSLocalizedString("Toggle in Settings > Accessibility", comment: "")
                    ]
                )
                
                // Voice Assistance Section
                HelpSection(
                    title: NSLocalizedString("Voice Assistance", comment: ""),
                    content: [
                        NSLocalizedString("Use voice commands to navigate the app", comment: ""),
                        NSLocalizedString("Hands-free operation for mobility challenges", comment: ""),
                        NSLocalizedString("Voice feedback for all app actions", comment: ""),
                        NSLocalizedString("Customizable voice settings and speed", comment: ""),
                        NSLocalizedString("Access detailed voice help in Voice Assistance section", comment: "")
                    ]
                )
                
                // Navigation Assistance Section
                HelpSection(
                    title: NSLocalizedString("Navigation Assistance", comment: ""),
                    content: [
                        NSLocalizedString("Large, easy-to-tap buttons throughout the app", comment: ""),
                        NSLocalizedString("Clear visual hierarchy and organization", comment: ""),
                        NSLocalizedString("Consistent navigation patterns", comment: ""),
                        NSLocalizedString("Back buttons always visible", comment: ""),
                        NSLocalizedString("Minimal gestures required for operation", comment: "")
                    ]
                )
                
                // Color and Visual Aids Section
                HelpSection(
                    title: NSLocalizedString("Color and Visual Aids", comment: ""),
                    content: [
                        NSLocalizedString("Color-coded sections for easy identification", comment: ""),
                        NSLocalizedString("Icons accompany all text labels", comment: ""),
                        NSLocalizedString("Clear visual feedback for all actions", comment: ""),
                        NSLocalizedString("Progress indicators for long operations", comment: ""),
                        NSLocalizedString("Consistent color scheme throughout", comment: "")
                    ]
                )
                
                // Cognitive Support Section
                HelpSection(
                    title: NSLocalizedString("Cognitive Support Features", comment: ""),
                    content: [
                        NSLocalizedString("Simple, intuitive interface design", comment: ""),
                        NSLocalizedString("Step-by-step guidance for complex tasks", comment: ""),
                        NSLocalizedString("Clear confirmation messages", comment: ""),
                        NSLocalizedString("Consistent terminology throughout", comment: ""),
                        NSLocalizedString("Helpful tooltips and explanations", comment: ""),
                        NSLocalizedString("Undo options for most actions", comment: "")
                    ]
                )
                
                // Motor Assistance Section
                HelpSection(
                    title: NSLocalizedString("Motor Assistance", comment: ""),
                    content: [
                        NSLocalizedString("Large touch targets for easy tapping", comment: ""),
                        NSLocalizedString("Minimal fine motor skills required", comment: ""),
                        NSLocalizedString("Voice commands reduce physical interaction", comment: ""),
                        NSLocalizedString("Simple swipe gestures only", comment: ""),
                        NSLocalizedString("No complex multi-finger gestures", comment: "")
                    ]
                )
                
                // Settings and Customization Section
                HelpSection(
                    title: NSLocalizedString("Settings and Customization", comment: ""),
                    content: [
                        NSLocalizedString("Access all accessibility settings in Settings tab", comment: ""),
                        NSLocalizedString("Changes apply immediately across the app", comment: ""),
                        NSLocalizedString("Settings are saved automatically", comment: ""),
                        NSLocalizedString("Reset to defaults option available", comment: ""),
                        NSLocalizedString("Test settings before committing to changes", comment: "")
                    ]
                )
                
                // Troubleshooting Section
                HelpSection(
                    title: NSLocalizedString("Troubleshooting", comment: ""),
                    content: [
                        NSLocalizedString("If text is too small, increase text size in Settings", comment: ""),
                        NSLocalizedString("If buttons are hard to tap, enable high contrast", comment: ""),
                        NSLocalizedString("If voice commands aren't working, check microphone permissions", comment: ""),
                        NSLocalizedString("If app seems slow, try reducing text size", comment: ""),
                        NSLocalizedString("Contact support for additional accessibility needs", comment: "")
                    ]
                )
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Accessibility Help", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AccessibilityHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccessibilityHelpView()
                .environmentObject(UserSettings())
        }
    }
} 