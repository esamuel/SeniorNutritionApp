import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.layoutDirection) private var layoutDirection
    
    var body: some View {
        NavigationView {
            List {
                // HEALTH & WELLNESS section
                Section(header: sectionHeader(NSLocalizedString("HEALTH & WELLNESS", comment: ""))) {
                    menuItem(icon: "pill.fill", title: NSLocalizedString("Medications", comment: ""), color: .purple)
                    menuItem(icon: "lightbulb.fill", title: NSLocalizedString("Health Tips", comment: ""), color: .orange)
                }
                
                // HELP & SUPPORT section
                Section(header: sectionHeader(NSLocalizedString("HELP & SUPPORT", comment: ""))) {
                    menuItem(icon: "questionmark.circle.fill", title: NSLocalizedString("Help", comment: ""), color: .teal)
                    menuItem(icon: "phone.fill", title: NSLocalizedString("Emergency Contacts", comment: ""), color: .red)
                }
            }
            .navigationTitle(NSLocalizedString("More", comment: ""))
            .environment(\.layoutDirection, layoutDirection)
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: userSettings.textSize.size, weight: .bold))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: layoutDirection == .rightToLeft ? .trailing : .leading)
            .padding(.top, 10)
    }
    
    private func menuItem(icon: String, title: String, color: Color) -> some View {
        NavigationLink(destination: destinationView(for: title)) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(color)
                    .cornerRadius(8)
                
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
    
    private func destinationView(for title: String) -> some View {
        Group {
            switch title {
            case NSLocalizedString("Medications", comment: ""):
                MedicationsView()
            case NSLocalizedString("Health Tips", comment: ""):
                HealthTipsView()
            case NSLocalizedString("Help", comment: ""):
                HelpView()
            case NSLocalizedString("Emergency Contacts", comment: ""):
                EmergencyContactsView()
            default:
                Text("View not implemented")
            }
        }
    }
}

// Preview
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(UserSettings())
    }
} 