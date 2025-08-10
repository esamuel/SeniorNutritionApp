import Foundation

// Test script to verify calorie calculation implementation
print("Testing Calorie Calculation Service...")

// Test user profile data
let testWeight: Double = 70.0  // kg
let testHeight: Double = 170.0 // cm  
let testAge: Int = 65
let testGender: String = "Female"
let testActivityLevel = ActivityLevel.lightlyActive

// Test BMR calculations
print("\n=== BMR Calculations ===")

let harrisBenedictBMR = CalorieCalculationService.calculateBMRHarrisBenedict(
    weight: testWeight, 
    height: testHeight, 
    age: testAge, 
    gender: testGender
)

let mifflinStJeorBMR = CalorieCalculationService.calculateBMRMifflinStJeor(
    weight: testWeight, 
    height: testHeight, 
    age: testAge, 
    gender: testGender
)

print("Harris-Benedict BMR: \(Int(harrisBenedictBMR.rounded())) cal/day")
print("Mifflin-St Jeor BMR: \(Int(mifflinStJeorBMR.rounded())) cal/day")

// Test TDEE calculations
print("\n=== TDEE Calculations ===")

let harrisBenedictTDEE = CalorieCalculationService.calculateTDEE(
    bmr: harrisBenedictBMR, 
    activityLevel: testActivityLevel
)

let mifflinStJeorTDEE = CalorieCalculationService.calculateTDEE(
    bmr: mifflinStJeorBMR, 
    activityLevel: testActivityLevel
)

print("Harris-Benedict TDEE (\(testActivityLevel.rawValue)): \(Int(harrisBenedictTDEE.rounded())) cal/day")
print("Mifflin-St Jeor TDEE (\(testActivityLevel.rawValue)): \(Int(mifflinStJeorTDEE.rounded())) cal/day")

// Test complete calorie calculation
print("\n=== Complete Calorie Calculation ===")

let calculationResult = CalorieCalculationService.calculateCalorieNeeds(
    weight: testWeight,
    height: testHeight,
    age: testAge,
    gender: testGender,
    activityLevel: testActivityLevel,
    formula: .mifflinStJeor
)

print("BMR: \(Int(calculationResult.bmr.rounded())) cal/day")
print("TDEE (Maintenance): \(Int(calculationResult.tdee.rounded())) cal/day")
print("Weight Loss Goal: \(Int(calculationResult.weightLossCalories.rounded())) cal/day")
print("Weight Gain Goal: \(Int(calculationResult.weightGainCalories.rounded())) cal/day")

// Test senior adjustments
print("\n=== Senior-Specific Adjustments ===")

let healthConditions = ["Diabetes", "High Blood Pressure"]
let adjustedCalories = CalorieCalculationService.applySeniorAdjustments(
    baseCalories: calculationResult.tdee,
    age: testAge,
    healthConditions: healthConditions
)

print("Original TDEE: \(Int(calculationResult.tdee.rounded())) cal/day")
print("Adjusted for senior (age \(testAge)) with conditions \(healthConditions): \(Int(adjustedCalories.rounded())) cal/day")

// Test input validation
print("\n=== Input Validation ===")

let validInputs = CalorieCalculationService.validateInputs(weight: testWeight, height: testHeight, age: testAge)
let invalidInputs = CalorieCalculationService.validateInputs(weight: 0, height: testHeight, age: testAge)

print("Valid inputs (weight: \(testWeight), height: \(testHeight), age: \(testAge)): \(validInputs)")
print("Invalid inputs (weight: 0, height: \(testHeight), age: \(testAge)): \(invalidInputs)")

// Test different activity levels
print("\n=== Activity Level Comparisons ===")

for activityLevel in ActivityLevel.allCases {
    let tdee = CalorieCalculationService.calculateTDEE(bmr: mifflinStJeorBMR, activityLevel: activityLevel)
    print("\(activityLevel.rawValue) (×\(activityLevel.multiplier)): \(Int(tdee.rounded())) cal/day")
}

print("\n✅ All tests completed successfully!")