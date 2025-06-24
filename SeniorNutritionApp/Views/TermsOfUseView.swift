import SwiftUI

struct TermsOfUseView: View {
    @EnvironmentObject private var userSettings: UserSettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HelpSectionHeader(title: NSLocalizedString("terms_of_use_title", comment: "Terms of Use"))

                Text(NSLocalizedString("terms_intro", comment: "Introduction to terms of use."))
                    .font(.system(size: userSettings.textSize.size - 2))

                termsSection(
                    title: NSLocalizedString("terms_section_acceptance", comment: "Title for acceptance of terms section"),
                    content: NSLocalizedString("terms_content_acceptance", comment: "Content for acceptance of terms section")
                )
                termsSection(
                    title: NSLocalizedString("terms_section_health_disclaimer", comment: "Title for health disclaimer section"),
                    content: NSLocalizedString("terms_content_health_disclaimer", comment: "Content for health disclaimer section")
                )
                termsSection(
                    title: NSLocalizedString("terms_section_user_accounts", comment: "Title for user accounts section"),
                    content: NSLocalizedString("terms_content_user_accounts", comment: "Content for user accounts section")
                )
                termsSection(
                    title: NSLocalizedString("terms_section_ip", comment: "Title for intellectual property section"),
                    content: NSLocalizedString("terms_content_ip", comment: "Content for intellectual property section")
                )
                termsSection(
                    title: NSLocalizedString("terms_section_termination", comment: "Title for termination of use section"),
                    content: NSLocalizedString("terms_content_termination", comment: "Content for termination of use section")
                )
                termsSection(
                    title: NSLocalizedString("terms_section_liability", comment: "Title for limitation of liability section"),
                    content: NSLocalizedString("terms_content_liability", comment: "Content for limitation of liability section")
                )
                termsSection(
                    title: NSLocalizedString("terms_section_governing_law", comment: "Title for governing law section"),
                    content: NSLocalizedString("terms_content_governing_law", comment: "Content for governing law section")
                )

                Text(NSLocalizedString("Last Updated: June 1, 2025", comment: ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("terms_of_use_title", comment: "Terms of Use"))
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }

    private func termsSection(title: String, content: String) -> some View {
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
        TermsOfUseView()
            .environmentObject(UserSettings())
    }
}
