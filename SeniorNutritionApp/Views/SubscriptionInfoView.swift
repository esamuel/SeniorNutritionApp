import SwiftUI

struct SubscriptionInfoView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text(NSLocalizedString("Subscription Information", comment: "Title for subscription information screen"))
                            .font(.system(size: userSettings.textSize.size + 6, weight: .bold))
                        
                        Text(NSLocalizedString("Clear information about our premium features and pricing", comment: "Subtitle for subscription information"))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    
                    // Business Model Section
                    infoSection(
                        title: NSLocalizedString("How Our App Works", comment: "Section title"),
                        content: NSLocalizedString("subscription_info_how_app_works_content", comment: "How our app works content")
                    )
                    
                    // Target Users Section
                    infoSection(
                        title: NSLocalizedString("Who Benefits from Premium?", comment: "Section title"),
                        content: NSLocalizedString("subscription_info_who_benefits_content", comment: "Who benefits from premium content")
                    )
                    
                    // Pricing Section
                    infoSection(
                        title: NSLocalizedString("Subscription Options", comment: "Section title"),
                        content: NSLocalizedString("subscription_info_options_content", comment: "Subscription options content")
                    )
                    
                    // Features Comparison
                    VStack(alignment: .leading, spacing: 16) {
                        Text(NSLocalizedString("Feature Comparison", comment: "Feature comparison section title"))
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        comparisonSection(
                            title: NSLocalizedString("Free Features", comment: "Free features section title"),
                            features: [
                                "Basic nutrition tracking",
                                "Water intake monitoring", 
                                "Medication reminders",
                                "General health tips",
                                "Simple meal logging",
                                "Basic analytics (7 days)"
                            ],
                            color: .gray
                        )
                        
                        comparisonSection(
                            title: NSLocalizedString("Premium Features ($9.99/month)", comment: "Premium features section title"),
                            features: [
                                "AI-powered nutrition chat",
                                "Personalized meal suggestions",
                                "Advanced analytics & insights",
                                "Data export (PDF/CSV)",
                                "Personalized health tips",
                                "Family sharing access",
                                "Priority customer support",
                                "Voice assistant features",
                                "Custom themes & appearance",
                                "Recipe builder tools",
                                "Unlimited history access"
                            ],
                            color: .purple
                        )
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Purchase Info
                    infoSection(
                        title: NSLocalizedString("How to Purchase", comment: "Section title"),
                        content: NSLocalizedString("subscription_info_how_to_purchase_content", comment: "How to purchase content")
                    )
                    
                    // Transparency Section
                    infoSection(
                        title: NSLocalizedString("Our Commitment", comment: "Section title"),
                        content: NSLocalizedString("subscription_info_commitment_content", comment: "Our commitment content")
                    )
                    
                    // Current Status
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("Your Current Status", comment: "Current status section title"))
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        HStack {
                            Circle()
                                .fill(premiumManager.isPremium ? Color.green : Color.orange)
                                .frame(width: 12, height: 12)
                            
                            Text(premiumManager.isPremium ? NSLocalizedString("Premium Subscriber", comment: "Premium user status") : NSLocalizedString("Free User", comment: "Free user status"))
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            
                            Spacer()
                        }
                        
                        if premiumManager.isInFreeTrial {
                            Text(String(format: NSLocalizedString("Free trial: %d days remaining", comment: "Free trial days remaining"), premiumManager.daysLeftInTrial()))
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.orange)
                        }
                        
                        if !premiumManager.isPremium {
                            Button(action: {
                                // This would open the premium features view
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text(NSLocalizedString("Upgrade to Premium", comment: "Upgrade button text"))
                                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Subscription Info")
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
    
    private func infoSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
            
            Text(content)
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
    
    private func comparisonSection(title: String, features: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
            }
            
            ForEach(features, id: \.self) { feature in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(color)
                        .font(.caption)
                    
                    Text(feature)
                        .font(.system(size: userSettings.textSize.size - 1))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    SubscriptionInfoView()
        .environmentObject(UserSettings())
}