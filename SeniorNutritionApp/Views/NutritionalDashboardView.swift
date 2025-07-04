import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct NutritionalDashboardView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @ObservedObject var mealManager: MealManager
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Date selector
                dateSelector
                
                // Daily summary
                dailySummarySection
                
                // Macronutrient breakdown
                macronutrientSection
                
                // Vitamin progress
                vitaminProgressSection
                
                // Mineral progress
                mineralProgressSection
            }
            .padding()
        }
        .onAppear {
            Task { await mealManager.updateGoalsFromUserSettings(userSettings) }
        }
        .onChange(of: selectedDate) { _, _ in
            Task { await mealManager.updateGoalsFromUserSettings(userSettings) }
        }
    }
    
    // Date selector
    private var dateSelector: some View {
        HStack {
            Button(action: { moveDate(by: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: userSettings.textSize.size))
            }
            
            Text(dateFormatter.string(from: selectedDate))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
                .frame(maxWidth: .infinity)
            
            Button(action: { moveDate(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: userSettings.textSize.size))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Daily summary section
    private var dailySummarySection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Daily Summary", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("Calories", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2))
                    Text("\(Int(totalNutrition.calories))/\(Int(goals.dailyCalories))")
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: totalNutrition.calories / goals.dailyCalories,
                    color: .blue
                )
                .frame(width: 50, height: 50)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Macronutrient section
    private var macronutrientSection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Macronutrients", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            VStack(spacing: 10) {
                nutrientProgressBar(
                    name: NSLocalizedString("Protein", comment: ""),
                    current: totalNutrition.protein,
                    goal: goals.dailyProtein,
                    unit: "g",
                    color: .blue
                )
                
                nutrientProgressBar(
                    name: NSLocalizedString("Carbs", comment: ""),
                    current: totalNutrition.carbohydrates,
                    goal: goals.dailyCarbohydrates,
                    unit: "g",
                    color: .green
                )
                
                nutrientProgressBar(
                    name: NSLocalizedString("Fat", comment: ""),
                    current: totalNutrition.fat,
                    goal: goals.dailyFat,
                    unit: "g",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Vitamin progress section
    private var vitaminProgressSection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Vitamins", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                vitaminProgressItem(
                    name: NSLocalizedString("Vitamin D", comment: ""),
                    current: totalNutrition.vitaminD,
                    goal: goals.dailyVitaminD,
                    unit: "IU",
                    color: .yellow
                )
                
                vitaminProgressItem(
                    name: NSLocalizedString("Vitamin C", comment: ""),
                    current: totalNutrition.vitaminC,
                    goal: goals.dailyVitaminC,
                    unit: "mg",
                    color: .orange
                )
                
                vitaminProgressItem(
                    name: NSLocalizedString("Vitamin B12", comment: ""),
                    current: totalNutrition.vitaminB12,
                    goal: goals.dailyVitaminB12,
                    unit: "mcg",
                    color: .blue
                )
                
                vitaminProgressItem(
                    name: NSLocalizedString("Folate", comment: ""),
                    current: totalNutrition.folate,
                    goal: goals.dailyFolate,
                    unit: "mcg",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Mineral progress section
    private var mineralProgressSection: some View {
        let totalNutrition = mealManager.totalNutritionForDate(selectedDate)
        let goals = mealManager.nutritionalGoals
        
        return VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Minerals", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                mineralProgressItem(
                    name: NSLocalizedString("Calcium", comment: ""),
                    current: totalNutrition.calcium,
                    goal: goals.dailyCalcium,
                    unit: "mg",
                    color: .gray
                )
                
                mineralProgressItem(
                    name: NSLocalizedString("Iron", comment: ""),
                    current: totalNutrition.iron,
                    goal: goals.dailyIron,
                    unit: "mg",
                    color: .red
                )
                
                mineralProgressItem(
                    name: NSLocalizedString("Magnesium", comment: ""),
                    current: totalNutrition.magnesium,
                    goal: goals.dailyMagnesium,
                    unit: "mg",
                    color: .green
                )
                
                mineralProgressItem(
                    name: NSLocalizedString("Zinc", comment: ""),
                    current: totalNutrition.zinc,
                    goal: goals.dailyZinc,
                    unit: "mg",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Helper views
    private func nutrientProgressBar(name: String, current: Double, goal: Double, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .font(.system(size: userSettings.textSize.size - 2))
                Spacer()
                Text("\(Int(current))/\(Int(goal))\(unit)")
                    .font(.system(size: userSettings.textSize.size - 2))
            }
            
            ProgressView(value: current, total: goal)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
    
    private func vitaminProgressItem(name: String, current: Double, goal: Double, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(name)
                .font(.system(size: userSettings.textSize.size - 2))
            
            Text("\(Int(current))/\(Int(goal))\(unit)")
                .font(.system(size: userSettings.textSize.size - 2))
            
            CircularProgressView(progress: current / goal, color: color)
                .frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func mineralProgressItem(name: String, current: Double, goal: Double, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(name)
                .font(.system(size: userSettings.textSize.size - 2))
            
            Text("\(Int(current))/\(Int(goal))\(unit)")
                .font(.system(size: userSettings.textSize.size - 2))
            
            CircularProgressView(progress: current / goal, color: color)
                .frame(width: 40, height: 40)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    // Helper functions
    private func moveDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

// Circular progress view
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
        }
    }
} 