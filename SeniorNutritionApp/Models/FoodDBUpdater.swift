import Foundation

/// Utility class to update food database without modifying the app itself
class FoodDBUpdater {
    static func updateFoodDatabase() {
        /// Remove the existing stored foods in UserDefaults
        UserDefaults.standard.removeObject(forKey: "savedFoods")
        
        /// Initialize the FoodDatabaseService which will reload all foods
        /// including the new ones from NewFoodItems.swift
        let _ = FoodDatabaseService()
        
        print("Food database has been updated with new items!")
    }
} 