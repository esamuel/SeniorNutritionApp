import SwiftUI

struct FoodDatabaseView: View {
    // MARK: - View Mode
    private enum ViewMode {
        case foods, recipes
    }
    
    // MARK: - Environment & State Objects
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var premiumManager: PremiumManager
    @StateObject private var foodDatabase = FoodDatabaseService()
    @StateObject private var recipeManager = RecipeManager.shared
    
    // MARK: - State
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var selectedCuisine: CuisineType?
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
                    
                    // Cuisine filter
                    cuisineFilter
                    
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
    
    // Cuisine filter
    private var cuisineFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(CuisineType.allCases, id: \.self) { cuisine in
                    cuisineButton(cuisine)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Cuisine button
    private func cuisineButton(_ cuisine: CuisineType) -> some View {
        Button(action: {
            selectedCuisine = selectedCuisine == cuisine ? nil : cuisine
        }) {
            Text(cuisine.localizedString)
                .font(.system(size: userSettings.textSize.size - 2))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(selectedCuisine == cuisine ? Color.blue : Color(.systemGray6))
                .foregroundColor(selectedCuisine == cuisine ? .white : .primary)
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
    
    // MARK: - Computed Properties
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
        
        // Apply cuisine filter
        if let cuisine = selectedCuisine {
            foods = foods.filter { $0.cuisineType == cuisine }
        }
        
        return foods
    }
    
    // MARK: - Views
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
}