import Foundation
import SwiftUI

@MainActor
class AIMealSuggestionService: ObservableObject {
    static let shared = AIMealSuggestionService()
    
    @Published var suggestedMeals: [MealSuggestion] = []
    @Published var isGenerating = false
    
    // AI-powered nutrition service
    private let aiNutritionService = UnifiedAINutritionService()
    
    private init() {}
    
    // MARK: - Public Methods
    
    func generateMealSuggestions(for userProfile: UserProfile?, healthGoals: [String], dietaryRestrictions: [String]) {
        isGenerating = true
        
        Task { @MainActor in
            var allSuggestions: [MealSuggestion] = []
            
            // Generate AI-powered suggestions for each meal type
            for mealType in MealType.allCases {
                let aiSuggestions = await aiNutritionService.generateMealSuggestions(
                    userProfile: userProfile,
                    dietaryRestrictions: dietaryRestrictions,
                    healthGoals: healthGoals,
                    mealType: mealType
                )
                allSuggestions.append(contentsOf: aiSuggestions)
            }
            
            // Fallback to traditional suggestions if AI didn't provide enough
            if allSuggestions.count < 8 {
                let fallbackSuggestions = self.createIntelligentSuggestions(
                    userProfile: userProfile,
                    healthGoals: healthGoals,
                    dietaryRestrictions: dietaryRestrictions
                )
                
                // Merge AI suggestions with fallback, avoiding duplicates
                for fallback in fallbackSuggestions {
                    if !allSuggestions.contains(where: { $0.name == fallback.name }) {
                        allSuggestions.append(fallback)
                    }
                }
            }
            
            self.suggestedMeals = Array(allSuggestions.prefix(12)) // Limit to 12 suggestions
            self.isGenerating = false
        }
    }
    
    func generateBreakfastSuggestions(for userProfile: UserProfile?, dietaryRestrictions: [String]) async -> [MealSuggestion] {
        let aiSuggestions = await aiNutritionService.generateMealSuggestions(
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: [],
            mealType: .breakfast
        )
        
        // Fallback if AI doesn't provide enough suggestions
        if aiSuggestions.count < 3 {
            let fallback = createMealsByType(.breakfast, userProfile: userProfile, dietaryRestrictions: dietaryRestrictions)
            return aiSuggestions + fallback.prefix(3 - aiSuggestions.count)
        }
        
        return aiSuggestions
    }
    
    func generateLunchSuggestions(for userProfile: UserProfile?, dietaryRestrictions: [String]) async -> [MealSuggestion] {
        let aiSuggestions = await aiNutritionService.generateMealSuggestions(
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: [],
            mealType: .lunch
        )
        
        if aiSuggestions.count < 3 {
            let fallback = createMealsByType(.lunch, userProfile: userProfile, dietaryRestrictions: dietaryRestrictions)
            return aiSuggestions + fallback.prefix(3 - aiSuggestions.count)
        }
        
        return aiSuggestions
    }
    
    func generateDinnerSuggestions(for userProfile: UserProfile?, dietaryRestrictions: [String]) async -> [MealSuggestion] {
        let aiSuggestions = await aiNutritionService.generateMealSuggestions(
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: [],
            mealType: .dinner
        )
        
        if aiSuggestions.count < 3 {
            let fallback = createMealsByType(.dinner, userProfile: userProfile, dietaryRestrictions: dietaryRestrictions)
            return aiSuggestions + fallback.prefix(3 - aiSuggestions.count)
        }
        
        return aiSuggestions
    }
    
    // MARK: - Private Methods
    
    private func createIntelligentSuggestions(userProfile: UserProfile?, healthGoals: [String], dietaryRestrictions: [String]) -> [MealSuggestion] {
        var suggestions: [MealSuggestion] = []
        
        // Breakfast suggestions
        suggestions.append(contentsOf: createMealsByType(.breakfast, userProfile: userProfile, dietaryRestrictions: dietaryRestrictions))
        
        // Lunch suggestions
        suggestions.append(contentsOf: createMealsByType(.lunch, userProfile: userProfile, dietaryRestrictions: dietaryRestrictions))
        
        // Dinner suggestions
        suggestions.append(contentsOf: createMealsByType(.dinner, userProfile: userProfile, dietaryRestrictions: dietaryRestrictions))
        
        // Snack suggestions
        suggestions.append(contentsOf: createMealsByType(.snack, userProfile: userProfile, dietaryRestrictions: dietaryRestrictions))
        
        return suggestions
    }
    
    private func createMealsByType(_ mealType: MealType, userProfile: UserProfile?, dietaryRestrictions: [String]) -> [MealSuggestion] {
        let baseMeals = getBaseMealsForType(mealType)
        var filteredMeals: [MealSuggestion] = []
        
        for meal in baseMeals {
            // Filter by dietary restrictions
            if isDietaryCompatible(meal, with: dietaryRestrictions) {
                // Customize meal based on user profile
                let customizedMeal = customizeMealForUser(meal, userProfile: userProfile)
                filteredMeals.append(customizedMeal)
            }
        }
        
        // Sort by relevance score
        filteredMeals.sort { $0.relevanceScore > $1.relevanceScore }
        
        // Return top 3 suggestions per meal type
        return Array(filteredMeals.prefix(3))
    }
    
    private func getBaseMealsForType(_ mealType: MealType) -> [MealSuggestion] {
        switch mealType {
        case .breakfast:
            return breakfastMeals
        case .lunch:
            return lunchMeals
        case .dinner:
            return dinnerMeals
        case .snack:
            return snackMeals
        }
    }
    
    private func isDietaryCompatible(_ meal: MealSuggestion, with restrictions: [String]) -> Bool {
        for restriction in restrictions {
            if meal.incompatibleDietaryRestrictions.contains(restriction) {
                return false
            }
        }
        return true
    }
    
    private func customizeMealForUser(_ meal: MealSuggestion, userProfile: UserProfile?) -> MealSuggestion {
        var customizedMeal = meal
        
        guard let profile = userProfile else { return customizedMeal }
        
        // Adjust relevance score based on user profile
        var relevanceAdjustment: Double = 0
        
        // Age-based adjustments
        if profile.age >= 65 {
            if meal.benefits.contains(where: { $0.contains("bone") || $0.contains("calcium") || $0.contains("vitamin D") }) {
                relevanceAdjustment += 0.3
            }
            if meal.benefits.contains(where: { $0.contains("heart") || $0.contains("cardiovascular") }) {
                relevanceAdjustment += 0.2
            }
        }
        
        // BMI-based adjustments
        if let bmi = profile.calculateBMI() {
            if bmi < 18.5 && meal.name.contains("High-Protein") {
                relevanceAdjustment += 0.2
            } else if bmi > 25 && meal.isLowCalorie {
                relevanceAdjustment += 0.3
            }
        }
        
        // Medical condition adjustments
        for condition in profile.medicalConditions {
            if condition.lowercased().contains("diabetes") && meal.isLowGlycemic {
                relevanceAdjustment += 0.4
            }
            if condition.lowercased().contains("heart") && meal.isHeartHealthy {
                relevanceAdjustment += 0.4
            }
            if condition.lowercased().contains("hypertension") && meal.isLowSodium {
                relevanceAdjustment += 0.3
            }
        }
        
        customizedMeal.relevanceScore = min(1.0, meal.relevanceScore + relevanceAdjustment)
        
        // Add personalized reasoning
        if relevanceAdjustment > 0 {
            customizedMeal.personalizedReason = generatePersonalizedReason(for: meal, profile: profile)
        }
        
        return customizedMeal
    }
    
    private func generatePersonalizedReason(for meal: MealSuggestion, profile: UserProfile) -> String {
        var reasons: [String] = []
        
        if profile.age >= 65 {
            if meal.benefits.contains(where: { $0.contains("calcium") || $0.contains("bone") }) {
                reasons.append("Great for bone health at your age")
            }
            if meal.benefits.contains(where: { $0.contains("heart") }) {
                reasons.append("Supports cardiovascular health")
            }
        }
        
        if let bmi = profile.calculateBMI() {
            if bmi > 25 && meal.isLowCalorie {
                reasons.append("Helps with weight management")
            }
        }
        
        for condition in profile.medicalConditions {
            if condition.lowercased().contains("diabetes") && meal.isLowGlycemic {
                reasons.append("Diabetes-friendly option")
            }
        }
        
        return reasons.isEmpty ? "Recommended for you" : reasons.joined(separator: " • ")
    }
    
    // MARK: - Static Meal Data
    
    private var breakfastMeals: [MealSuggestion] {
        [
            MealSuggestion(
                id: UUID(),
                name: "Greek Yogurt with Berries",
                mealType: .breakfast,
                description: "Protein-rich Greek yogurt topped with antioxidant-rich mixed berries and a drizzle of honey",
                ingredients: ["Greek yogurt (1 cup)", "Mixed berries (1/2 cup)", "Honey (1 tbsp)", "Chopped almonds (1 tbsp)"],
                estimatedCalories: 250,
                prepTime: 5,
                benefits: ["High in protein", "Rich in calcium", "Antioxidant-rich", "Supports bone health"],
                isLowCalorie: true,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: true,
                incompatibleDietaryRestrictions: ["Dairy-Free", "Vegan", "Nut-Free"],
                relevanceScore: 0.8
            ),
            
            MealSuggestion(
                id: UUID(),
                name: "Oatmeal with Banana and Nuts",
                mealType: .breakfast,
                description: "Heart-healthy oatmeal with potassium-rich banana and protein-packed nuts",
                ingredients: ["Steel-cut oats (1/2 cup)", "Banana (1 medium)", "Walnuts (1 tbsp)", "Cinnamon", "Skim milk (1/2 cup)"],
                estimatedCalories: 320,
                prepTime: 10,
                benefits: ["Heart-healthy", "High fiber", "Potassium-rich", "Supports cholesterol levels"],
                isLowCalorie: false,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: true,
                incompatibleDietaryRestrictions: ["Gluten-Free", "Nut-Free"],
                relevanceScore: 0.9
            ),
            
            MealSuggestion(
                id: UUID(),
                name: "Vegetable Omelet",
                mealType: .breakfast,
                description: "Protein-rich eggs with colorful vegetables for a nutritious start",
                ingredients: ["Eggs (2 large)", "Spinach (1 cup)", "Bell peppers (1/4 cup)", "Mushrooms (1/4 cup)", "Low-fat cheese (1 oz)"],
                estimatedCalories: 280,
                prepTime: 12,
                benefits: ["High in protein", "Rich in vitamins", "Low carb", "Supports muscle health"],
                isLowCalorie: true,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: false,
                incompatibleDietaryRestrictions: ["Vegan", "Dairy-Free"],
                relevanceScore: 0.85
            )
        ]
    }
    
    private var lunchMeals: [MealSuggestion] {
        [
            MealSuggestion(
                id: UUID(),
                name: "Mediterranean Quinoa Bowl",
                mealType: .lunch,
                description: "Nutrient-dense quinoa with Mediterranean vegetables and healthy fats",
                ingredients: ["Quinoa (1/2 cup cooked)", "Cucumber (1/2 cup)", "Cherry tomatoes (1/2 cup)", "Olives (10)", "Feta cheese (1 oz)", "Olive oil (1 tbsp)"],
                estimatedCalories: 380,
                prepTime: 15,
                benefits: ["Complete protein", "Heart-healthy fats", "Anti-inflammatory", "Rich in antioxidants"],
                isLowCalorie: false,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: false,
                incompatibleDietaryRestrictions: ["Dairy-Free"],
                relevanceScore: 0.9
            ),
            
            MealSuggestion(
                id: UUID(),
                name: "Grilled Salmon Salad",
                mealType: .lunch,
                description: "Omega-3 rich salmon over mixed greens with heart-healthy dressing",
                ingredients: ["Salmon fillet (4 oz)", "Mixed greens (2 cups)", "Avocado (1/2)", "Cherry tomatoes (1/2 cup)", "Olive oil vinaigrette (2 tbsp)"],
                estimatedCalories: 420,
                prepTime: 20,
                benefits: ["High in omega-3", "Heart-healthy", "Anti-inflammatory", "Supports brain health"],
                isLowCalorie: false,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: true,
                incompatibleDietaryRestrictions: ["Vegetarian", "Vegan"],
                relevanceScore: 0.95
            ),
            
            MealSuggestion(
                id: UUID(),
                name: "Lentil Vegetable Soup",
                mealType: .lunch,
                description: "Fiber-rich lentils with colorful vegetables in a warming broth",
                ingredients: ["Red lentils (1/2 cup)", "Carrots (1/2 cup)", "Celery (1/2 cup)", "Onion (1/4 cup)", "Low-sodium vegetable broth (2 cups)", "Spinach (1 cup)"],
                estimatedCalories: 280,
                prepTime: 25,
                benefits: ["High fiber", "Plant-based protein", "Low fat", "Supports digestive health"],
                isLowCalorie: true,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: true,
                incompatibleDietaryRestrictions: [],
                relevanceScore: 0.8
            )
        ]
    }
    
    private var dinnerMeals: [MealSuggestion] {
        [
            MealSuggestion(
                id: UUID(),
                name: "Herb-Crusted Chicken with Sweet Potato",
                mealType: .dinner,
                description: "Lean protein with nutrient-rich sweet potato and steamed vegetables",
                ingredients: ["Chicken breast (4 oz)", "Sweet potato (1 medium)", "Broccoli (1 cup)", "Herbs (rosemary, thyme)", "Olive oil (1 tsp)"],
                estimatedCalories: 450,
                prepTime: 30,
                benefits: ["Lean protein", "Rich in beta-carotene", "High in vitamins", "Supports immune system"],
                isLowCalorie: false,
                isHeartHealthy: true,
                isLowGlycemic: false,
                isLowSodium: true,
                incompatibleDietaryRestrictions: ["Vegetarian", "Vegan"],
                relevanceScore: 0.9
            ),
            
            MealSuggestion(
                id: UUID(),
                name: "Baked Cod with Quinoa",
                mealType: .dinner,
                description: "Mild white fish with complete protein quinoa and roasted vegetables",
                ingredients: ["Cod fillet (5 oz)", "Quinoa (1/2 cup cooked)", "Asparagus (1 cup)", "Lemon", "Garlic", "Olive oil (1 tsp)"],
                estimatedCalories: 380,
                prepTime: 25,
                benefits: ["Lean protein", "Complete amino acids", "Low in mercury", "Heart-healthy"],
                isLowCalorie: true,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: true,
                incompatibleDietaryRestrictions: ["Vegetarian", "Vegan"],
                relevanceScore: 0.85
            ),
            
            MealSuggestion(
                id: UUID(),
                name: "Turkey and Vegetable Stir-Fry",
                mealType: .dinner,
                description: "Lean ground turkey with colorful vegetables in a light sauce",
                ingredients: ["Ground turkey (4 oz)", "Bell peppers (1 cup)", "Snap peas (1/2 cup)", "Carrots (1/2 cup)", "Brown rice (1/2 cup)", "Low-sodium soy sauce"],
                estimatedCalories: 420,
                prepTime: 20,
                benefits: ["Lean protein", "High in vegetables", "Complex carbohydrates", "Balanced nutrition"],
                isLowCalorie: false,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: false,
                incompatibleDietaryRestrictions: ["Vegetarian", "Vegan", "Gluten-Free"],
                relevanceScore: 0.8
            )
        ]
    }
    
    private var snackMeals: [MealSuggestion] {
        [
            MealSuggestion(
                id: UUID(),
                name: "Apple with Almond Butter",
                mealType: .snack,
                description: "Crisp apple with protein-rich almond butter for sustained energy",
                ingredients: ["Apple (1 medium)", "Almond butter (1 tbsp)"],
                estimatedCalories: 180,
                prepTime: 2,
                benefits: ["High fiber", "Healthy fats", "Natural sweetness", "Sustained energy"],
                isLowCalorie: true,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: true,
                incompatibleDietaryRestrictions: ["Nut-Free"],
                relevanceScore: 0.7
            ),
            
            MealSuggestion(
                id: UUID(),
                name: "Greek Yogurt with Cucumber",
                mealType: .snack,
                description: "Refreshing, protein-rich snack with hydrating cucumber",
                ingredients: ["Greek yogurt (1/2 cup)", "Cucumber (1/2 cup sliced)", "Dill", "Lemon juice"],
                estimatedCalories: 100,
                prepTime: 3,
                benefits: ["High protein", "Low calorie", "Hydrating", "Probiotic benefits"],
                isLowCalorie: true,
                isHeartHealthy: true,
                isLowGlycemic: true,
                isLowSodium: true,
                incompatibleDietaryRestrictions: ["Dairy-Free", "Vegan"],
                relevanceScore: 0.75
            )
        ]
    }
}

// MARK: - Supporting Models

struct MealSuggestion: Identifiable {
    let id: UUID
    var name: String
    let mealType: MealType
    var description: String
    var ingredients: [String]
    var estimatedCalories: Int
    var prepTime: Int // in minutes
    var benefits: [String]
    var isLowCalorie: Bool
    var isHeartHealthy: Bool
    var isLowGlycemic: Bool
    var isLowSodium: Bool
    var incompatibleDietaryRestrictions: [String]
    var relevanceScore: Double
    var personalizedReason: String?
    
    init(id: UUID, name: String, mealType: MealType, description: String, ingredients: [String], estimatedCalories: Int, prepTime: Int, benefits: [String], isLowCalorie: Bool, isHeartHealthy: Bool, isLowGlycemic: Bool, isLowSodium: Bool, incompatibleDietaryRestrictions: [String], relevanceScore: Double, personalizedReason: String? = nil) {
        self.id = id
        self.name = name
        self.mealType = mealType
        self.description = description
        self.ingredients = ingredients
        self.estimatedCalories = estimatedCalories
        self.prepTime = prepTime
        self.benefits = benefits
        self.isLowCalorie = isLowCalorie
        self.isHeartHealthy = isHeartHealthy
        self.isLowGlycemic = isLowGlycemic
        self.isLowSodium = isLowSodium
        self.incompatibleDietaryRestrictions = incompatibleDietaryRestrictions
        self.relevanceScore = relevanceScore
        self.personalizedReason = personalizedReason
    }
}

