import SwiftUI

struct FoodDatabaseView: View {
    enum ViewMode {
        case foods, recipes
    }
    
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var premiumManager: PremiumManager
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var recipeManager = RecipeManager.shared
    
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var showingAddFood = false
    @State private var showingRecipeBuilder = false
    @State private var showingPremiumAlert = false
    @State private var viewMode: ViewMode = .foods
    
    var body: some View {
        NavigationView {
            VStack {
                // View mode picker
                Picker("View Mode", selection: $viewMode) {
                    Text("Foods").tag(ViewMode.foods)
                    Text("Recipes").tag(ViewMode.recipes)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewMode == .foods {
                    // Search bar
                    searchBar
                    
                    // Category filter
                    categoryFilter
                    
                    // Food list
                    foodList
                } else {
                    // Recipes list
                    recipesList
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(viewMode == .foods ? NSLocalizedString("Food Database", comment: "") : NSLocalizedString("Recipes", comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewMode == .foods {
                        Button(action: {
                            showingAddFood = true
                        }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                    } else {
                        Button(action: {
                            if premiumManager.checkFeatureAccess("recipe_builder") {
                                showingRecipeBuilder = true
                            } else {
                                showingPremiumAlert = true
                            }
                        }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        foodDatabase.resetToDefaultFoods()
                    }) {
                        Label(NSLocalizedString("Reset", comment: ""), systemImage: "arrow.clockwise")
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView { newFood in
                    foodDatabase.addCustomFood(newFood)
                }
            }
            .sheet(isPresented: $showingRecipeBuilder) {
                RecipeBuilderView { recipe in
                    recipeManager.addRecipe(recipe)
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
            .onAppear {
                foodDatabase.loadFoodDatabase()
            }
        }
    }
    
    // Search bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search foods", text: $searchText)
                .font(.system(size: userSettings.textSize.size))
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // Category filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    categoryButton(category)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Category button
    private func categoryButton(_ category: FoodCategory) -> some View {
        Button(action: {
            selectedCategory = selectedCategory == category ? nil : category
        }) {
            Text(category.localizedString)
                .font(.system(size: userSettings.textSize.size - 2))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(selectedCategory == category ? Color.blue : Color(.systemGray6))
                .foregroundColor(selectedCategory == category ? .white : .primary)
                .cornerRadius(20)
        }
    }
    
    // Food list
    private var foodList: some View {
        List {
            ForEach(filteredFoods) { food in
                foodRow(food)
            }
        }
    }
    
    // Food row
    private func foodRow(_ food: FoodItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(food.name)
                    .font(.system(size: userSettings.textSize.size, weight: .medium))
                
                Spacer()
                
                Text("\(Int(food.nutritionalInfo.calories)) cal")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("\(Int(food.nutritionalInfo.protein))g protein")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Text("\(Int(food.nutritionalInfo.carbohydrates))g carbs")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                
                Text("•")
                    .foregroundColor(.secondary)
                
                Text("\(Int(food.nutritionalInfo.fat))g fat")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            if food.isCustom {
                Text("Custom Food")
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 4)
    }
    
    // Filtered foods
    private var filteredFoods: [FoodItem] {
        var foods = foodDatabase.foodItems + foodDatabase.customFoodItems
        
        // Apply search filter
        if !searchText.isEmpty {
            foods = foods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    List {
        ForEach(filteredFoods) { food in
            foodRow(food)
        }
    }
}

// Food row
private func foodRow(_ food: FoodItem) -> some View {
    VStack(alignment: .leading, spacing: 8) {
        HStack {
            Text(food.name)
                .font(.system(size: userSettings.textSize.size, weight: .medium))
            
            Spacer()
            
            Text("\(Int(food.nutritionalInfo.calories)) cal")
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
        }
        
        HStack {
            Text("\(Int(food.nutritionalInfo.protein))g protein")
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
            
            Text("•")
                .foregroundColor(.secondary)
            
            Text("\(Int(food.nutritionalInfo.carbohydrates))g carbs")
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
            
            Text("•")
                .foregroundColor(.secondary)
            
            Text("\(Int(food.nutritionalInfo.fat))g fat")
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
        }
        
        if food.isCustom {
            Text("Custom Food")
                .font(.system(size: userSettings.textSize.size - 4))
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
        }
    }
    .padding(.vertical, 4)
}

// Filtered foods
private var filteredFoods: [FoodItem] {
    var foods = foodDatabase.foodItems + foodDatabase.customFoodItems
    
    // Apply search filter
    if !searchText.isEmpty {
        foods = foods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    // Apply category filter
    if let category = selectedCategory {
        foods = foods.filter { $0.category == category }
    }
    
    return foods
}

// Recipes list
private var recipesList: some View {
    List {
        ForEach(recipeManager.recipes) { recipe in
            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.system(size: userSettings.textSize.size, weight: .medium))
                    
                    HStack {
                        Text("\(recipe.ingredients.count) ingredients")
                        Spacer()
                        Text("\(Int(recipe.totalNutritionalInfo.calories / Double(recipe.servings))) cal/serving")
                    }
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .onDelete { indexSet in
            for index in indexSet {
                recipeManager.deleteRecipe(recipeManager.recipes[index])
            }
        }
    }
}

// Add Food View
struct AddFoodView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var selectedCategory: FoodCategory = .other
    @State private var servingSize: Double = 100
    @State private var servingUnit = "g"
    @State private var nutritionalInfo = NutritionalInfo()
    @State private var notes = ""
    
    var onSave: (FoodItem) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details").font(.system(size: userSettings.textSize.size))) {
                    TextField("Food name", text: $name)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                    
                    HStack {
                        Text("Serving Size")
                        Spacer()
                        TextField("Size", value: $servingSize, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text(servingUnit)
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Nutritional Information").font(.system(size: userSettings.textSize.size))) {
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
                
                Section(header: Text("Notes").font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: saveFood) {
                        Text("Save Food")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(name.isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle(NSLocalizedString("Add Food", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    // Save food
    private func saveFood() {
        let newFood = FoodItem(
            id: UUID(),
            name: name,
            category: selectedCategory,
            nutritionalInfo: nutritionalInfo,
            servingSize: servingSize,
            servingUnit: servingUnit,
            isCustom: true,
            notes: notes.isEmpty ? nil : notes
        )
        
        onSave(newFood)
        presentationMode.wrappedValue.dismiss()
    }
} 