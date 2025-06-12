import SwiftUI

struct VoiceAssistantButton: View {
    @EnvironmentObject var voiceAssistant: VoiceAssistantManager
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Button(action: {
            if voiceAssistant.isListening {
                // When stopping, cancel any pending commands
                voiceAssistant.stopListening()
            } else {
                voiceAssistant.startListening()
            }
        }) {
            Image(systemName: voiceAssistant.isListening ? "waveform.circle.fill" : "mic.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundColor(voiceAssistant.isListening ? .red : .blue)
                .padding(5)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    Circle()
                        .stroke(voiceAssistant.isListening ? Color.red : Color.blue, lineWidth: 2)
                        .opacity(voiceAssistant.isListening ? 0.8 : 0.5)
                )
        }
        .accessibilityLabel(Text("Voice Assistant"))
        .accessibilityHint(Text(voiceAssistant.isListening ? "Tap to stop listening" : "Tap to start voice commands"))
        .overlay(
            VoiceFeedbackView()
                .environmentObject(voiceAssistant)
        )
    }
}

struct VoiceFeedbackView: View {
    @EnvironmentObject var voiceAssistant: VoiceAssistantManager
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    
    var body: some View {
        ZStack {
            if voiceAssistant.showFeedback {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 8) {
                            if voiceAssistant.isListening {
                                Text(NSLocalizedString("Listening...", comment: ""))
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(voiceAssistant.recognizedText)
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            } else {
                                // Show feedback message with appropriate color based on content
                                Text(voiceAssistant.feedbackMessage)
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                    .foregroundColor(voiceAssistant.feedbackMessage.contains("not recognized") ? .red : .white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                                    .padding(.horizontal, 8)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(voiceAssistant.feedbackMessage.contains("not recognized") ? Color.red : Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .frame(minWidth: 200)
                        .padding(layoutDirection == .rightToLeft ? .leading : .trailing, 20)
                        .padding(.bottom, 100)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: voiceAssistant.showFeedback)
            }
        }
    }
}

#Preview {
    VoiceAssistantButton()
        .environmentObject(VoiceAssistantManager())
        .environmentObject(UserSettings())
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.2))
}
