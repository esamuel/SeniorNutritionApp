import SwiftUI

struct FoodDatabaseBrowserView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var foodDatabase = FoodDatabaseService()
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var showingFoodDetail = false
    @State private var selectedFood: FoodItem?
    @State private var showingAllCategories = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
                .padding(.top)
                
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        categoryButton(nil)
                        
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            categoryButton(category)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Food count
                HStack {
                    Text("\(filteredFoods.count) items")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                    Spacer()
                    
                    Button(action: {
                        // Force refresh the database
                        foodDatabase.resetToDefaultFoods()
                    }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
                .padding(.horizontal)
                
                // Food list
                List {
                    ForEach(filteredFoods) { food in
                        foodRow(food)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedFood = food
                                showingFoodDetail = true
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Food Database")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                foodDatabase.loadFoodDatabase()
            }
            .sheet(isPresented: $showingFoodDetail) {
                if let food = selectedFood {
                    FoodDetailView(food: food)
                }
            }
        }
    }
    
    // Category button
    private func categoryButton(_ category: FoodCategory?) -> some View {
        Button(action: {
            selectedCategory = category
            showingAllCategories = category == nil
        }) {
            Text(category?.rawValue ?? "All")
                .font(.system(size: userSettings.textSize.size - 2))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background((showingAllCategories && category == nil) || selectedCategory == category ? Color.blue : Color(.systemGray6))
                .foregroundColor((showingAllCategories && category == nil) || selectedCategory == category ? .white : .primary)
                .cornerRadius(20)
        }
    }
    
    // Food row
    private func foodRow(_ food: FoodItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(food.localizedName())
                    .font(.system(size: userSettings.textSize.size, weight: .medium))
                    .fixedSize(horizontal: false, vertical: true)
                
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
            
            if food.category == .grains && food.name.lowercased().contains("pasta") {
                Text("Pasta Dish")
                    .font(.system(size: userSettings.textSize.size - 3))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.2))
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
            foods = foods.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // Apply category filter
        if let category = selectedCategory {
            foods = foods.filter { $0.category == category }
        }
        
        return foods.sorted { $0.name < $1.name }
    }
}

struct FoodDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    let food: FoodItem
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(food.localizedName())
                            .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                        
                        Text("Category: \(food.category.rawValue)")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                        
                        Text("Serving Size: \(Int(food.servingSize))\(food.servingUnit)")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Macronutrients
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Macronutrients")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        HStack {
                            macroNutrientView(
                                title: "Calories",
                                value: "\(Int(food.nutritionalInfo.calories))",
                                unit: "kcal",
                                color: .red
                            )
                            
                            Spacer()
                            
                            macroNutrientView(
                                title: "Protein",
                                value: "\(Int(food.nutritionalInfo.protein))",
                                unit: "g",
                                color: .blue
                            )
                            
                            Spacer()
                            
                            macroNutrientView(
                                title: "Carbs",
                                value: "\(Int(food.nutritionalInfo.carbohydrates))",
                                unit: "g",
                                color: .green
                            )
                            
                            Spacer()
                            
                            macroNutrientView(
                                title: "Fat",
                                value: "\(Int(food.nutritionalInfo.fat))",
                                unit: "g",
                                color: .yellow
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Additional nutrients
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Additional Nutrients")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        nutrientRow(name: "Fiber", value: food.nutritionalInfo.fiber, unit: "g")
                        nutrientRow(name: "Sugar", value: food.nutritionalInfo.sugar, unit: "g")
                        nutrientRow(name: "Sodium", value: food.nutritionalInfo.sodium, unit: "mg")
                        
                        if food.nutritionalInfo.vitaminA > 0 {
                            nutrientRow(name: "Vitamin A", value: food.nutritionalInfo.vitaminA, unit: "IU")
                        }
                        
                        if food.nutritionalInfo.vitaminC > 0 {
                            nutrientRow(name: "Vitamin C", value: food.nutritionalInfo.vitaminC, unit: "mg")
                        }
                        
                        if food.nutritionalInfo.calcium > 0 {
                            nutrientRow(name: "Calcium", value: food.nutritionalInfo.calcium, unit: "mg")
                        }
                        
                        if food.nutritionalInfo.iron > 0 {
                            nutrientRow(name: "Iron", value: food.nutritionalInfo.iron, unit: "mg")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Notes
                    if let notes = food.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                            
                            Text(notes)
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Food Details", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func macroNutrientView(title: String, value: String, unit: String, color: Color) -> some View {
        VStack {
            Text(title)
                .font(.system(size: userSettings.textSize.size - 1))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                .foregroundColor(color)
            
            Text(unit)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
        }
        .frame(width: 70)
    }
    
    private func nutrientRow(name: String, value: Double, unit: String) -> some View {
        HStack {
            Text(name)
                .font(.system(size: userSettings.textSize.size))
            
            Spacer()
            
            Text("\(Int(value)) \(unit)")
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
        }
    }
}
