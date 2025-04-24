import Foundation
import SwiftUI

class UserCommonMeals: ObservableObject {
    @Published var userMeals: [Meal] = []
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var commonMealsFileURL: URL {
        documentsDirectory.appendingPathComponent("userCommonMeals.json")
    }
    
    init() {
        loadUserMeals()
    }
    
    func addCommonMeal(_ meal: Meal) {
        userMeals.append(meal)
        saveUserMeals()
    }
    
    func removeCommonMeal(_ meal: Meal) {
        userMeals.removeAll { $0.id == meal.id }
        saveUserMeals()
    }
    
    private func saveUserMeals() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encoded = try encoder.encode(userMeals)
            try encoded.write(to: commonMealsFileURL)
            print("Successfully saved \(userMeals.count) common meals")
        } catch {
            print("Error saving common meals: \(error)")
        }
    }
    
    private func loadUserMeals() {
        do {
            guard FileManager.default.fileExists(atPath: commonMealsFileURL.path) else {
                print("No common meals file found - starting with empty array")
                userMeals = []
                return
            }
            
            let data = try Data(contentsOf: commonMealsFileURL)
            let decoder = JSONDecoder()
            userMeals = try decoder.decode([Meal].self, from: data)
            print("Successfully loaded \(userMeals.count) common meals")
        } catch {
            print("Error loading common meals: \(error)")
            userMeals = []
        }
    }
} 