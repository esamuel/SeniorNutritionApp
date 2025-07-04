import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#endif
// UIKit is not needed if we're only using a notification feedback generator and Color system

// No need to import from SeniorNutritionApp as we're already inside the app target

struct FoodDatabaseBrowserView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var foodDatabase = FoodDatabaseService()
    @State private var searchText = ""
    @State private var selectedCategory: FoodCategory?
    @State private var selectedCuisine: CuisineType?
    @State private var showingFoodDetail = false
    @State private var selectedFood: FoodItem?
    @State private var showingAllCategories = true
    @State private var isSelectingFood = false  // Flag to prevent double tap issues
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                VStack(spacing: 8) {
                    // Quick language switcher
                    HStack(spacing: 8) {
                        Button(action: { changeLanguage("en") }) {
                            Text("🇺🇸")
                                .font(.system(size: 20))
                                .padding(8)
                                .background(LanguageManager.shared.currentLanguage == "en" ? Color.blue.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { changeLanguage("he") }) {
                            Text("🇮🇱")
                                .font(.system(size: 20))
                                .padding(8)
                                .background(LanguageManager.shared.currentLanguage == "he" ? Color.blue.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { changeLanguage("fr") }) {
                            Text("🇫🇷")
                                .font(.system(size: 20))
                                .padding(8)
                                .background(LanguageManager.shared.currentLanguage == "fr" ? Color.blue.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { changeLanguage("es") }) {
                            Text("🇪🇸")
                                .font(.system(size: 20))
                                .padding(8)
                                .background(LanguageManager.shared.currentLanguage == "es" ? Color.blue.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Trigger comprehensive translations when user taps the button
                            Task {
                                // Simple feedback without UIKit
                                #if os(iOS)
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                #endif
                                
                                // Translate all foods
                                _ = await foodDatabase.translateAllFoodItems()
                                
                                // Update the foodDatabase to trigger UI refresh
                                DispatchQueue.main.async {
                                    foodDatabase.objectWillChange.send()
                                }
                            }
                        }) {
                            Text("🔄")
                                .font(.system(size: 20))
                                .padding(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField(NSLocalizedString("Search foods", comment: ""), text: $searchText)
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
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
                }
                
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
                
                // Cuisine filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        cuisineButton(nil)
                        
                        ForEach(CuisineType.allCases, id: \.self) { cuisine in
                            cuisineButton(cuisine)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
                
                // Food count
                HStack {
                    Text("\(filteredFoods.count) \(NSLocalizedString("items", comment: ""))")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                    Spacer()
                    
                    Button(action: {
                        // Force refresh the database
                        foodDatabase.resetToDefaultFoods()
                    }) {
                        Label(NSLocalizedString("Refresh", comment: ""), systemImage: "arrow.clockwise")
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                }
                .padding(.horizontal)
                
                // Food list
                List {
                    ForEach(filteredFoods) { food in
                        Button(action: {
                            if !isSelectingFood {
                                isSelectingFood = true
                                selectedFood = food
                                print("Selected food: \(food.name)")
                                // Use a short timer to avoid state update race conditions
                                DispatchQueue.main.async {
                                    showingFoodDetail = true
                                    // Reset the flag after a short delay to prevent rapid tapping issues
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isSelectingFood = false
                                    }
                                }
                            }
                        }) {
                            foodRow(food)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle()) // Prevent button styling
                        .id(food.id) // Ensure each row has a unique identifier
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle(NSLocalizedString("Food Database", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Force refresh of language settings
                let currentLanguage = LanguageManager.shared.currentLanguage
                print("FoodDatabaseBrowserView appeared - current language: \(currentLanguage)")
                if #available(iOS 16.0, *) {
                    print("Current locale: \(Locale.current.language.languageCode?.identifier ?? "unknown")")
                } else {
                    print("Current locale: \(Locale.current.languageCode ?? "unknown")")
                }
                
                // Make sure language is applied
                Bundle.setLanguage(currentLanguage)
                LanguageManager.shared.forceRefreshLocalization()
                
                // Load food database
                foodDatabase.loadFoodDatabase()
                
                // Trigger translations when view appears
                Task {
                    // Delay slightly to ensure database is fully loaded
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                    print("Running food translations for language: \(currentLanguage)")
                    
                    // First fix notes translations specifically
                    await foodDatabase.fixNotesTranslations()
                    
                    // Force update to ensure UI reflects changes
                    DispatchQueue.main.async {
                        // This will trigger a view refresh
                        foodDatabase.objectWillChange.send()
                    }
                    
                    // In the background, translate all foods (comprehensive)
                    Task.detached {
                        _ = await foodDatabase.translateAllFoodItems()
                        
                        // Update UI again after comprehensive translation
                        DispatchQueue.main.async {
                            self.foodDatabase.objectWillChange.send()
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showingFoodDetail, onDismiss: {
                // Clear the selection when dismissed and reset the selecting flag
                DispatchQueue.main.async {
                    selectedFood = nil
                    isSelectingFood = false
                }
            }) {
                Group {
                    if let food = selectedFood {
                        FoodDetailView(food: food)
                            .environmentObject(userSettings)
                            .onAppear {
                                print("FoodDetailView appeared with food: \(food.name)")
                            }
                    } else {
                        // Improved error handling view
                        NavigationView {
                            VStack {
                                Text("No food details available")
                                    .font(.headline)
                                
                                Button("Return to Food List") {
                                    showingFoodDetail = false
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.top, 20)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                            .navigationTitle(NSLocalizedString("Error", comment: ""))
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(NSLocalizedString("Close", comment: "")) {
                                        showingFoodDetail = false
                                    }
                                }
                            }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .onAppear {
                            print("ERROR: Food detail view appeared with nil food")
                            // Auto-dismiss with a longer delay to prevent rapid state changes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                showingFoodDetail = false
                            }
                        }
                    }
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
            Text(category?.localizedString ?? NSLocalizedString("All", comment: ""))
                .font(.system(size: userSettings.textSize.size - 2))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background((showingAllCategories && category == nil) || selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor((showingAllCategories && category == nil) || selectedCategory == category ? .white : .primary)
                .cornerRadius(20)
        }
    }
    
    // Cuisine button
    private func cuisineButton(_ cuisine: CuisineType?) -> some View {
        Button(action: {
            selectedCuisine = cuisine
        }) {
            Text(cuisine?.localizedString ?? NSLocalizedString("All", comment: ""))
                .font(.system(size: userSettings.textSize.size - 2))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background((selectedCuisine == cuisine) ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor((selectedCuisine == cuisine) ? .white : .primary)
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
                Text("\(Int(food.nutritionalInfo.calories)) \(NSLocalizedString("cal", comment: ""))")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("\(Int(food.nutritionalInfo.protein))\(NSLocalizedString("g protein", comment: ""))")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                Text("•").foregroundColor(.secondary)
                Text("\(Int(food.nutritionalInfo.carbohydrates))\(NSLocalizedString("g carbs", comment: ""))")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
                Text("•").foregroundColor(.secondary)
                Text("\(Int(food.nutritionalInfo.fat))\(NSLocalizedString("g fat", comment: ""))")
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.secondary)
            }
            
            if food.category == .grains && food.name.lowercased().contains("pasta") {
                Text(NSLocalizedString("Pasta Dish", comment: ""))
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
            foods = foods.filter { food in
                // Get current language using updated API
                let currentLanguage: String
                if #available(iOS 16, *) {
                    currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
                } else {
                    // Fallback for older iOS versions
                    currentLanguage = Locale.current.languageCode ?? "en"
                }
                
                let nameToCheck: String
                
                switch currentLanguage {
                case "fr":
                    nameToCheck = food.nameFr ?? food.name
                case "es":
                    nameToCheck = food.nameEs ?? food.name
                case "he", "iw":
                    nameToCheck = food.nameHe ?? food.name
                default:
                    nameToCheck = food.name
                }
                
                // Check in all names (primary and translations)
                return nameToCheck.lowercased().contains(searchText.lowercased()) ||
                       food.name.lowercased().contains(searchText.lowercased()) ||
                       (food.nameFr?.lowercased().contains(searchText.lowercased()) ?? false) ||
                       (food.nameEs?.lowercased().contains(searchText.lowercased()) ?? false) ||
                       (food.nameHe?.lowercased().contains(searchText.lowercased()) ?? false)
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
        
        // Sort based on current language
        let currentLanguage: String
        if #available(iOS 16, *) {
            currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            // Fallback for older iOS versions
            currentLanguage = Locale.current.languageCode ?? "en"
        }
        
        return foods.sorted { food1, food2 in
            switch currentLanguage {
            case "fr":
                return (food1.nameFr ?? food1.name) < (food2.nameFr ?? food2.name)
            case "es":
                return (food1.nameEs ?? food1.name) < (food2.nameEs ?? food2.name)
            case "he", "iw":
                return (food1.nameHe ?? food1.name) < (food2.nameHe ?? food2.name)
            default:
                return food1.name < food2.name
            }
        }
    }
    
    private func changeLanguage(_ code: String) {
        print("Changing language to: \(code)")
        LanguageManager.shared.setLanguage(code)
        
        // Clear any translation caches
        UserDefaults.standard.removeObject(forKey: "translationCache")
        
        // Reload food database and retranslate items after a brief delay to allow language change to take effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Force reset the database to ensure we're not using cached data
            self.foodDatabase.resetToDefaultFoods()
            
            Task {
                // First translate visible foods for quick UI update
                await self.foodDatabase.forceTranslateVisibleFoods()
                
                // Also fix notes translations
                await self.foodDatabase.fixNotesTranslations()
                
                // Force UI refresh
                DispatchQueue.main.async {
                    self.foodDatabase.objectWillChange.send()
                }
                
                // Then translate all foods in the background
                Task.detached {
                                            _ = await self.foodDatabase.translateAllFoodItems()
                    
                    // Force another UI refresh after all translations are done
                    DispatchQueue.main.async {
                        self.foodDatabase.objectWillChange.send()
                    }
                }
            }
        }
    }
}

struct FoodDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    let food: FoodItem
    @State private var isLoading = true
    @State private var canDismiss = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                        Text("Loading food details...")
                            .padding(.top, 20)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Header
                            VStack(alignment: .leading, spacing: 8) {
                                Text(food.localizedName())
                                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                                
                                Text(NSLocalizedString("Category", comment: "") + ": \(food.category.localizedString)")
                                    .font(.system(size: userSettings.textSize.size))
                                    .foregroundColor(.secondary)
                                
                                Text(NSLocalizedString("Serving Size", comment: "") + ": \(Int(food.servingSize))\(food.servingUnit)")
                                    .font(.system(size: userSettings.textSize.size))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            
                            // Macronutrients
                            VStack(alignment: .leading, spacing: 12) {
                                Text(NSLocalizedString("Macronutrients", comment: ""))
                                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                
                                HStack {
                                    macroNutrientView(
                                        title: NSLocalizedString("Calories", comment: ""),
                                        value: "\(Int(food.nutritionalInfo.calories))",
                                        unit: "kcal",
                                        color: .red
                                    )
                                    
                                    Spacer()
                                    
                                    macroNutrientView(
                                        title: NSLocalizedString("Protein", comment: ""),
                                        value: "\(Int(food.nutritionalInfo.protein))",
                                        unit: "g",
                                        color: .blue
                                    )
                                    
                                    Spacer()
                                    
                                    macroNutrientView(
                                        title: NSLocalizedString("Carbs", comment: ""),
                                        value: "\(Int(food.nutritionalInfo.carbohydrates))",
                                        unit: "g",
                                        color: .green
                                    )
                                    
                                    Spacer()
                                    
                                    macroNutrientView(
                                        title: NSLocalizedString("Fat", comment: ""),
                                        value: "\(Int(food.nutritionalInfo.fat))",
                                        unit: "g", 
                                        color: .yellow
                                    )
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            
                            // Additional nutrients
                            VStack(alignment: .leading, spacing: 12) {
                                Text(NSLocalizedString("Additional Nutrients", comment: ""))
                                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                
                                nutrientRow(name: NSLocalizedString("Fiber", comment: ""), value: food.nutritionalInfo.fiber, unit: "g")
                                nutrientRow(name: NSLocalizedString("Sugar", comment: ""), value: food.nutritionalInfo.sugar, unit: "g")
                                nutrientRow(name: NSLocalizedString("Sodium", comment: ""), value: food.nutritionalInfo.sodium, unit: "mg")
                                
                                if food.nutritionalInfo.vitaminA > 0 {
                                    nutrientRow(name: NSLocalizedString("Vitamin A", comment: ""), value: food.nutritionalInfo.vitaminA, unit: "IU")
                                }
                                
                                if food.nutritionalInfo.vitaminC > 0 {
                                    nutrientRow(name: NSLocalizedString("Vitamin C", comment: ""), value: food.nutritionalInfo.vitaminC, unit: "mg")
                                }
                                
                                if food.nutritionalInfo.calcium > 0 {
                                    nutrientRow(name: NSLocalizedString("Calcium", comment: ""), value: food.nutritionalInfo.calcium, unit: "mg")
                                }
                                
                                if food.nutritionalInfo.iron > 0 {
                                    nutrientRow(name: NSLocalizedString("Iron", comment: ""), value: food.nutritionalInfo.iron, unit: "mg")
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            
                            // Notes
                            if let notes = food.localizedNotes(), !notes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(NSLocalizedString("Notes", comment: "Food item notes"))
                                        .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                                    Text(notes)
                                        .font(.system(size: userSettings.textSize.size))
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Food Details", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "")) {
                        if canDismiss {
                            dismiss()
                        }
                    }
                    .disabled(!canDismiss)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            print("FoodDetailView onAppear: Loading food \(food.name)")
            // Prevent immediate dismissal by adding a delay before allowing dismissal
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                canDismiss = true
            }
            
            // Small delay to ensure view is ready to display content
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Force language refresh for this view
                LanguageManager.shared.forceRefreshLocalization()
                isLoading = false
                print("FoodDetailView finished loading: \(food.name)")
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
