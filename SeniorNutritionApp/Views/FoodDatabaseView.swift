import SwiftUI

struct FoodDatabaseView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var foodDatabase = FoodDatabaseService()
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var showingAddFood = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                searchBar
                
                // Category filter
                categoryFilter
                
                // Food list
                foodList
            }
            .navigationTitle("Food Database")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddFood = true
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView { newFood in
                    foodDatabase.addCustomFood(newFood)
                }
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
            Text(category.rawValue)
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
            foods = foods.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // Apply category filter
        if let category = selectedCategory {
            foods = foods.filter { $0.category == category }
        }
        
        return foods
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
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
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