import SwiftUI

struct CustomFastingProtocolView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @State private var fastingHours: Int = 16
    @State private var eatingHours: Int = 8
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Fasting Hours")) {
                    Stepper("Fasting: \(fastingHours) hours", value: $fastingHours, in: 12...24)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Eating Hours")) {
                    Stepper("Eating: \(eatingHours) hours", value: $eatingHours, in: 4...12)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Total Hours")) {
                    Text("Total: \(fastingHours + eatingHours) hours")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button("Save Protocol") {
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
            .navigationTitle("Custom Protocol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
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