import SwiftUI
import StoreKit

struct PremiumFeaturesView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var premiumManager = PremiumManager.shared
    @Environment(\.presentationMode) private var presentationMode
    // Single premium tier - matches App Store metadata
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        if premiumManager.isInFreeTrial {
                            Text("Free Trial Active")
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            
                            Text("\(premiumManager.daysLeftInTrial()) days remaining")
                                .font(.system(size: userSettings.textSize.size))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        } else if premiumManager.isPremium {
                            Text("Premium Subscriber")
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                                .foregroundColor(.green)
                        } else {
                            Text("Start Your Premium Journey")
                                .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                            
                            Text("Get access to all premium features")
                                .font(.system(size: userSettings.textSize.size))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 20)
                    
                    // Current Tier Status
                    if premiumManager.currentTier != .free {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Current Plan: \(premiumManager.currentTier.displayName)")
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                    .foregroundColor(.green)
                            }
                            
                            if premiumManager.isDebugMode {
                                Text("DEBUG MODE ACTIVE")
                                    .font(.system(size: userSettings.textSize.size - 4, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Single Premium Tier
                    if !premiumManager.isPremium {
                        VStack(spacing: 15) {
                            TierCard(
                                tier: .premium,
                                isSelected: true,
                                onSelect: { }
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Purchase Button
                    if !premiumManager.isPremium {
                        VStack(spacing: 12) {
                        Button(action: {
                            Task {
                                    if premiumManager.isDebugMode {
                                        // In debug mode, just set the tier
                                        premiumManager.setDebugTier(.premium)
                                        presentationMode.wrappedValue.dismiss()
                                    } else {
                                        // In production, this would trigger the purchase flow
                                        // For now, just show an alert
                                    }
                            }
                        }) {
                                VStack(spacing: 4) {
                                    if premiumManager.isInFreeTrial {
                                        Text("Continue with Premium")
                                    } else {
                                        Text("Start Free Trial")
                                    }
                                    
                                    Text("$9.99/month or $99.99/year after trial")
                                        .font(.system(size: userSettings.textSize.size - 2))
                                }
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                // Restore purchases action
                            }) {
                                Text("Restore Purchases")
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    
                    // Premium Benefits Info
                    if premiumManager.isInFreeTrial {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Trial Includes:")
                                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(getKeyFeatures(for: .premium), id: \.self) { feature in
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.system(size: 14))
                                        
                                        Text(feature)
                                            .font(.system(size: userSettings.textSize.size - 1))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
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
    
    private func getKeyFeatures(for tier: SubscriptionTier) -> [String] {
        switch tier {
        case .free:
            return [
                "7-day free trial",
                "Full access to all features",
                "No commitment required"
            ]
        case .premium:
            return [
                "Advanced analytics & insights",
                "Data export (PDF/CSV)",
                "Voice assistance",
                "Personalized health tips",
                "1-on-1 nutritionist chat",
                "AI-driven meal suggestions",
                "Family/caregiver access",
                "Unlimited fasting protocols",
                "Priority support"
            ]
        }
    }
}

struct TierCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let tier: SubscriptionTier
    let isSelected: Bool
    let onSelect: () -> Void
    
    private func getKeyFeatures(for tier: SubscriptionTier) -> [String] {
        switch tier {
        case .free:
            return [
                "7-day free trial",
                "Full access to all features",
                "No commitment required"
            ]
        case .premium:
            return [
                "Advanced analytics & insights",
                "Data export (PDF/CSV)",
                "Voice assistance",
                "Personalized health tips",
                "1-on-1 nutritionist chat",
                "AI-driven meal suggestions",
                "Family/caregiver access",
                "Unlimited fasting protocols",
                "Priority support"
            ]
        }
    }
    
    var body: some View {
        Button(action: onSelect) {
        VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tier.displayName)
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(tier.localizedDescription)
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(tier.monthlyPrice)
                            .font(.system(size: userSettings.textSize.size, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("per month")
                            .font(.system(size: userSettings.textSize.size - 4))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Key Features
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(getKeyFeatures(for: tier), id: \.self) { feature in
            HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 12))
                            
                            Text(feature)
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                    }
                }
                
                // Annual Savings
                if !tier.annualSavings.isEmpty {
                    HStack {
                        Text("Annual: \(tier.annualPrice)")
                            .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                    .foregroundColor(.blue)
                
                        Text("(\(tier.annualSavings))")
                            .font(.system(size: userSettings.textSize.size - 3))
                            .foregroundColor(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(isSelected ? (tier == .premium ? Color.purple.opacity(0.1) : Color.blue.opacity(0.1)) : Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? (tier == .premium ? Color.purple : Color.blue) : Color.clear, lineWidth: 2)
            )
            .cornerRadius(12)
            }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    PremiumFeaturesView()
        .environmentObject(UserSettings())
}
