import Foundation
import SwiftUI
import Combine
// Add missing model imports

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
    
    // MARK: - Nutrition Trends Data Aggregation
    
    /// Get meals for a specific date range
    func mealsForDateRange(from startDate: Date, to endDate: Date) -> [Meal] {
        let calendar = Calendar.current
        let startOfRange = calendar.startOfDay(for: startDate)
        let endOfRange = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)) ?? endDate
        
        return meals.filter { meal in
            meal.time >= startOfRange && meal.time < endOfRange
        }
    }
    
    /// Get average nutrition for a date range
    func averageNutritionForDateRange(from startDate: Date, to endDate: Date) -> NutritionalInfo {
        let calendar = Calendar.current
        let startOfRange = calendar.startOfDay(for: startDate)
        let endOfRange = calendar.startOfDay(for: endDate)
        
        var totalNutrition = NutritionalInfo()
        var dayCount = 0
        
        var currentDate = startOfRange
        while currentDate <= endOfRange {
            let dayNutrition = totalNutritionForDate(currentDate)
            totalNutrition = addNutrition(totalNutrition, dayNutrition)
            dayCount += 1
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        // Calculate average
        if dayCount > 0 {
            return divideNutrition(totalNutrition, by: Double(dayCount))
        }
        
        return NutritionalInfo()
    }
    
    /// Get nutrition data points for a specific time range
    func nutritionDataPointsForTimeRange(_ timeRange: TimeRange) -> [NutritionDataPoint] {
        let now = Date()
        let calendar = Calendar.current
        let filterDate: Date
        
        switch timeRange {
        case .week:
            filterDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            filterDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .threeMonths:
            filterDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        }
        
        var dataPoints: [NutritionDataPoint] = []
        var currentDate = filterDate
        
        while currentDate <= now {
            let dayStart = calendar.startOfDay(for: currentDate)
            let totalNutrition = totalNutritionForDate(dayStart)
            
            let dataPoint = NutritionDataPoint(
                date: dayStart,
                calories: totalNutrition.calories,
                protein: totalNutrition.protein,
                carbohydrates: totalNutrition.carbohydrates,
                fat: totalNutrition.fat,
                vitaminC: totalNutrition.vitaminC,
                vitaminD: totalNutrition.vitaminD,
                calcium: totalNutrition.calcium,
                iron: totalNutrition.iron
            )
            
            dataPoints.append(dataPoint)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dataPoints
    }
    
    /// Get weekly nutrition summary
    func weeklyNutritionSummary(for date: Date = Date()) -> WeeklyNutritionSummary {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? date
        
        let weeklyMeals = mealsForDateRange(from: startOfWeek, to: endOfWeek)
        let averageNutrition = averageNutritionForDateRange(from: startOfWeek, to: endOfWeek)
        
        return WeeklyNutritionSummary(
            startDate: startOfWeek,
            endDate: endOfWeek,
            averageNutrition: averageNutrition,
            totalMeals: weeklyMeals.count,
            daysWithMeals: uniqueDaysWithMeals(from: startOfWeek, to: endOfWeek)
        )
    }
    
    /// Get monthly nutrition summary
    func monthlyNutritionSummary(for date: Date = Date()) -> MonthlyNutritionSummary {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start ?? date
        let endOfMonth = calendar.dateInterval(of: .month, for: date)?.end ?? date
        
        let monthlyMeals = mealsForDateRange(from: startOfMonth, to: endOfMonth)
        let averageNutrition = averageNutritionForDateRange(from: startOfMonth, to: endOfMonth)
        
        return MonthlyNutritionSummary(
            startDate: startOfMonth,
            endDate: endOfMonth,
            averageNutrition: averageNutrition,
            totalMeals: monthlyMeals.count,
            daysWithMeals: uniqueDaysWithMeals(from: startOfMonth, to: endOfMonth)
        )
    }
    
    /// Get nutrition insights for a time period
    func nutritionInsights(for timeRange: TimeRange, goalCalories: Double) -> [NutritionInsight] {
        let dataPoints = nutritionDataPointsForTimeRange(timeRange)
        var insights: [NutritionInsight] = []
        
        guard !dataPoints.isEmpty else {
            return [NutritionInsight(
                type: .noData,
                message: NSLocalizedString("Add more meals to see nutrition insights and trends.", comment: ""),
                severity: .info
            )]
        }
        
        let avgCalories = dataPoints.reduce(0) { $0 + $1.calories } / Double(dataPoints.count)
        let caloriesDifference = avgCalories - goalCalories
        let percentageDifference = abs(caloriesDifference) / goalCalories * 100
        
        // Calorie insights
        if percentageDifference < 5 {
            insights.append(NutritionInsight(
                type: .calorieBalance,
                message: NSLocalizedString("Great job! Your calorie intake is well-balanced and close to your goal.", comment: ""),
                severity: .positive
            ))
        } else if caloriesDifference > 0 {
            insights.append(NutritionInsight(
                type: .calorieExcess,
                message: String(format: NSLocalizedString("You're consuming about %.0f calories above your daily goal. Consider adjusting portion sizes or meal choices.", comment: ""), caloriesDifference),
                severity: .warning
            ))
        } else {
            insights.append(NutritionInsight(
                type: .calorieDeficit,
                message: String(format: NSLocalizedString("You're consuming about %.0f calories below your daily goal. Consider adding nutritious snacks or larger portions.", comment: ""), abs(caloriesDifference)),
                severity: .warning
            ))
        }
        
        // Consistency insights
        let daysWithData = dataPoints.filter { $0.calories > 0 }.count
        let totalDays = dataPoints.count
        let consistencyPercentage = Double(daysWithData) / Double(totalDays) * 100
        
        if consistencyPercentage < 50 {
            insights.append(NutritionInsight(
                type: .consistency,
                message: NSLocalizedString("Try to log meals more consistently for better tracking and insights.", comment: ""),
                severity: .info
            ))
        }
        
        return insights
    }
    
    // MARK: - Helper Methods
    
    /// Add two nutritional info objects
    private func addNutrition(_ nutrition1: NutritionalInfo, _ nutrition2: NutritionalInfo) -> NutritionalInfo {
        return NutritionalInfo(
            calories: nutrition1.calories + nutrition2.calories,
            protein: nutrition1.protein + nutrition2.protein,
            carbohydrates: nutrition1.carbohydrates + nutrition2.carbohydrates,
            fat: nutrition1.fat + nutrition2.fat,
            fiber: nutrition1.fiber + nutrition2.fiber,
            sugar: nutrition1.sugar + nutrition2.sugar,
            vitaminA: nutrition1.vitaminA + nutrition2.vitaminA,
            vitaminC: nutrition1.vitaminC + nutrition2.vitaminC,
            vitaminD: nutrition1.vitaminD + nutrition2.vitaminD,
            vitaminE: nutrition1.vitaminE + nutrition2.vitaminE,
            vitaminK: nutrition1.vitaminK + nutrition2.vitaminK,
            thiamin: nutrition1.thiamin + nutrition2.thiamin,
            riboflavin: nutrition1.riboflavin + nutrition2.riboflavin,
            niacin: nutrition1.niacin + nutrition2.niacin,
            vitaminB6: nutrition1.vitaminB6 + nutrition2.vitaminB6,
            vitaminB12: nutrition1.vitaminB12 + nutrition2.vitaminB12,
            folate: nutrition1.folate + nutrition2.folate,
            calcium: nutrition1.calcium + nutrition2.calcium,
            iron: nutrition1.iron + nutrition2.iron,
            magnesium: nutrition1.magnesium + nutrition2.magnesium,
            phosphorus: nutrition1.phosphorus + nutrition2.phosphorus,
            potassium: nutrition1.potassium + nutrition2.potassium,
            sodium: nutrition1.sodium + nutrition2.sodium,
            zinc: nutrition1.zinc + nutrition2.zinc,
            selenium: nutrition1.selenium + nutrition2.selenium,
            omega3: nutrition1.omega3 + nutrition2.omega3,
            omega6: nutrition1.omega6 + nutrition2.omega6,
            cholesterol: nutrition1.cholesterol + nutrition2.cholesterol
        )
    }
    
    /// Divide nutrition by a number
    private func divideNutrition(_ nutrition: NutritionalInfo, by divisor: Double) -> NutritionalInfo {
        guard divisor > 0 else { return nutrition }
        
        return NutritionalInfo(
            calories: nutrition.calories / divisor,
            protein: nutrition.protein / divisor,
            carbohydrates: nutrition.carbohydrates / divisor,
            fat: nutrition.fat / divisor,
            fiber: nutrition.fiber / divisor,
            sugar: nutrition.sugar / divisor,
            vitaminA: nutrition.vitaminA / divisor,
            vitaminC: nutrition.vitaminC / divisor,
            vitaminD: nutrition.vitaminD / divisor,
            vitaminE: nutrition.vitaminE / divisor,
            vitaminK: nutrition.vitaminK / divisor,
            thiamin: nutrition.thiamin / divisor,
            riboflavin: nutrition.riboflavin / divisor,
            niacin: nutrition.niacin / divisor,
            vitaminB6: nutrition.vitaminB6 / divisor,
            vitaminB12: nutrition.vitaminB12 / divisor,
            folate: nutrition.folate / divisor,
            calcium: nutrition.calcium / divisor,
            iron: nutrition.iron / divisor,
            magnesium: nutrition.magnesium / divisor,
            phosphorus: nutrition.phosphorus / divisor,
            potassium: nutrition.potassium / divisor,
            sodium: nutrition.sodium / divisor,
            zinc: nutrition.zinc / divisor,
            selenium: nutrition.selenium / divisor,
            omega3: nutrition.omega3 / divisor,
            omega6: nutrition.omega6 / divisor,
            cholesterol: nutrition.cholesterol / divisor
        )
    }
    
    /// Count unique days with meals in a date range
    private func uniqueDaysWithMeals(from startDate: Date, to endDate: Date) -> Int {
        let calendar = Calendar.current
        let mealsInRange = mealsForDateRange(from: startDate, to: endDate)
        
        let uniqueDays = Set(mealsInRange.map { meal in
            calendar.startOfDay(for: meal.time)
        })
        
        return uniqueDays.count
    }
}

// MARK: - Supporting Data Structures

/// Data structure for nutrition data points used in charts
struct NutritionDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
    let protein: Double
    let carbohydrates: Double
    let fat: Double
    let vitaminC: Double
    let vitaminD: Double
    let calcium: Double
    let iron: Double
}

/// Weekly nutrition summary
struct WeeklyNutritionSummary {
    let startDate: Date
    let endDate: Date
    let averageNutrition: NutritionalInfo
    let totalMeals: Int
    let daysWithMeals: Int
}

/// Monthly nutrition summary
struct MonthlyNutritionSummary {
    let startDate: Date
    let endDate: Date
    let averageNutrition: NutritionalInfo
    let totalMeals: Int
    let daysWithMeals: Int
}

/// Nutrition insight for trend analysis
struct NutritionInsight {
    let type: InsightType
    let message: String
    let severity: InsightSeverity
    
    enum InsightType {
        case calorieBalance
        case calorieExcess
        case calorieDeficit
        case consistency
        case noData
    }
    
    enum InsightSeverity {
        case positive
        case warning
        case info
        
        var color: Color {
            switch self {
            case .positive: return .green
            case .warning: return .orange
            case .info: return .blue
            }
        }
    }
}

 