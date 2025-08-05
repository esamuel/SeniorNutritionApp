import Foundation

// MARK: - Health Tip Model
struct HealthTip: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var category: HealthTipCategory
    var icon: String // SF Symbol name
    var citations: [MedicalCitation] // Added for Apple Review compliance
    
    // Initializer with default empty citations for backward compatibility
    init(id: UUID = UUID(), title: String, description: String, category: HealthTipCategory, icon: String, citations: [MedicalCitation] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.icon = icon
        self.citations = citations
    }
    
    // Convenience accessor for localized title
    var localizedTitle: String {
        return NSLocalizedString(title, comment: "Health tip title")
    }
    
    // Convenience accessor for localized description
    var localizedDescription: String {
        return NSLocalizedString(description, comment: "Health tip description")
    }
    
    // Convenience accessor for formatted citations
    var formattedCitations: String {
        return citations.map { $0.formattedReference }.joined(separator: "\n")
    }
}

// MARK: - Medical Citation Model
struct MedicalCitation: Identifiable, Codable {
    var id = UUID()
    var title: String
    var authors: String
    var source: String
    var year: String
    var url: String?
    
    var formattedReference: String {
        var reference = "\(authors) (\(year)). \(title). \(source)."
        if let url = url {
            reference += " Available at: \(url)"
        }
        return reference
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
    
    // All health tips with medical citations for Apple Review compliance
    lazy var allTips: [HealthTip] = [
        // MARK: - General Health Tips
        HealthTip(
            title: "health_tip_sleep_title",
            description: "health_tip_sleep_description",
            category: .general,
            icon: "bed.double.fill",
            citations: [
                MedicalCitation(
                    title: "Sleep and Health",
                    authors: "National Sleep Foundation",
                    source: "Sleep Research & Education",
                    year: "2023",
                    url: "https://www.sleepfoundation.org/how-sleep-works/sleep-and-health"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_stress_title",
            description: "health_tip_stress_description",
            category: .general,
            icon: "heart.slash.fill",
            citations: [
                MedicalCitation(
                    title: "Stress and Heart Health",
                    authors: "American Heart Association",
                    source: "Heart.org",
                    year: "2023",
                    url: "https://www.heart.org/en/healthy-living/healthy-lifestyle/stress-management"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_checkups_title",
            description: "health_tip_checkups_description",
            category: .general,
            icon: "stethoscope",
            citations: [
                MedicalCitation(
                    title: "Preventive Care and Screening Guidelines for Adults",
                    authors: "U.S. Preventive Services Task Force",
                    source: "USPSTF.org",
                    year: "2023",
                    url: "https://www.uspreventiveservicestaskforce.org"
                )
            ]
        ),
        
        // MARK: - Nutrition Tips
        HealthTip(
            title: "health_tip_protein_title",
            description: "health_tip_protein_description",
            category: .nutrition,
            icon: "fork.knife",
            citations: [
                MedicalCitation(
                    title: "Protein Needs for Older Adults",
                    authors: "Bauer J, et al.",
                    source: "Journal of the American Medical Directors Association",
                    year: "2013",
                    url: "https://pubmed.ncbi.nlm.nih.gov/23871116/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_fiber_title",
            description: "health_tip_fiber_description",
            category: .nutrition,
            icon: "leaf.fill",
            citations: [
                MedicalCitation(
                    title: "Dietary Fiber and Health Outcomes",
                    authors: "Anderson JW, et al.",
                    source: "American Journal of Clinical Nutrition",
                    year: "2009",
                    url: "https://pubmed.ncbi.nlm.nih.gov/19321571/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_calcium_title",
            description: "health_tip_calcium_description",
            category: .nutrition,
            icon: "bones",
            citations: [
                MedicalCitation(
                    title: "Calcium and Vitamin D: Important at Every Age",
                    authors: "National Institutes of Health",
                    source: "NIH Osteoporosis and Related Bone Diseases",
                    year: "2022",
                    url: "https://www.bones.nih.gov/health-info/bone/bone-health/nutrition"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_vitaminD_title",
            description: "health_tip_vitaminD_description",
            category: .nutrition,
            icon: "sun.max.fill",
            citations: [
                MedicalCitation(
                    title: "Vitamin D Fact Sheet for Health Professionals",
                    authors: "National Institutes of Health",
                    source: "Office of Dietary Supplements",
                    year: "2023",
                    url: "https://ods.od.nih.gov/factsheets/VitaminD-HealthProfessional/"
                )
            ]
        ),
        
        // MARK: - Fasting Tips
        HealthTip(
            title: "health_tip_fasting_hydration_title",
            description: "health_tip_fasting_hydration_description",
            category: .fasting,
            icon: "drop.fill",
            citations: [
                MedicalCitation(
                    title: "Intermittent Fasting and Human Metabolic Health",
                    authors: "Patterson RE, et al.",
                    source: "Journal of the Academy of Nutrition and Dietetics",
                    year: "2015",
                    url: "https://pubmed.ncbi.nlm.nih.gov/26194343/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_fasting_listen_body_title",
            description: "health_tip_fasting_listen_body_description",
            category: .fasting,
            icon: "ear.fill",
            citations: [
                MedicalCitation(
                    title: "Effects of Intermittent Fasting on Health, Aging, and Disease",
                    authors: "de Cabo R, Mattson MP",
                    source: "New England Journal of Medicine",
                    year: "2019",
                    url: "https://pubmed.ncbi.nlm.nih.gov/31881139/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_fasting_break_title",
            description: "health_tip_fasting_break_description",
            category: .fasting,
            icon: "fork.knife",
            citations: [
                MedicalCitation(
                    title: "Breaking the Fast: A Case for Eating Slowly",
                    authors: "Kokkinos A, et al.",
                    source: "Journal of Clinical Endocrinology & Metabolism",
                    year: "2010",
                    url: "https://pubmed.ncbi.nlm.nih.gov/19858320/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_fasting_sleep_title",
            description: "health_tip_fasting_sleep_description",
            category: .fasting,
            icon: "moon.zzz.fill",
            citations: [
                MedicalCitation(
                    title: "Meal Timing and Metabolic Health",
                    authors: "Mattson MP, et al.",
                    source: "Proceedings of the National Academy of Sciences",
                    year: "2014",
                    url: "https://pubmed.ncbi.nlm.nih.gov/25404320/"
                )
            ]
        ),
        
        // MARK: - Hydration Tips
        HealthTip(
            title: "health_tip_hydration_reminder_title",
            description: "health_tip_hydration_reminder_description",
            category: .hydration,
            icon: "drop.fill",
            citations: [
                MedicalCitation(
                    title: "Water, Hydration and Health",
                    authors: "Popkin BM, et al.",
                    source: "Nutrition Reviews",
                    year: "2010",
                    url: "https://pubmed.ncbi.nlm.nih.gov/20646222/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_hydration_foods_title",
            description: "health_tip_hydration_foods_description",
            category: .hydration,
            icon: "carrot.fill",
            citations: [
                MedicalCitation(
                    title: "Dietary Reference Intakes for Water",
                    authors: "Institute of Medicine",
                    source: "National Academies Press",
                    year: "2005",
                    url: "https://www.nap.edu/catalog/10925/dietary-reference-intakes-for-water-potassium-sodium-chloride-and-sulfate"
                )
            ]
        ),
        
        // MARK: - Activity Tips
        HealthTip(
            title: "health_tip_activity_walking_title",
            description: "health_tip_activity_walking_description",
            category: .activity,
            icon: "figure.walk",
            citations: [
                MedicalCitation(
                    title: "Physical Activity Guidelines for Americans",
                    authors: "U.S. Department of Health and Human Services",
                    source: "HHS.gov",
                    year: "2018",
                    url: "https://health.gov/our-work/physical-activity/current-guidelines"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_activity_strength_title",
            description: "health_tip_activity_strength_description",
            category: .activity,
            icon: "dumbbell.fill",
            citations: [
                MedicalCitation(
                    title: "Resistance Training for Health and Performance",
                    authors: "Westcott WL",
                    source: "Current Sports Medicine Reports",
                    year: "2012",
                    url: "https://pubmed.ncbi.nlm.nih.gov/22777332/"
                )
            ]
        ),
        
        // MARK: - Medication Tips
        HealthTip(
            title: "health_tip_medication_schedule_title",
            description: "health_tip_medication_schedule_description",
            category: .medication,
            icon: "pills.fill",
            citations: [
                MedicalCitation(
                    title: "Medication Adherence in Older Adults",
                    authors: "Bosworth HB, et al.",
                    source: "Journal of the American Geriatrics Society",
                    year: "2006",
                    url: "https://pubmed.ncbi.nlm.nih.gov/16686867/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_medication_food_title",
            description: "health_tip_medication_food_description",
            category: .medication,
            icon: "clock.fill",
            citations: [
                MedicalCitation(
                    title: "Drug-Food Interactions",
                    authors: "Boullata JI, Hudson LM",
                    source: "Journal of Pharmacy Practice",
                    year: "2012",
                    url: "https://pubmed.ncbi.nlm.nih.gov/22045989/"
                )
            ]
        ),
        
        // MARK: - Senior-Specific Tips
        HealthTip(
            title: "health_tip_senior_balance_title",
            description: "health_tip_senior_balance_description",
            category: .seniorSpecific,
            icon: "figure.stand",
            citations: [
                MedicalCitation(
                    title: "Fall Prevention in Older Adults",
                    authors: "American Geriatrics Society",
                    source: "Journal of the American Geriatrics Society",
                    year: "2019",
                    url: "https://pubmed.ncbi.nlm.nih.gov/30656389/"
                )
            ]
        ),
        HealthTip(
            title: "health_tip_senior_vision_title",
            description: "health_tip_senior_vision_description",
            category: .seniorSpecific,
            icon: "eye.fill",
            citations: [
                MedicalCitation(
                    title: "Vision Loss in Older Adults",
                    authors: "National Eye Institute",
                    source: "NEI.NIH.gov",
                    year: "2023",
                    url: "https://www.nei.nih.gov/learn-about-eye-health/eye-conditions-and-diseases/age-related-eye-diseases"
                )
            ]
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