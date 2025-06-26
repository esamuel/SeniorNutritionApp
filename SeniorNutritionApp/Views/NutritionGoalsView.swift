import SwiftUI

struct NutritionGoalsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @State private var calorieGoal: String = ""
    @State private var showMacros: Bool = false
    @State private var proteinGoal: String = ""
    @State private var carbGoal: String = ""
    @State private var fatGoal: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("nutrition_goals_title", comment: ""))) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NSLocalizedString("Calories", comment: ""))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField(NSLocalizedString("set_calorie_goal", comment: ""), text: $calorieGoal)
                            .keyboardType(.numberPad)
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
            .navigationBarTitle(Text(NSLocalizedString("nutrition_goals_title", comment: "")), displayMode: .inline)
            .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text(NSLocalizedString("Cancel", comment: ""))
            }, trailing: Button(action: saveGoals) {
                Text(NSLocalizedString("save_goals", comment: ""))
            })
            .onAppear {
                calorieGoal = String(userSettings.dailyCalorieGoal)
                showMacros = userSettings.macroGoalsEnabled
                proteinGoal = String(userSettings.dailyProteinGoal)
                carbGoal = String(userSettings.dailyCarbGoal)
                fatGoal = String(userSettings.dailyFatGoal)
            }
        }
    }
    
    private func saveGoals() {
        if let cal = Int(calorieGoal) { userSettings.dailyCalorieGoal = cal }
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