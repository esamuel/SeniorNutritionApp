import SwiftUI
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published private(set) var subscriptionInfo: SubscriptionInfo
    @Published private(set) var isDebugMode: Bool = false
    
    // App Store product IDs (these would be configured in App Store Connect)
    static let productIDs = [
        "senior_nutrition_advanced_monthly",
        "senior_nutrition_advanced_annual",
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
            // Default to free tier
            self.subscriptionInfo = SubscriptionInfo()
            self.isDebugMode = false
        }
    }
    
    // MARK: - Public Interface
    
    var currentTier: SubscriptionTier {
        return subscriptionInfo.tier
    }
    
    var isActive: Bool {
        return subscriptionInfo.status == .active || isDebugMode
    }
    
    var isPremium: Bool {
        return currentTier == .premium && isActive
    }
    
    var isAdvanced: Bool {
        return (currentTier == .advanced || currentTier == .premium) && isActive
    }
    
    var isFree: Bool {
        return currentTier == .free || !isActive
    }
    
    // MARK: - Feature Access Control
    
    func hasAccess(to feature: String) -> Bool {
        guard isActive else { return currentTier.hasDataExport == false } // Only free features if not active
        
        switch feature {
        case PremiumFeature.advancedAnalytics:
            return currentTier.hasAdvancedAnalytics
        case PremiumFeature.dataExport:
            return currentTier.hasDataExport
        case PremiumFeature.voiceAssistant:
            return currentTier.hasVoiceAssistant
        case PremiumFeature.personalizedTips:
            return currentTier.hasPersonalizedTips
        case PremiumFeature.prioritySupport:
            return currentTier.hasPrioritySupport
        case PremiumFeature.coachChat:
            return currentTier.hasCoachChat
        case PremiumFeature.aiSuggestions:
            return currentTier.hasAIDrivenSuggestions
        case PremiumFeature.familyAccess:
            return currentTier.hasFamilyAccess
        case PremiumFeature.customThemes:
            return currentTier.hasCustomThemes
        case PremiumFeature.earlyAccess:
            return currentTier.hasEarlyAccess
        case PremiumFeature.exclusiveContent:
            return currentTier.hasExclusiveContent
        case PremiumFeature.unlimitedProtocols:
            return currentTier.maxCustomFastingProtocols == -1
        case PremiumFeature.extendedHistory:
            return currentTier.analyticsHistoryDays > 7
        case PremiumFeature.recipeBuilder:
            return currentTier.hasRecipeBuilder
        default:
            return false
        }
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
        
        // For now, just check if subscription has expired
        if let expirationDate = subscriptionInfo.expirationDate,
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
        switch feature {
        case PremiumFeature.coachChat, PremiumFeature.aiSuggestions, PremiumFeature.familyAccess, 
             PremiumFeature.customThemes, PremiumFeature.earlyAccess, PremiumFeature.exclusiveContent:
            return .premium
        default:
            return .advanced
        }
    }
}
