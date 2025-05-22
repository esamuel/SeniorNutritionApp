import SwiftUI
import Foundation

struct AddMealView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var nutritionalAnalysisService = NutritionalAnalysisService()
    
    @Binding var selectedMealType: MealType
    @State private var mealName: String = ""
    @State private var showingVoiceInput = false
    @State private var mealPortion: MealPortion = .medium
    @State private var nutritionalInfo = NutritionalInfo()
    @State private var notes: String = ""
    
    // Food search states
    @State private var searchText = ""
    @State private var selectedFood: FoodItem?
    @State private var showingFoodSearch = false
    
    // Analysis results states
    @State private var showingAnalysisResults = false
    @State private var analysisResult: MealAnalysisResult?
    
    // UI states
    @State private var showingPortionInfo = false
    
    var onSave: (Meal) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Food Selection", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    Button(action: {
                        showingFoodSearch = true
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text(selectedFood == nil ? NSLocalizedString("Search Food Database", comment: "") : NSLocalizedString("Change Food", comment: ""))
                            Spacer()
                            if selectedFood != nil {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    if let food = selectedFood {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(food.localizedName())
                                .font(.system(size: userSettings.textSize.size, weight: .medium))
                            
                            HStack {
                                Text("\(Int(food.nutritionalInfo.calories)) cal")
                                Text("•")
                                Text("\(Int(food.nutritionalInfo.protein))g protein")
                                Text("•")
                                Text("\(Int(food.nutritionalInfo.carbohydrates))g carbs")
                                Text("•")
                                Text("\(Int(food.nutritionalInfo.fat))g fat")
                            }
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text(NSLocalizedString("Meal Details", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    HStack {
                        Text(NSLocalizedString("Meal Type", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        Picker("", selection: $selectedMealType) {
                            ForEach(MealType.allCases) { type in
                                HStack {
                                    Image(systemName: type.icon)
                                    Text(type.localizedName)
                                }
                                .tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.system(size: userSettings.textSize.size))
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Name", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                        
                        TextField(NSLocalizedString("Meal name", comment: ""), text: $mealName)
                            .font(.system(size: userSettings.textSize.size))
                        
                        Button(action: {
                            showingVoiceInput = true
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text(NSLocalizedString("Portion Size", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(NSLocalizedString("Select Portion Size", comment: ""))
                                .font(.system(size: userSettings.textSize.size))
                            Button(action: {
                                showingPortionInfo.toggle()
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                            .popover(isPresented: $showingPortionInfo) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(NSLocalizedString("Portion Size Guide", comment: ""))
                                        .font(.system(size: 22, weight: .bold))
                                        .padding(.bottom, 10)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    ScrollView {
                                        VStack(spacing: 20) {
                                            portionInfoCard(
                                                title: NSLocalizedString("Small", comment: ""),
                                                subtitle: "(3/4 of standard serving)",
                                                examples: [
                                                    "Protein: 2-3 oz (60-85g)",
                                                    "Vegetables: 1/2 cup (75g)",
                                                    "Grains: 1/3 cup (60g)",
                                                    "Fruit: 1 small piece or 1/2 cup"
                                                ],
                                                color: .blue.opacity(0.1),
                                                borderColor: .blue
                                            )
                                            portionInfoCard(
                                                title: NSLocalizedString("Medium", comment: ""),
                                                subtitle: "(Standard serving)",
                                                examples: [
                                                    "Protein: 3-4 oz (85-115g)",
                                                    "Vegetables: 3/4 cup (100g)",
                                                    "Grains: 1/2 cup (80g)",
                                                    "Fruit: 1 medium piece or 3/4 cup"
                                                ],
                                                color: .green.opacity(0.1),
                                                borderColor: .green
                                            )
                                            portionInfoCard(
                                                title: NSLocalizedString("Large", comment: ""),
                                                subtitle: "(1.5x standard serving)",
                                                examples: [
                                                    "Protein: 5-6 oz (140-170g)",
                                                    "Vegetables: 1 cup (150g)",
                                                    "Grains: 3/4 cup (120g)",
                                                    "Fruit: 1 large piece or 1 cup"
                                                ],
                                                color: .orange.opacity(0.1),
                                                borderColor: .orange
                                            )
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding()
                                .frame(width: 350, height: 500)
                            }
                        }
                        // Slider for portion size
                        VStack(alignment: .center, spacing: 8) {
                            // Show selected label
                            Text(mealPortion.localizedName)
                                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
                            // 3-point slider
                            Slider(
                                value: Binding(
                                    get: {
                                        switch mealPortion {
                                        case .small: return 0
                                        case .medium: return 1
                                        case .large: return 2
                                        }
                                    },
                                    set: { newValue in
                                        let rounded = Int(round(newValue))
                                        switch rounded {
                                        case 0: mealPortion = .small
                                        case 1: mealPortion = .medium
                                        case 2: mealPortion = .large
                                        default: mealPortion = .medium
                                        }
                                    }
                                ),
                                in: 0...2,
                                step: 1
                            ) {
                                Text(NSLocalizedString("Portion Size", comment: ""))
                            }
                            .accentColor(.blue)
                            // Custom tick labels
                            HStack {
                                Text(NSLocalizedString("Small", comment: "")).font(.system(size: userSettings.textSize.size - 2))
                                Spacer()
                                Text(NSLocalizedString("Medium", comment: "")).font(.system(size: userSettings.textSize.size - 2))
                                Spacer()
                                Text(NSLocalizedString("Large", comment: "")).font(.system(size: userSettings.textSize.size - 2))
                            }
                            .padding(.horizontal, 4)
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                if selectedFood == nil {
                    Section(header: Text(NSLocalizedString("Nutritional Information", comment: "")).font(.system(size: userSettings.textSize.size))) {
                        Group {
                            HStack {
                                Text(NSLocalizedString("Calories", comment: ""))
                                Spacer()
                                TextField(NSLocalizedString("Calories", comment: ""), value: $nutritionalInfo.calories, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            HStack {
                                Text(NSLocalizedString("Protein (g)", comment: ""))
                                Spacer()
                                TextField(NSLocalizedString("Protein", comment: ""), value: $nutritionalInfo.protein, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            HStack {
                                Text(NSLocalizedString("Carbs (g)", comment: ""))
                                Spacer()
                                TextField(NSLocalizedString("Carbs", comment: ""), value: $nutritionalInfo.carbohydrates, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            HStack {
                                Text(NSLocalizedString("Fat (g)", comment: ""))
                                Spacer()
                                TextField(NSLocalizedString("Fat", comment: ""), value: $nutritionalInfo.fat, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .font(.system(size: userSettings.textSize.size))
                    }
                }
                
                Section(header: Text(NSLocalizedString("Notes", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: analyzeAndShowResults) {
                        Text(NSLocalizedString("Analyze Nutrition", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .disabled(mealName.isEmpty)
                    
                    Button(action: saveMeal) {
                        Text(NSLocalizedString("Save Meal", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(mealName.isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle(NSLocalizedString("Add Meal", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .sheet(isPresented: $showingFoodSearch) {
                FoodSearchView(foodDatabase: foodDatabase, selectedFood: $selectedFood)
            }
            .sheet(isPresented: $showingAnalysisResults) {
                if let result = analysisResult {
                    NavigationView {
                        VStack(spacing: 0) {
                            MealAnalysisView(analysisResult: result)
                                .environmentObject(userSettings)
                                .padding(.horizontal)
                                
                            Divider()
                                .padding(.vertical, 8)
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    showingAnalysisResults = false
                                }) {
                                    Text(NSLocalizedString("Edit Meal", comment: ""))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.orange)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    showingAnalysisResults = false
                                    saveMeal()
                                }) {
                                    Text(NSLocalizedString("Save Anyway", comment: ""))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        .navigationTitle(NSLocalizedString("Nutrition Analysis", comment: ""))
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(NSLocalizedString("Close", comment: "")) {
                                    showingAnalysisResults = false
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: selectedFood) { oldValue, newValue in
                if let food = newValue {
                    mealName = food.localizedName()
                    nutritionalInfo = food.nutritionalInfo
                }
            }
            .onAppear {
                foodDatabase.loadFoodDatabase()
                suggestMealTypeBasedOnTime()
            }
        }
    }
    
    // Helper for portion size info cards
    private func portionInfoCard(title: String, subtitle: String, examples: [String], color: Color, borderColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                Text(NSLocalizedString(subtitle, comment: ""))
                    .font(.system(size: userSettings.textSize.size - 1))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(examples, id: \.self) { example in
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .padding(.top, 6)
                        
                        Text(NSLocalizedString(example, comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    // Function to suggest meal type based on time
    private func suggestMealTypeBasedOnTime() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        // Early morning (5-10): Breakfast
        if hour >= 5 && hour < 10 {
            selectedMealType = .breakfast
        }
        // Late morning to early afternoon (10-15): Lunch
        else if hour >= 10 && hour < 15 {
            selectedMealType = .lunch
        }
        // Late afternoon to evening (15-21): Dinner
        else if hour >= 15 && hour < 21 {
            selectedMealType = .dinner
        }
        // Else (late night or early morning): Snack
        else {
            selectedMealType = .snack
        }
        
        print("DEBUG: Suggesting meal type \(selectedMealType) based on hour \(hour)")
    }
    
    // Analyze nutritional content and show results
    private func analyzeAndShowResults() {
        guard let userProfile = userSettings.userProfile else {
            // Handle case where user profile isn't set up
            saveMeal()
            return
        }
        
        let tempMeal = Meal(
            name: mealName,
            type: selectedMealType,
            time: Date(),
            portion: mealPortion,
            nutritionalInfo: nutritionalInfo,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Analyze the meal
        // tempMeal and userProfile automatically conform to MealAnalyzable and UserProfileAnalyzable
        analysisResult = nutritionalAnalysisService.analyzeMeal(tempMeal, for: userProfile)
        
        // Show the analysis results
        showingAnalysisResults = true
    }
    
    // Save meal
    private func saveMeal() {
        // Use current time to ensure the meal is added for today
        let now = Date()
        print("DEBUG: Adding meal '\(mealName)' with time: \(now)")

        let newMeal: Meal
        
        if let food = selectedFood {
            // If a food was selected, preserve all language translations
            newMeal = Meal(
                name: food.name,
                nameFr: food.nameFr,
                nameEs: food.nameEs,
                nameHe: food.nameHe,
                type: selectedMealType,
                time: now,
                portion: mealPortion,
                nutritionalInfo: nutritionalInfo,
                notes: notes.isEmpty ? nil : notes
            )
        } else {
            // Manual entry without a selected food
            newMeal = Meal(
                name: mealName,
                type: selectedMealType,
                time: now,
                portion: mealPortion,
                nutritionalInfo: nutritionalInfo,
                notes: notes.isEmpty ? nil : notes
            )
        }
        
        print("DEBUG: Created new meal with ID: \(newMeal.id)")
        
        onSave(newMeal)
        presentationMode.wrappedValue.dismiss()
    }
} 