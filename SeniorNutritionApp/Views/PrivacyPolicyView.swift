import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject private var userSettings: UserSettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HelpSectionHeader(title: NSLocalizedString("privacy_policy_title", comment: "Privacy Policy"))
                
                Text(NSLocalizedString("privacy_policy_intro", comment: "Introduction to privacy policy."))
                    .font(.system(size: userSettings.textSize.size - 2))

                privacySection(
                    title: NSLocalizedString("privacy_section_data_collection", comment: "Title for data collection section"),
                    content: NSLocalizedString("privacy_content_data_collection", comment: "Content for data collection section")
                )
                privacySection(
                    title: NSLocalizedString("privacy_section_data_usage", comment: "Title for data usage section"),
                    content: NSLocalizedString("privacy_content_data_usage", comment: "Content for data usage section")
                )
                privacySection(
                    title: NSLocalizedString("privacy_section_data_sharing", comment: "Title for data sharing section"),
                    content: NSLocalizedString("privacy_content_data_sharing", comment: "Content for data sharing section")
                )
                privacySection(
                    title: NSLocalizedString("privacy_section_data_security", comment: "Title for data security section"),
                    content: NSLocalizedString("privacy_content_data_security", comment: "Content for data security section")
                )
                privacySection(
                    title: NSLocalizedString("privacy_section_user_rights", comment: "Title for user rights section"),
                    content: NSLocalizedString("privacy_content_user_rights", comment: "Content for user rights section")
                )
                privacySection(
                    title: NSLocalizedString("privacy_section_policy_changes", comment: "Title for policy changes section"),
                    content: NSLocalizedString("privacy_content_policy_changes", comment: "Content for policy changes section")
                )
                privacySection(
                    title: NSLocalizedString("privacy_section_contact", comment: "Title for contact section"),
                    content: NSLocalizedString("privacy_content_contact", comment: "Content for contact section")
                )

                Text(NSLocalizedString("Last Updated: June 1, 2025", comment: ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("privacy_policy_title", comment: "Privacy Policy"))
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func privacySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            Text(content)
                .font(.system(size: userSettings.textSize.size))
        }
    }
}

#Preview {
    NavigationView {
        PrivacyPolicyView()
            .environmentObject(UserSettings())
    }
}
