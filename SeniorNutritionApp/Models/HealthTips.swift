import Foundation

// MARK: - Health Tip Model
struct HealthTip: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var category: HealthTipCategory
    var icon: String // SF Symbol name
    
    // Convenience accessor for localized title
    var localizedTitle: String {
        return NSLocalizedString(title, comment: "Health tip title")
    }
    
    // Convenience accessor for localized description
    var localizedDescription: String {
        return NSLocalizedString(description, comment: "Health tip description")
    }
}

// MARK: - Health Tip Categories
enum HealthTipCategory: String, Codable, CaseIterable {
    case general = "General"
    case nutrition = "Nutrition"
    case fasting = "Fasting"
    case hydration = "Hydration"
    case activity = "Activity"
    case medication = "Medication"
    case seniorSpecific = "SeniorSpecific"
    
    // Convenience accessor for localized category name
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "Health tip category")
    }
}

// MARK: - Health Tips Service
class HealthTipsService {
    static let shared = HealthTipsService()
    
    private init() {
        // Private initializer to enforce singleton pattern
    }
    
    // All health tips
    lazy var allTips: [HealthTip] = [
        // MARK: - General Health Tips
        HealthTip(
            title: "health_tip_sleep_title",
            description: "health_tip_sleep_description",
            category: .general,
            icon: "bed.double.fill"
        ),
        HealthTip(
            title: "health_tip_stress_title",
            description: "health_tip_stress_description",
            category: .general,
            icon: "heart.slash.fill"
        ),
        HealthTip(
            title: "health_tip_checkups_title",
            description: "health_tip_checkups_description",
            category: .general,
            icon: "stethoscope"
        ),
        
        // MARK: - Nutrition Tips
        HealthTip(
            title: "health_tip_protein_title",
            description: "health_tip_protein_description",
            category: .nutrition,
            icon: "fork.knife"
        ),
        HealthTip(
            title: "health_tip_fiber_title",
            description: "health_tip_fiber_description",
            category: .nutrition,
            icon: "leaf.fill"
        ),
        HealthTip(
            title: "health_tip_calcium_title",
            description: "health_tip_calcium_description",
            category: .nutrition,
            icon: "bones"
        ),
        HealthTip(
            title: "health_tip_vitaminD_title",
            description: "health_tip_vitaminD_description",
            category: .nutrition,
            icon: "sun.max.fill"
        ),
        
        // MARK: - Fasting Tips
        HealthTip(
            title: "health_tip_fasting_hydration_title",
            description: "health_tip_fasting_hydration_description",
            category: .fasting,
            icon: "drop.fill"
        ),
        HealthTip(
            title: "health_tip_fasting_listen_body_title",
            description: "health_tip_fasting_listen_body_description",
            category: .fasting,
            icon: "ear.fill"
        ),
        HealthTip(
            title: "health_tip_fasting_break_title",
            description: "health_tip_fasting_break_description",
            category: .fasting,
            icon: "fork.knife"
        ),
        HealthTip(
            title: "health_tip_fasting_sleep_title",
            description: "health_tip_fasting_sleep_description",
            category: .fasting,
            icon: "moon.zzz.fill"
        ),
        
        // MARK: - Hydration Tips
        HealthTip(
            title: "health_tip_hydration_reminder_title",
            description: "health_tip_hydration_reminder_description",
            category: .hydration,
            icon: "drop.fill"
        ),
        HealthTip(
            title: "health_tip_hydration_foods_title",
            description: "health_tip_hydration_foods_description",
            category: .hydration,
            icon: "carrot.fill"
        ),
        
        // MARK: - Activity Tips
        HealthTip(
            title: "health_tip_activity_walking_title",
            description: "health_tip_activity_walking_description",
            category: .activity,
            icon: "figure.walk"
        ),
        HealthTip(
            title: "health_tip_activity_strength_title",
            description: "health_tip_activity_strength_description",
            category: .activity,
            icon: "dumbbell.fill"
        ),
        
        // MARK: - Medication Tips
        HealthTip(
            title: "health_tip_medication_schedule_title",
            description: "health_tip_medication_schedule_description",
            category: .medication,
            icon: "pills.fill"
        ),
        HealthTip(
            title: "health_tip_medication_food_title",
            description: "health_tip_medication_food_description",
            category: .medication,
            icon: "clock.fill"
        ),
        
        // MARK: - Senior-Specific Tips
        HealthTip(
            title: "health_tip_senior_balance_title",
            description: "health_tip_senior_balance_description",
            category: .seniorSpecific,
            icon: "figure.stand"
        ),
        HealthTip(
            title: "health_tip_senior_vision_title",
            description: "health_tip_senior_vision_description",
            category: .seniorSpecific,
            icon: "eye.fill"
        )
    ]
    
    // Get tips by category
    func getTips(for category: HealthTipCategory) -> [HealthTip] {
        return allTips.filter { $0.category == category }
    }
    
    // Get random tips (useful for displaying on home screen)
    func getRandomTips(count: Int = 3, category: HealthTipCategory? = nil) -> [HealthTip] {
        let filteredTips = category != nil ? getTips(for: category!) : allTips
        
        // If we have fewer tips than requested count, return all available tips
        if filteredTips.count <= count {
            return filteredTips
        }
        
        // Create a mutable copy to shuffle
        var availableTips = filteredTips
        availableTips.shuffle()
        
        return Array(availableTips.prefix(count))
    }
    
    // Get random tips from multiple categories
    func getRandomTips(count: Int = 3, categories: [HealthTipCategory]) -> [HealthTip] {
        let filteredTips = allTips.filter { categories.contains($0.category) }
        
        // If we have fewer tips than requested count, return all available tips
        if filteredTips.count <= count {
            return filteredTips
        }
        
        // Create a mutable copy to shuffle
        var availableTips = filteredTips
        availableTips.shuffle()
        
        return Array(availableTips.prefix(count))
    }
} 