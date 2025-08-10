import Foundation
import SwiftUI

// MARK: - Unified AI Nutrition Service

@MainActor
class UnifiedAINutritionService: ObservableObject {
    @Published var isAvailable = false
    @Published var isProcessing = false
    @Published var lastError: String?
    
    private let ollamaService = OllamaService()
    private let fallbackKnowledgeBase = NutritionKnowledgeBase()
    
    // Settings
    @Published var useAIFirst = true // Try AI first, fallback to keyword-based
    @Published var aiTimeout: TimeInterval = 45.0 // Increased timeout for better AI responses
    
    init() {
        // Observe Ollama connection status
        ollamaService.$isConnected
            .assign(to: &$isAvailable)
        
        // Perform initial connection check with delay
        Task {
            // Wait a moment for app initialization
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            await ollamaService.checkConnection()
        }
    }
    
    // MARK: - Nutrition Chat Integration
    
    func generateNutritionResponse(
        userMessage: String,
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        medications: [Medication],
        age: Int
    ) async -> String {
        
        isProcessing = true
        defer { isProcessing = false }
        
        // Try AI first if available and enabled
        if useAIFirst && isAvailable {
            do {
                let aiResponse = try await withTimeout(aiTimeout) {
                    await self.ollamaService.generateNutritionResponse(
                        userQuestion: userMessage,
                        userProfile: userProfile,
                        dietaryRestrictions: dietaryRestrictions,
                        healthGoals: healthGoals,
                        medications: medications,
                        age: age
                    )
                }
                
                if let response = aiResponse, !response.isEmpty {
                    lastError = nil
                    return formatAIResponse(response)
                }
            } catch {
                if error.localizedDescription.contains("timed out") {
                    lastError = "AI response taking too long, using fallback"
                    print("⏱️ AI request timed out after \(aiTimeout)s, falling back to keyword-based response")
                } else {
                    lastError = "AI service error: \(error.localizedDescription)"
                    print("❌ AI request failed: \(error)")
                }
            }
        }
        
        // Fallback to keyword-based system
        return fallbackKnowledgeBase.generateNutritionResponse(
            userMessage: userMessage.lowercased(),
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: healthGoals,
            medications: medications,
            age: age
        ) ?? "I'm here to help with your nutrition questions. Could you provide more specific details about what you'd like to know?"
    }
    
    // MARK: - Meal Suggestions Integration
    
    func generateMealSuggestions(
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        mealType: MealType,
        availableIngredients: [String]? = nil
    ) async -> [MealSuggestion] {
        
        isProcessing = true
        defer { isProcessing = false }
        
        // Try AI first if available
        if isAvailable {
            do {
                let aiResponse = try await withTimeout(aiTimeout) {
                    await self.ollamaService.generateMealSuggestions(
                        userProfile: userProfile,
                        dietaryRestrictions: dietaryRestrictions,
                        healthGoals: healthGoals,
                        mealType: mealType,
                        availableIngredients: availableIngredients
                    )
                }
                
                if let response = aiResponse, !response.isEmpty {
                    lastError = nil
                    return parseMealSuggestions(from: response, mealType: mealType)
                }
            } catch {
                lastError = "AI meal suggestion failed: \(error.localizedDescription)"
                print("AI meal suggestion failed: \(error)")
            }
        }
        
        // Fallback to traditional meal suggestions
        return generateFallbackMealSuggestions(
            userProfile: userProfile,
            dietaryRestrictions: dietaryRestrictions,
            healthGoals: healthGoals,
            mealType: mealType
        )
    }
    
    // MARK: - Recipe Enhancement
    
    func enhanceRecipe(
        _ recipe: String,
        for dietaryRestrictions: [String],
        healthGoals: [String]
    ) async -> String? {
        
        guard isAvailable else { return nil }
        
        let prompt = """
        Modify this recipe for a senior with these requirements:
        - Dietary restrictions: \(dietaryRestrictions.joined(separator: ", "))
        - Health goals: \(healthGoals.joined(separator: ", "))
        
        Original recipe:
        \(recipe)
        
        Provide:
        1. Modified ingredients list
        2. Adjusted preparation steps
        3. Nutritional improvements made
        4. Why these changes benefit seniors
        
        Keep it practical and easy to follow.
        """
        
        return await ollamaService.queryOllama(prompt: prompt, temperature: 0.6)
    }
    
    // MARK: - Smart Shopping Lists
    
    func generateShoppingList(
        for mealPlan: [MealSuggestion],
        servings: Int = 1
    ) async -> [String] {
        
        guard isAvailable else {
            return generateBasicShoppingList(for: mealPlan)
        }
        
        let mealDescriptions = mealPlan.map { "\($0.name): \($0.ingredients.joined(separator: ", "))" }
        
        let prompt = """
        Create a consolidated shopping list for these meals (serves \(servings)):
        
        \(mealDescriptions.joined(separator: "\n"))
        
        Requirements:
        - Combine duplicate ingredients with total quantities
        - Group by grocery store sections (produce, dairy, etc.)
        - Include approximate quantities for \(servings) serving(s)
        - Focus on senior-friendly package sizes
        - Suggest generic/store brands where appropriate
        
        Format as a simple list grouped by section.
        """
        
        if let response = await ollamaService.queryOllama(prompt: prompt, temperature: 0.5) {
            return response.components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        
        return generateBasicShoppingList(for: mealPlan)
    }
    
    // MARK: - Utility Functions
    
    private func formatAIResponse(_ response: String) -> String {
        // Clean up AI response formatting
        var formatted = response
        
        // Add proper spacing for readability
        formatted = formatted.replacingOccurrences(of: "**", with: "")
        formatted = formatted.replacingOccurrences(of: "###", with: "")
        
        // Ensure proper line breaks
        formatted = formatted.replacingOccurrences(of: "\\n\\n", with: "\n\n")
        formatted = formatted.replacingOccurrences(of: "\\n", with: "\n")
        
        return formatted.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func parseMealSuggestions(from response: String, mealType: MealType) -> [MealSuggestion] {
        var suggestions: [MealSuggestion] = []
        
        // Parse AI response into structured meal suggestions
        let lines = response.components(separatedBy: "\n")
        var currentMeal: MealSuggestion?
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Detect meal titles (Option 1:, Option 2:, etc.)
            if trimmed.contains("Option") && trimmed.contains(":") {
                // Save previous meal if exists
                if let meal = currentMeal {
                    suggestions.append(meal)
                }
                
                // Extract meal name
                let name = trimmed.components(separatedBy: ":").dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines)
                currentMeal = MealSuggestion(
                    id: UUID(),
                    name: name.isEmpty ? "AI Suggested Meal" : name,
                    mealType: mealType,
                    description: "",
                    ingredients: [],
                    estimatedCalories: 300,
                    prepTime: 30,
                    benefits: ["AI Generated"],
                    isLowCalorie: false,
                    isHeartHealthy: true,
                    isLowGlycemic: false,
                    isLowSodium: false,
                    incompatibleDietaryRestrictions: [],
                    relevanceScore: 0.8
                )
            }
            // Parse ingredients
            else if trimmed.lowercased().starts(with: "- ingredients:") || trimmed.lowercased().starts(with: "ingredients:") {
                let ingredientText = trimmed.replacingOccurrences(of: "- Ingredients:", with: "").replacingOccurrences(of: "Ingredients:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                currentMeal?.ingredients = ingredientText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            }
            // Parse preparation (add to description since MealSuggestion doesn't have instructions)
            else if trimmed.lowercased().starts(with: "- preparation:") || trimmed.lowercased().starts(with: "preparation:") {
                let prepText = trimmed.replacingOccurrences(of: "- Preparation:", with: "").replacingOccurrences(of: "Preparation:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                if currentMeal?.description.isEmpty == true {
                    currentMeal?.description = prepText
                } else {
                    currentMeal?.description += "\n\nPreparation: " + prepText
                }
            }
            // Add to description if it's content
            else if !trimmed.isEmpty && currentMeal != nil {
                if currentMeal!.description.isEmpty {
                    currentMeal!.description = trimmed
                } else {
                    currentMeal!.description += "\n" + trimmed
                }
            }
        }
        
        // Add final meal
        if let meal = currentMeal {
            suggestions.append(meal)
        }
        
        // If parsing failed, create a simple suggestion
        if suggestions.isEmpty {
            suggestions.append(MealSuggestion(
                id: UUID(),
                name: "AI Suggested \(mealType.rawValue)",
                mealType: mealType,
                description: response,
                ingredients: ["Check AI response for details"],
                estimatedCalories: 300,
                prepTime: 30,
                benefits: ["AI Generated"],
                isLowCalorie: false,
                isHeartHealthy: true,
                isLowGlycemic: false,
                isLowSodium: false,
                incompatibleDietaryRestrictions: [],
                relevanceScore: 0.8
            ))
        }
        
        return suggestions
    }
    
    private func generateFallbackMealSuggestions(
        userProfile: UserProfile?,
        dietaryRestrictions: [String],
        healthGoals: [String],
        mealType: MealType
    ) -> [MealSuggestion] {
        
        // Simple fallback suggestions based on meal type and restrictions
        switch mealType {
        case .breakfast:
            return [
                MealSuggestion(
                    id: UUID(),
                    name: "Protein-Rich Oatmeal",
                    mealType: .breakfast,
                    description: "Heart-healthy breakfast with protein and fiber",
                    ingredients: ["Rolled oats", "Greek yogurt", "Berries", "Nuts", "Honey"],
                    estimatedCalories: 350,
                    prepTime: 10,
                    benefits: ["High Protein", "Heart Healthy"],
                    isLowCalorie: false,
                    isHeartHealthy: true,
                    isLowGlycemic: true,
                    isLowSodium: true,
                    incompatibleDietaryRestrictions: ["Dairy-Free", "Vegan"],
                    relevanceScore: 0.8
                )
            ]
        case .lunch:
            return [
                MealSuggestion(
                    id: UUID(),
                    name: "Salmon Salad Bowl",
                    mealType: .lunch,
                    description: "Omega-3 rich lunch with vegetables",
                    ingredients: ["Canned salmon", "Mixed greens", "Avocado", "Olive oil", "Lemon"],
                    estimatedCalories: 400,
                    prepTime: 15,
                    benefits: ["Omega-3", "Low Sodium"],
                    isLowCalorie: false,
                    isHeartHealthy: true,
                    isLowGlycemic: true,
                    isLowSodium: true,
                    incompatibleDietaryRestrictions: ["Vegetarian", "Vegan"],
                    relevanceScore: 0.9
                )
            ]
        case .dinner:
            return [
                MealSuggestion(
                    id: UUID(),
                    name: "Baked Chicken with Vegetables",
                    mealType: .dinner,
                    description: "Complete protein with roasted vegetables",
                    ingredients: ["Chicken breast", "Sweet potato", "Broccoli", "Olive oil", "Herbs"],
                    estimatedCalories: 450,
                    prepTime: 45,
                    benefits: ["High Protein", "Balanced"],
                    isLowCalorie: false,
                    isHeartHealthy: true,
                    isLowGlycemic: false,
                    isLowSodium: true,
                    incompatibleDietaryRestrictions: ["Vegetarian", "Vegan"],
                    relevanceScore: 0.8
                )
            ]
        case .snack:
            return [
                MealSuggestion(
                    id: UUID(),
                    name: "Greek Yogurt with Nuts",
                    mealType: .snack,
                    description: "Protein-rich snack with healthy fats",
                    ingredients: ["Greek yogurt", "Mixed nuts", "Berries"],
                    estimatedCalories: 200,
                    prepTime: 2,
                    benefits: ["High Protein", "Quick"],
                    isLowCalorie: true,
                    isHeartHealthy: true,
                    isLowGlycemic: true,
                    isLowSodium: true,
                    incompatibleDietaryRestrictions: ["Dairy-Free", "Vegan"],
                    relevanceScore: 0.7
                )
            ]
        }
    }
    
    private func generateBasicShoppingList(for mealPlan: [MealSuggestion]) -> [String] {
        let allIngredients = mealPlan.flatMap { $0.ingredients }
        let uniqueIngredients = Array(Set(allIngredients)).sorted()
        return uniqueIngredients
    }
    
    // MARK: - Settings & Configuration
    
    func toggleAIPreference() {
        useAIFirst.toggle()
    }
    
    func updateTimeout(_ timeout: TimeInterval) {
        aiTimeout = timeout
    }
    
    func checkOllamaStatus() async {
        await ollamaService.checkConnection()
        print("🔍 Ollama status check: isConnected=\(ollamaService.isConnected), isAvailable=\(isAvailable)")
    }
    
    func forceConnectionCheck() async {
        print("🔄 Force checking Ollama connection...")
        await ollamaService.checkConnection()
        await MainActor.run {
            self.isAvailable = ollamaService.isConnected
        }
        print("✅ Force check complete: isConnected=\(ollamaService.isConnected), isAvailable=\(isAvailable)")
    }
}

// MARK: - Timeout Utility

private func withTimeout<T>(_ timeout: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
    return try await withThrowingTaskGroup(of: T.self) { group in
        // Add the actual operation
        group.addTask {
            return try await operation()
        }
        
        // Add timeout task
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            throw TimeoutError()
        }
        
        // Return the first completed task result
        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}

private struct TimeoutError: Error {
    let localizedDescription = "Operation timed out"
}