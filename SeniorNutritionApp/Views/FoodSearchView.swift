import SwiftUI

struct FoodSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    
    @ObservedObject var foodDatabase: FoodDatabaseService
    @Binding var selectedFood: FoodItem?
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    
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
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            categoryButton(category)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Food list
                List {
                    ForEach(filteredFoods) { food in
                        foodRow(food)
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
            }
            .padding(.vertical, 4)
        }
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
        
        return foods
    }
} 