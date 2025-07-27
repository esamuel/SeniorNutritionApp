import SwiftUI

/// A comprehensive disclaimer view for health data functionality
/// that complies with Apple's App Store guidelines
struct HealthDataDisclaimerView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @State private var showingFullDisclaimer = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Health App Identification Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "cross.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 32))
                                .background(
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 56, height: 56)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(NSLocalizedString("Health & Wellness App", comment: "Health app identification title"))
                                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                                    .foregroundColor(.red)
                                
                                Text("Senior Nutrition & Health Tracker")
                                    .font(.system(size: userSettings.textSize.size))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(NSLocalizedString("This application provides health and wellness tracking functionality designed specifically for seniors.", comment: "Health app description"))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.red.opacity(0.05))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.3), lineWidth: 2)
                    )
                    
                    // Health Data Categories
                    VStack(alignment: .leading, spacing: 16) {
                        Text(NSLocalizedString("Health Data Categories", comment: "Health data categories section title"))
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                            .foregroundColor(.red)
                        
                        VStack(spacing: 12) {
                            healthCategoryRow(
                                icon: "heart.fill",
                                color: .red,
                                title: NSLocalizedString("Cardiovascular", comment: "Health category: cardiovascular"),
                                description: NSLocalizedString("Blood pressure and heart rate monitoring", comment: "Cardiovascular category description")
                            )
                            
                            healthCategoryRow(
                                icon: "drop.fill",
                                color: .orange,
                                title: NSLocalizedString("Blood Sugar", comment: "Health category: blood sugar"),
                                description: NSLocalizedString("Glucose level tracking for diabetes management", comment: "Blood sugar category description")
                            )
                            
                            healthCategoryRow(
                                icon: "scalemass.fill",
                                color: .green,
                                title: NSLocalizedString("Body Metrics", comment: "Health category: body metrics"),
                                description: NSLocalizedString("Weight tracking and BMI calculations", comment: "Body metrics category description")
                            )
                            
                            healthCategoryRow(
                                icon: "fork.knife",
                                color: .blue,
                                title: NSLocalizedString("Nutrition", comment: "Health category: nutrition"),
                                description: NSLocalizedString("Meal tracking and nutritional analysis", comment: "Nutrition category description")
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Medical Disclaimer
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 24))
                            
                            Text(NSLocalizedString("Important Medical Disclaimer", comment: "Medical disclaimer section title"))
                                .font(.system(size: userSettings.textSize.size + 1, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• This app is for informational and tracking purposes only")
                            Text("• It is not intended to diagnose, treat, cure, or prevent any disease")
                            Text("• Always consult your healthcare provider before making health decisions")
                            Text("• Do not use this app for medical emergencies")
                            Text("• Regular medical check-ups are essential for proper healthcare")
                        }
                        .font(.system(size: userSettings.textSize.size - 1))
                        .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.05))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                    )
                    
                    // Data Privacy and Security
                    HealthDataPrivacyNotice()
                    
                    // Continue Button
                    Button(action: {
                        dismiss()
                    }) {
                        Text(NSLocalizedString("I Understand - Continue", comment: "Health disclaimer continue button"))
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Health App Information", comment: "Health app information screen title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Close", comment: "Close button")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func healthCategoryRow(icon: String, color: Color, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20))
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    HealthDataDisclaimerView()
        .environmentObject(UserSettings())
}