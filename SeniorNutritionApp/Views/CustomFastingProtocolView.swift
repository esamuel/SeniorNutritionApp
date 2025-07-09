import SwiftUI

struct CustomFastingProtocolView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @State private var fastingHours: Int = 16
    @State private var eatingHours: Int = 8
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Fasting Hours", comment: ""))) {
                    Stepper(String(format: NSLocalizedString("Fasting: %d hours", comment: ""), fastingHours), value: $fastingHours, in: 12...24)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text(NSLocalizedString("Eating Hours", comment: ""))) {
                    Stepper(String(format: NSLocalizedString("Eating: %d hours", comment: ""), eatingHours), value: $eatingHours, in: 4...12)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text(NSLocalizedString("Total Hours", comment: ""))) {
                    Text(String(format: NSLocalizedString("Total: %d hours", comment: ""), fastingHours + eatingHours))
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button(NSLocalizedString("Save Protocol", comment: "")) {
                        FastingProtocol.setCustomProtocol(fastingHours: fastingHours, eatingHours: eatingHours)
                        userSettings.activeFastingProtocol = .custom
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("Custom Protocol", comment: ""))
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .multilineTextAlignment(.center)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Save Protocol", comment: "")) {
                        FastingProtocol.setCustomProtocol(fastingHours: fastingHours, eatingHours: eatingHours)
                        userSettings.activeFastingProtocol = .custom
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CustomFastingProtocolView_Previews: PreviewProvider {
    static var previews: some View {
        CustomFastingProtocolView()
            .environmentObject(UserSettings())
    }
} 