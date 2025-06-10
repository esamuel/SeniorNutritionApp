import SwiftUI
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published private(set) var isPremium: Bool = false
    
    // Premium features
    let premiumFeatures: [PremiumFeature] = [
        .init(id: "recipe_builder", 
              name: "Recipe Builder",
              description: "Create custom recipes by combining ingredients. Automatically calculate nutritional values.",
              icon: "fork.knife.circle.fill"),
        .init(id: "barcode_scanner", 
              name: "Barcode Scanner",
              description: "Quickly add foods by scanning product barcodes",
              icon: "barcode.viewfinder"),
        // Add more premium features here
    ]
    
    private init() {
        // Load premium status from UserDefaults
        isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
    }
    
    func unlockPremium() {
        isPremium = true
        UserDefaults.standard.set(true, forKey: "isPremiumUser")
    }
    
    func checkFeatureAccess(_ featureId: String) -> Bool {
        return isPremium
    }
}

struct PremiumFeature: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
}
