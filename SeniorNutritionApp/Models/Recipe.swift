import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    var name: String
    var ingredients: [RecipeIngredient]
    var totalNutritionalInfo: NutritionalInfo
    var notes: String?
    var servings: Int
    var isCustom: Bool = true
    
    init(id: UUID = UUID(), name: String, ingredients: [RecipeIngredient], notes: String? = nil, servings: Int = 1) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.notes = notes
        self.servings = servings
        self.totalNutritionalInfo = Recipe.calculateTotalNutrition(for: ingredients)
    }
    
    static func calculateTotalNutrition(for ingredients: [RecipeIngredient]) -> NutritionalInfo {
        var total = NutritionalInfo()
        
        for ingredient in ingredients {
            let multiplier = ingredient.quantity / 100.0 // Convert to 100g base
            total.calories += ingredient.food.nutritionalInfo.calories * multiplier
            total.protein += ingredient.food.nutritionalInfo.protein * multiplier
            total.carbohydrates += ingredient.food.nutritionalInfo.carbohydrates * multiplier
            total.fat += ingredient.food.nutritionalInfo.fat * multiplier
            // Add other nutritional values as needed
        }
        
        return total
    }
}

struct RecipeIngredient: Identifiable, Codable {
    let id: UUID
    var food: FoodItem
    var quantity: Double // in grams or ml
    var unit: String
    
    init(id: UUID = UUID(), food: FoodItem, quantity: Double, unit: String = "g") {
        self.id = id
        self.food = food
        self.quantity = quantity
        self.unit = unit
    }
}
