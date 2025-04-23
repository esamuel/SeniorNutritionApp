import SwiftUI

struct AddMealView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var foodDatabase = FoodDatabaseService()
    
    @Binding var selectedMealType: MealType
    @State private var mealName: String = ""
    @State private var mealTime = Date()
    @State private var showingVoiceInput = false
    @State private var mealPortion: MealPortion = .medium
    @State private var nutritionalInfo = NutritionalInfo()
    @State private var notes: String = ""
    
    // Food search states
    @State private var searchText = ""
    @State private var selectedFood: FoodItem?
    @State private var showingFoodSearch = false
    
    var onSave: (Meal) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details").font(.system(size: userSettings.textSize.size))) {
                    HStack {
                        Text("Meal Type")
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        Picker("", selection: $selectedMealType) {
                            ForEach(MealType.allCases) { type in
                                HStack {
                                    Image(systemName: type.icon)
                                    Text(type.rawValue)
                                }
                                .tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.system(size: userSettings.textSize.size))
                    }
                    
                    HStack {
                        Text("Name")
                            .font(.system(size: userSettings.textSize.size))
                        
                        TextField("Meal name", text: $mealName)
                            .font(.system(size: userSettings.textSize.size))
                        
                        Button(action: {
                            showingVoiceInput = true
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        Text("Time")
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        DatePicker("", selection: $mealTime, displayedComponents: .hourAndMinute)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
                
                Section(header: Text("Food Selection").font(.system(size: userSettings.textSize.size))) {
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
                    
                    if let food = selectedFood {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(food.name)
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
                }
                
                Section(header: Text("Portion Size").font(.system(size: userSettings.textSize.size))) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Portion Size")
                            .font(.system(size: userSettings.textSize.size))
                        
                        HStack(spacing: 15) {
                            ForEach(MealPortion.allCases) { size in
                                portionSizeButton(size)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                if selectedFood == nil {
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
                }
                
                Section(header: Text("Notes").font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: saveMeal) {
                        Text("Save Meal")
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
            .navigationTitle("Add Meal")
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
            .onChange(of: selectedFood) { newFood in
                if let food = newFood {
                    mealName = food.name
                    nutritionalInfo = food.nutritionalInfo
                }
            }
            .onAppear {
                foodDatabase.loadFoodDatabase()
            }
        }
    }
    
    // Helper for portion size buttons
    private func portionSizeButton(_ size: MealPortion) -> some View {
        Button(action: {
            withAnimation {
                mealPortion = size
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(mealPortion == size ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: size == .small ? 40 : (size == .medium ? 55 : 70),
                               height: size == .small ? 40 : (size == .medium ? 55 : 70))
                    
                    if mealPortion == size {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 15, height: 15)
                    }
                }
                
                Text(size.rawValue)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(mealPortion == size ? .blue : .primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Save meal
    private func saveMeal() {
        let newMeal = Meal(
            name: mealName,
            type: selectedMealType,
            time: mealTime,
            portion: mealPortion,
            nutritionalInfo: nutritionalInfo,
            notes: notes.isEmpty ? nil : notes
        )
        
        onSave(newMeal)
        presentationMode.wrappedValue.dismiss()
    }
}

// Food Search View
struct FoodSearchView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var foodDatabase: FoodDatabaseService
    
    @Binding var selectedFood: FoodItem?
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var isSearching = false
    @State private var searchResults: [FoodItem] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search foods", text: $searchText)
                        .font(.system(size: userSettings.textSize.size))
                        .onChange(of: searchText) { newValue in
                            if !newValue.isEmpty {
                                searchResults = foodDatabase.searchFoods(query: newValue)
                                isSearching = true
                            } else {
                                searchResults = []
                                isSearching = false
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                            isSearching = false
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
                    if isSearching {
                        if searchResults.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No results found for '\(searchText)'")
                                    .font(.system(size: userSettings.textSize.size))
                                    .foregroundColor(.secondary)
                                Text("Try a different search term")
                                    .font(.system(size: userSettings.textSize.size - 2))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        } else {
                            ForEach(searchResults) { food in
                                foodRow(food)
                            }
                        }
                    } else {
                        ForEach(filteredFoods) { food in
                            foodRow(food)
                        }
                    }
                }
            }
            .navigationTitle("Search Foods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .onAppear {
                print("FoodSearchView appeared")
                print("Total foods in database: \(foodDatabase.foodItems.count)")
                print("Total custom foods: \(foodDatabase.customFoodItems.count)")
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
            presentationMode.wrappedValue.dismiss()
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
    }
    
    // Filtered foods
    private var filteredFoods: [FoodItem] {
        var foods = foodDatabase.foodItems + foodDatabase.customFoodItems
        
        // Apply category filter
        if let category = selectedCategory {
            foods = foods.filter { $0.category == category }
        }
        
        return foods
    }
} 