import SwiftUI

struct FoodSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @ObservedObject var foodDatabase: FoodDatabaseService
    @Binding var selectedFood: FoodItem?
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var showingAllFoods = false
    
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
                
                // Food list
                if showingAllFoods || !searchText.isEmpty || selectedCategory != nil {
                    List {
                        ForEach(filteredFoods) { food in
                            foodRow(food)
                        }
                    }
                } else {
                    // Initial view - grouped food categories
                    List {
                        Group {
                            foodCategorySection(title: "Recent Selections", foods: Array(foodDatabase.foodItems.prefix(5)))
                            
                            foodCategorySection(title: "Fruits", 
                                                foods: foodDatabase.foodItems.filter { $0.category == .fruits }.prefix(5))
                            
                            foodCategorySection(title: "Vegetables", 
                                                foods: foodDatabase.foodItems.filter { $0.category == .vegetables }.prefix(5))
                            
                            foodCategorySection(title: "Protein", 
                                                foods: foodDatabase.foodItems.filter { $0.category == .protein }.prefix(5))
                            
                            foodCategorySection(title: "Dairy", 
                                                foods: foodDatabase.foodItems.filter { $0.category == .dairy }.prefix(5))
                        }
                        
                        Group {
                            foodCategorySection(title: "Grains", 
                                                foods: foodDatabase.foodItems.filter { $0.category == .grains }.prefix(5))
                            
                            foodCategorySection(title: "Beverages", 
                                                foods: foodDatabase.foodItems.filter { $0.category == .beverages }.prefix(5))
                            
                            foodCategorySection(title: "Snacks", 
                                                foods: foodDatabase.foodItems.filter { $0.category == .snacks }.prefix(5))
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
                            searchText = ""
                        }
                        .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
            .onAppear {
                // Ensure the database is loaded when view appears
                foodDatabase.loadFoodDatabase()
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
        
        return foods
    }
} 