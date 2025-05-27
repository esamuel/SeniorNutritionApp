import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.layoutDirection) var layoutDirection
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Privacy Policy", comment: ""))
                    .font(.system(size: userSettings.textSize.size * 1.5, weight: .bold))
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: layoutDirection == .rightToLeft ? .trailing : .leading)

                Text(NSLocalizedString("Last Updated", comment: "") + ": " + NSLocalizedString("June 15, 2023", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                Text(NSLocalizedString("Privacy Policy Introduction", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.bottom, 20)
                
                privacyPolicyContent
                    .font(.system(size: userSettings.textSize.size))
                
                contactInformation
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Privacy Policy", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var privacyPolicyContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            privacySection(
                title: NSLocalizedString("1. Information We Collect", comment: ""),
                content: NSLocalizedString("Information We Collect Content", comment: "")
            )
            
            privacySection(
                title: NSLocalizedString("2. How We Use Your Information", comment: ""),
                content: NSLocalizedString("How We Use Information Content", comment: "")
            )
            
            privacySection(
                title: NSLocalizedString("3. Information Sharing", comment: ""),
                content: NSLocalizedString("Information Sharing Content", comment: "")
            )
            
            // Add other sections as needed...
        }
    }
    
    private var contactInformation: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(NSLocalizedString("Contact Information", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            Text(NSLocalizedString("Support Email", comment: "") + ": support@seniornutritionapp.com")
            Text(NSLocalizedString("Company Location", comment: "") + ": " + NSLocalizedString("Tel Aviv, Israel", comment: ""))
        }
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
