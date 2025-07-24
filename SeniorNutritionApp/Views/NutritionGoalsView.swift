import SwiftUI

struct NutritionGoalsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @State private var calorieGoal: String = ""
    @State private var useCalculatedCalories: Bool = true
    @State private var showMacros: Bool = false
    @State private var proteinGoal: String = ""
    @State private var carbGoal: String = ""
    @State private var fatGoal: String = ""
    @State private var showCalorieCalculation: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("nutrition_goals_title", comment: ""))) {
                    // Calorie Goal Selection
                    if userSettings.hasCalculatedCalorieGoal() {
                        Toggle(NSLocalizedString("Use calculated calorie goal", comment: ""), isOn: $useCalculatedCalories)
                            .onChange(of: useCalculatedCalories) { _, value in
                                if value {
                                    if let calculated = userSettings.getCalculatedDailyCalorieGoal() {
                                        calorieGoal = String(calculated)
                                    }
                                } else {
                                    calorieGoal = String(userSettings.dailyCalorieGoal)
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(NSLocalizedString("Calories", comment: ""))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if userSettings.hasCalculatedCalorieGoal() && useCalculatedCalories {
                                Spacer()
                                Button(action: { showCalorieCalculation.toggle() }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        if useCalculatedCalories && userSettings.hasCalculatedCalorieGoal() {
                            Text(calorieGoal)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .padding(.vertical, 8)
                        } else {
                            TextField(NSLocalizedString("set_calorie_goal", comment: ""), text: $calorieGoal)
                                .keyboardType(.numberPad)
                        }
                        
                        if useCalculatedCalories && userSettings.hasCalculatedCalorieGoal() {
                            Text(NSLocalizedString("Based on your profile and activity level", comment: ""))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Show calculation details if requested
                    if showCalorieCalculation && userSettings.hasCalculatedCalorieGoal() {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(NSLocalizedString("Calorie Calculation Details", comment: ""))
                                .font(.headline)
                            
                            if let explanation = userSettings.getCalorieCalculationExplanation() {
                                Text(explanation)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let bmr = userSettings.getCurrentBMR() {
                                HStack {
                                    Text(NSLocalizedString("BMR:", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("\(Int(bmr.rounded())) cal/day")
                                        .font(.caption)
                                }
                            }
                            
                            if let tdee = userSettings.getCurrentTDEE() {
                                HStack {
                                    Text(NSLocalizedString("TDEE:", comment: ""))
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("\(Int(tdee.rounded())) cal/day")
                                        .font(.caption)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                Toggle(NSLocalizedString("expand_macros", comment: ""), isOn: $showMacros)
                if showMacros {
                    Section(header: Text(NSLocalizedString("expand_macros", comment: ""))) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(NSLocalizedString("Protein", comment: ""))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField(NSLocalizedString("set_protein_goal", comment: ""), text: $proteinGoal)
                                .keyboardType(.numberPad)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(NSLocalizedString("Carbs", comment: ""))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField(NSLocalizedString("set_carb_goal", comment: ""), text: $carbGoal)
                                .keyboardType(.numberPad)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(NSLocalizedString("Fat", comment: ""))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField(NSLocalizedString("set_fat_goal", comment: ""), text: $fatGoal)
                                .keyboardType(.numberPad)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text(NSLocalizedString("Cancel", comment: ""))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("nutrition_goals_title", comment: ""))
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .multilineTextAlignment(.center)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveGoals) {
                        Text(NSLocalizedString("save_goals", comment: ""))
                    }
                }
            }
            .onAppear {
                useCalculatedCalories = userSettings.useCalculatedCalories
                if useCalculatedCalories && userSettings.hasCalculatedCalorieGoal() {
                    calorieGoal = String(userSettings.getCalculatedDailyCalorieGoal() ?? userSettings.dailyCalorieGoal)
                } else {
                    calorieGoal = String(userSettings.dailyCalorieGoal)
                }
                showMacros = userSettings.macroGoalsEnabled
                proteinGoal = String(userSettings.dailyProteinGoal)
                carbGoal = String(userSettings.dailyCarbGoal)
                fatGoal = String(userSettings.dailyFatGoal)
            }
        }
    }
    
    private func saveGoals() {
        // Save calorie goal based on whether using calculated or manual
        if useCalculatedCalories && userSettings.hasCalculatedCalorieGoal() {
            userSettings.useCalculatedCalorieGoal()
        } else {
            if let cal = Int(calorieGoal) {
                userSettings.useManualCalorieGoal(cal)
            }
        }
        
        userSettings.macroGoalsEnabled = showMacros
        if showMacros {
            if let protein = Int(proteinGoal) { userSettings.dailyProteinGoal = protein }
            if let carb = Int(carbGoal) { userSettings.dailyCarbGoal = carb }
            if let fat = Int(fatGoal) { userSettings.dailyFatGoal = fat }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct NutritionGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionGoalsView().environmentObject(UserSettings())
    }
}
#endif 