import SwiftUI

struct FoodSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @ObservedObject var foodDatabase: FoodDatabaseService
    @Binding var selectedFood: FoodItem?
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var selectedCuisine: CuisineType?
    @State private var showingAllFoods = false
    @State private var refreshTrigger = UUID()
    
    var body: some View {
        NavigationView {
            VStack {
                searchBarSection
                
                if showingAllFoods {
                    categoryFilterSection
                }
                
                contentSection
            }
            .id(refreshTrigger)
            .navigationTitle("Search Foods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarButtons
                }
            }
            .onAppear {
                setupOnAppear()
            }
            .onChange(of: LanguageManager.shared.currentLanguage) { _, _ in
                handleLanguageChange()
            }
        }
    }
    
    // MARK: - View Components
    
    private var searchBarSection: some View {
        VStack(spacing: 8) {
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
    }
    
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button(action: {
                    selectedCategory = nil
                    selectedCuisine = nil
                }) {
                    Text("All")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(selectedCategory == nil && selectedCuisine == nil ? Color.blue : Color(.systemGray6))
                        .foregroundColor(selectedCategory == nil && selectedCuisine == nil ? .white : .primary)
                        .cornerRadius(20)
                }
                
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category ? nil : category
                        selectedCuisine = nil
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
            }
            .padding(.horizontal)
        }
    }
    
    private var contentSection: some View {
        Group {
            if !searchText.isEmpty || showingAllFoods {
                searchResultsList
            } else {
                categorizedFoodsList
            }
        }
    }
    
    private var searchResultsList: some View {
        List(filteredFoods, id: \.id) { food in
            Button(action: {
                selectedFood = food
                dismiss()
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(food.localizedName())
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.primary)
                        
                        if let notes = food.localizedNotes(), !notes.isEmpty {
                            Text(notes)
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(food.nutritionalInfo.calories)) cal")
                            .font(.system(size: userSettings.textSize.size - 1, weight: .semibold))
                            .foregroundColor(.blue)
                        
                        Text(food.category.localizedString)
                            .font(.system(size: userSettings.textSize.size - 3))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var categorizedFoodsList: some View {
        List {
            Group {
                foodCategorySection(title: "Recent Selections", foods: Array(foodDatabase.foodItems.prefix(5)))
                
                // Cuisine sections
                foodCuisineSection(title: "Chinese", cuisine: .chinese)
                foodCuisineSection(title: "Russian", cuisine: .russian)
                foodCuisineSection(title: "Japanese", cuisine: .japanese)
                foodCuisineSection(title: "Italian", cuisine: .italian)
                foodCuisineSection(title: "Indian", cuisine: .indian)
            }
            
            Group {
                foodCuisineSection(title: "Mexican", cuisine: .mexican)
                foodCuisineSection(title: "Korean", cuisine: .korean)
                foodCuisineSection(title: "Middle Eastern", cuisine: .middleEastern)
                
                // Traditional category sections
                foodCategorySection(title: "Fruits", 
                                    foods: foodDatabase.foodItems.filter { $0.category == .fruits }.prefix(5))
                
                foodCategorySection(title: "Vegetables", 
                                    foods: foodDatabase.foodItems.filter { $0.category == .vegetables }.prefix(5))
            }
            
            Button(action: {
                showingAllFoods = true
            }) {
                Text("Show All Foods")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
        .font(.system(size: userSettings.textSize.size))
    }
    
    private var toolbarButtons: some View {
        HStack {
            if showingAllFoods {
                Button("Categories") {
                    showingAllFoods = false
                    selectedCategory = nil
                    selectedCuisine = nil
                    searchText = ""
                }
                .font(.system(size: userSettings.textSize.size))
            }
            
            // Clean refresh button like Food Database Browser
            Button(action: {
                performRefresh()
            }) {
                Text("🔄")
                    .font(.system(size: 20))
                    .padding(8)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupOnAppear() {
        // Ensure the database is loaded when view appears
        foodDatabase.loadFoodDatabase()
        
        // Ensure food database is translated for current language BEFORE showing content
        Task { @MainActor in
            await foodDatabase.checkAndTranslateIfNeeded()
            
            // Force multiple UI refreshes to ensure view updates
            foodDatabase.objectWillChange.send()
            refreshTrigger = UUID()
            
            // Add a small delay and force another refresh
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.foodDatabase.objectWillChange.send()
                self.refreshTrigger = UUID()
            }
        }
    }
    
    private func handleLanguageChange() {
        // When language changes, retranslate foods
        Task {
            await foodDatabase.checkAndTranslateIfNeeded()
        }
    }
    
    private func performRefresh() {
        // Same refresh mechanism as Food Database Browser
        Task {
            // Simple feedback
            #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            #endif
            
            // Translate all foods using the same method as Food Database Browser
            _ = await foodDatabase.translateAllFoodItems()
            
            // Update the foodDatabase to trigger UI refresh
            DispatchQueue.main.async {
                foodDatabase.objectWillChange.send()
                refreshTrigger = UUID()
            }
        }
    }
    
    // Food category section with see all button
    private func foodCategorySection(title: String, foods: some Collection<FoodItem>) -> some View {
        // Localize section titles
        let localizedTitle = NSLocalizedString(title, comment: "Food category section title")
        
        return Section(header: Text(localizedTitle)
            .font(.system(size: userSettings.textSize.size, weight: .bold))) {
            
            if foods.isEmpty {
                Text(NSLocalizedString("No foods in this category", comment: "Empty category message"))
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(Array(foods)) { food in
                    foodRow(food)
                }
                
                if title != "Recent Selections" {
                    Button(action: {
                        selectedCategory = foods.first?.category
                        showingAllFoods = true
                    }) {
                        Text(String(format: NSLocalizedString("See All %@", comment: "See all category button"), localizedTitle))
                            .font(.system(size: userSettings.textSize.size - 1))
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
            }
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
                .background(selectedCuisine == cuisine ? Color.green : Color(.systemGray6))
                .foregroundColor(selectedCuisine == cuisine ? .white : .primary)
                .cornerRadius(20)
        }
    }
    
    // Food cuisine section with see all button
    private func foodCuisineSection(title: String, cuisine: CuisineType) -> some View {
        let localizedTitle = NSLocalizedString(title, comment: "Cuisine section title")
        let cuisineFoods = foodDatabase.foodItems.filter { $0.cuisineType == cuisine }.prefix(5)
        
        return Section(header: Text(localizedTitle)
            .font(.system(size: userSettings.textSize.size, weight: .bold))) {
            
            if cuisineFoods.isEmpty {
                Text(NSLocalizedString("No foods in this cuisine", comment: "Empty cuisine message"))
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(Array(cuisineFoods)) { food in
                    foodRow(food)
                }
                
                Button(action: {
                    selectedCuisine = cuisine
                    showingAllFoods = true
                }) {
                    Text(String(format: NSLocalizedString("See All %@", comment: "See all cuisine button"), localizedTitle))
                        .font(.system(size: userSettings.textSize.size - 1))
                        .foregroundColor(.green)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // Food row
    private func foodRow(_ food: FoodItem) -> some View {
        Button(action: {
            selectedFood = food
            dismiss()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(food.localizedName())
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
            }
            .padding(.vertical, 4)
        }
    }
    
    // Filtered foods
    private var filteredFoods: [FoodItem] {
        var foods = foodDatabase.foodItems + foodDatabase.customFoodItems
        
        // Apply search filter
        if !searchText.isEmpty {
            let searchQuery = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            foods = foods.filter { food in
                return matchesSearchQuery(food: food, query: searchQuery)
            }
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
    
    // Helper function to break down complex search logic
    private func matchesSearchQuery(food: FoodItem, query: String) -> Bool {
        // Search in all available languages for names
        let nameMatches = food.name.lowercased().contains(query) ||
                         (food.nameFr ?? "").lowercased().contains(query) ||
                         (food.nameEs ?? "").lowercased().contains(query) ||
                         (food.nameHe ?? "").lowercased().contains(query)
        
        // Search in all available languages for notes
        let notesMatches = (food.notes ?? "").lowercased().contains(query) ||
                          (food.notesFr ?? "").lowercased().contains(query) ||
                          (food.notesEs ?? "").lowercased().contains(query) ||
                          (food.notesHe ?? "").lowercased().contains(query)
        
        return nameMatches || notesMatches
    }
} 