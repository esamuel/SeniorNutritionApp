import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// A reusable alert view to display nutritional warnings or positive feedback
struct NutritionalAlertView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Binding var isPresented: Bool
    
    let analysisResult: MealAnalysisResult
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: headerIcon)
                    .font(.system(size: 24))
                    .foregroundColor(headerColor)
                
                Text("Nutrition Insights")
                    .font(.headline)
                    .foregroundColor(headerColor)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isPresented = false
                        onDismiss()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                }
            }
            .padding()
            .background(headerColor.opacity(0.1))
            
            // Content
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    // Meal name and top message
                    Text(analysisResult.mealName)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(analysisResult.overallMessage)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                    
                    // Critical warnings (if any)
                    let highWarnings = analysisResult.healthWarnings.filter { $0.severity == .high }
                    if !highWarnings.isEmpty {
                        criticalWarningsSection(warnings: highWarnings)
                    }
                    
                    // Positive effects (if any)
                    if analysisResult.hasPositiveEffects {
                        positiveEffectsSection
                    }
                    
                    // View full analysis button
                    Button(action: {
                        // This would navigate to a detailed analysis view
                        withAnimation {
                            isPresented = false
                            onDismiss()
                        }
                    }) {
                        HStack {
                            Text("View Full Analysis")
                            Image(systemName: "chevron.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
    
    // MARK: - UI Components
    
    private func criticalWarningsSection(warnings: [HealthWarning]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Health Considerations")
                .font(.headline)
                .foregroundColor(.red)
            
            ForEach(warnings) { warning in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: warning.severity.icon)
                        .foregroundColor(warning.severity.color)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        if let nutrient = warning.nutrient {
                            Text(nutrient)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(warning.severity.color)
                        }
                        
                        Text(warning.message)
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(8)
    }
    
    private var positiveEffectsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Beneficial Nutrients")
                .font(.headline)
                .foregroundColor(.green)
            
            // Display up to 2 positive effects to keep the alert concise
            let limitedEffects = Array(analysisResult.positiveEffects.prefix(2))
            
            ForEach(limitedEffects) { effect in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(effect.nutrient)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                        
                        Text(effect.message)
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Show a message if there are more positive effects
            if analysisResult.positiveEffects.count > 2 {
                Text("... and \(analysisResult.positiveEffects.count - 2) more benefits")
                    .font(.system(size: userSettings.textSize.size - 1))
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(8)
    }
    
    // MARK: - Helper Properties
    
    private var headerIcon: String {
        if analysisResult.healthWarnings.contains(where: { $0.severity == .high }) {
            return "exclamationmark.triangle.fill"
        } else if analysisResult.healthWarnings.contains(where: { $0.severity == .moderate }) {
            return "exclamationmark.circle.fill"
        } else if analysisResult.positiveEffects.isEmpty {
            return "info.circle.fill"
        } else {
            return "checkmark.circle.fill"
        }
    }
    
    private var headerColor: Color {
        if analysisResult.healthWarnings.contains(where: { $0.severity == .high }) {
            return .red
        } else if analysisResult.healthWarnings.contains(where: { $0.severity == .moderate }) {
            return .orange
        } else if analysisResult.positiveEffects.isEmpty {
            return .blue
        } else {
            return .green
        }
    }
}

// MARK: - Preview
struct NutritionalAlertView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview
        let meal = Meal(
            name: "Bacon Cheeseburger with Fries",
            type: .lunch,
            nutritionalInfo: NutritionalInfo(
                calories: 850,
                protein: 35,
                carbohydrates: 65,
                fat: 48,
                fiber: 3,
                sugar: 12,
                sodium: 1200,
                cholesterol: 120
            )
        )
        
        let warnings = [
            HealthWarning(
                type: .medicalCondition("High Blood Pressure"),
                severity: .high,
                nutrient: "Sodium",
                message: "This meal contains high sodium (1200mg), which may affect your blood pressure."
            ),
            HealthWarning(
                type: .generalNutrition,
                severity: .moderate,
                nutrient: "Fat",
                message: "This meal is high in fat, which may contribute to heart disease and weight gain."
            )
        ]
        
        let positiveEffects = [
            PositiveEffect(
                type: .generalNutrition,
                nutrient: "Protein",
                message: "This meal provides good protein content which helps maintain muscle mass."
            )
        ]
        
        let analysisResult = MealAnalysisResult(
            mealName: meal.name,
            healthWarnings: warnings,
            positiveEffects: positiveEffects,
            timestamp: Date()
        )
        
        return ZStack {
            Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
            
            NutritionalAlertView(
                isPresented: .constant(true),
                analysisResult: analysisResult,
                onDismiss: {}
            )
            .environmentObject(UserSettings())
        }
    }
} 