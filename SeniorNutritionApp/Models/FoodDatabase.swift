import Foundation

// MARK: - Food Item
struct FoodItem: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var category: FoodCategory
    var nutritionalInfo: NutritionalInfo
    var servingSize: Double // in grams
    var servingUnit: String // e.g., "g", "oz", "cup"
    var isCustom: Bool
    var notes: String?
    
    // Computed property for nutritional info per 100g
    var nutritionalInfoPer100g: NutritionalInfo {
        let multiplier = 100.0 / servingSize
        return NutritionalInfo(
            calories: nutritionalInfo.calories * multiplier,
            protein: nutritionalInfo.protein * multiplier,
            carbohydrates: nutritionalInfo.carbohydrates * multiplier,
            fat: nutritionalInfo.fat * multiplier,
            fiber: nutritionalInfo.fiber * multiplier,
            sugar: nutritionalInfo.sugar * multiplier,
            vitaminA: nutritionalInfo.vitaminA * multiplier,
            vitaminC: nutritionalInfo.vitaminC * multiplier,
            vitaminD: nutritionalInfo.vitaminD * multiplier,
            vitaminE: nutritionalInfo.vitaminE * multiplier,
            vitaminK: nutritionalInfo.vitaminK * multiplier,
            thiamin: nutritionalInfo.thiamin * multiplier,
            riboflavin: nutritionalInfo.riboflavin * multiplier,
            niacin: nutritionalInfo.niacin * multiplier,
            vitaminB6: nutritionalInfo.vitaminB6 * multiplier,
            vitaminB12: nutritionalInfo.vitaminB12 * multiplier,
            folate: nutritionalInfo.folate * multiplier,
            calcium: nutritionalInfo.calcium * multiplier,
            iron: nutritionalInfo.iron * multiplier,
            magnesium: nutritionalInfo.magnesium * multiplier,
            phosphorus: nutritionalInfo.phosphorus * multiplier,
            potassium: nutritionalInfo.potassium * multiplier,
            sodium: nutritionalInfo.sodium * multiplier,
            zinc: nutritionalInfo.zinc * multiplier,
            selenium: nutritionalInfo.selenium * multiplier,
            omega3: nutritionalInfo.omega3 * multiplier,
            omega6: nutritionalInfo.omega6 * multiplier,
            cholesterol: nutritionalInfo.cholesterol * multiplier
        )
    }
    
    // Equatable conformance
    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.category == rhs.category &&
        lhs.nutritionalInfo == rhs.nutritionalInfo &&
        lhs.servingSize == rhs.servingSize &&
        lhs.servingUnit == rhs.servingUnit &&
        lhs.isCustom == rhs.isCustom &&
        lhs.notes == rhs.notes
    }
}

// MARK: - Food Category
enum FoodCategory: String, Codable, CaseIterable {
    case grains = "Grains"
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case protein = "Protein"
    case dairy = "Dairy"
    case fats = "Fats"
    case beverages = "Beverages"
    case snacks = "Snacks"
    case other = "Other"
}

// MARK: - Food Database Service
class FoodDatabaseService: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var customFoodItems: [FoodItem] = []
    
    init() {
        // Force reset the database to include new foods
        resetToDefaultFoods()
    }
    
    // Add this new method to reset the database
    func resetToDefaultFoods() {
        print("\n=== Resetting food database to defaults ===")
        // Remove saved foods from UserDefaults
        UserDefaults.standard.removeObject(forKey: "savedFoods")
        UserDefaults.standard.removeObject(forKey: "savedCustomFoods")
        
        // Reload the database
        loadFoodDatabase()
        print("=== Reset complete ===\n")
    }
    
    // Load food database
    func loadFoodDatabase() {
        print("\n=== Starting to load food database ===")
        
        // Load all foods from all food item files
        var allFoods = SampleFoodData.foods + NewFoodItems.foods + AdditionalFoodItems.foods + DairyFoodItems.foods + BeverageFoodItems.foods + SnackFoodItems.foods + FruitFoodItems.foods
        
        print("\nInitial food count: \(allFoods.count)")
        print("\nAvailable foods:")
        for food in allFoods {
            print("- \(food.name) (\(food.category.rawValue))")
        }
        
        // Remove duplicates based on food names (case-insensitive)
        var seenNames = Set<String>()
        allFoods = allFoods.filter { food in
            let lowercaseName = food.name.lowercased()
            let isNew = !seenNames.contains(lowercaseName)
            if isNew {
                seenNames.insert(lowercaseName)
            } else {
                print("Removing duplicate: \(food.name)")
            }
            return isNew
        }
        
        print("\nAfter removing duplicates: \(allFoods.count) foods")
        
        // Load from local storage
        if let savedFoods = UserDefaults.standard.data(forKey: "savedFoods"),
           let decodedFoods = try? JSONDecoder().decode([FoodItem].self, from: savedFoods) {
            print("\nFound saved foods in storage")
            foodItems = decodedFoods
            print("Loaded \(foodItems.count) foods from storage")
        } else {
            print("\nNo saved foods found in storage, using default foods")
            foodItems = allFoods
            // Save default foods
            if let encoded = try? JSONEncoder().encode(foodItems) {
                UserDefaults.standard.set(encoded, forKey: "savedFoods")
                print("Saved default foods to storage")
            }
        }
        
        // Load custom foods and remove any duplicates with main database
        if let savedCustomFoods = UserDefaults.standard.data(forKey: "savedCustomFoods"),
           let decodedCustomFoods = try? JSONDecoder().decode([FoodItem].self, from: savedCustomFoods) {
            print("\nFound saved custom foods in storage")
            // Filter out any custom foods that might duplicate main database entries
            customFoodItems = decodedCustomFoods.filter { customFood in
                let lowercaseName = customFood.name.lowercased()
                return !foodItems.contains { $0.name.lowercased() == lowercaseName }
            }
            print("Loaded \(customFoodItems.count) unique custom foods from storage")
        } else {
            print("\nNo saved custom foods found in storage")
        }
        
        // Print all available foods for debugging
        print("\n=== All available foods ===")
        for food in foodItems {
            print("- \(food.name) (Category: \(food.category.rawValue))")
        }
        print("\n=== All custom foods ===")
        for food in customFoodItems {
            print("- \(food.name) (Category: \(food.category.rawValue))")
        }
        print("\n=== Food database loading complete ===")
    }
    
    // Add custom food
    func addCustomFood(_ food: FoodItem) {
        customFoodItems.append(food)
        saveCustomFoods()
    }
    
    // Remove custom food
    func removeCustomFood(_ food: FoodItem) {
        customFoodItems.removeAll { $0.id == food.id }
        saveCustomFoods()
    }
    
    // Update custom food
    func updateCustomFood(_ food: FoodItem) {
        if let index = customFoodItems.firstIndex(where: { $0.id == food.id }) {
            customFoodItems[index] = food
            saveCustomFoods()
        }
    }
    
    // Search foods
    func searchFoods(query: String) -> [FoodItem] {
        let allFoods = foodItems + customFoodItems
        let searchQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("\n=== Starting food search ===")
        print("Search query: '\(searchQuery)'")
        print("Total foods available: \(allFoods.count)")
        
        // More flexible search that includes partial matches and case-insensitive comparison
        let results = allFoods.filter { food in
            let foodName = food.name.lowercased()
            let matches = foodName.contains(searchQuery) || 
                         foodName.components(separatedBy: " ").contains { $0.contains(searchQuery) }
            if matches {
                print("Match found: \(food.name)")
            }
            return matches
        }
        
        print("\nFound \(results.count) results:")
        for result in results {
            print("- \(result.name) (Category: \(result.category.rawValue))")
        }
        print("=== Search complete ===\n")
        
        return results
    }
    
    // Get foods by category
    func foodsByCategory(_ category: FoodCategory) -> [FoodItem] {
        let allFoods = foodItems + customFoodItems
        return allFoods.filter { $0.category == category }
    }
    
    // Save custom foods
    private func saveCustomFoods() {
        if let encoded = try? JSONEncoder().encode(customFoodItems) {
            UserDefaults.standard.set(encoded, forKey: "savedCustomFoods")
            print("Saved \(customFoodItems.count) custom foods to storage")
        }
    }
} 