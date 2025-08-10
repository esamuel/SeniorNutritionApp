import SwiftUI

struct HealthMonitoringHelpView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Health identification banner
                HealthScreenBanner()
                
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.pink)
                        
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("Health Data Tracking", comment: ""))
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            Text(NSLocalizedString("Monitor vital signs and track your health progress", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // Available Metrics Section
                HealthHelpSection(
                    title: NSLocalizedString("Available Health Metrics", comment: ""),
                    content: [
                        NSLocalizedString("Blood Pressure: Track systolic and diastolic readings", comment: ""),
                        NSLocalizedString("Blood Sugar: Monitor glucose levels for diabetes management", comment: ""),
                        NSLocalizedString("Heart Rate: Record resting and active heart rates", comment: ""),
                        NSLocalizedString("Weight: Track body weight changes over time", comment: ""),
                        NSLocalizedString("Body Mass Index (BMI): Automatic calculation from height and weight", comment: "")
                    ]
                )
                
                // Data Privacy Section
                HealthHelpSection(
                    title: NSLocalizedString("Data Privacy", comment: ""),
                    content: [
                        NSLocalizedString("Your health data is encrypted and stored securely", comment: ""),
                        NSLocalizedString("Health data is never shared without your permission", comment: "")
                    ]
                )
                
                // Medical Disclaimer Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "stethoscope")
                            .foregroundColor(.blue)
                        Text(NSLocalizedString("Important: This app is for tracking and educational purposes only. Always consult your healthcare provider for medical advice and treatment decisions.", comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    
                    // Add citations for health monitoring information
                    CitationsView(categories: [.seniorHealth])
                }
            }
            .padding()
        }
        .navigationTitle(NSLocalizedString("Health Data Help", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Renamed from HelpSection to HealthHelpSection to avoid naming conflict
struct HealthHelpSection: View {
    let title: String
    let content: [String]
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            ForEach(content, id: \.self) { item in
                HStack(alignment: .top) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: userSettings.textSize.size - 2))
                    
                    Text(item)
                        .font(.system(size: userSettings.textSize.size - 2))
                }
                .padding(.vertical, 2)
            }
        }
    }
}

#Preview {
    HealthMonitoringHelpView()
        .environmentObject(UserSettings())
} 