import SwiftUI
import Foundation

struct EditMealView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var foodDatabase = FoodDatabaseService()
    
    @State private var meal: Meal
    @State private var selectedMealType: MealType
    @State private var mealName: String
    @State private var mealTime: Date
    @State private var mealPortion: MealPortion
    @State private var nutritionalInfo: NutritionalInfo
    @State private var notes: String
    @State private var selectedFood: FoodItem?
    @State private var showingFoodSearch = false
    @State private var showingVoiceInput = false
    
    // Store original nutritional info for scaling
    @State private var originalNutritionalInfo: NutritionalInfo
    @State private var originalPortion: MealPortion
    
    var onSave: (Meal) -> Void
    
    init(meal: Meal, onSave: @escaping (Meal) -> Void) {
        _meal = State(initialValue: meal)
        _selectedMealType = State(initialValue: meal.type)
        _mealName = State(initialValue: meal.name)
        _mealTime = State(initialValue: meal.time)
        _mealPortion = State(initialValue: meal.portion)
        _nutritionalInfo = State(initialValue: meal.nutritionalInfo)
        _notes = State(initialValue: meal.notes ?? "")
        _originalNutritionalInfo = State(initialValue: meal.nutritionalInfo)
        _originalPortion = State(initialValue: meal.portion)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details").font(.system(size: userSettings.textSize.size))) {
                    HStack {
                        Text("Meal Type")
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
                        Text("Name")
                            .font(.system(size: userSettings.textSize.size))
                        TextField("Meal name", text: $mealName)
                            .font(.system(size: userSettings.textSize.size))
                        Button(action: {
                            showingVoiceInput = true
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    HStack {
                        Text("Time")
                            .font(.system(size: userSettings.textSize.size))
                        Spacer()
                        DatePicker("", selection: $mealTime, displayedComponents: .hourAndMinute)
                            .font(.system(size: userSettings.textSize.size))
                            .datePickerLTR()
                    }
                }
                Section(header: Text("Food Selection").font(.system(size: userSettings.textSize.size))) {
                    Button(action: {
                        showingFoodSearch = true
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text(selectedFood == nil ? "Search Food Database" : "Change Food")
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
                Section(header: Text(NSLocalizedString("Portion Size", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("Select Portion Size", comment: ""))
                            .font(.system(size: userSettings.textSize.size))
                        VStack(alignment: .center, spacing: 8) {
                            Text(mealPortion.localizedName)
                                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .center)
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
                                        let newPortion: MealPortion
                                        switch rounded {
                                        case 0: newPortion = .small
                                        case 1: newPortion = .medium
                                        case 2: newPortion = .large
                                        default: newPortion = .medium
                                        }
                                        
                                        // Only update if the portion actually changed
                                        if newPortion != mealPortion {
                                            mealPortion = newPortion
                                            
                                            // Scale nutritional information based on portion change
                                            updateNutritionalInfo()
                                        }
                                    }
                                ),
                                in: 0...2,
                                step: 1
                            ) {
                                Text(NSLocalizedString("Portion Size", comment: ""))
                            }
                            .accentColor(.blue)
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
                        
                        // Add explanatory text about auto-scaling of nutritional values
                        Text(NSLocalizedString("Nutritional information automatically scales with portion size", comment: ""))
                            .font(.system(size: userSettings.textSize.size - 3))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 5)
                        
                        // Show the original portion size for the nutritional information when food is selected
                        if selectedFood != nil {
                            Text(String(format: NSLocalizedString("Original nutritional values are for a %@ portion", comment: ""), originalPortion.localizedName))
                                .font(.system(size: userSettings.textSize.size - 3))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                if selectedFood == nil {
                    Section(header: Text("Nutritional Information").font(.system(size: userSettings.textSize.size))) {
                        // Add note about scaling if portion size changed
                        if mealPortion != originalPortion {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(.blue)
                                let scalingFactor = mealPortion.multiplier / originalPortion.multiplier
                                Text(String(format: NSLocalizedString("Values scaled by %@× from %@ size", comment: ""), String(format: "%.2f", scalingFactor), originalPortion.localizedName))
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.secondary)
                                    .padding(.vertical, 4)
                            }
                        }
                        
                        Group {
                            HStack {
                                Text("Calories")
                                Spacer()
                                TextField("Calories", value: $nutritionalInfo.calories, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Protein (g)")
                                Spacer()
                                TextField("Protein", value: $nutritionalInfo.protein, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Carbs (g)")
                                Spacer()
                                TextField("Carbs", value: $nutritionalInfo.carbohydrates, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Fat (g)")
                                Spacer()
                                TextField("Fat", value: $nutritionalInfo.fat, format: .number)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .font(.system(size: userSettings.textSize.size))
                    }
                }
                Section(header: Text("Notes").font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                Section {
                    Button(action: saveMeal) {
                        Text("Save Changes")
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
            .navigationTitle("Edit Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .sheet(isPresented: $showingFoodSearch) {
                FoodSearchView(foodDatabase: foodDatabase, selectedFood: $selectedFood)
            }
            .onChange(of: selectedFood) { oldValue, newValue in
                if let food = newValue {
                    mealName = food.localizedName()
                    originalNutritionalInfo = food.nutritionalInfo
                    nutritionalInfo = food.nutritionalInfo
                    originalPortion = .medium
                    mealPortion = .medium
                }
            }
            .onChange(of: nutritionalInfo) { oldValue, newValue in
                // Only update original values when no food is selected and user edits them manually
                if selectedFood == nil && mealPortion == originalPortion {
                    originalNutritionalInfo = newValue
                }
            }
            .onAppear {
                foodDatabase.loadFoodDatabase()
                // Ensure food database is translated for current language
                Task {
                    await foodDatabase.checkAndTranslateIfNeeded()
                }
            }
        }
    }
    
    // Function to update nutritional information based on portion size
    private func updateNutritionalInfo() {
        // Calculate scaling factor based on portion sizes
        let targetMultiplier = mealPortion.multiplier
        let originalMultiplier = originalPortion.multiplier
        let scalingFactor = targetMultiplier / originalMultiplier
        
        // Scale the nutritional info
        nutritionalInfo = NutritionalInfo(
            calories: originalNutritionalInfo.calories * scalingFactor,
            protein: originalNutritionalInfo.protein * scalingFactor,
            carbohydrates: originalNutritionalInfo.carbohydrates * scalingFactor,
            fat: originalNutritionalInfo.fat * scalingFactor,
            fiber: originalNutritionalInfo.fiber * scalingFactor,
            sugar: originalNutritionalInfo.sugar * scalingFactor,
            vitaminA: originalNutritionalInfo.vitaminA * scalingFactor,
            vitaminC: originalNutritionalInfo.vitaminC * scalingFactor,
            vitaminD: originalNutritionalInfo.vitaminD * scalingFactor,
            vitaminE: originalNutritionalInfo.vitaminE * scalingFactor,
            vitaminK: originalNutritionalInfo.vitaminK * scalingFactor,
            thiamin: originalNutritionalInfo.thiamin * scalingFactor,
            riboflavin: originalNutritionalInfo.riboflavin * scalingFactor,
            niacin: originalNutritionalInfo.niacin * scalingFactor,
            vitaminB6: originalNutritionalInfo.vitaminB6 * scalingFactor,
            vitaminB12: originalNutritionalInfo.vitaminB12 * scalingFactor,
            folate: originalNutritionalInfo.folate * scalingFactor,
            calcium: originalNutritionalInfo.calcium * scalingFactor,
            iron: originalNutritionalInfo.iron * scalingFactor,
            magnesium: originalNutritionalInfo.magnesium * scalingFactor,
            phosphorus: originalNutritionalInfo.phosphorus * scalingFactor,
            potassium: originalNutritionalInfo.potassium * scalingFactor,
            sodium: originalNutritionalInfo.sodium * scalingFactor,
            zinc: originalNutritionalInfo.zinc * scalingFactor,
            selenium: originalNutritionalInfo.selenium * scalingFactor,
            omega3: originalNutritionalInfo.omega3 * scalingFactor,
            omega6: originalNutritionalInfo.omega6 * scalingFactor,
            cholesterol: originalNutritionalInfo.cholesterol * scalingFactor
        )
    }
    
    private func saveMeal() {
        let updatedMeal: Meal
        
        if let food = selectedFood {
            // If a food was selected, preserve all language translations
            updatedMeal = Meal(
                id: meal.id,
                name: food.name,
                nameFr: food.nameFr,
                nameEs: food.nameEs,
                nameHe: food.nameHe,
                type: selectedMealType,
                time: mealTime,
                portion: mealPortion,
                nutritionalInfo: nutritionalInfo,
                notes: notes.isEmpty ? nil : notes,
                imageURL: meal.imageURL
            )
        } else {
            // Using custom name or editing existing meal
            updatedMeal = Meal(
                id: meal.id,
                name: mealName,
                nameFr: meal.nameFr,
                nameEs: meal.nameEs,
                nameHe: meal.nameHe,
                type: selectedMealType,
                time: mealTime,
                portion: mealPortion,
                nutritionalInfo: nutritionalInfo,
                notes: notes.isEmpty ? nil : notes,
                imageURL: meal.imageURL
            )
        }
        
        onSave(updatedMeal)
        presentationMode.wrappedValue.dismiss()
    }
} 