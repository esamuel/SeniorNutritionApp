import Foundation
import SwiftUI

// MARK: - Protocols for Meal and User Profile
// This approach avoids direct references to the actual types, using protocols instead

/// Protocol for access to nutritional information
protocol NutritionalInfoProvider {
    var calories: Double { get }
    var protein: Double { get }
    var carbohydrates: Double { get }
    var fat: Double { get }
    var fiber: Double { get }
    var sugar: Double { get }
    var vitaminA: Double { get }
    var vitaminC: Double { get }
    var vitaminD: Double { get }
    var vitaminE: Double { get }
    var vitaminK: Double { get }
    var thiamin: Double { get }
    var riboflavin: Double { get }
    var niacin: Double { get }
    var vitaminB6: Double { get }
    var vitaminB12: Double { get }
    var folate: Double { get }
    var calcium: Double { get }
    var iron: Double { get }
    var magnesium: Double { get }
    var phosphorus: Double { get }
    var potassium: Double { get }
    var sodium: Double { get }
    var zinc: Double { get }
    var selenium: Double { get }
    var omega3: Double { get }
    var omega6: Double { get }
    var cholesterol: Double { get }
}

/// Protocol for meal-like objects
protocol MealAnalyzable {
    var name: String { get }
    var nutritionalContent: NutritionalInfoProvider { get }
}

/// Protocol for user profile-like objects
protocol UserProfileAnalyzable {
    var medicalConditions: [String] { get }
    var dietaryRestrictions: [String] { get }
    var weight: Double { get }
    var bmi: Double? { get }
}

// MARK: - Nutritional Analysis Service

class NutritionalAnalysisService: ObservableObject {
    // MARK: - Properties
    
    // The results of the last meal analysis
    @Published var analysisResults: MealAnalysisResult?
    
    // MARK: - Analysis Methods
    
    /// Analyzes a meal's nutritional content based on the user's health conditions and dietary restrictions
    /// - Parameters:
    ///   - meal: The meal to analyze (must conform to MealAnalyzable)
    ///   - userProfile: The user's profile (must conform to UserProfileAnalyzable)
    /// - Returns: MealAnalysisResult with feedback and recommendations
    func analyzeMeal(_ meal: MealAnalyzable, for userProfile: UserProfileAnalyzable) -> MealAnalysisResult {
        var healthWarnings: [HealthWarning] = []
        var positiveEffects: [PositiveEffect] = []
        
        // Analyze for medical conditions
        analyzeMedicalConditions(meal: meal, medicalConditions: userProfile.medicalConditions, healthWarnings: &healthWarnings, positiveEffects: &positiveEffects)
        
        // Check for dietary restrictions violations
        checkDietaryRestrictions(meal: meal, dietaryRestrictions: userProfile.dietaryRestrictions, healthWarnings: &healthWarnings)
        
        // Analyze for overall nutritional balance
        analyzeNutritionalBalance(meal: meal, healthWarnings: &healthWarnings, positiveEffects: &positiveEffects)
        
        // Add analysis for glycemic index/load
        analyzeGlycemicLoad(meal: meal, medicalConditions: userProfile.medicalConditions, healthWarnings: &healthWarnings, positiveEffects: &positiveEffects)
        
        // Add analysis for inflammation potential
        analyzeInflammation(meal: meal, medicalConditions: userProfile.medicalConditions, healthWarnings: &healthWarnings, positiveEffects: &positiveEffects)
        
        // Add specific senior nutrition concerns
        analyzeSeniorNutritionNeeds(meal: meal, userProfile: userProfile, healthWarnings: &healthWarnings, positiveEffects: &positiveEffects)
        
        // Create and store the analysis result
        let result = MealAnalysisResult(
            mealName: meal.name,
            healthWarnings: healthWarnings,
            positiveEffects: positiveEffects,
            timestamp: Date()
        )
        
        // Store the result for later reference
        analysisResults = result
        
        return result
    }
    
    // MARK: - Enhanced Analysis Methods
    
    // Analyze glycemic load (important for diabetes and metabolic health)
    private func analyzeGlycemicLoad(meal: MealAnalyzable, medicalConditions: [String], healthWarnings: inout [HealthWarning], positiveEffects: inout [PositiveEffect]) {
        let nutrition = meal.nutritionalContent
        
        // Estimate glycemic load based on carbs and fiber content
        // This is a simplified estimation - a real implementation would need a database of GI values
        let estimatedGlycemicLoad = nutrition.carbohydrates - (nutrition.fiber * 0.7)
        
        if medicalConditions.contains("Diabetes") {
            if estimatedGlycemicLoad > 20 {
                healthWarnings.append(HealthWarning(
                    type: .medicalCondition("Diabetes"),
                    severity: .moderate,
                    nutrient: "Glycemic Load",
                    message: "This meal may have a high glycemic load, which could cause blood sugar spikes. Consider pairing with protein or healthy fats to moderate the glycemic response."
                ))
            } else if estimatedGlycemicLoad < 10 && nutrition.carbohydrates > 5 {
                positiveEffects.append(PositiveEffect(
                    type: .medicalCondition("Diabetes"),
                    nutrient: "Glycemic Load",
                    message: "This meal has a lower estimated glycemic load, which may help maintain steadier blood sugar levels."
                ))
            }
        }
    }
    
    // Analyze inflammation potential (important for arthritis, heart disease)
    private func analyzeInflammation(meal: MealAnalyzable, medicalConditions: [String], healthWarnings: inout [HealthWarning], positiveEffects: inout [PositiveEffect]) {
        let nutrition = meal.nutritionalContent
        let hasInflammatoryCondition = medicalConditions.contains("Arthritis") || 
                                      medicalConditions.contains("Heart Disease") ||
                                      medicalConditions.contains("Inflammatory Bowel Disease")
        
        // Anti-inflammatory nutrients
        let hasAntiInflammatoryNutrients = nutrition.omega3 > 0.5 || 
                                          nutrition.vitaminE > 3 || 
                                          nutrition.vitaminC > 30
        
        // Pro-inflammatory indicators
        let hasProInflammatoryProfile = (nutrition.omega6 / max(nutrition.omega3, 0.1) > 10) || 
                                       (nutrition.sugar > 20)
        
        if hasInflammatoryCondition {
            if hasProInflammatoryProfile {
                healthWarnings.append(HealthWarning(
                    type: .medicalCondition(medicalConditions.first(where: { 
                        ["Arthritis", "Heart Disease", "Inflammatory Bowel Disease"].contains($0)
                    }) ?? "Inflammatory Condition"),
                    severity: .moderate,
                    nutrient: "Inflammatory Profile",
                    message: "This meal contains ingredients that may promote inflammation. Consider balancing with anti-inflammatory foods like fatty fish, olive oil, or colorful vegetables."
                ))
            }
            
            if hasAntiInflammatoryNutrients {
                positiveEffects.append(PositiveEffect(
                    type: .medicalCondition(medicalConditions.first(where: { 
                        ["Arthritis", "Heart Disease", "Inflammatory Bowel Disease"].contains($0)
                    }) ?? "Inflammatory Condition"),
                    nutrient: "Anti-inflammatory Nutrients",
                    message: "This meal contains nutrients that may help reduce inflammation."
                ))
            }
        }
    }
    
    // Special analysis for senior-specific nutritional needs
    private func analyzeSeniorNutritionNeeds(meal: MealAnalyzable, userProfile: UserProfileAnalyzable, healthWarnings: inout [HealthWarning], positiveEffects: inout [PositiveEffect]) {
        let nutrition = meal.nutritionalContent
        
        // Analyze based on BMI if available
        if let bmi = userProfile.bmi {
            let isOverweight = bmi >= 25
            let isObese = bmi >= 30
            let isUnderweight = bmi < 18.5
            
            if isObese {
                if nutrition.calories > 600 {
                    healthWarnings.append(HealthWarning(
                        type: .generalNutrition,
                        severity: .high,
                        nutrient: "Calories",
                        message: "This meal is high in calories. Consider lower-calorie alternatives to support healthy weight management."
                    ))
                }
                
                if nutrition.fat > 20 {
                    healthWarnings.append(HealthWarning(
                        type: .generalNutrition,
                        severity: .moderate,
                        nutrient: "Fat",
                        message: "This meal is high in fat. Consider leaner protein sources and more vegetables."
                    ))
                }
                
                if nutrition.fiber > 5 {
                    positiveEffects.append(PositiveEffect(
                        type: .generalNutrition,
                        nutrient: "Fiber",
                        message: "Good fiber content helps you feel full longer and supports healthy weight management."
                    ))
                }
            } else if isOverweight {
                if nutrition.calories > 700 {
                    healthWarnings.append(HealthWarning(
                        type: .generalNutrition,
                        severity: .moderate,
                        nutrient: "Calories",
                        message: "Consider portion control while ensuring you get essential nutrients."
                    ))
                }
                
                if nutrition.fiber > 5 {
                    positiveEffects.append(PositiveEffect(
                        type: .generalNutrition,
                        nutrient: "Fiber",
                        message: "Good fiber content supports healthy digestion and weight management."
                    ))
                }
            } else if isUnderweight {
                if nutrition.calories < 400 {
                    healthWarnings.append(HealthWarning(
                        type: .generalNutrition,
                        severity: .moderate,
                        nutrient: "Calories",
                        message: "This meal is relatively low in calories. Consider adding healthy fats or protein to increase caloric intake."
                    ))
                }
                
                if nutrition.protein < 15 {
                    healthWarnings.append(HealthWarning(
                        type: .generalNutrition,
                        severity: .moderate,
                        nutrient: "Protein",
                        message: "Consider adding more protein to support healthy weight gain and maintain muscle mass."
                    ))
                }
            }
        }
        
        // Check for protein adequacy (seniors need more protein)
        // The general recommendation for seniors is 1.0-1.2g per kg of body weight daily
        let recommendedProteinPerMeal = userProfile.weight * 0.3 // Roughly 1/4 of daily needs per meal
        
        if nutrition.protein < recommendedProteinPerMeal * 0.5 && nutrition.calories > 200 {
            healthWarnings.append(HealthWarning(
                type: .generalNutrition,
                severity: .low,
                nutrient: "Protein",
                message: "This meal may be low in protein for your needs. Seniors benefit from higher protein intake to maintain muscle mass and strength."
            ))
        }
        
        // Check for important micronutrients that are often deficient in seniors
        if nutrition.vitaminB12 > 0.8 {
            positiveEffects.append(PositiveEffect(
                type: .generalNutrition,
                nutrient: "Vitamin B12",
                message: "This meal provides vitamin B12, which becomes more difficult to absorb as we age and is essential for nerve function and red blood cell formation."
            ))
        }
        
        if nutrition.vitaminD > 100 {
            positiveEffects.append(PositiveEffect(
                type: .generalNutrition,
                nutrient: "Vitamin D",
                message: "This meal contains good amounts of vitamin D, which is important for bone health and immune function, especially for seniors."
            ))
        }
        
        if nutrition.calcium > 200 {
            positiveEffects.append(PositiveEffect(
                type: .generalNutrition,
                nutrient: "Calcium",
                message: "This meal provides calcium, which helps maintain bone density and is especially important as we age."
            ))
        }
        
        // Check for fluid content if the meal seems dry
        // This is a simplified approach; ideally, you'd have data on water content
        let estimatedWaterContent = nutrition.carbohydrates * 0.3 + nutrition.protein * 0.4
        if estimatedWaterContent < 10 && nutrition.calories > 200 {
            healthWarnings.append(HealthWarning(
                type: .generalNutrition,
                severity: .low,
                nutrient: "Hydration",
                message: "This meal appears to be relatively dry. Remember to stay hydrated by drinking water with your meals, as dehydration risk increases with age."
            ))
        }
    }
    
    // MARK: - Private Analysis Methods
    
    private func analyzeMedicalConditions(meal: MealAnalyzable, medicalConditions: [String], healthWarnings: inout [HealthWarning], positiveEffects: inout [PositiveEffect]) {
        // Get the nutritional info
        let nutrition = meal.nutritionalContent
        
        for condition in medicalConditions {
            switch condition {
            case "High Blood Pressure":
                // Check for high sodium
                if nutrition.sodium > 500 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .moderate,
                        nutrient: "Sodium",
                        message: "This meal is high in sodium (over 500mg), which may affect your blood pressure. Consider reducing portion size or pairing with low-sodium foods."
                    ))
                }
                
                // Check for positive potassium content (helps with blood pressure)
                if nutrition.potassium > 300 {
                    positiveEffects.append(PositiveEffect(
                        type: .medicalCondition(condition),
                        nutrient: "Potassium",
                        message: "This meal contains good amounts of potassium, which can help maintain healthy blood pressure."
                    ))
                }
                
            case "Diabetes":
                // Check for high sugar content
                if nutrition.sugar > 15 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .high,
                        nutrient: "Sugar",
                        message: "This meal contains over 15g of sugar, which may affect your blood glucose levels. Consider a smaller portion or balancing with protein and healthy fats."
                    ))
                }
                
                // Check for high carbs
                if nutrition.carbohydrates > 45 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .moderate,
                        nutrient: "Carbohydrates",
                        message: "This meal is high in carbohydrates (over 45g), which may impact blood sugar. Consider spreading carb intake throughout the day."
                    ))
                }
                
                // Check for good fiber content (helps with blood sugar control)
                if nutrition.fiber > 5 {
                    positiveEffects.append(PositiveEffect(
                        type: .medicalCondition(condition),
                        nutrient: "Fiber",
                        message: "This meal contains good fiber, which can help slow down digestion and prevent blood sugar spikes."
                    ))
                }
                
            case "Heart Disease":
                // Check for high saturated fat and cholesterol
                if nutrition.fat > 15 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .moderate,
                        nutrient: "Fat",
                        message: "This meal is high in fat (over 15g), which may affect heart health. Consider reducing portion size or substituting with heart-healthy fats."
                    ))
                }
                
                if nutrition.cholesterol > 100 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .moderate,
                        nutrient: "Cholesterol",
                        message: "This meal contains substantial cholesterol, which may impact heart health. Consider balancing with plant-based meals throughout the day."
                    ))
                }
                
                // Check for positive omega-3 content
                if nutrition.omega3 > 0.5 {
                    positiveEffects.append(PositiveEffect(
                        type: .medicalCondition(condition),
                        nutrient: "Omega-3 Fatty Acids",
                        message: "This meal contains heart-healthy omega-3 fatty acids, which can help support cardiovascular health."
                    ))
                }
                
            case "Osteoporosis":
                // Check for positive calcium and vitamin D content
                if nutrition.calcium > 200 {
                    positiveEffects.append(PositiveEffect(
                        type: .medicalCondition(condition),
                        nutrient: "Calcium",
                        message: "This meal is rich in calcium, which can help maintain bone health."
                    ))
                }
                
                if nutrition.vitaminD > 100 {
                    positiveEffects.append(PositiveEffect(
                        type: .medicalCondition(condition),
                        nutrient: "Vitamin D",
                        message: "This meal contains vitamin D, which helps your body absorb calcium for stronger bones."
                    ))
                }
                
            case "Arthritis":
                // Check for foods that may promote inflammation
                if nutrition.omega6 > 2.0 && nutrition.omega3 < 0.5 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .low,
                        nutrient: "Omega-6 to Omega-3 ratio",
                        message: "This meal has a high ratio of omega-6 to omega-3 fatty acids, which may contribute to inflammation. Consider adding foods rich in omega-3s."
                    ))
                }
                
            case "Kidney Disease":
                // Check for high potassium, phosphorus, and protein
                if nutrition.potassium > 600 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .high,
                        nutrient: "Potassium",
                        message: "This meal is high in potassium, which may be a concern for kidney health. Consider reducing portion size or substituting with lower-potassium options."
                    ))
                }
                
                if nutrition.phosphorus > 250 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .moderate,
                        nutrient: "Phosphorus",
                        message: "This meal contains substantial phosphorus, which may need to be monitored for kidney health."
                    ))
                }
                
                if nutrition.protein > 25 {
                    healthWarnings.append(HealthWarning(
                        type: .medicalCondition(condition),
                        severity: .moderate,
                        nutrient: "Protein",
                        message: "This meal is high in protein, which may need to be moderated for kidney health."
                    ))
                }
                
            default:
                // No specific rules for other conditions
                break
            }
        }
    }
    
    private func checkDietaryRestrictions(meal: MealAnalyzable, dietaryRestrictions: [String], healthWarnings: inout [HealthWarning]) {
        // This would ideally reference a database of food ingredients
        // For now, we'll use some simple heuristics based on meal name
        
        let mealNameLowercased = meal.name.lowercased()
        let nutrition = meal.nutritionalContent
        
        for restriction in dietaryRestrictions {
            switch restriction {
            case "Vegetarian":
                if mealNameLowercased.contains("beef") || 
                   mealNameLowercased.contains("chicken") || 
                   mealNameLowercased.contains("pork") || 
                   mealNameLowercased.contains("turkey") ||
                   mealNameLowercased.contains("lamb") {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .high,
                        nutrient: nil,
                        message: "This meal contains meat, which conflicts with your vegetarian dietary restriction."
                    ))
                }
                
            case "Vegan":
                if mealNameLowercased.contains("meat") || 
                   mealNameLowercased.contains("beef") || 
                   mealNameLowercased.contains("chicken") || 
                   mealNameLowercased.contains("pork") || 
                   mealNameLowercased.contains("turkey") ||
                   mealNameLowercased.contains("lamb") ||
                   mealNameLowercased.contains("milk") ||
                   mealNameLowercased.contains("cheese") ||
                   mealNameLowercased.contains("yogurt") ||
                   mealNameLowercased.contains("butter") ||
                   mealNameLowercased.contains("cream") ||
                   mealNameLowercased.contains("egg") {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .high,
                        nutrient: nil,
                        message: "This meal may contain animal products, which conflicts with your vegan dietary restriction."
                    ))
                }
                
            case "Gluten-Free":
                if mealNameLowercased.contains("wheat") || 
                   mealNameLowercased.contains("bread") || 
                   mealNameLowercased.contains("pasta") || 
                   mealNameLowercased.contains("flour") ||
                   mealNameLowercased.contains("cookie") ||
                   mealNameLowercased.contains("cake") ||
                   mealNameLowercased.contains("cereal") {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .high,
                        nutrient: nil,
                        message: "This meal may contain gluten, which conflicts with your gluten-free dietary restriction."
                    ))
                }
                
            case "Dairy-Free":
                if mealNameLowercased.contains("milk") || 
                   mealNameLowercased.contains("cheese") || 
                   mealNameLowercased.contains("yogurt") || 
                   mealNameLowercased.contains("butter") ||
                   mealNameLowercased.contains("cream") {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .high,
                        nutrient: nil,
                        message: "This meal may contain dairy, which conflicts with your dairy-free dietary restriction."
                    ))
                }
                
            case "Nut-Free":
                if mealNameLowercased.contains("nut") || 
                   mealNameLowercased.contains("almond") || 
                   mealNameLowercased.contains("peanut") || 
                   mealNameLowercased.contains("walnut") ||
                   mealNameLowercased.contains("cashew") ||
                   mealNameLowercased.contains("pecan") {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .high,
                        nutrient: nil,
                        message: "This meal may contain nuts, which conflicts with your nut-free dietary restriction."
                    ))
                }
                
            case "Low Sodium":
                if nutrition.sodium > 400 {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .moderate,
                        nutrient: "Sodium",
                        message: "This meal contains more than 400mg of sodium, which exceeds your low-sodium dietary restriction."
                    ))
                }
                
            case "Low Sugar":
                if nutrition.sugar > 10 {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .moderate,
                        nutrient: "Sugar",
                        message: "This meal contains more than 10g of sugar, which exceeds your low-sugar dietary restriction."
                    ))
                }
                
            case "Low Fat":
                if nutrition.fat > 10 {
                    healthWarnings.append(HealthWarning(
                        type: .dietaryRestriction(restriction),
                        severity: .moderate,
                        nutrient: "Fat",
                        message: "This meal contains more than 10g of fat, which exceeds your low-fat dietary restriction."
                    ))
                }
                
            default:
                // No specific rules for other restrictions
                break
            }
        }
    }
    
    private func analyzeNutritionalBalance(meal: MealAnalyzable, healthWarnings: inout [HealthWarning], positiveEffects: inout [PositiveEffect]) {
        let nutrition = meal.nutritionalContent
        
        // Check for high calories
        if nutrition.calories > 700 {
            healthWarnings.append(HealthWarning(
                type: .generalNutrition,
                severity: .moderate,
                nutrient: "Calories",
                message: "This meal is high in calories (over 700). Consider adjusting portion size or balancing with lighter meals throughout the day."
            ))
        }
        
        // Check for positive protein content
        if nutrition.protein > 15 && nutrition.protein < 40 {
            positiveEffects.append(PositiveEffect(
                type: .generalNutrition,
                nutrient: "Protein",
                message: "This meal contains a good amount of protein, which helps maintain muscle mass and supports overall health."
            ))
        } else if nutrition.protein > 40 {
            healthWarnings.append(HealthWarning(
                type: .generalNutrition,
                severity: .low,
                nutrient: "Protein",
                message: "This meal is very high in protein. While protein is important, it's best to distribute intake throughout the day."
            ))
        }
        
        // Check for good fiber content
        if nutrition.fiber > 5 {
            positiveEffects.append(PositiveEffect(
                type: .generalNutrition,
                nutrient: "Fiber",
                message: "This meal is a good source of dietary fiber, which supports digestive health."
            ))
        }
        
        // Check for vitamin content
        let hasGoodVitamins = nutrition.vitaminA > 1000 || 
                            nutrition.vitaminC > 20 || 
                            nutrition.vitaminD > 100 || 
                            nutrition.vitaminE > 3 ||
                            nutrition.vitaminB12 > 0.6
        
        if hasGoodVitamins {
            positiveEffects.append(PositiveEffect(
                type: .generalNutrition,
                nutrient: "Vitamins",
                message: "This meal contains important vitamins that support overall health and immune function."
            ))
        }
        
        // Check for mineral content
        let hasGoodMinerals = nutrition.calcium > 200 || 
                            nutrition.iron > 3 || 
                            nutrition.magnesium > 75 || 
                            nutrition.zinc > 2
        
        if hasGoodMinerals {
            positiveEffects.append(PositiveEffect(
                type: .generalNutrition,
                nutrient: "Minerals",
                message: "This meal contains essential minerals that support various body functions and overall health."
            ))
        }
        
        // Check for excessive fat
        if nutrition.fat > 30 {
            healthWarnings.append(HealthWarning(
                type: .generalNutrition,
                severity: .moderate,
                nutrient: "Fat",
                message: "This meal is high in fat. Consider balancing with lower-fat options in your other meals today."
            ))
        }
    }
}

// MARK: - Supporting Types

/// The types of health warning categories
enum HealthWarningType {
    case medicalCondition(String)  // The specific medical condition
    case dietaryRestriction(String)  // The specific dietary restriction
    case generalNutrition  // General nutritional concerns
}

/// The severity level of a health warning
enum WarningSeverity: Comparable {
    case low
    case moderate
    case high
    
    var color: Color {
        switch self {
        case .low:
            return .yellow
        case .moderate:
            return .orange
        case .high:
            return .red
        }
    }
    
    var icon: String {
        switch self {
        case .low:
            return "exclamationmark.circle"
        case .moderate:
            return "exclamationmark.triangle"
        case .high:
            return "xmark.octagon"
        }
    }
}

/// A specific health warning about a meal
struct HealthWarning: Identifiable {
    var id = UUID()
    var type: HealthWarningType
    var severity: WarningSeverity
    var nutrient: String?
    var message: String
    var timestamp = Date()
}

/// The types of positive effects
enum PositiveEffectType {
    case medicalCondition(String)  // Positive for a specific medical condition
    case generalNutrition  // Generally good for health
}

/// A positive health effect of a meal
struct PositiveEffect: Identifiable {
    var id = UUID()
    var type: PositiveEffectType
    var nutrient: String
    var message: String
    var timestamp = Date()
}

/// The complete analysis result for a meal
struct MealAnalysisResult {
    var id = UUID()
    var mealName: String
    var healthWarnings: [HealthWarning]
    var positiveEffects: [PositiveEffect]
    var timestamp: Date
    
    var hasConcerns: Bool {
        return !healthWarnings.isEmpty
    }
    
    var hasPositiveEffects: Bool {
        return !positiveEffects.isEmpty
    }
    
    var overallMessage: String {
        if hasConcerns && !hasPositiveEffects {
            return "This meal requires some attention based on your health profile."
        } else if hasConcerns && hasPositiveEffects {
            return "This meal has some benefits, but also some concerns for your health profile."
        } else if !hasConcerns && hasPositiveEffects {
            return "This meal is a great choice for your health profile!"
        } else {
            return "This meal appears to be neutral for your health profile."
        }
    }
    
    var overallColor: Color {
        if let highestSeverity = healthWarnings.map({ $0.severity }).max() {
            switch highestSeverity {
            case .high:
                return .red
            case .moderate:
                return .orange
            case .low:
                return hasPositiveEffects ? .yellow : .yellow
            }
        } else if hasPositiveEffects {
            return .green
        } else {
            return .blue
        }
    }
} 