import SwiftUI
import StoreKit

struct PremiumFeaturesView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var premiumManager = PremiumManager.shared
    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedTier: SubscriptionTier = .advanced
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        Text("Upgrade Your Plan")
                            .font(.system(size: userSettings.textSize.size + 8, weight: .bold))
                        
                        Text("Choose the plan that's right for you")
                            .font(.system(size: userSettings.textSize.size))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
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
                    
                    // Tier Selection
                    VStack(spacing: 15) {
                        ForEach(SubscriptionTier.allCases.filter { $0 != .free }, id: \.self) { tier in
                            TierCard(
                                tier: tier,
                                isSelected: selectedTier == tier,
                                onSelect: { selectedTier = tier }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Purchase Button
                    if premiumManager.currentTier == .free || premiumManager.currentTier.rawValue < selectedTier.rawValue {
                        VStack(spacing: 12) {
                        Button(action: {
                            Task {
                                    if premiumManager.isDebugMode {
                                        // In debug mode, just set the tier
                                        premiumManager.setDebugTier(selectedTier)
                                        presentationMode.wrappedValue.dismiss()
                                    } else {
                                        // In production, this would trigger the purchase flow
                                        // For now, just show an alert
                                    }
                            }
                        }) {
                                VStack(spacing: 4) {
                                    Text("Upgrade to \(selectedTier.displayName)")
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                    
                                    Text(selectedTier.monthlyPrice + "/month")
                                        .font(.system(size: userSettings.textSize.size - 2))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedTier == .premium ? Color.purple : Color.blue)
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
                    
                    // Feature Comparison
                    FeatureComparisonView()
                        .padding(.top, 20)
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

struct TierCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let tier: SubscriptionTier
    let isSelected: Bool
    let onSelect: () -> Void
    
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
    
    private func getKeyFeatures(for tier: SubscriptionTier) -> [String] {
        switch tier {
        case .free:
            return []
        case .advanced:
            return [
                "Advanced analytics (90 days)",
                "Data export (PDF/CSV)",
                "Voice assistance",
                "Personalized health tips",
                "Priority email support",
                "5 custom fasting protocols"
            ]
        case .premium:
            return [
                "Everything in Advanced",
                "1-on-1 nutritionist chat",
                "AI-driven meal suggestions",
                "Family/caregiver access",
                "Custom app themes",
                "Unlimited fasting protocols",
                "Early access to new features",
                "Premium live chat support"
            ]
        }
    }
}

struct FeatureComparisonView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Feature Comparison")
                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                // Header row
                HStack {
                    Text("Feature")
                        .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Free")
                        .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                        .frame(width: 60)
                    
                    Text("Advanced")
                        .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                        .frame(width: 80)
                    
                    Text("Premium")
                        .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                        .frame(width: 70)
                }
        .padding()
                .background(Color(.systemGray5))
                
                // Feature rows
                ForEach(comparisonFeatures, id: \.name) { feature in
                    HStack {
                        Text(feature.name)
                            .font(.system(size: userSettings.textSize.size - 3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: feature.free ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(feature.free ? .green : .red)
                            .frame(width: 60)
                        
                        Image(systemName: feature.advanced ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(feature.advanced ? .green : .red)
                            .frame(width: 80)
                        
                        Image(systemName: feature.premium ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(feature.premium ? .green : .red)
                            .frame(width: 70)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                }
            }
        .background(Color(.systemGray6))
        .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private var comparisonFeatures: [ComparisonFeature] {
        [
            ComparisonFeature(name: "Basic nutrition tracking", free: true, advanced: true, premium: true),
            ComparisonFeature(name: "Basic fasting protocols", free: true, advanced: true, premium: true),
            ComparisonFeature(name: "Medication reminders", free: true, advanced: true, premium: true),
            ComparisonFeature(name: "7-day analytics", free: true, advanced: false, premium: false),
            ComparisonFeature(name: "90-day analytics", free: false, advanced: true, premium: true),
            ComparisonFeature(name: "1-year analytics", free: false, advanced: false, premium: true),
            ComparisonFeature(name: "Data export", free: false, advanced: true, premium: true),
            ComparisonFeature(name: "Voice assistance", free: false, advanced: true, premium: true),
            ComparisonFeature(name: "Personalized tips", free: false, advanced: true, premium: true),
            ComparisonFeature(name: "Priority support", free: false, advanced: true, premium: true),
            ComparisonFeature(name: "Nutritionist chat", free: false, advanced: false, premium: true),
            ComparisonFeature(name: "AI suggestions", free: false, advanced: false, premium: true),
            ComparisonFeature(name: "Family access", free: false, advanced: false, premium: true),
            ComparisonFeature(name: "Custom themes", free: false, advanced: false, premium: true)
        ]
    }
}

struct ComparisonFeature {
    let name: String
    let free: Bool
    let advanced: Bool
    let premium: Bool
}

#Preview {
    PremiumFeaturesView()
        .environmentObject(UserSettings())
}
