import SwiftUI

struct MealAnalysisView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let analysisResult: MealAnalysisResult
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 16) {
                // Header with overall assessment
                HStack {
                    Image(systemName: analysisResult.healthWarnings.isEmpty ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(analysisResult.overallColor)
                        .font(.system(size: 32))
                    
                    Text(analysisResult.overallMessage)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10).fill(analysisResult.overallColor.opacity(0.1)))
                
                // Health warnings section (if any)
                if !analysisResult.healthWarnings.isEmpty {
                    warningsSection
                }
                
                // Positive effects section (if any)
                if !analysisResult.positiveEffects.isEmpty {
                    positiveEffectsSection
                }
                
                // Recommendations
                if !analysisResult.healthWarnings.isEmpty || !analysisResult.positiveEffects.isEmpty {
                    recommendationsSection
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
    
    // MARK: - Section Components
    
    private var warningsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Considerations")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            ForEach(analysisResult.healthWarnings.sorted { $0.severity.rawValue > $1.severity.rawValue }) { warning in
                warningRow(warning)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.08)))
    }
    
    private func warningRow(_ warning: HealthWarning) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: warning.severity.icon)
                .foregroundColor(warning.severity.color)
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(getWarningTitle(warning))
                        .font(.headline)
                        .foregroundColor(warning.severity.color)
                    
                    if let nutrient = warning.nutrient {
                        Text("(\(nutrient))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(warning.message)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var positiveEffectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Beneficial Nutrients")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            ForEach(analysisResult.positiveEffects) { effect in
                positiveEffectRow(effect)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.08)))
    }
    
    private func positiveEffectRow(_ effect: PositiveEffect) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "heart.fill")
                .foregroundColor(.green)
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(getEffectTitle(effect))
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("(\(effect.nutrient))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(effect.message)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recommendations")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Generate personalized recommendations based on analysis
            let recommendations = getRecommendations()
            
            ForEach(recommendations, id: \.self) { recommendation in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    
                    Text(recommendation)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.08)))
    }
    
    // MARK: - Helper Methods
    
    private func getWarningTitle(_ warning: HealthWarning) -> String {
        switch warning.type {
        case .medicalCondition(let condition):
            return condition
        case .dietaryRestriction(let restriction):
            return restriction
        case .generalNutrition:
            return "Nutritional Balance"
        }
    }
    
    private func getEffectTitle(_ effect: PositiveEffect) -> String {
        switch effect.type {
        case .medicalCondition(let condition):
            return "Good for \(condition)"
        case .generalNutrition:
            return "Healthy Choice"
        }
    }
    
    private func getRecommendations() -> [String] {
        var recommendations: [String] = []
        
        // Add recommendations based on health warnings
        let highPriorityWarnings = analysisResult.healthWarnings.filter { $0.severity == .high }
        
        if !highPriorityWarnings.isEmpty {
            recommendations.append("Consider alternatives for nutrients marked with high concerns.")
        }
        
        // Add balanced meal recommendation if there are both warnings and positives
        if analysisResult.healthWarnings.count > 0 && analysisResult.positiveEffects.count > 0 {
            recommendations.append("This meal has both benefits and concerns. Consider reducing portion size to get the benefits while minimizing potential issues.")
        }
        
        // Add specific recommendations based on nutrients
        let hasHighSodium = analysisResult.healthWarnings.contains { $0.nutrient == "Sodium" }
        if hasHighSodium {
            recommendations.append("Try rinsing canned foods or using fresh ingredients to reduce sodium content.")
        }
        
        let hasHighSugar = analysisResult.healthWarnings.contains { $0.nutrient == "Sugar" }
        if hasHighSugar {
            recommendations.append("Pair sweet foods with protein or healthy fats to slow sugar absorption.")
        }
        
        // Add general meal recommendations based on name
        let mealName = analysisResult.mealName.lowercased()
        if mealName.contains("breakfast") || mealName.contains("morning") {
            recommendations.append("Breakfast is a great time for fiber and protein to keep you feeling full longer.")
        } else if mealName.contains("lunch") || mealName.contains("noon") {
            recommendations.append("For lunch, aim for a balance of protein and complex carbs to maintain energy throughout the afternoon.")
        } else if mealName.contains("dinner") || mealName.contains("evening") {
            recommendations.append("For dinner, consider lighter options if you have digestion concerns or sleep issues.")
        } else if mealName.contains("snack") {
            recommendations.append("Snacks are best kept small and nutritious - focus on quality over quantity.")
        }
        
        // Ensure we have at least some recommendations
        if recommendations.isEmpty {
            recommendations.append("Continue maintaining a balanced diet with a variety of nutrient-rich foods.")
        }
        
        return recommendations
    }
}

// MARK: - Extensions for sorting
extension WarningSeverity {
    // Raw value for sorting
    var rawValue: Int {
        switch self {
        case .low: return 1
        case .moderate: return 2
        case .high: return 3
        }
    }
}

// MARK: - Preview
struct MealAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        let meal = Meal(
            name: "Grilled Salmon with Vegetables",
            type: .dinner,
            nutritionalInfo: NutritionalInfo(
                calories: 450,
                protein: 30,
                carbohydrates: 25,
                fat: 22,
                fiber: 6,
                sugar: 5,
                vitaminA: 1200,
                vitaminC: 45,
                vitaminD: 400,
                calcium: 150,
                potassium: 600,
                sodium: 350,
                omega3: 1.5
            )
        )
        
        // Sample analysis result with both warnings and benefits
        let warnings = [
            HealthWarning(
                type: .medicalCondition("High Blood Pressure"),
                severity: .moderate,
                nutrient: "Sodium",
                message: "This meal contains a moderate amount of sodium, which may affect your blood pressure."
            )
        ]
        
        let positives = [
            PositiveEffect(
                type: .medicalCondition("Heart Disease"),
                nutrient: "Omega-3 Fatty Acids",
                message: "This meal is rich in omega-3 fatty acids, which are beneficial for heart health."
            ),
            PositiveEffect(
                type: .generalNutrition,
                nutrient: "Protein",
                message: "This meal provides a good amount of protein to support muscle maintenance."
            )
        ]
        
        let analysisResult = MealAnalysisResult(
            mealName: meal.name,
            healthWarnings: warnings,
            positiveEffects: positives,
            timestamp: Date()
        )
        
        return MealAnalysisView(analysisResult: analysisResult)
            .environmentObject(UserSettings())
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 