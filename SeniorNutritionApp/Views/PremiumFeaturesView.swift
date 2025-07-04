import SwiftUI
import StoreKit

struct PremiumFeaturesView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var premiumManager: PremiumManager
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("Premium Features")
                            .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                        
                        Text("Unlock powerful features to enhance your nutrition journey")
                            .font(.system(size: userSettings.textSize.size))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 30)
                    
                    // Features List
                    VStack(spacing: 15) {
                        ForEach(premiumManager.premiumFeatures) { feature in
                            FeatureCard(feature: feature)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Purchase Button
                    if !premiumManager.isPremium {
                        Button(action: {
                            Task {
                                premiumManager.unlockPremium()
                            }
                        }) {
                            Text("Unlock Premium")
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
}

struct FeatureCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let feature: PremiumFeature
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: feature.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                
                Text(feature.name)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
            }
            
            Text(feature.description)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
