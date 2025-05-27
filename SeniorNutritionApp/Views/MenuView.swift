import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.layoutDirection) private var layoutDirection
    
    var body: some View {
        NavigationView {
            List {
                // HEALTH & WELLNESS section
                Section(header: sectionHeader(NSLocalizedString("HEALTH & WELLNESS", comment: ""))) {
                    menuItem(icon: "pill.fill", title: NSLocalizedString("Medications", comment: ""), color: .purple)
                    menuItem(icon: "calendar", title: NSLocalizedString("Appointments", comment: ""), color: .blue)
                    menuItem(icon: "heart.fill", title: NSLocalizedString("Health", comment: ""), color: .red)
                    menuItem(icon: "lightbulb.fill", title: NSLocalizedString("Health Tips", comment: ""), color: .orange)
                }
                
                // ACCOUNT & SETTINGS section
                Section(header: sectionHeader(NSLocalizedString("ACCOUNT & SETTINGS", comment: ""))) {
                    menuItem(icon: "person.fill", title: NSLocalizedString("Profile", comment: ""), color: .indigo)
                    menuItem(icon: "gearshape.fill", title: NSLocalizedString("Settings", comment: ""), color: .gray)
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
            case NSLocalizedString("Appointments", comment: ""):
                AppointmentsView()
            case NSLocalizedString("Health", comment: ""):
                HealthView()
            case NSLocalizedString("Health Tips", comment: ""):
                HealthTipsView()
            case NSLocalizedString("Profile", comment: ""):
                ProfileView()
            case NSLocalizedString("Settings", comment: ""):
                SettingsView()
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