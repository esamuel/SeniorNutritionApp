import SwiftUI

struct NutritionView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @State private var showingAddMeal = false
    @State private var showingBarcodeScan = false
    @State private var showingVoiceInput = false
    @State private var selectedMealType: MealType = .breakfast
    @State private var meals: [Meal] = []
    
    enum MealType: String, CaseIterable, Identifiable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .breakfast: return "sunrise.fill"
            case .lunch: return "sun.max.fill"
            case .dinner: return "sunset.fill"
            case .snack: return "lightbulb.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .breakfast: return .orange
            case .lunch: return .yellow
            case .dinner: return .blue
            case .snack: return .green
            }
        }
    }
    
    var body: some View {
        NavigationView {
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
                    meals.append(newMeal)
                }
            }
            .onAppear {
                // Load sample meals if none exist
                if meals.isEmpty {
                    loadSampleMeals()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
            
            if todayMeals.isEmpty {
                emptyMealsView
            } else {
                ForEach(todayMeals) { meal in
                    mealRow(meal: meal)
                }
            }
        }
        .padding()
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
            
            if let protein = meal.nutritionInfo["protein"] {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(protein)g")
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                    
                    Text("Protein")
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // Common meals section
    private var commonMealsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick-Add Common Meals")
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(commonMeals) { meal in
                        commonMealCard(meal: meal)
                    }
                }
                .padding(.horizontal, 2)
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
            addMealNow(meal)
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
                
                if let protein = meal.nutritionInfo["protein"] {
                    Text("\(protein)g protein")
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
                
                Text("Tap to add")
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.blue)
            }
            .frame(width: 140, height: 170)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
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
    
    // Add meal now with current time
    private func addMealNow(_ meal: Meal) {
        var newMeal = meal
        newMeal.id = UUID()
        newMeal.time = Date()
        meals.append(newMeal)
    }
    
    // Computed property for today's meals
    private var todayMeals: [Meal] {
        meals.filter { Calendar.current.isDateInToday($0.time) }
            .sorted { $0.time > $1.time }
    }
    
    // Sample common meals
    private var commonMeals: [Meal] {
        [
            Meal(
                name: "Oatmeal with Berries",
                type: .breakfast,
                time: Date(),
                nutritionInfo: ["calories": 350, "protein": 12, "carbs": 55, "fat": 10]
            ),
            Meal(
                name: "Greek Yogurt with Nuts",
                type: .breakfast,
                time: Date(),
                nutritionInfo: ["calories": 250, "protein": 15, "carbs": 12, "fat": 15]
            ),
            Meal(
                name: "Grilled Chicken Salad",
                type: .lunch,
                time: Date(),
                nutritionInfo: ["calories": 400, "protein": 30, "carbs": 20, "fat": 18]
            ),
            Meal(
                name: "Salmon with Vegetables",
                type: .dinner,
                time: Date(),
                nutritionInfo: ["calories": 450, "protein": 35, "carbs": 15, "fat": 25]
            ),
            Meal(
                name: "Apple with Peanut Butter",
                type: .snack,
                time: Date(),
                nutritionInfo: ["calories": 220, "protein": 7, "carbs": 25, "fat": 12]
            )
        ]
    }
    
    // Time formatter
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    // Load sample meals
    private func loadSampleMeals() {
        // Create breakfast 3 hours ago
        let breakfastTime = Calendar.current.date(byAdding: .hour, value: -3, to: Date())!
        
        // Create yesterday's dinner
        var yesterdayComponents = DateComponents()
        yesterdayComponents.day = -1
        yesterdayComponents.hour = 18
        let yesterdayDinner = Calendar.current.date(from: yesterdayComponents)!
        
        meals = [
            Meal(
                name: "Oatmeal with Blueberries",
                type: .breakfast,
                time: breakfastTime,
                nutritionInfo: ["calories": 320, "protein": 10, "carbs": 50, "fat": 8]
            ),
            Meal(
                name: "Grilled Chicken with Steamed Vegetables",
                type: .dinner,
                time: yesterdayDinner,
                nutritionInfo: ["calories": 450, "protein": 35, "carbs": 25, "fat": 15]
            )
        ]
    }
}

// Meal structure
struct Meal: Identifiable {
    var id = UUID()
    var name: String
    var type: NutritionView.MealType
    var time: Date
    var nutritionInfo: [String: Int]
    var notes: String?
}

// Add Meal View
struct AddMealView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var selectedMealType: NutritionView.MealType
    @State private var mealName: String = ""
    @State private var mealTime = Date()
    @State private var showingVoiceInput = false
    @State private var mealPortionSize: PortionSize = .medium
    
    var onSave: (Meal) -> Void
    
    enum PortionSize: String, CaseIterable, Identifiable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        
        var id: String { self.rawValue }
        
        var calorieMultiplier: Double {
            switch self {
            case .small: return 0.75
            case .medium: return 1.0
            case .large: return 1.5
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details").font(.system(size: userSettings.textSize.size))) {
                    HStack {
                        Text("Meal Type")
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        Picker("", selection: $selectedMealType) {
                            ForEach(NutritionView.MealType.allCases) { type in
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
                
                Section(header: Text("Simple Portion Size").font(.system(size: userSettings.textSize.size))) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Portion Size")
                            .font(.system(size: userSettings.textSize.size))
                        
                        HStack(spacing: 15) {
                            ForEach(PortionSize.allCases) { size in
                                portionSizeButton(size)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Section(header: Text("Common Options").font(.system(size: userSettings.textSize.size))) {
                    commonMealButton("Oatmeal with Berries", icon: "circle.fill", color: .brown)
                    commonMealButton("Grilled Chicken Salad", icon: "leaf.fill", color: .green)
                    commonMealButton("Fish with Vegetables", icon: "fish.fill", color: .blue)
                    commonMealButton("Yogurt with Fruit", icon: "cup.and.saucer.fill", color: .purple)
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
        }
    }
    
    // Helper for portion size buttons
    private func portionSizeButton(_ size: PortionSize) -> some View {
        Button(action: {
            mealPortionSize = size
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(mealPortionSize == size ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: size == .small ? 40 : (size == .medium ? 55 : 70),
                               height: size == .small ? 40 : (size == .medium ? 55 : 70))
                    
                    if mealPortionSize == size {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 15, height: 15)
                    }
                }
                
                Text(size.rawValue)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(mealPortionSize == size ? .blue : .primary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // Helper for common meal buttons
    private func commonMealButton(_ name: String, icon: String, color: Color) -> some View {
        Button(action: {
            mealName = name
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(name)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                    .opacity(mealName == name ? 1 : 0)
            }
            .contentShape(Rectangle())
        }
    }
    
    // Save meal
    private func saveMeal() {
        // Calculate approximate nutrition based on portion size
        let baseCalories = 350
        let baseProtein = 20
        let baseCarbs = 30
        let baseFat = 15
        
        let calorieMultiplier = mealPortionSize.calorieMultiplier
        
        let newMeal = Meal(
            name: mealName,
            type: selectedMealType,
            time: mealTime,
            nutritionInfo: [
                "calories": Int(Double(baseCalories) * calorieMultiplier),
                "protein": Int(Double(baseProtein) * calorieMultiplier),
                "carbs": Int(Double(baseCarbs) * calorieMultiplier),
                "fat": Int(Double(baseFat) * calorieMultiplier)
            ]
        )
        
        onSave(newMeal)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView()
            .environmentObject(UserSettings())
    }
} 