import Foundation

struct AppConfig {
    // App Information
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    // Support Contact Information
    struct Support {
        static let email = "support@seniornutritionapp.com"
        static let phone = "+1-800-123-4567"
        static let hours = "9:00 AM - 5:00 PM EST, Monday-Friday"
        static let location = "Health Tech Solutions Inc., 123 Wellness Ave, Boston, MA 02108"
    }
    
    // Emergency Contact Information
    struct Emergency {
        static let emergencyNumber = "911" // US emergency number, should be localized for different regions
        static let emergencyMessage = NSLocalizedString("If you are experiencing a medical emergency, please call emergency services immediately.", comment: "")
    }
    
    // Help Resources
    struct HelpResources {
        static let faqUrl = "https://seniornutritionapp.com/faq"
        static let tutorialUrl = "https://seniornutritionapp.com/tutorials"
        static let supportUrl = "https://seniornutritionapp.com/support"
    }
}
