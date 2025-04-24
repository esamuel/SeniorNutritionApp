import SwiftUI

struct NutritionView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var mealManager = MealManager()
    @State private var showingAddMeal = false
    @State private var showingBarcodeScan = false
    @State private var showingVoiceInput = false
    @State private var selectedMealType: MealType = .breakfast
    @State private var selectedTab = 0
    @State private var mealToEdit: Meal?
    @State private var showingDeleteAlert = false
    @State private var mealToDelete: Meal?
    
    var body: some View {
        NavigationView {
            VStack {
                // Tab selector
                Picker("View", selection: $selectedTab) {
                    Text("Dashboard").tag(0)
                    Text("Meals").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content based on selected tab
                if selectedTab == 0 {
                    NutritionalDashboardView(mealManager: mealManager)
                } else {
                    mealsView
                }
            }
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMeal = true
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView(selectedMealType: $selectedMealType) { newMeal in
                    mealManager.addMeal(newMeal)
                }
            }
            .sheet(item: $mealToEdit) { meal in
                EditMealView(meal: meal) { updatedMeal in
                    mealManager.updateMeal(updatedMeal)
                }
            }
            .alert("Delete Meal", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let meal = mealToDelete {
                        mealManager.removeMeal(meal)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this meal?")
            }
            .onAppear {
                mealManager.loadMeals()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Meals view
    private var mealsView: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Quick add meal options
                quickAddSection
                
                // Today's meals
                todayMealsSection
                
                // Common meals
                commonMealsSection
                
                // Nutrition tips
                nutritionTipsSection
            }
            .padding()
        }
    }
    
    // Quick add meal section
    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Add")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            HStack(spacing: 15) {
                quickAddButton(
                    icon: "camera.fill",
                    title: "Take Photo",
                    action: {
                        // Action to take photo of meal
                    }
                )
                
                quickAddButton(
                    icon: "barcode.viewfinder",
                    title: "Scan Barcode",
                    action: {
                        showingBarcodeScan = true
                    }
                )
                
                quickAddButton(
                    icon: "mic.fill",
                    title: "Voice Add",
                    action: {
                        showingVoiceInput = true
                    }
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Helper for quick add buttons
    private func quickAddButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // Today's meals list view
    private var todayMealsList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(mealManager.mealsForDate(Date())) { meal in
                    mealRow(meal: meal)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                mealToDelete = meal
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                mealToEdit = meal
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.clear)
    }
    
    // Today's meals section
    private var todayMealsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Today's Meals")
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    showingAddMeal = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            if mealManager.mealsForDate(Date()).isEmpty {
                emptyMealsView
            } else {
                todayMealsList
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Empty meals view
    private var emptyMealsView: some View {
        VStack(spacing: 10) {
            Image(systemName: "fork.knife")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No meals logged today")
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingAddMeal = true
            }) {
                Text("Add First Meal")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    // Meal row for today's meals
    private func mealRow(meal: Meal) -> some View {
        Button(action: {
            mealToEdit = meal
        }) {
            HStack(spacing: 15) {
                Image(systemName: meal.type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(meal.type.color)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(meal.name)
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(meal.type.rawValue)
                            .font(.system(size: userSettings.textSize.size - 4))
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text(timeFormatter.string(from: meal.time))
                            .font(.system(size: userSettings.textSize.size - 4))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(meal.adjustedNutritionalInfo.calories))")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                    
                    Text("calories")
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Common meals section
    private var commonMealsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Common Meals")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(commonMeals) { meal in
                        commonMealCard(meal: meal)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Common meal card
    private func commonMealCard(meal: Meal) -> some View {
        Button(action: {
            var newMeal = meal
            newMeal.time = Date() // Set current time when adding the meal
            mealManager.addMeal(newMeal)
        }) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: meal.type.icon)
                    .font(.system(size: 30))
                    .foregroundColor(meal.type.color)
                    .frame(width: 50, height: 50)
                    .background(meal.type.color.opacity(0.2))
                    .cornerRadius(10)
                
                Text(meal.name)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text("\(Int(meal.adjustedNutritionalInfo.calories)) calories")
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.secondary)
                
                Text("Tap to add")
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.blue)
            }
            .frame(width: 140, height: 170)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                mealToDelete = meal
                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button {
                mealToEdit = meal
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
    }
    
    // Nutrition tips section
    private var nutritionTipsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Nutrition Tips for Seniors")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            nutritionTip(
                icon: "leaf.fill",
                title: "Protein is Important",
                description: "Try to include protein with every meal to maintain muscle mass."
            )
            
            nutritionTip(
                icon: "drop.fill",
                title: "Stay Hydrated",
                description: "Drink water regularly, even when not fasting."
            )
            
            nutritionTip(
                icon: "heart.fill",
                title: "Healthy Fats",
                description: "Include sources of healthy fats like olive oil, avocados, and nuts."
            )
            
            Button(action: {
                // Action to show more nutrition tips
            }) {
                Text("View More Tips")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    // Helper for nutrition tips
    private func nutritionTip(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: userSettings.textSize.size))
                
                Text(description)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 5)
    }
    
    // Sample common meals
    private var commonMeals: [Meal] {
        [
            Meal(
                name: "Oatmeal with Berries",
                type: .breakfast,
                nutritionalInfo: NutritionalInfo(
                    calories: 350,
                    protein: 12,
                    carbohydrates: 55,
                    fat: 10,
                    fiber: 8,
                    sugar: 15,
                    vitaminA: 0,
                    vitaminC: 30,
                    vitaminD: 0,
                    vitaminE: 0,
                    vitaminK: 0,
                    thiamin: 0,
                    riboflavin: 0,
                    niacin: 0,
                    vitaminB6: 0,
                    vitaminB12: 0,
                    folate: 0,
                    calcium: 200,
                    iron: 4,
                    magnesium: 0,
                    phosphorus: 0,
                    potassium: 0,
                    sodium: 0,
                    zinc: 0,
                    selenium: 0,
                    omega3: 0,
                    omega6: 0,
                    cholesterol: 0
                )
            ),
            Meal(
                name: "Greek Yogurt with Nuts",
                type: .breakfast,
                nutritionalInfo: NutritionalInfo(
                    calories: 250,
                    protein: 15,
                    carbohydrates: 12,
                    fat: 15,
                    fiber: 3,
                    sugar: 8,
                    vitaminA: 0,
                    vitaminC: 0,
                    vitaminD: 100,
                    vitaminE: 0,
                    vitaminK: 0,
                    thiamin: 0,
                    riboflavin: 0,
                    niacin: 0,
                    vitaminB6: 0,
                    vitaminB12: 0,
                    folate: 0,
                    calcium: 300,
                    iron: 0,
                    magnesium: 0,
                    phosphorus: 0,
                    potassium: 0,
                    sodium: 0,
                    zinc: 0,
                    selenium: 0,
                    omega3: 0,
                    omega6: 0,
                    cholesterol: 0
                )
            ),
            Meal(
                name: "Grilled Chicken Salad",
                type: .lunch,
                nutritionalInfo: NutritionalInfo(
                    calories: 400,
                    protein: 30,
                    carbohydrates: 20,
                    fat: 18,
                    fiber: 5,
                    sugar: 3,
                    vitaminA: 5000,
                    vitaminC: 45,
                    vitaminD: 0,
                    vitaminE: 0,
                    vitaminK: 0,
                    thiamin: 0,
                    riboflavin: 0,
                    niacin: 0,
                    vitaminB6: 0,
                    vitaminB12: 0,
                    folate: 0,
                    calcium: 150,
                    iron: 3,
                    magnesium: 0,
                    phosphorus: 0,
                    potassium: 0,
                    sodium: 0,
                    zinc: 0,
                    selenium: 0,
                    omega3: 0,
                    omega6: 0,
                    cholesterol: 0
                )
            ),
            Meal(
                name: "Salmon with Vegetables",
                type: .dinner,
                nutritionalInfo: NutritionalInfo(
                    calories: 450,
                    protein: 35,
                    carbohydrates: 15,
                    fat: 25,
                    fiber: 6,
                    sugar: 4,
                    vitaminA: 0,
                    vitaminC: 0,
                    vitaminD: 600,
                    vitaminE: 0,
                    vitaminK: 0,
                    thiamin: 0,
                    riboflavin: 0,
                    niacin: 0,
                    vitaminB6: 0,
                    vitaminB12: 0,
                    folate: 0,
                    calcium: 100,
                    iron: 2,
                    magnesium: 0,
                    phosphorus: 0,
                    potassium: 0,
                    sodium: 0,
                    zinc: 0,
                    selenium: 0,
                    omega3: 2.5,
                    omega6: 0,
                    cholesterol: 0
                )
            ),
            Meal(
                name: "Apple with Peanut Butter",
                type: .snack,
                nutritionalInfo: NutritionalInfo(
                    calories: 220,
                    protein: 7,
                    carbohydrates: 25,
                    fat: 12,
                    fiber: 4,
                    sugar: 18,
                    vitaminA: 0,
                    vitaminC: 8,
                    vitaminD: 0,
                    vitaminE: 0,
                    vitaminK: 0,
                    thiamin: 0,
                    riboflavin: 0,
                    niacin: 0,
                    vitaminB6: 0,
                    vitaminB12: 0,
                    folate: 0,
                    calcium: 50,
                    iron: 1,
                    magnesium: 0,
                    phosphorus: 0,
                    potassium: 0,
                    sodium: 0,
                    zinc: 0,
                    selenium: 0,
                    omega3: 0,
                    omega6: 0,
                    cholesterol: 0
                )
            )
        ]
    }
    
    // Time formatter
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

// Edit Meal View
struct EditMealView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    let meal: Meal
    let onSave: (Meal) -> Void
    
    @State private var mealName: String
    @State private var mealTime: Date
    @State private var mealType: MealType
    @State private var mealPortion: MealPortion
    @State private var nutritionalInfo: NutritionalInfo
    @State private var notes: String
    
    init(meal: Meal, onSave: @escaping (Meal) -> Void) {
        self.meal = meal
        self.onSave = onSave
        _mealName = State(initialValue: meal.name)
        _mealTime = State(initialValue: meal.time)
        _mealType = State(initialValue: meal.type)
        _mealPortion = State(initialValue: meal.portion)
        _nutritionalInfo = State(initialValue: meal.nutritionalInfo)
        _notes = State(initialValue: meal.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details").font(.system(size: userSettings.textSize.size))) {
                    TextField("Meal name", text: $mealName)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Picker("Meal Type", selection: $mealType) {
                        ForEach(MealType.allCases) { type in
                            HStack {
                                Image(systemName: type.icon)
                                    .foregroundColor(type.color)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                    
                    DatePicker("Time", selection: $mealTime, displayedComponents: .hourAndMinute)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Portion Size").font(.system(size: userSettings.textSize.size))) {
                    Picker("Portion", selection: $mealPortion) {
                        ForEach(MealPortion.allCases) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Notes").font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: saveMealChanges) {
                        Text("Save Changes")
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
            .navigationTitle("Edit Meal")
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
    
    private func saveMealChanges() {
        let updatedMeal = Meal(
            id: meal.id,
            name: mealName,
            type: mealType,
            time: mealTime,
            portion: mealPortion,
            nutritionalInfo: nutritionalInfo,
            notes: notes.isEmpty ? nil : notes
        )
        onSave(updatedMeal)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
            .environmentObject(UserSettings())
    }
} 