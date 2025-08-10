import SwiftUI
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published private(set) var subscriptionInfo: SubscriptionInfo
    @Published private(set) var isDebugMode: Bool = false
    
    // App Store product IDs (these would be configured in App Store Connect)
    static let productIDs = [
        "senior_nutrition_premium_monthly", 
        "senior_nutrition_premium_annual"
    ]
    

    
    private init() {
        // Load subscription info from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "subscriptionInfo"),
           let savedInfo = try? JSONDecoder().decode(SubscriptionInfo.self, from: data) {
            self.subscriptionInfo = savedInfo
            self.isDebugMode = savedInfo.isDebugMode
        } else {
            // New users get 7-day free trial
            let trialEndDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
            self.subscriptionInfo = SubscriptionInfo(
                tier: .free,
                status: .freeTrial,
                expirationDate: trialEndDate,
                isDebugMode: false
            )
            self.isDebugMode = false
        }
    }
    
    // MARK: - Public Interface
    
    var currentTier: SubscriptionTier {
        return subscriptionInfo.tier
    }
    
    var isActive: Bool {
        return subscriptionInfo.status == .active || subscriptionInfo.status == .freeTrial || isDebugMode
    }
    
    var isPremium: Bool {
        return currentTier == .premium && isActive
    }
    
    var isInFreeTrial: Bool {
        return subscriptionInfo.status == .freeTrial && !isTrialExpired()
    }
    
    var isFree: Bool {
        return currentTier == .free && !isActive
    }
    
    var hasFullAccess: Bool {
        return isPremium || isInFreeTrial || isDebugMode
    }
    
    // MARK: - Trial Management
    
    func isTrialExpired() -> Bool {
        guard let expirationDate = subscriptionInfo.expirationDate else { return true }
        return Date() > expirationDate
    }
    
    func daysLeftInTrial() -> Int {
        guard subscriptionInfo.status == .freeTrial,
              let expirationDate = subscriptionInfo.expirationDate else { return 0 }
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
        return max(0, daysLeft)
    }
    
    // MARK: - Feature Access Control
    
    func hasAccess(to feature: String) -> Bool {
        // During free trial or premium subscription, user has full access to all features
        return hasFullAccess
    }
    
    func getAnalyticsHistoryLimit() -> Int {
        return currentTier.analyticsHistoryDays
    }
    
    func getCustomProtocolLimit() -> Int {
        return currentTier.maxCustomFastingProtocols
    }
    
    func canCreateMoreProtocols(currentCount: Int) -> Bool {
        let limit = currentTier.maxCustomFastingProtocols
        return limit == -1 || currentCount < limit
    }
    
    // MARK: - Debug Mode (for testing)
    
    func enableDebugMode() {
        isDebugMode = true
        updateSubscriptionInfo(
            tier: subscriptionInfo.tier,
            status: .active,
            expirationDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
            isDebugMode: true
        )
    }
    
    func disableDebugMode() {
        isDebugMode = false
        updateSubscriptionInfo(
            tier: .free,
            status: .notSubscribed,
            expirationDate: nil,
            isDebugMode: false
        )
    }
    
    func setDebugTier(_ tier: SubscriptionTier) {
        guard isDebugMode else { return }
        updateSubscriptionInfo(
            tier: tier,
            status: .active,
            expirationDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
            isDebugMode: true
        )
    }
    
    // MARK: - Subscription Management
    
    func updateSubscriptionInfo(tier: SubscriptionTier, 
                              status: SubscriptionStatus, 
                              expirationDate: Date?, 
                              isDebugMode: Bool = false,
                              productId: String? = nil) {
        let newInfo = SubscriptionInfo(
            tier: tier,
            status: status,
            expirationDate: expirationDate,
            isDebugMode: isDebugMode,
            productId: productId
        )
        
        self.subscriptionInfo = newInfo
        self.isDebugMode = isDebugMode
        
        // Save to UserDefaults
        if let encoded = try? JSONEncoder().encode(newInfo) {
            UserDefaults.standard.set(encoded, forKey: "subscriptionInfo")
        }
    }
    
    func restorePurchases() async {
        // TODO: Implement StoreKit 2 restore purchases
        // This would verify receipts and update subscription status
    }
    
    func purchaseProduct(productId: String) async throws {
        // TODO: Implement StoreKit 2 purchase flow
        // This would handle the actual purchase and update subscription status
        throw NSError(domain: "PremiumManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Purchase not implemented yet"])
    }
    
    // MARK: - Subscription Status Checking
    
    func checkSubscriptionStatus() async {
        // TODO: Implement StoreKit 2 status checking
        // This would verify current subscription status with App Store
        
        // Check if free trial has expired
        if subscriptionInfo.status == .freeTrial && isTrialExpired() && !isDebugMode {
            updateSubscriptionInfo(
                tier: .free,
                status: .expired,
                expirationDate: subscriptionInfo.expirationDate
            )
        }
        
        // Check if subscription has expired
        if subscriptionInfo.status == .active,
           let expirationDate = subscriptionInfo.expirationDate,
           expirationDate < Date(),
           !isDebugMode {
            updateSubscriptionInfo(
                tier: .free,
                status: .expired,
                expirationDate: expirationDate
            )
        }
    }
    
    // MARK: - Feature Descriptions
    
    func getFeatureDescription(for feature: String) -> String {
        switch feature {
        case PremiumFeature.advancedAnalytics:
            return NSLocalizedString("Detailed weekly and monthly reports with trend analysis", comment: "")
        case PremiumFeature.dataExport:
            return NSLocalizedString("Export your health data as PDF reports or CSV files", comment: "")
        case PremiumFeature.voiceAssistant:
            return NSLocalizedString("Hands-free navigation and voice commands", comment: "")
        case PremiumFeature.personalizedTips:
            return NSLocalizedString("AI-powered health tips based on your profile", comment: "")
        case PremiumFeature.prioritySupport:
            return NSLocalizedString("Priority email support with faster response times", comment: "")
        case PremiumFeature.coachChat:
            return NSLocalizedString("1-on-1 chat with certified nutrition coaches", comment: "")
        case PremiumFeature.aiSuggestions:
            return NSLocalizedString("Smart meal and fasting recommendations", comment: "")
        case PremiumFeature.familyAccess:
            return NSLocalizedString("Share access with family members and caregivers", comment: "")
        case PremiumFeature.customThemes:
            return NSLocalizedString("Personalize the app with custom color themes", comment: "")
        case PremiumFeature.earlyAccess:
            return NSLocalizedString("Get new features before they're released to everyone", comment: "")
        case PremiumFeature.exclusiveContent:
            return NSLocalizedString("Access to premium health content and guides", comment: "")
        case PremiumFeature.recipeBuilder:
            return NSLocalizedString("Create custom recipes and automatically calculate nutritional values", comment: "")
        default:
            return ""
        }
    }
    
    // MARK: - Upgrade Prompts
    
    func getUpgradeMessage(for feature: String) -> String {
        let tierNeeded = getRequiredTier(for: feature)
        return String(format: NSLocalizedString("This feature requires %@ subscription. Upgrade now to unlock it!", comment: ""), tierNeeded.displayName)
    }
    
    func getRequiredTier(for feature: String) -> SubscriptionTier {
        // All premium features now require premium tier
        return .premium
    }
}
