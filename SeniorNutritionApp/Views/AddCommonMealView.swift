import SwiftUI

struct AddCommonMealView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var foodDatabase = FoodDatabaseService()
    
    @ObservedObject var userCommonMeals: UserCommonMeals
    @State private var mealName: String = ""
    @State private var selectedMealType: MealType = .breakfast
    @State private var mealPortion: MealPortion = .medium
    @State private var nutritionalInfo = NutritionalInfo()
    @State private var notes: String = ""
    
    // Food search states
    @State private var selectedFood: FoodItem?
    @State private var showingFoodSearch = false
    
    init(userCommonMeals: UserCommonMeals) {
        self.userCommonMeals = userCommonMeals
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Meal Details", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    TextField(NSLocalizedString("Meal name", comment: ""), text: $mealName)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Picker(NSLocalizedString("Meal Type", comment: ""), selection: $selectedMealType) {
                        ForEach(MealType.allCases) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                foodSelectionSection
                
                Section(header: Text(NSLocalizedString("Portion Size", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    Picker(NSLocalizedString("Portion", comment: ""), selection: $mealPortion) {
                        ForEach(MealPortion.allCases) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text(NSLocalizedString("Notes", comment: "")).font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: saveCommonMeal) {
                        Text("Save as Common Meal")
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
            .navigationTitle("Add Common Meal")
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
                    nutritionalInfo = food.nutritionalInfo
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
    
    private var foodSelectionSection: some View {
        Section(header: Text("Food Selection").font(.system(size: userSettings.textSize.size))) {
            searchButton
            if let food = selectedFood {
                selectedFoodView(food)
            }
        }
    }
    
    private var searchButton: some View {
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
    }
    
    private func selectedFoodView(_ food: FoodItem) -> some View {
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
    
    private func saveCommonMeal() {
        let newMeal: Meal
        
        if let food = selectedFood {
            // If a food was selected, preserve all language translations
            newMeal = Meal(
                name: food.name,
                nameFr: food.nameFr,
                nameEs: food.nameEs,
                nameHe: food.nameHe,
                type: selectedMealType,
                time: Date(), // Default time, will be updated when added to daily meals
                portion: mealPortion,
                nutritionalInfo: nutritionalInfo,
                notes: notes.isEmpty ? nil : notes
            )
        } else {
            // Manual entry without a selected food
            newMeal = Meal(
                name: mealName,
                type: selectedMealType,
                time: Date(), // Default time, will be updated when added to daily meals
                portion: mealPortion,
                nutritionalInfo: nutritionalInfo,
                notes: notes.isEmpty ? nil : notes
            )
        }
        
        userCommonMeals.addCommonMeal(newMeal)
        presentationMode.wrappedValue.dismiss()
    }
} 