import SwiftUI

struct VoiceAssistanceHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Introduction
                HelpSectionHeader(title: NSLocalizedString("voice_help_nav_title", comment: "Voice Help"))
                Text(NSLocalizedString("voice_help_intro", comment: "Introduction to voice commands."))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .padding(.bottom)

                // Activation
                HelpSectionHeader(title: NSLocalizedString("voice_activation_header", comment: "Activating Voice Commands"))
                VStack(alignment: .leading, spacing: 8) {
                    step(1, text: NSLocalizedString("voice_activation_step1", comment: "Step 1"))
                    step(2, text: NSLocalizedString("voice_activation_step2", comment: "Step 2"))
                    step(3, text: NSLocalizedString("voice_activation_step3", comment: "Step 3"))
                    step(4, text: NSLocalizedString("voice_activation_step4", comment: "Step 4"))
                }
                .padding(.bottom)

                // Available Commands
                HelpSectionHeader(title: NSLocalizedString("voice_commands_header", comment: "Available Voice Commands"))
                
                commandSection(title: NSLocalizedString("voice_nav_commands_header", comment: "Navigation Commands"), commands: [
                    ("house.fill", NSLocalizedString("voice_command_navigate_home", comment: "Navigate home")),
                    ("fork.knife", NSLocalizedString("voice_command_navigate_nutrition", comment: "Navigate nutrition")),
                    ("drop.fill", NSLocalizedString("voice_command_navigate_water", comment: "Navigate water")),
                    ("timer", NSLocalizedString("voice_command_navigate_fasting", comment: "Navigate fasting")),
                    ("pill.fill", NSLocalizedString("voice_command_view_medications", comment: "View medications")),
                    ("questionmark.circle.fill", NSLocalizedString("voice_command_open_help", comment: "Open help"))
                ])
                
                commandSection(title: NSLocalizedString("voice_action_commands_header", comment: "Action Commands"), commands: [
                    ("plus.circle.fill", NSLocalizedString("voice_command_log_water", comment: "Log water")),
                    ("plus.square.fill.on.square.fill", NSLocalizedString("voice_command_record_meal", comment: "Record meal")),
                    ("play.circle.fill", NSLocalizedString("voice_command_begin_fast", comment: "Begin fast")),
                    ("stop.circle.fill", NSLocalizedString("voice_command_end_fast", comment: "End fast")),
                    ("checkmark.circle.fill", NSLocalizedString("voice_command_mark_medication_taken", comment: "Mark medication taken")),
                    ("calendar.badge.plus", NSLocalizedString("voice_command_create_reminder", comment: "Create reminder")),
                    ("gearshape.fill", NSLocalizedString("voice_command_set_language", comment: "Set language"))
                ])
                
                commandSection(title: NSLocalizedString("voice_info_commands_header", comment: "Information Commands"), commands: [
                    ("chart.pie.fill", NSLocalizedString("voice_command_daily_progress", comment: "Daily progress")),
                    ("info.circle.fill", NSLocalizedString("voice_command_check_water_intake", comment: "Check water intake")),
                    ("alarm.fill", NSLocalizedString("voice_command_next_medication", comment: "Next medication")),
                    ("hourglass", NSLocalizedString("voice_command_check_fast_status", comment: "Check fast status"))
                ])
                
                // Tips
                HelpSectionHeader(title: NSLocalizedString("voice_tips_header", comment: "Tips for Better Voice Recognition"))
                VStack(alignment: .leading, spacing: 8) {
                    tip(text: NSLocalizedString("voice_tip_speak_clearly", comment: "Tip 1"))
                    tip(text: NSLocalizedString("voice_tip_reduce_noise", comment: "Tip 2"))
                    tip(text: NSLocalizedString("voice_tip_rephrase", comment: "Tip 3"))
                    tip(text: NSLocalizedString("voice_tip_use_exact_phrases", comment: "Tip 4"))
                }
                .padding(.bottom)

                // Video Tutorial
                HelpSectionHeader(title: NSLocalizedString("video_tutorial_header", comment: "Video Tutorial"))
                VideoTutorialView(videoName: "VoiceAssistanceTutorial", videoType: "mp4")

            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("voice_help_nav_title", comment: "Voice Help"))
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }

    private func step(_ number: Int, text: String) -> some View {
        HStack(alignment: .top) {
            Text("\(number).")
                .bold()
                .font(.system(size: userSettings.textSize.size - 1))
            Text(text)
                .font(.system(size: userSettings.textSize.size - 2))
        }
    }
    
    private func commandSection(title: String, commands: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                .padding(.bottom, 2)
            ForEach(commands, id: \.1) { command in
                commandExample(icon: command.0, text: command.1)
            }
        }
        .padding(.bottom)
    }

    private func commandExample(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: userSettings.textSize.size - 1))
                .frame(width: 25, alignment: .center)
                .foregroundColor(.accentColor)
            Text(text)
                .font(.system(size: userSettings.textSize.size - 2))
        }
    }

    private func tip(text: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
                .font(.system(size: userSettings.textSize.size - 1))
            Text(text)
                .font(.system(size: userSettings.textSize.size - 2))
        }
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
