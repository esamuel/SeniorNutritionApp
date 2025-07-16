import Foundation

// MARK: - Citation Model
struct Citation: Identifiable, Codable {
    var id = UUID()
    var title: String
    var source: String
    var url: String
    var date: String // Publication or last updated date
    var category: CitationCategory
}

/// Categories for different types of medical information
enum CitationCategory: String, Codable, CaseIterable {
    case nutrition = "Nutrition"
    case fasting = "Fasting"
    case hydration = "Hydration"
    case seniorHealth = "Senior Health"
    case medication = "Medication"
    case mealAnalysis = "Meal Analysis"
    
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "Citation category")
    }
}

/// Service to manage citations
class CitationService {
    static let shared = CitationService()
    
    private init() {}
    
    /// All citations used in the app
    let allCitations: [Citation] = [
        // Nutrition Citations
        Citation(
            title: "Protein Requirements for Older Adults",
            source: "National Academy of Medicine",
            url: "https://nam.edu/protein-requirements-for-older-adults/",
            date: "2021",
            category: .nutrition
        ),
        Citation(
            title: "Dietary Guidelines for Americans 2020-2025",
            source: "U.S. Department of Agriculture and U.S. Department of Health and Human Services",
            url: "https://www.dietaryguidelines.gov/",
            date: "2020",
            category: .nutrition
        ),
        
        // Fasting Citations
        Citation(
            title: "Intermittent Fasting and Human Metabolic Health",
            source: "Journal of the Academy of Nutrition and Dietetics",
            url: "https://www.jandonline.org/article/S2212-2672(15)01636-8/",
            date: "2015",
            category: .fasting
        ),
        Citation(
            title: "Safety of Fasting in Older Adults",
            source: "National Institute on Aging",
            url: "https://www.nia.nih.gov/health/fasting",
            date: "2022",
            category: .fasting
        ),
        
        // Hydration Citations
        Citation(
            title: "Water and Healthier Drinks",
            source: "Centers for Disease Control and Prevention",
            url: "https://www.cdc.gov/healthyweight/healthy_eating/water-and-healthier-drinks.html",
            date: "2022",
            category: .hydration
        ),
        Citation(
            title: "Water: How much should you drink every day?",
            source: "Mayo Clinic",
            url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/water/art-20044256",
            date: "2022",
            category: .hydration
        ),
        
        // Senior Health Citations
        Citation(
            title: "Nutrition for Older Adults",
            source: "National Institute on Aging",
            url: "https://www.nia.nih.gov/health/healthy-eating",
            date: "2023",
            category: .seniorHealth
        ),
        Citation(
            title: "Special Nutrient Needs of Older Adults",
            source: "Academy of Nutrition and Dietetics",
            url: "https://www.eatright.org/health/wellness/healthy-aging/special-nutrient-needs-of-older-adults",
            date: "2023",
            category: .seniorHealth
        ),
        
        // Medication Citations
        Citation(
            title: "Taking Medicines Safely as You Age",
            source: "U.S. Food and Drug Administration",
            url: "https://www.fda.gov/drugs/information-consumers-and-patients-drugs/taking-medicines-safely-you-age",
            date: "2023",
            category: .medication
        ),
        Citation(
            title: "Safe Medication Use in Older Adults",
            source: "American Geriatrics Society",
            url: "https://www.healthinaging.org/medications-older-adults",
            date: "2023",
            category: .medication
        ),
        
        // Meal Analysis Citations
        Citation(
            title: "Sodium Reduction Guidelines",
            source: "American Heart Association",
            url: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/sodium/how-much-sodium-should-i-eat-per-day",
            date: "2023",
            category: .mealAnalysis
        ),
        Citation(
            title: "Added Sugars and Cardiovascular Disease Risk",
            source: "American Heart Association",
            url: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/sugar/added-sugars",
            date: "2023",
            category: .mealAnalysis
        ),
        Citation(
            title: "Timing of Food Intake and Obesity",
            source: "Journal of Nutrition",
            url: "https://academic.oup.com/jn/article/147/4/722/4584708",
            date: "2022",
            category: .mealAnalysis
        ),
        Citation(
            title: "Meal Timing and Metabolic Health",
            source: "National Institute on Aging",
            url: "https://www.nia.nih.gov/health/important-nutrients-know-proteins-carbohydrates-and-fats",
            date: "2023",
            category: .mealAnalysis
        )
    ]
    
    /// Get citations by category
    func getCitations(for category: CitationCategory) -> [Citation] {
        return allCitations.filter { $0.category == category }
    }
    
    /// Get citations for multiple categories
    func getCitations(for categories: [CitationCategory]) -> [Citation] {
        return allCitations.filter { categories.contains($0.category) }
    }
} 