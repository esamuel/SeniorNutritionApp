import SwiftUI

struct TermsOfUseView: View {
    @Environment(\.layoutDirection) var layoutDirection
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Terms of Service", comment: ""))
                    .font(.system(size: userSettings.textSize.size * 1.5, weight: .bold))
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: layoutDirection == .rightToLeft ? .trailing : .leading)

                Text(NSLocalizedString("Last Updated", comment: "") + ": " + NSLocalizedString("June 15, 2023", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                Text(NSLocalizedString("Terms Introduction", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.bottom, 20)
                
                termsContent
                    .font(.system(size: userSettings.textSize.size))
                
                contactInformation
                    .font(.system(size: userSettings.textSize.size))
                    .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Terms of Service", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var termsContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            termsSection(
                title: NSLocalizedString("1. Use of the App", comment: ""),
                content: NSLocalizedString("Use of App Content", comment: "")
            )
            
            termsSection(
                title: NSLocalizedString("2. Medical Disclaimer", comment: ""),
                content: NSLocalizedString("Medical Disclaimer Content", comment: "")
            )
            
            termsSection(
                title: NSLocalizedString("3. Your Account", comment: ""),
                content: NSLocalizedString("Account Content", comment: "")
            )
            
            termsSection(
                title: NSLocalizedString("4. Privacy and Data", comment: ""),
                content: NSLocalizedString("Privacy Content", comment: "")
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
