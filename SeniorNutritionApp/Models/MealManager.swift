import Foundation
import SwiftUI
import Combine
// Add missing model imports
import SeniorNutritionApp // If all models are in the main module, or:
// import the specific files if needed, e.g.:
// import "Meal.swift"
// import "NutritionalModels.swift"
// import "NutritionalAnalysisService.swift"
// import "UserProfile.swift"
// import "NutritionalInfo.swift"

class MealManager: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var nutritionalGoals: NutritionalGoals = NutritionalGoals()
    @Published var currentAnalysisResult: MealAnalysisResult?
    @Published var showingNutritionalAlert: Bool = false
    
    private let nutritionalAnalysisService = NutritionalAnalysisService()
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var mealsFileURL: URL {
        documentsDirectory.appendingPathComponent("meals.json")
    }
    
    init() {
        loadMeals()
    }
    
    // Add a new meal with nutritional analysis
    func addMeal(_ meal: Meal, userProfile: UserProfile? = nil) {
        print("Adding new meal: \(meal.name) at time: \(meal.time)")
        meals.append(meal)
        saveMeals()
        print("Total meals after adding: \(meals.count)")
        print("Meals for today: \(mealsForDate(Date()).count)")
        
        // Perform nutritional analysis if user profile is available
        if let profile = userProfile {
            analyzeAndAlertIfNeeded(meal: meal, userProfile: profile)
        }
    }
    
    // Analyze a meal and show an alert if there are concerns
    func analyzeAndAlertIfNeeded(meal: Meal, userProfile: UserProfile) {
        // Analyze the meal for health warnings and positive effects
        // Meal and UserProfile automatically conform to MealAnalyzable and UserProfileAnalyzable
        let analysisResult = nutritionalAnalysisService.analyzeMeal(meal, for: userProfile)
        
        // Store the analysis result
        currentAnalysisResult = analysisResult
        
        // Show an alert if there are any high-severity health warnings
        let hasHighSeverityWarnings = analysisResult.healthWarnings.contains { $0.severity == .high }
        
        if hasHighSeverityWarnings || (analysisResult.healthWarnings.count > 0 && analysisResult.positiveEffects.count > 0) {
            showingNutritionalAlert = true
        }
    }
    
    // Get the most recent analysis result
    func getCurrentAnalysisResult() -> MealAnalysisResult? {
        return currentAnalysisResult
    }
    
    // Dismiss the nutritional alert
    func dismissNutritionalAlert() {
        showingNutritionalAlert = false
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
        print("DEBUG: Filtering meals for date: \(date)")
        print("DEBUG: Total meals in memory: \(meals.count)")
        
        // Get the start and end of the requested day
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDayComponents = DateComponents(day: 1, second: -1)
        let endOfDay = calendar.date(byAdding: endOfDayComponents, to: startOfDay) ?? date
        
        print("DEBUG: Looking for meals between \(startOfDay) and \(endOfDay)")
        
        // Debug print all meals with their times
        for meal in meals {
            let isSameDay = calendar.isDate(meal.time, inSameDayAs: date)
            let isAfterStart = meal.time >= startOfDay
            let isBeforeEnd = meal.time <= endOfDay
            print("DEBUG: Meal: \(meal.name), time: \(meal.time), isSameDay: \(isSameDay), isAfterStart: \(isAfterStart), isBeforeEnd: \(isBeforeEnd)")
        }
        
        // Filter the meals for the specified date
        let filteredMeals = meals.filter { meal in
            calendar.isDate(meal.time, inSameDayAs: date)
        }
        
        print("DEBUG: Found \(filteredMeals.count) meals for date \(date)")
        
        return filteredMeals
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
        print("DEBUG: Attempting to save \(meals.count) meals")
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
            
            print("DEBUG: Successfully saved \(meals.count) meals to \(mealsFileURL.path)")
        } catch {
            print("ERROR: Failed to save meals: \(error)")
        }
    }
    
    // Load meals from persistent storage
    func loadMeals() {
        print("DEBUG: Attempting to load meals from \(mealsFileURL.path)")
        do {
            guard FileManager.default.fileExists(atPath: mealsFileURL.path) else {
                print("DEBUG: No meals file found - starting with empty meals array")
                meals = []
                return
            }
            
            let data = try Data(contentsOf: mealsFileURL)
            print("DEBUG: Loaded \(data.count) bytes from meals file")
            
            let decoder = JSONDecoder()
            meals = try decoder.decode([Meal].self, from: data)
            
            print("DEBUG: Successfully loaded \(meals.count) meals")
            
            if meals.isEmpty {
                print("DEBUG: Warning: Loaded meals array is empty")
            } else {
                print("DEBUG: All loaded meals:")
                for meal in meals {
                    print("DEBUG: - \(meal.name) at \(meal.time)")
                }
            }
        } catch {
            print("ERROR: Failed to load meals: \(error)")
            // If loading fails, start with empty array
            meals = []
        }
    }
    
    /// Update nutritional goals from UserSettings (must be called from a Task or main actor context)
    func updateGoalsFromUserSettings(_ userSettings: UserSettings) async {
        nutritionalGoals.dailyCalories = Double(await userSettings.dailyCalorieGoal)
        nutritionalGoals.dailyProtein = await userSettings.macroGoalsEnabled ? Double(await userSettings.dailyProteinGoal) : NutritionalGoals().dailyProtein
        nutritionalGoals.dailyCarbohydrates = await userSettings.macroGoalsEnabled ? Double(await userSettings.dailyCarbGoal) : NutritionalGoals().dailyCarbohydrates
        nutritionalGoals.dailyFat = await userSettings.macroGoalsEnabled ? Double(await userSettings.dailyFatGoal) : NutritionalGoals().dailyFat
    }
} 