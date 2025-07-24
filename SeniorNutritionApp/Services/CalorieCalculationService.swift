import Foundation

// MARK: - Activity Level Enum
enum ActivityLevel: String, CaseIterable, Identifiable, Codable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extraActive = "Extra Active"
    
    var id: String { self.rawValue }
    
    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2          // Little/no exercise
        case .lightlyActive: return 1.375    // Light exercise 1-3 days/week
        case .moderatelyActive: return 1.55  // Moderate exercise 3-5 days/week
        case .veryActive: return 1.725       // Hard exercise 6-7 days/week
        case .extraActive: return 1.9        // Very hard exercise, physical job
        }
    }
    
    var description: String {
        switch self {
        case .sedentary:
            return NSLocalizedString("Little or no exercise", comment: "")
        case .lightlyActive:
            return NSLocalizedString("Light exercise 1-3 days/week", comment: "")
        case .moderatelyActive:
            return NSLocalizedString("Moderate exercise 3-5 days/week", comment: "")
        case .veryActive:
            return NSLocalizedString("Hard exercise 6-7 days/week", comment: "")
        case .extraActive:
            return NSLocalizedString("Very hard exercise or physical job", comment: "")
        }
    }
}

// MARK: - BMR Formula Enum
enum BMRFormula: String, CaseIterable, Identifiable, Codable {
    case harrisBenedict = "Harris-Benedict"
    case mifflinStJeor = "Mifflin-St Jeor"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .harrisBenedict:
            return NSLocalizedString("Harris-Benedict (Traditional)", comment: "")
        case .mifflinStJeor:
            return NSLocalizedString("Mifflin-St Jeor (More accurate for seniors)", comment: "")
        }
    }
}

// MARK: - Calorie Calculation Result
struct CalorieCalculationResult {
    let bmr: Double
    let tdee: Double
    let formula: BMRFormula
    let activityLevel: ActivityLevel
    let weightLossCalories: Double      // -500 cal/day for 1 lb/week
    let weightGainCalories: Double      // +500 cal/day for 1 lb/week
    let maintenanceCalories: Double
    
    init(bmr: Double, activityLevel: ActivityLevel, formula: BMRFormula) {
        self.bmr = bmr
        self.tdee = bmr * activityLevel.multiplier
        self.formula = formula
        self.activityLevel = activityLevel
        self.maintenanceCalories = tdee
        self.weightLossCalories = max(1200, tdee - 500) // Don't go below 1200 for safety
        self.weightGainCalories = tdee + 500
    }
}

// MARK: - Calorie Calculation Service
class CalorieCalculationService: ObservableObject {
    
    // MARK: - BMR Calculations
    
    /// Calculate BMR using Harris-Benedict formula
    /// - Parameters:
    ///   - weight: Weight in kg
    ///   - height: Height in cm
    ///   - age: Age in years
    ///   - gender: "Male", "Female", or "Other"
    /// - Returns: BMR in calories per day
    static func calculateBMRHarrisBenedict(weight: Double, height: Double, age: Int, gender: String) -> Double {
        switch gender.lowercased() {
        case "male":
            return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * Double(age))
        case "female":
            return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * Double(age))
        default:
            // For "Other" or non-binary, use average of male and female formulas
            let maleBMR = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * Double(age))
            let femaleBMR = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * Double(age))
            return (maleBMR + femaleBMR) / 2.0
        }
    }
    
    /// Calculate BMR using Mifflin-St Jeor formula (more accurate for modern populations)
    /// - Parameters:
    ///   - weight: Weight in kg
    ///   - height: Height in cm
    ///   - age: Age in years
    ///   - gender: "Male", "Female", or "Other"
    /// - Returns: BMR in calories per day
    static func calculateBMRMifflinStJeor(weight: Double, height: Double, age: Int, gender: String) -> Double {
        let baseBMR = (10 * weight) + (6.25 * height) - (5 * Double(age))
        
        switch gender.lowercased() {
        case "male":
            return baseBMR + 5
        case "female":
            return baseBMR - 161
        default:
            // For "Other" or non-binary, use average adjustment
            let maleBMR = baseBMR + 5
            let femaleBMR = baseBMR - 161
            return (maleBMR + femaleBMR) / 2.0
        }
    }
    
    // MARK: - TDEE Calculation
    
    /// Calculate Total Daily Energy Expenditure (TDEE)
    /// - Parameters:
    ///   - bmr: Basal Metabolic Rate
    ///   - activityLevel: Activity level multiplier
    /// - Returns: TDEE in calories per day
    static func calculateTDEE(bmr: Double, activityLevel: ActivityLevel) -> Double {
        return bmr * activityLevel.multiplier
    }
    
    // MARK: - Complete Calorie Calculation
    
    /// Calculate complete calorie needs for a user
    /// - Parameters:
    ///   - weight: Weight in kg
    ///   - height: Height in cm
    ///   - age: Age in years
    ///   - gender: "Male", "Female", or "Other"
    ///   - activityLevel: Activity level
    ///   - formula: BMR formula to use
    /// - Returns: Complete calorie calculation result
    static func calculateCalorieNeeds(
        weight: Double,
        height: Double,
        age: Int,
        gender: String,
        activityLevel: ActivityLevel,
        formula: BMRFormula = .mifflinStJeor
    ) -> CalorieCalculationResult {
        
        let bmr: Double
        switch formula {
        case .harrisBenedict:
            bmr = calculateBMRHarrisBenedict(weight: weight, height: height, age: age, gender: gender)
        case .mifflinStJeor:
            bmr = calculateBMRMifflinStJeor(weight: weight, height: height, age: age, gender: gender)
        }
        
        return CalorieCalculationResult(bmr: bmr, activityLevel: activityLevel, formula: formula)
    }
    
    // MARK: - Senior-Specific Adjustments
    
    /// Apply senior-specific adjustments to calorie calculations
    /// Seniors may need slight adjustments due to changes in metabolism and muscle mass
    /// - Parameters:
    ///   - baseCalories: Base calorie calculation
    ///   - age: User's age
    ///   - healthConditions: List of health conditions
    /// - Returns: Adjusted calorie needs
    static func applySeniorAdjustments(
        baseCalories: Double,
        age: Int,
        healthConditions: [String] = []
    ) -> Double {
        var adjustedCalories = baseCalories
        
        // Age-based adjustments (metabolism slows with age)
        if age >= 70 {
            adjustedCalories *= 0.95  // 5% reduction for 70+
        } else if age >= 65 {
            adjustedCalories *= 0.97  // 3% reduction for 65-69
        }
        
        // Health condition adjustments
        if healthConditions.contains("Diabetes") {
            // Diabetics may benefit from slightly lower calorie targets for better glucose control
            adjustedCalories *= 0.95
        }
        
        if healthConditions.contains("Heart Disease") {
            // Heart disease patients may need modest calorie restriction
            adjustedCalories *= 0.93
        }
        
        if healthConditions.contains("Kidney Disease") {
            // Kidney disease may require calorie management
            adjustedCalories *= 0.90
        }
        
        // Ensure minimum safe calorie level
        return max(1200, adjustedCalories)
    }
    
    // MARK: - Validation Methods
    
    /// Validate user input for calorie calculations
    /// - Parameters:
    ///   - weight: Weight in kg
    ///   - height: Height in cm
    ///   - age: Age in years
    /// - Returns: True if inputs are valid for calculation
    static func validateInputs(weight: Double, height: Double, age: Int) -> Bool {
        return weight > 30 && weight < 300 &&  // Reasonable weight range
               height > 100 && height < 250 && // Reasonable height range
               age > 0 && age < 120            // Reasonable age range
    }
    
    /// Get recommended calorie goal based on health goals
    /// - Parameters:
    ///   - calculationResult: Base calculation result
    ///   - healthGoals: User's health goals
    /// - Returns: Recommended daily calorie target
    static func getRecommendedCalorieGoal(
        from calculationResult: CalorieCalculationResult,
        healthGoals: [String]
    ) -> Int {
        
        if healthGoals.contains("Weight Loss") || healthGoals.contains("Lose Weight") {
            return Int(calculationResult.weightLossCalories.rounded())
        } else if healthGoals.contains("Weight Gain") || healthGoals.contains("Gain Weight") {
            return Int(calculationResult.weightGainCalories.rounded())
        } else {
            return Int(calculationResult.maintenanceCalories.rounded())
        }
    }
    
    // MARK: - Utility Methods
    
    /// Convert pounds to kilograms
    static func poundsToKg(_ pounds: Double) -> Double {
        return pounds * 0.453592
    }
    
    /// Convert feet/inches to centimeters
    static func feetInchesToCm(feet: Int, inches: Int) -> Double {
        return Double(feet * 12 + inches) * 2.54
    }
    
    /// Format calorie value for display
    static func formatCalories(_ calories: Double) -> String {
        return String(format: "%.0f", calories)
    }
}