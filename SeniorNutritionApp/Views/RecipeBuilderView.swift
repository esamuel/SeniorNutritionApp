import SwiftUI

struct RecipeBuilderView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var premiumManager: PremiumManager
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var foodDatabase = FoodDatabaseService()
    @State private var recipeName: String
    @State private var ingredients: [RecipeIngredient]
    @State private var notes: String
    @State private var servings: Int
    @State private var showingFoodPicker = false
    @State private var showingPremiumAlert = false
    
    private let isEditing: Bool
    var onSave: (Recipe) -> Void
    
    init(recipe: Recipe? = nil, onSave: @escaping (Recipe) -> Void) {
        if let recipe = recipe {
            _recipeName = State(initialValue: recipe.name)
            _ingredients = State(initialValue: recipe.ingredients)
            _notes = State(initialValue: recipe.notes ?? "")
            _servings = State(initialValue: recipe.servings)
            self.isEditing = true
        } else {
            _recipeName = State(initialValue: "")
            _ingredients = State(initialValue: [])
            _notes = State(initialValue: "")
            _servings = State(initialValue: 1)
            self.isEditing = false
        }
        self.onSave = onSave
    }
    
    private var canSave: Bool {
        !recipeName.isEmpty && !ingredients.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details").font(.system(size: userSettings.textSize.size))) {
                    TextField("Recipe name", text: $recipeName)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Stepper("Servings: \(servings)", value: $servings, in: 1...50)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Ingredients").font(.system(size: userSettings.textSize.size))) {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text(ingredient.food.localizedName())
                                .font(.system(size: userSettings.textSize.size))
                            Spacer()
                            Text("\(Int(ingredient.quantity))\(ingredient.unit)")
                                .foregroundColor(.secondary)
                                .font(.system(size: userSettings.textSize.size - 2))
                        }
                    }
                    .onDelete(perform: deleteIngredient)
                    
                    Button(action: {
                        if premiumManager.checkFeatureAccess("recipe_builder") {
                            showingFoodPicker = true
                        } else {
                            showingPremiumAlert = true
                        }
                    }) {
                        Label("Add Ingredient", systemImage: "plus.circle.fill")
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
                
                if !ingredients.isEmpty {
                    Section(header: Text("Nutritional Information (per serving)").font(.system(size: userSettings.textSize.size))) {
                        let nutrition = Recipe.calculateTotalNutrition(for: ingredients)
                        Group {
                            HStack {
                                Text("Calories")
                                Spacer()
                                Text("\(Int(nutrition.calories / Double(servings)))")
                            }
                            HStack {
                                Text("Protein")
                                Spacer()
                                Text("\(Int(nutrition.protein / Double(servings)))g")
                            }
                            HStack {
                                Text("Carbs")
                                Spacer()
                                Text("\(Int(nutrition.carbohydrates / Double(servings)))g")
                            }
                            HStack {
                                Text("Fat")
                                Spacer()
                                Text("\(Int(nutrition.fat / Double(servings)))g")
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
            }
            .navigationTitle(isEditing ? "Edit Recipe" : "Create Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(!canSave)
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .sheet(isPresented: $showingFoodPicker) {
                FoodPickerView { selectedFood in
                    addIngredient(selectedFood)
                }
            }
            .alert("Premium Feature", isPresented: $showingPremiumAlert) {
                Button("Learn More") {
                    // Show premium features view
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Recipe Builder is a premium feature. Upgrade to create custom recipes and automatically calculate nutritional values.")
            }
        }
    }
    
    private func addIngredient(_ food: FoodItem) {
        let ingredient = RecipeIngredient(food: food, quantity: 100) // Default to 100g
        ingredients.append(ingredient)
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    private func saveRecipe() {
        let recipe = Recipe(
            name: recipeName,
            ingredients: ingredients,
            notes: notes.isEmpty ? nil : notes,
            servings: servings
        )
        onSave(recipe)
        presentationMode.wrappedValue.dismiss()
    }
}

// Food Picker View
struct FoodPickerView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var foodDatabase = FoodDatabaseService()
    @State private var searchText = ""
    
    var onSelect: (FoodItem) -> Void
    
    var body: some View {
        NavigationView {
            List(filteredFoods) { food in
                Button(action: {
                    onSelect(food)
                    presentationMode.wrappedValue.dismiss()
                }) {
                                            Text(food.localizedName())
                        .font(.system(size: userSettings.textSize.size))
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Select Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    private var filteredFoods: [FoodItem] {
        let foods = foodDatabase.foodItems
        if searchText.isEmpty {
            return foods
        }
        let searchQuery = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return foods.filter { food in
            // Search in all available languages
            let nameInEnglish = food.name.lowercased().contains(searchQuery)
            let nameInFrench = (food.nameFr ?? "").lowercased().contains(searchQuery)
            let nameInSpanish = (food.nameEs ?? "").lowercased().contains(searchQuery)
            let nameInHebrew = (food.nameHe ?? "").lowercased().contains(searchQuery)
            
            return nameInEnglish || nameInFrench || nameInSpanish || nameInHebrew
        }
    }
}
