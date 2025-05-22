import Foundation
import SwiftUI

// MARK: - Nutritional Information
struct NutritionalInfo: Codable, Identifiable, Equatable {
    var id = UUID()
    
    // Macronutrients
    var calories: Double
    var protein: Double // in grams
    var carbohydrates: Double // in grams
    var fat: Double // in grams
    var fiber: Double // in grams
    var sugar: Double // in grams
    
    // Vitamins
    var vitaminA: Double // in IU
    var vitaminC: Double // in mg
    var vitaminD: Double // in IU
    var vitaminE: Double // in mg
    var vitaminK: Double // in mcg
    var thiamin: Double // in mg
    var riboflavin: Double // in mg
    var niacin: Double // in mg
    var vitaminB6: Double // in mg
    var vitaminB12: Double // in mcg
    var folate: Double // in mcg
    
    // Minerals
    var calcium: Double // in mg
    var iron: Double // in mg
    var magnesium: Double // in mg
    var phosphorus: Double // in mg
    var potassium: Double // in mg
    var sodium: Double // in mg
    var zinc: Double // in mg
    var selenium: Double // in mcg
    
    // Other nutrients
    var omega3: Double // in grams
    var omega6: Double // in grams
    var cholesterol: Double // in mg
    
    // Initializer with default values
    init(
        calories: Double = 0,
        protein: Double = 0,
        carbohydrates: Double = 0,
        fat: Double = 0,
        fiber: Double = 0,
        sugar: Double = 0,
        vitaminA: Double = 0,
        vitaminC: Double = 0,
        vitaminD: Double = 0,
        vitaminE: Double = 0,
        vitaminK: Double = 0,
        thiamin: Double = 0,
        riboflavin: Double = 0,
        niacin: Double = 0,
        vitaminB6: Double = 0,
        vitaminB12: Double = 0,
        folate: Double = 0,
        calcium: Double = 0,
        iron: Double = 0,
        magnesium: Double = 0,
        phosphorus: Double = 0,
        potassium: Double = 0,
        sodium: Double = 0,
        zinc: Double = 0,
        selenium: Double = 0,
        omega3: Double = 0,
        omega6: Double = 0,
        cholesterol: Double = 0
    ) {
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.fiber = fiber
        self.sugar = sugar
        self.vitaminA = vitaminA
        self.vitaminC = vitaminC
        self.vitaminD = vitaminD
        self.vitaminE = vitaminE
        self.vitaminK = vitaminK
        self.thiamin = thiamin
        self.riboflavin = riboflavin
        self.niacin = niacin
        self.vitaminB6 = vitaminB6
        self.vitaminB12 = vitaminB12
        self.folate = folate
        self.calcium = calcium
        self.iron = iron
        self.magnesium = magnesium
        self.phosphorus = phosphorus
        self.potassium = potassium
        self.sodium = sodium
        self.zinc = zinc
        self.selenium = selenium
        self.omega3 = omega3
        self.omega6 = omega6
        self.cholesterol = cholesterol
    }
    
    // Equatable conformance
    static func == (lhs: NutritionalInfo, rhs: NutritionalInfo) -> Bool {
        lhs.calories == rhs.calories &&
        lhs.protein == rhs.protein &&
        lhs.carbohydrates == rhs.carbohydrates &&
        lhs.fat == rhs.fat &&
        lhs.fiber == rhs.fiber &&
        lhs.sugar == rhs.sugar &&
        lhs.vitaminA == rhs.vitaminA &&
        lhs.vitaminC == rhs.vitaminC &&
        lhs.vitaminD == rhs.vitaminD &&
        lhs.vitaminE == rhs.vitaminE &&
        lhs.vitaminK == rhs.vitaminK &&
        lhs.thiamin == rhs.thiamin &&
        lhs.riboflavin == rhs.riboflavin &&
        lhs.niacin == rhs.niacin &&
        lhs.vitaminB6 == rhs.vitaminB6 &&
        lhs.vitaminB12 == rhs.vitaminB12 &&
        lhs.folate == rhs.folate &&
        lhs.calcium == rhs.calcium &&
        lhs.iron == rhs.iron &&
        lhs.magnesium == rhs.magnesium &&
        lhs.phosphorus == rhs.phosphorus &&
        lhs.potassium == rhs.potassium &&
        lhs.sodium == rhs.sodium &&
        lhs.zinc == rhs.zinc &&
        lhs.selenium == rhs.selenium &&
        lhs.omega3 == rhs.omega3 &&
        lhs.omega6 == rhs.omega6 &&
        lhs.cholesterol == rhs.cholesterol
    }
}

// MARK: - Nutritional Goals
struct NutritionalGoals: Codable {
    // Daily targets
    var dailyCalories: Double
    var dailyProtein: Double // in grams
    var dailyCarbohydrates: Double // in grams
    var dailyFat: Double // in grams
    var dailyFiber: Double // in grams
    var dailySugar: Double // in grams
    
    // Vitamin targets
    var dailyVitaminA: Double // in IU
    var dailyVitaminC: Double // in mg
    var dailyVitaminD: Double // in IU
    var dailyVitaminE: Double // in mg
    var dailyVitaminK: Double // in mcg
    var dailyThiamin: Double // in mg
    var dailyRiboflavin: Double // in mg
    var dailyNiacin: Double // in mg
    var dailyVitaminB6: Double // in mg
    var dailyVitaminB12: Double // in mcg
    var dailyFolate: Double // in mcg
    
    // Mineral targets
    var dailyCalcium: Double // in mg
    var dailyIron: Double // in mg
    var dailyMagnesium: Double // in mg
    var dailyPhosphorus: Double // in mg
    var dailyPotassium: Double // in mg
    var dailySodium: Double // in mg
    var dailyZinc: Double // in mg
    var dailySelenium: Double // in mcg
    
    // Other nutrient targets
    var dailyOmega3: Double // in grams
    var dailyOmega6: Double // in grams
    var dailyCholesterol: Double // in mg
    
    // Initializer with default values based on senior nutrition guidelines
    init(
        dailyCalories: Double = 2000,
        dailyProtein: Double = 60, // 1.2g per kg of body weight
        dailyCarbohydrates: Double = 250,
        dailyFat: Double = 65,
        dailyFiber: Double = 28,
        dailySugar: Double = 25,
        dailyVitaminA: Double = 5000,
        dailyVitaminC: Double = 90,
        dailyVitaminD: Double = 800,
        dailyVitaminE: Double = 15,
        dailyVitaminK: Double = 120,
        dailyThiamin: Double = 1.2,
        dailyRiboflavin: Double = 1.3,
        dailyNiacin: Double = 16,
        dailyVitaminB6: Double = 1.7,
        dailyVitaminB12: Double = 2.4,
        dailyFolate: Double = 400,
        dailyCalcium: Double = 1200,
        dailyIron: Double = 8,
        dailyMagnesium: Double = 420,
        dailyPhosphorus: Double = 700,
        dailyPotassium: Double = 4700,
        dailySodium: Double = 1500,
        dailyZinc: Double = 11,
        dailySelenium: Double = 55,
        dailyOmega3: Double = 1.6,
        dailyOmega6: Double = 17,
        dailyCholesterol: Double = 300
    ) {
        self.dailyCalories = dailyCalories
        self.dailyProtein = dailyProtein
        self.dailyCarbohydrates = dailyCarbohydrates
        self.dailyFat = dailyFat
        self.dailyFiber = dailyFiber
        self.dailySugar = dailySugar
        self.dailyVitaminA = dailyVitaminA
        self.dailyVitaminC = dailyVitaminC
        self.dailyVitaminD = dailyVitaminD
        self.dailyVitaminE = dailyVitaminE
        self.dailyVitaminK = dailyVitaminK
        self.dailyThiamin = dailyThiamin
        self.dailyRiboflavin = dailyRiboflavin
        self.dailyNiacin = dailyNiacin
        self.dailyVitaminB6 = dailyVitaminB6
        self.dailyVitaminB12 = dailyVitaminB12
        self.dailyFolate = dailyFolate
        self.dailyCalcium = dailyCalcium
        self.dailyIron = dailyIron
        self.dailyMagnesium = dailyMagnesium
        self.dailyPhosphorus = dailyPhosphorus
        self.dailyPotassium = dailyPotassium
        self.dailySodium = dailySodium
        self.dailyZinc = dailyZinc
        self.dailySelenium = dailySelenium
        self.dailyOmega3 = dailyOmega3
        self.dailyOmega6 = dailyOmega6
        self.dailyCholesterol = dailyCholesterol
    }
}

// MARK: - Meal Portion
enum MealPortion: String, CaseIterable, Identifiable, Codable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    var id: String { self.rawValue }
    
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var multiplier: Double {
        switch self {
        case .small: return 0.75
        case .medium: return 1.0
        case .large: return 1.5
        }
    }
}

// MARK: - Meal Type
enum MealType: String, CaseIterable, Identifiable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var id: String { self.rawValue }
    
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "sunset.fill"
        case .snack: return "lightbulb.fill"
        }
    }
    
    var colorName: String {
        switch self {
        case .breakfast: return "orange"
        case .lunch: return "yellow"
        case .dinner: return "blue"
        case .snack: return "green"
        }
    }
    
    var color: Color {
        switch self {
        case .breakfast: return .orange
        case .lunch: return .yellow
        case .dinner: return .blue
        case .snack: return .green
        }
    }
} 