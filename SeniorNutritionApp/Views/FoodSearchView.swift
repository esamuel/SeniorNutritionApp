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
    @State private var isTranslating = false
    @State private var refreshTrigger = UUID()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
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
                
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // All foods button
                        Button(action: {
                            selectedCategory = nil
                        }) {
                            Text("All")
                                .font(.system(size: userSettings.textSize.size - 2))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(selectedCategory == nil ? Color.blue : Color(.systemGray6))
                                .foregroundColor(selectedCategory == nil ? .white : .primary)
                                .cornerRadius(20)
                        }
                        
                        // Category buttons
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            categoryButton(category)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Cuisine filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // All cuisines button
                        Button(action: {
                            selectedCuisine = nil
                        }) {
                            Text(NSLocalizedString("All Cuisines", comment: ""))
                                .font(.system(size: userSettings.textSize.size - 2))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(selectedCuisine == nil ? Color.green : Color(.systemGray6))
                                .foregroundColor(selectedCuisine == nil ? .white : .primary)
                                .cornerRadius(20)
                        }
                        
                        // Cuisine buttons
                        ForEach(CuisineType.allCases, id: \.self) { cuisine in
                            cuisineButton(cuisine)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Food list
                if showingAllFoods || !searchText.isEmpty || selectedCategory != nil || selectedCuisine != nil {
                    List {
                        ForEach(filteredFoods) { food in
                            foodRow(food)
                        }
                    }
                } else if isTranslating {
                    // Show loading while translating
                    VStack {
                        ProgressView()
                        Text("Loading foods...")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Initial view - grouped food categories and cuisines
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
            }
            .id(refreshTrigger) // Force view refresh when trigger changes
            .navigationTitle("Search Foods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                if showingAllFoods {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Categories") {
                            showingAllFoods = false
                            selectedCategory = nil
                            selectedCuisine = nil
                            searchText = ""
                        }
                        .font(.system(size: userSettings.textSize.size))
                    }
                } else {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("🔄") {
                            // Manual translation trigger for debugging
                            Task { @MainActor in
                                print("DEBUG: Manual translation triggered")
                                await foodDatabase.translateCommonFoodsFirst(for: LanguageManager.shared.currentLanguage)
                                refreshTrigger = UUID()
                                foodDatabase.objectWillChange.send()
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Show loading state immediately
                isTranslating = true
                
                // Ensure the database is loaded when view appears
                foodDatabase.loadFoodDatabase()
                
                // Ensure food database is translated for current language BEFORE showing content
                Task { @MainActor in
                    await foodDatabase.checkAndTranslateIfNeeded()
                    
                    // Hide loading and show content with translated names
                    isTranslating = false
                    
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
            .onChange(of: LanguageManager.shared.currentLanguage) { _ in
                // When language changes, retranslate foods
                Task {
                    await foodDatabase.checkAndTranslateIfNeeded()
                }
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
    
    // Category button
    private func categoryButton(_ category: FoodCategory) -> some View {
        Button(action: {
            selectedCategory = selectedCategory == category ? nil : category
        }) {
            Text(category.rawValue)
                .font(.system(size: userSettings.textSize.size - 2))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(selectedCategory == category ? Color.blue : Color(.systemGray6))
                .foregroundColor(selectedCategory == category ? .white : .primary)
                .cornerRadius(20)
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
                        .onAppear {
                            // Debug: Print the food name and its translations
                            print("DEBUG: Displaying food '\(food.name)'")
                            print("DEBUG: Current language: \(LanguageManager.shared.currentLanguage)")
                            print("DEBUG: Hebrew name: \(food.nameHe ?? "nil")")
                            print("DEBUG: localizedName(): \(food.localizedName())")
                        }
                    
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
                // Search in all available languages
                let nameInEnglish = food.name.lowercased().contains(searchQuery)
                let nameInFrench = (food.nameFr ?? "").lowercased().contains(searchQuery)
                let nameInSpanish = (food.nameEs ?? "").lowercased().contains(searchQuery)
                let nameInHebrew = (food.nameHe ?? "").lowercased().contains(searchQuery)
                
                // Also search in localized notes if available
                let notesInEnglish = (food.notes ?? "").lowercased().contains(searchQuery)
                let notesInFrench = (food.notesFr ?? "").lowercased().contains(searchQuery)
                let notesInSpanish = (food.notesEs ?? "").lowercased().contains(searchQuery)
                let notesInHebrew = (food.notesHe ?? "").lowercased().contains(searchQuery)
                
                return nameInEnglish || nameInFrench || nameInSpanish || nameInHebrew ||
                       notesInEnglish || notesInFrench || notesInSpanish || notesInHebrew
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
} 