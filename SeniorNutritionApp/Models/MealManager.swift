import Foundation
import SwiftUI
import Combine

class MealManager: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var nutritionalGoals: NutritionalGoals = NutritionalGoals()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var mealsFileURL: URL {
        documentsDirectory.appendingPathComponent("meals.json")
    }
    
    init() {
        loadMeals()
    }
    
    // Add a new meal
    func addMeal(_ meal: Meal) {
        print("Adding new meal: \(meal.name) at time: \(meal.time)")
        meals.append(meal)
        saveMeals()
        print("Total meals after adding: \(meals.count)")
        print("Meals for today: \(mealsForDate(Date()).count)")
    }
    
    // Remove a meal
    func removeMeal(_ meal: Meal) {
        print("Removing meal: \(meal.name)")
        meals.removeAll { $0.id == meal.id }
        saveMeals()
        print("Total meals after removing: \(meals.count)")
    }
    
    // Update a meal
    func updateMeal(_ meal: Meal) {
        print("Updating meal: \(meal.name)")
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index] = meal
            saveMeals()
            print("Meal updated successfully")
        } else {
            print("Failed to find meal to update")
        }
    }
    
    // Get meals for a specific date
    func mealsForDate(_ date: Date) -> [Meal] {
        let calendar = Calendar.current
        let meals = meals.filter { calendar.isDate($0.time, inSameDayAs: date) }
        print("Found \(meals.count) meals for date: \(date)")
        return meals
    }
    
    // Get total nutritional info for a specific date
    func totalNutritionForDate(_ date: Date) -> NutritionalInfo {
        let mealsForDate = mealsForDate(date)
        return mealsForDate.reduce(NutritionalInfo()) { result, meal in
            NutritionalInfo(
                calories: result.calories + meal.adjustedNutritionalInfo.calories,
                protein: result.protein + meal.adjustedNutritionalInfo.protein,
                carbohydrates: result.carbohydrates + meal.adjustedNutritionalInfo.carbohydrates,
                fat: result.fat + meal.adjustedNutritionalInfo.fat,
                fiber: result.fiber + meal.adjustedNutritionalInfo.fiber,
                sugar: result.sugar + meal.adjustedNutritionalInfo.sugar,
                vitaminA: result.vitaminA + meal.adjustedNutritionalInfo.vitaminA,
                vitaminC: result.vitaminC + meal.adjustedNutritionalInfo.vitaminC,
                vitaminD: result.vitaminD + meal.adjustedNutritionalInfo.vitaminD,
                vitaminE: result.vitaminE + meal.adjustedNutritionalInfo.vitaminE,
                vitaminK: result.vitaminK + meal.adjustedNutritionalInfo.vitaminK,
                thiamin: result.thiamin + meal.adjustedNutritionalInfo.thiamin,
                riboflavin: result.riboflavin + meal.adjustedNutritionalInfo.riboflavin,
                niacin: result.niacin + meal.adjustedNutritionalInfo.niacin,
                vitaminB6: result.vitaminB6 + meal.adjustedNutritionalInfo.vitaminB6,
                vitaminB12: result.vitaminB12 + meal.adjustedNutritionalInfo.vitaminB12,
                folate: result.folate + meal.adjustedNutritionalInfo.folate,
                calcium: result.calcium + meal.adjustedNutritionalInfo.calcium,
                iron: result.iron + meal.adjustedNutritionalInfo.iron,
                magnesium: result.magnesium + meal.adjustedNutritionalInfo.magnesium,
                phosphorus: result.phosphorus + meal.adjustedNutritionalInfo.phosphorus,
                potassium: result.potassium + meal.adjustedNutritionalInfo.potassium,
                sodium: result.sodium + meal.adjustedNutritionalInfo.sodium,
                zinc: result.zinc + meal.adjustedNutritionalInfo.zinc,
                selenium: result.selenium + meal.adjustedNutritionalInfo.selenium,
                omega3: result.omega3 + meal.adjustedNutritionalInfo.omega3,
                omega6: result.omega6 + meal.adjustedNutritionalInfo.omega6,
                cholesterol: result.cholesterol + meal.adjustedNutritionalInfo.cholesterol
            )
        }
    }
    
    // Save meals to persistent storage
    private func saveMeals() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encoded = try encoder.encode(meals)
            
            // Write to temporary file first
            let tempURL = documentsDirectory.appendingPathComponent("meals.json.tmp")
            try encoded.write(to: tempURL)
            
            // If write was successful, move temp file to final location
            if FileManager.default.fileExists(atPath: mealsFileURL.path) {
                try FileManager.default.removeItem(at: mealsFileURL)
            }
            try FileManager.default.moveItem(at: tempURL, to: mealsFileURL)
            
            print("Successfully saved \(meals.count) meals to file")
        } catch {
            print("Error saving meals: \(error)")
        }
    }
    
    // Load meals from persistent storage
    func loadMeals() {
        do {
            guard FileManager.default.fileExists(atPath: mealsFileURL.path) else {
                print("No meals file found - starting with empty meals array")
                meals = []
                return
            }
            
            let data = try Data(contentsOf: mealsFileURL)
            let decoder = JSONDecoder()
            meals = try decoder.decode([Meal].self, from: data)
            
            print("Successfully loaded \(meals.count) meals")
            print("\nAll loaded meals:")
            for meal in meals {
                print("- \(meal.name) at \(meal.time)")
            }
        } catch {
            print("Error loading meals: \(error)")
            // If loading fails, start with empty array
            meals = []
        }
    }
} 