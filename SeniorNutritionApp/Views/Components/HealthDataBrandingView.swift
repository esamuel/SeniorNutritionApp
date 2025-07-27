import SwiftUI

/// A component that provides clear identification of health data functionality
/// in compliance with Apple's App Store guidelines for health apps
struct HealthDataBrandingView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let healthDataType: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
                
                Text(NSLocalizedString("Health Data", comment: "Health data identifier label"))
                    .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                    .foregroundColor(.red)
                
                Spacer()
                
                Text(healthDataType)
                    .font(.system(size: userSettings.textSize.size - 3))
                    .foregroundColor(.secondary)
            }
            
            Text(NSLocalizedString("This app stores and manages your health information securely on your device.", comment: "Health data identification message"))
                .font(.system(size: userSettings.textSize.size - 3))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.red.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
    }
}

/// A banner component for health screens that clearly identifies health functionality
struct HealthScreenBanner: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        HStack {
            Image(systemName: "cross.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 24))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(NSLocalizedString("Health & Wellness Tracking", comment: "Health screen banner title"))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                    .foregroundColor(.red)
                
                Text(NSLocalizedString("Monitor your health metrics safely and securely", comment: "Health screen banner subtitle"))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.08))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

/// Health data privacy notice component
struct HealthDataPrivacyNotice: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 18))
                
                Text(NSLocalizedString("Your Health Data Privacy", comment: "Health data privacy section title"))
                    .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 12))
                        .padding(.top, 2)
                    
                    Text(NSLocalizedString("All health data is stored securely on your device", comment: "Privacy bullet point"))
                        .font(.system(size: userSettings.textSize.size - 3))
                        .foregroundColor(.primary)
                }
                
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 12))
                        .padding(.top, 2)
                    
                    Text(NSLocalizedString("No health information is shared without your permission", comment: "Privacy bullet point"))
                        .font(.system(size: userSettings.textSize.size - 3))
                        .foregroundColor(.primary)
                }
                
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 12))
                        .padding(.top, 2)
                    
                    Text(NSLocalizedString("Data is encrypted and protected", comment: "Privacy bullet point"))
                        .font(.system(size: userSettings.textSize.size - 3))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        HealthDataBrandingView(healthDataType: "Blood Pressure")
        HealthScreenBanner()
        HealthDataPrivacyNotice()
    }
    .padding()
    .environmentObject(UserSettings())
}