import SwiftUI
import Foundation

struct VoiceAssistanceHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HelpComponents.HelpTopic(
                    title: NSLocalizedString("Voice Assistance", comment: ""),
                    description: NSLocalizedString("Learn how to use voice commands", comment: ""),
                    content: ""
                )
                
                // Introduction Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Using Voice Commands", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Voice commands make the app easier to use, especially for those with limited mobility or vision. Here's how to get started:", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                }
                .padding(.bottom, 10)
                
                // Activating Voice Commands Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Activating Voice Commands", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    helpStep(number: 1, text: NSLocalizedString("Tap the microphone icon in the top right corner of any screen", comment: ""))
                    helpStep(number: 2, text: NSLocalizedString("Wait for the \"Listening...\" prompt", comment: ""))
                    helpStep(number: 3, text: NSLocalizedString("Speak your command clearly and then pause", comment: ""))
                    helpStep(number: 4, text: NSLocalizedString("The app will automatically process your command without needing to tap again", comment: ""))
                    helpStep(number: 5, text: NSLocalizedString("You'll see a confirmation message and the app will take action", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Available Commands Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Available Voice Commands", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    Text(NSLocalizedString("Navigation Commands:", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    
                    commandExample(command: "Go to home", description: NSLocalizedString("Navigate to the home screen", comment: ""))
                    commandExample(command: "Open nutrition", description: NSLocalizedString("Go to the nutrition tracking screen", comment: ""))
                    commandExample(command: "Show water tracker", description: NSLocalizedString("Open the water tracking screen", comment: ""))
                    commandExample(command: "Go to fasting timer", description: NSLocalizedString("Navigate to the fasting timer", comment: ""))
                    commandExample(command: "Open medications", description: NSLocalizedString("View your medications", comment: ""))
                    commandExample(command: "Show help", description: NSLocalizedString("Open the help screen", comment: ""))
                    
                    Text(NSLocalizedString("Action Commands:", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .padding(.top, 10)
                    
                    commandExample(command: "Add water", description: NSLocalizedString("Log water consumption", comment: ""))
                    commandExample(command: "Log meal", description: NSLocalizedString("Record a new meal", comment: ""))
                    commandExample(command: "Start fast", description: NSLocalizedString("Begin a fasting period", comment: ""))
                    commandExample(command: "End fast", description: NSLocalizedString("End the current fast", comment: ""))
                    commandExample(command: "Take medication", description: NSLocalizedString("Mark medication as taken", comment: ""))
                    commandExample(command: "Set reminder", description: NSLocalizedString("Create a new reminder", comment: ""))
                    
                    Text(NSLocalizedString("Information Commands:", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .semibold))
                        .padding(.top, 10)
                    
                    commandExample(command: "What's my progress", description: NSLocalizedString("Hear a summary of your daily progress", comment: ""))
                    commandExample(command: "How much water today", description: NSLocalizedString("Check your water intake for the day", comment: ""))
                    commandExample(command: "Next medication", description: NSLocalizedString("Find out when your next medication is due", comment: ""))
                    commandExample(command: "Fasting status", description: NSLocalizedString("Check the status of your current fast", comment: ""))
                }
                .padding(.bottom, 10)
                
                // Tips for Better Recognition Section
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("Tips for Better Voice Recognition", comment: ""))
                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    
                    bulletPoint(text: NSLocalizedString("Speak clearly and at a moderate pace", comment: ""))
                    bulletPoint(text: NSLocalizedString("Reduce background noise when possible", comment: ""))
                    bulletPoint(text: NSLocalizedString("Hold the device about 8-12 inches from your mouth", comment: ""))
                    bulletPoint(text: NSLocalizedString("If the app doesn't understand, try rephrasing your command", comment: ""))
                    bulletPoint(text: NSLocalizedString("For better recognition, use the exact command phrases listed above", comment: ""))
                }
                
                // Video Tutorial Link
                NavigationLink(destination: VideoTutorialView(
                    videoName: "VoiceCommands",
                    videoDescription: NSLocalizedString("A demonstration of voice command features", comment: "")
                )) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.blue)
                        Text(NSLocalizedString("Watch Video Tutorial", comment: ""))
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Voice Help", comment: ""))
    }
    
    private func helpStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(Color.purple)
                .cornerRadius(13)
            
            Text(text)
                .font(.system(size: userSettings.textSize.size))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    private func bulletPoint(text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.system(size: userSettings.textSize.size + 4))
                .foregroundColor(.purple)
            
            Text(text)
                .font(.system(size: userSettings.textSize.size))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
    
    private func commandExample(command: String, description: String) -> some View {
        HStack {
            Text("\"\(command)\"")
                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                .foregroundColor(.purple)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(4)
            
            Text("—")
                .foregroundColor(.secondary)
            
            Text(description)
                .font(.system(size: userSettings.textSize.size - 1))
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

struct VoiceAssistanceHelpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VoiceAssistanceHelpView()
                .environmentObject(UserSettings())
        }
    }
}
