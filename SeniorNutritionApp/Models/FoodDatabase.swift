import Foundation

// MARK: - Cuisine Type
enum CuisineType: String, Codable, CaseIterable {
    case general = "General"
    case chinese = "Chinese"
    case russian = "Russian"
    case middleEastern = "Middle Eastern"
    case korean = "Korean"
    case japanese = "Japanese"
    case indian = "Indian"
    case mexican = "Mexican"
    case italian = "Italian"
    
    // Get localized cuisine name
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "Cuisine type")
    }
}

// MARK: - Food Item
struct FoodItem: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var category: FoodCategory
    var cuisineType: CuisineType
    var nutritionalInfo: NutritionalInfo
    var servingSize: Double // in grams
    var servingUnit: String // e.g., "g", "oz", "cup"
    var isCustom: Bool
    var notes: String?
    var nameFr: String?
    var nameEs: String?
    var nameHe: String?
    var notesFr: String?
    var notesEs: String?
    var notesHe: String?
    
    // Default initializer with general cuisine type for backward compatibility
    init(id: UUID = UUID(), name: String, category: FoodCategory, cuisineType: CuisineType = .general, nutritionalInfo: NutritionalInfo, servingSize: Double, servingUnit: String, isCustom: Bool = false, notes: String? = nil, nameFr: String? = nil, nameEs: String? = nil, nameHe: String? = nil, notesFr: String? = nil, notesEs: String? = nil, notesHe: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.cuisineType = cuisineType
        self.nutritionalInfo = nutritionalInfo
        self.servingSize = servingSize
        self.servingUnit = servingUnit
        self.isCustom = isCustom
        self.notes = notes
        self.nameFr = nameFr
        self.nameEs = nameEs
        self.nameHe = nameHe
        self.notesFr = notesFr
        self.notesEs = notesEs
        self.notesHe = notesHe
    }
    
    // Computed property for nutritional info per 100g
    var nutritionalInfoPer100g: NutritionalInfo {
        let multiplier = 100.0 / servingSize
        return NutritionalInfo(
            calories: nutritionalInfo.calories * multiplier,
            protein: nutritionalInfo.protein * multiplier,
            carbohydrates: nutritionalInfo.carbohydrates * multiplier,
            fat: nutritionalInfo.fat * multiplier,
            fiber: nutritionalInfo.fiber * multiplier,
            sugar: nutritionalInfo.sugar * multiplier,
            vitaminA: nutritionalInfo.vitaminA * multiplier,
            vitaminC: nutritionalInfo.vitaminC * multiplier,
            vitaminD: nutritionalInfo.vitaminD * multiplier,
            vitaminE: nutritionalInfo.vitaminE * multiplier,
            vitaminK: nutritionalInfo.vitaminK * multiplier,
            thiamin: nutritionalInfo.thiamin * multiplier,
            riboflavin: nutritionalInfo.riboflavin * multiplier,
            niacin: nutritionalInfo.niacin * multiplier,
            vitaminB6: nutritionalInfo.vitaminB6 * multiplier,
            vitaminB12: nutritionalInfo.vitaminB12 * multiplier,
            folate: nutritionalInfo.folate * multiplier,
            calcium: nutritionalInfo.calcium * multiplier,
            iron: nutritionalInfo.iron * multiplier,
            magnesium: nutritionalInfo.magnesium * multiplier,
            phosphorus: nutritionalInfo.phosphorus * multiplier,
            potassium: nutritionalInfo.potassium * multiplier,
            sodium: nutritionalInfo.sodium * multiplier,
            zinc: nutritionalInfo.zinc * multiplier,
            selenium: nutritionalInfo.selenium * multiplier,
            omega3: nutritionalInfo.omega3 * multiplier,
            omega6: nutritionalInfo.omega6 * multiplier,
            cholesterol: nutritionalInfo.cholesterol * multiplier
        )
    }
    
    // Equatable conformance
    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.category == rhs.category &&
        lhs.cuisineType == rhs.cuisineType &&
        lhs.nutritionalInfo == rhs.nutritionalInfo &&
        lhs.servingSize == rhs.servingSize &&
        lhs.servingUnit == rhs.servingUnit &&
        lhs.isCustom == rhs.isCustom &&
        lhs.notes == rhs.notes
    }
    
    // Return localized name based on current language.
    func localizedName() -> String {
        switch LanguageManager.shared.currentLanguage {
        case "he": return nameHe ?? name
        case "fr": return nameFr ?? name
        case "es": return nameEs ?? name
        default:   return name
        }
    }
    
    // Return localized notes based on current language
    func localizedNotes() -> String? {
        switch LanguageManager.shared.currentLanguage {
        case "he": return notesHe ?? notes
        case "fr": return notesFr ?? notes
        case "es": return notesEs ?? notes
        default:   return notes
        }
    }
}

// MARK: - Food Category
enum FoodCategory: String, Codable, CaseIterable {
    case grains = "Grains"
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case protein = "Protein"
    case dairy = "Dairy"
    case fats = "Fats"
    case beverages = "Beverages"
    case snacks = "Snacks"
    case other = "Other"
    // Single category for all stuffed dishes
    case stuffedDishes = "Stuffed Dishes"
    // Adding seeds category
    case seeds = "Seeds"
    // Adding condiments category
    case condiments = "Condiments / Spreads"
    case fishMeals = "Fish Meal"
    
    // Get localized category name
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "Food category")
    }
}

// MARK: - Food Database Service
class FoodDatabaseService: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var customFoodItems: [FoodItem] = []
    @Published var lastTranslatedLanguage: String? = nil
    
    init() {
        // Load basic database first for faster startup
        loadFoodDatabase()
        
        // Temporarily disable background operations to prevent freezing
        // TODO: Re-enable when performance issues are resolved
        print("FoodDatabase: Initialized with basic data only")
    }
    
    @MainActor
    private func performBackgroundInitialization() async {
        // IMPORTANT: Force a complete database reset to apply category changes (only if needed)
        let shouldReset = UserDefaults.standard.bool(forKey: "needsDatabaseReset")
        if shouldReset {
            print("\n=== CATEGORY CONSOLIDATION: Forcing complete database reset ===")
            UserDefaults.standard.removeObject(forKey: "savedFoods")
            UserDefaults.standard.removeObject(forKey: "savedCustomFoods")
            UserDefaults.standard.set(false, forKey: "needsDatabaseReset")
            
            // Force reset the database to include new foods
            resetToDefaultFoods()
        }
        
        // Check translations in background
        await self.checkAndTranslateIfNeeded()
    }
    
    // Populate translations for default foods if missing
    @MainActor
    private func populateTranslationsIfNeeded() async {
        let langCodes = ["fr", "es", "he"]
        var updated = false
        print("=== Starting food translations ===")
        for idx in foodItems.indices {
            for lang in langCodes {
                switch lang {
                case "fr":
                    // Always update translations to ensure they're complete
                    let t = await TranslationManager.shared.translated(foodItems[idx].name, target: lang)
                    foodItems[idx].nameFr = t
                    
                    // Also translate notes if present
                    if let notes = foodItems[idx].notes, notes.isEmpty == false {
                        let translatedNotes = await TranslationManager.shared.translated(notes, target: lang)
                        foodItems[idx].notesFr = translatedNotes
                        print("Translated notes for '\(foodItems[idx].name)' to French")
                    }
                    
                    updated = true
                    print("Translated '\(foodItems[idx].name)' to French: '\(t)'")
                case "es":
                    // Always update translations to ensure they're complete
                    let t = await TranslationManager.shared.translated(foodItems[idx].name, target: lang)
                    foodItems[idx].nameEs = t
                    
                    // Also translate notes if present
                    if let notes = foodItems[idx].notes, notes.isEmpty == false {
                        let translatedNotes = await TranslationManager.shared.translated(notes, target: lang)
                        foodItems[idx].notesEs = translatedNotes
                        print("Translated notes for '\(foodItems[idx].name)' to Spanish")
                    }
                    
                    updated = true
                    print("Translated '\(foodItems[idx].name)' to Spanish: '\(t)'")
                case "he":
                    // Always update translations to ensure they're complete
                    let t = await TranslationManager.shared.translated(foodItems[idx].name, target: lang)
                    foodItems[idx].nameHe = t
                    
                    // Also translate notes if present
                    if let notes = foodItems[idx].notes, notes.isEmpty == false {
                        let translatedNotes = await TranslationManager.shared.translated(notes, target: lang)
                        foodItems[idx].notesHe = translatedNotes
                        print("Translated notes for '\(foodItems[idx].name)' to Hebrew")
                    }
                    
                    updated = true
                    print("Translated '\(foodItems[idx].name)' to Hebrew: '\(t)'")
                default:
                    break
                }
            }
        }
        if updated {
            // persist
            if let encoded = try? JSONEncoder().encode(foodItems) {
                UserDefaults.standard.set(encoded, forKey: "savedFoods")
                print("=== Food translations completed and saved ===")
            }
        }
    }
    
    // Add this new method to reset the database
    func resetToDefaultFoods() {
        print("\n=== Resetting food database to defaults ===")
        // Remove saved foods from UserDefaults
        UserDefaults.standard.removeObject(forKey: "savedFoods")
        UserDefaults.standard.removeObject(forKey: "savedCustomFoods")
        
        // Reload the database
        loadFoodDatabase()
        print("=== Reset complete ===\n")
    }
    
    // Load food database
    func loadFoodDatabase() {
        print("\n=== Starting to load food database ===")
        
        // Load all foods from all food item files
        var allFoods = SampleFoodData.foods + NewFoodItems.foods + AdditionalFoodItems.foods + DairyFoodItems.foods + BeverageFoodItems.foods + SnackFoodItems.foods + FruitFoodItems.foods + PastaFoodItems.foods + CakeFoodItems.foods + BreadAndSandwichFoodItems.foods + StuffedDishFoodItems.foods + SeedFoodItems.foods + CondimentFoodItems.foods + FishMealItems.foods + GrainDishItems.foods + ItalianCuisineItems.foods + VegetableFoodItems.foods + MexicanCuisineFoodItems.foods + IndianCuisineFoodItems.foods + ChineseCuisineFoodItems.foods + JapaneseCuisineFoodItems.foods + KoreanCuisineFoodItems.foods + MiddleEasternCuisineFoodItems.foods + RussianCuisineFoodItems.foods
        
        print("\nInitial food count: \(allFoods.count)")
        print("\nAvailable foods:")
        for food in allFoods {
            print("- \(food.name) (\(food.category.rawValue))")
        }
        
        // Remove duplicates based on food names (case-insensitive)
        var seenNames = Set<String>()
        allFoods = allFoods.filter { food in
            let lowercaseName = food.name.lowercased()
            let isNew = !seenNames.contains(lowercaseName)
            if isNew {
                seenNames.insert(lowercaseName)
            } else {
                print("Removing duplicate: \(food.name)")
            }
            return isNew
        }
        
        print("\nAfter removing duplicates: \(allFoods.count) foods")
        
        // Load from local storage
        if let savedFoods = UserDefaults.standard.data(forKey: "savedFoods"),
           let decodedFoods = try? JSONDecoder().decode([FoodItem].self, from: savedFoods) {
            print("\nFound saved foods in storage")
            foodItems = decodedFoods
            print("Loaded \(foodItems.count) foods from storage")
        } else {
            print("\nNo saved foods found in storage, using default foods")
            foodItems = allFoods
            // Save default foods
            if let encoded = try? JSONEncoder().encode(foodItems) {
                UserDefaults.standard.set(encoded, forKey: "savedFoods")
                print("Saved default foods to storage")
            }
        }
        
        // Load custom foods and remove any duplicates with main database
        if let savedCustomFoods = UserDefaults.standard.data(forKey: "savedCustomFoods"),
           let decodedCustomFoods = try? JSONDecoder().decode([FoodItem].self, from: savedCustomFoods) {
            print("\nFound saved custom foods in storage")
            // Filter out any custom foods that might duplicate main database entries
            customFoodItems = decodedCustomFoods.filter { customFood in
                let lowercaseName = customFood.name.lowercased()
                return !foodItems.contains { $0.name.lowercased() == lowercaseName }
            }
            print("Loaded \(customFoodItems.count) unique custom foods from storage")
        } else {
            print("\nNo saved custom foods found in storage")
        }
        
        // Print all available foods for debugging
        print("\n=== All available foods ===")
        for food in foodItems {
            print("- \(food.name) (Category: \(food.category.rawValue))")
        }
        print("\n=== All custom foods ===")
        for food in customFoodItems {
            print("- \(food.name) (Category: \(food.category.rawValue))")
        }
        print("\n=== Food database loading complete ===")
        
        // After loading, check if translation is needed
        Task {
            await self.checkAndTranslateIfNeeded()
        }
    }
    
    // Comprehensive method to translate all foods in the database
    @MainActor
    func translateAllFoodItems() async -> Int {
        print("\n=== STARTING COMPREHENSIVE FOOD TRANSLATION ===")
        let langCodes = ["fr", "es", "he"]
        var translatedCount = 0
        
        print("Total foods to process: \(foodItems.count)")
        
        // Dictionary of known translations for exact matches only
        let knownTranslations: [String: [String: String]] = [
            "Milk": ["fr": "Lait", "es": "Leche", "he": "חלב"],
            "Cheese": ["fr": "Fromage", "es": "Queso", "he": "גבינה"],
            "Yogurt": ["fr": "Yaourt", "es": "Yogur", "he": "יוגורט"],
            "Salmon": ["fr": "Saumon", "es": "Salmón", "he": "סלמון"],
            // ... add more as needed ...
        ]
        
        for idx in foodItems.indices {
            let foodName = foodItems[idx].name
            print("\nProcessing [\(idx+1)/\(foodItems.count)]: \(foodName)")
            var wasTranslated = false
            
            // Use dictionary only for exact matches
            if let knownTrans = knownTranslations[foodName] {
                foodItems[idx].nameFr = knownTrans["fr"]
                foodItems[idx].nameEs = knownTrans["es"]
                foodItems[idx].nameHe = knownTrans["he"]
                wasTranslated = true
                print("Applied direct translation for: \(foodItems[idx].name)")
            }
            
            // If not an exact match, always translate the full name
            if !wasTranslated {
                for lang in langCodes {
                    switch lang {
                    case "fr":
                        let t = await TranslationManager.shared.translated(foodName, target: lang)
                        foodItems[idx].nameFr = t
                        print("Translated to French: \(t)")
                    case "es":
                        let t = await TranslationManager.shared.translated(foodName, target: lang)
                        foodItems[idx].nameEs = t
                        print("Translated to Spanish: \(t)")
                    case "he":
                        let t = await TranslationManager.shared.translated(foodName, target: lang)
                        foodItems[idx].nameHe = t
                        print("Translated to Hebrew: \(t)")
                    default:
                        break
                    }
                }
            }
            
            // Now handle notes translations
            if let notes = foodItems[idx].notes, notes.isEmpty == false {
                print("Processing notes for: \(foodName)")
                
                // Check if we have known translations for these notes
                var notesTranslated = false
                for (key, trans) in knownTranslations {
                    if notes.contains(key) {
                        print("Found known notes translation: \(key)")
                        foodItems[idx].notesFr = trans["fr"]
                        foodItems[idx].notesEs = trans["es"]
                        foodItems[idx].notesHe = trans["he"]
                        notesTranslated = true
                        break
                    }
                }
                
                // If no known translation, use the API
                if !notesTranslated {
                    for lang in langCodes {
                        switch lang {
                        case "fr":
                            if foodItems[idx].notesFr == nil || foodItems[idx].notesFr?.isEmpty == true {
                                let t = await TranslationManager.shared.translated(notes, target: lang)
                                foodItems[idx].notesFr = t
                            }
                        case "es":
                            if foodItems[idx].notesEs == nil || foodItems[idx].notesEs?.isEmpty == true {
                                let t = await TranslationManager.shared.translated(notes, target: lang)
                                foodItems[idx].notesEs = t
                            }
                        case "he":
                            if foodItems[idx].notesHe == nil || foodItems[idx].notesHe?.isEmpty == true {
                                let t = await TranslationManager.shared.translated(notes, target: lang)
                                foodItems[idx].notesHe = t
                            }
                        default:
                            break
                        }
                    }
                }
            }
            
            translatedCount += 1
        }
        
        // Save all translated foods to UserDefaults
        if let encoded = try? JSONEncoder().encode(foodItems) {
            UserDefaults.standard.set(encoded, forKey: "savedFoods")
            print("\n=== Saved \(translatedCount) translated foods to UserDefaults ===")
        }
        
        print("=== COMPREHENSIVE FOOD TRANSLATION COMPLETED ===\n")
        return translatedCount
    }
    
    // Add custom food with automatic translation
    func addCustomFood(_ food: FoodItem) async {
        var newFood = food
        
        // Generate translations for the new food
        if newFood.nameFr == nil || newFood.nameFr?.isEmpty == true {
            newFood.nameFr = await TranslationManager.shared.translated(food.name, target: "fr")
        }
        if newFood.nameEs == nil || newFood.nameEs?.isEmpty == true {
            newFood.nameEs = await TranslationManager.shared.translated(food.name, target: "es")
        }
        if newFood.nameHe == nil || newFood.nameHe?.isEmpty == true {
            newFood.nameHe = await TranslationManager.shared.translated(food.name, target: "he")
        }
        
        // Translate notes if present
        if let notes = food.notes, notes.isEmpty == false {
            if newFood.notesFr == nil || newFood.notesFr?.isEmpty == true {
                newFood.notesFr = await TranslationManager.shared.translated(notes, target: "fr")
            }
            if newFood.notesEs == nil || newFood.notesEs?.isEmpty == true {
                newFood.notesEs = await TranslationManager.shared.translated(notes, target: "es")
            }
            if newFood.notesHe == nil || newFood.notesHe?.isEmpty == true {
                newFood.notesHe = await TranslationManager.shared.translated(notes, target: "he")
            }
        }
        
        // Add the translated food to the custom foods list
        customFoodItems.append(newFood)
        saveCustomFoods()
    }
    
    // Original method (keep for compatibility)
    func addCustomFood(_ food: FoodItem) {
        customFoodItems.append(food)
        saveCustomFoods()
        
        // Trigger async translations in the background
        Task {
            await translateNewlyAddedFood(food.id)
        }
    }
    
    // Helper method to translate a newly added food by ID
    @MainActor
    private func translateNewlyAddedFood(_ foodId: UUID) async {
        if let index = customFoodItems.firstIndex(where: { $0.id == foodId }) {
            let food = customFoodItems[index]
            print("Translating newly added food: \(food.name)")
            
            // Generate translations
            customFoodItems[index].nameFr = await TranslationManager.shared.translated(food.name, target: "fr")
            customFoodItems[index].nameEs = await TranslationManager.shared.translated(food.name, target: "es")
            customFoodItems[index].nameHe = await TranslationManager.shared.translated(food.name, target: "he")
            
            // Translate notes if present
            if let notes = food.notes, notes.isEmpty == false {
                customFoodItems[index].notesFr = await TranslationManager.shared.translated(notes, target: "fr")
                customFoodItems[index].notesEs = await TranslationManager.shared.translated(notes, target: "es")
                customFoodItems[index].notesHe = await TranslationManager.shared.translated(notes, target: "he")
            }
            
            // Save changes
            saveCustomFoods()
            print("Translation of new food complete: \(food.name)")
        }
    }
    
    // Remove custom food
    func removeCustomFood(_ food: FoodItem) {
        customFoodItems.removeAll { $0.id == food.id }
        saveCustomFoods()
    }
    
    // Update custom food
    func updateCustomFood(_ food: FoodItem) {
        if let index = customFoodItems.firstIndex(where: { $0.id == food.id }) {
            customFoodItems[index] = food
            saveCustomFoods()
        }
    }
    
    // Search foods
    func searchFoods(query: String) -> [FoodItem] {
        let allFoods = foodItems + customFoodItems
        let searchQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("\n=== Starting food search ===")
        print("Search query: '\(searchQuery)'")
        print("Total foods available: \(allFoods.count)")
        
        // More flexible search that includes partial matches and case-insensitive comparison
        // and searches across all localized names
        let results = allFoods.filter { food in
            let foodName = food.name.lowercased()
            let nameFr = food.nameFr?.lowercased() ?? ""
            let nameEs = food.nameEs?.lowercased() ?? ""
            let nameHe = food.nameHe?.lowercased() ?? ""
            
            let matches = foodName.contains(searchQuery) || 
                         nameFr.contains(searchQuery) ||
                         nameEs.contains(searchQuery) ||
                         nameHe.contains(searchQuery) ||
                         foodName.components(separatedBy: " ").contains { $0.contains(searchQuery) }
            if matches {
                print("Match found: \(food.name)")
            }
            return matches
        }
        
        print("\nFound \(results.count) results:")
        for result in results {
            print("- \(result.name) (Category: \(result.category.rawValue))")
        }
        print("=== Search complete ===\n")
        
        return results
    }
    
    // Get foods by category
    func foodsByCategory(_ category: FoodCategory) -> [FoodItem] {
        let allFoods = foodItems + customFoodItems
        return allFoods.filter { $0.category == category }
    }
    
    // Get foods by cuisine type
    func foodsByCuisine(_ cuisineType: CuisineType) -> [FoodItem] {
        let allFoods = foodItems + customFoodItems
        return allFoods.filter { $0.cuisineType == cuisineType }
    }
    
    // Save custom foods
    private func saveCustomFoods() {
        if let encoded = try? JSONEncoder().encode(customFoodItems) {
            UserDefaults.standard.set(encoded, forKey: "savedCustomFoods")
            print("Saved \(customFoodItems.count) custom foods to storage")
        }
    }
    
    // Public method to manually translate specific food items for testing
    @MainActor
    func translateSpecificFoodItems() async {
        print("\n=== STARTING DIRECT FOOD TRANSLATION ===")
        let foodsToTranslate = ["Salmon", "BLT Sandwich", "Brown Rice", "Apple", "Chicken Breast", "Yogurt", "Olive Oil", "Water", "Almonds"]
        let langCodes = ["fr", "es", "he"]
        var updated = false
        
        // Replace deprecated languageCode
        let lang: String
        if #available(iOS 16.0, *) {
            lang = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            lang = Locale.current.languageCode ?? "en"
        }
        // For debugging - print current language
        print("Current app language: \(lang)")
        if #available(iOS 16.0, *) {
            print("Current locale language: \(Locale.current.language.languageCode?.identifier ?? "unknown")")
        } else {
            print("Current locale language: \(Locale.current.languageCode ?? "unknown")")
        }
        
        // First, process BLT Sandwich explicitly
        print("\n--- Looking specifically for BLT Sandwich ---")
        var bltFound = false
        
        for foodIdx in foodItems.indices {
            if foodItems[foodIdx].name == "BLT Sandwich" {
                print("Directly translating BLT Sandwich (index \(foodIdx))")
                bltFound = true
                
                // Manual translation overrides
                foodItems[foodIdx].nameFr = "Sandwich BLT"
                foodItems[foodIdx].nameEs = "Sándwich BLT"
                foodItems[foodIdx].nameHe = "סנדוויץ' בי.אל.טי"
                
                // Also translate the notes if present
                if let notes = foodItems[foodIdx].notes, notes.isEmpty == false {
                    foodItems[foodIdx].notesFr = "Bacon-laitue-tomate sur pain grillé"
                    foodItems[foodIdx].notesEs = "Tocino-lechuga-tomate en pan tostado"
                    foodItems[foodIdx].notesHe = "בייקון-חסה-עגבניה על טוסט"
                    print("Translated notes for BLT Sandwich")
                }
                
                updated = true
            }
        }
        
        if !bltFound {
            print("No exact match for 'BLT Sandwich' found, trying contains search")
            
            for foodIdx in foodItems.indices {
                if foodItems[foodIdx].name.lowercased().contains("blt") {
                    print("Found BLT in: \(foodItems[foodIdx].name) (index \(foodIdx))")
                    
                    // Manual translation overrides
                    foodItems[foodIdx].nameFr = "Sandwich BLT"
                    foodItems[foodIdx].nameEs = "Sándwich BLT"
                    foodItems[foodIdx].nameHe = "סנדוויץ' בי.אל.טי"
                    
                    // Also translate the notes if present
                    if let notes = foodItems[foodIdx].notes, notes.isEmpty == false {
                        foodItems[foodIdx].notesFr = "Bacon-laitue-tomate sur pain grillé"
                        foodItems[foodIdx].notesEs = "Tocino-lechuga-tomate en pan tostado"
                        foodItems[foodIdx].notesHe = "בייקון-חסה-עגבניה על טוסט"
                        print("Translated notes for BLT Sandwich")
                    }
                    
                    updated = true
                }
            }
        }
        
        // Then, try to find and directly translate "Salmon" as another key example
        print("\n--- Looking specifically for Salmon ---")
        
        // 1. Direct name search with exact match
        let salmonFoods = foodItems.filter { $0.name == "Salmon" }
        if !salmonFoods.isEmpty {
            print("Found exact match for Salmon: \(salmonFoods.count) items")
            
            for foodIdx in foodItems.indices {
                if foodItems[foodIdx].name == "Salmon" {
                    print("Directly translating Salmon (index \(foodIdx))")
                    
                    // Manual translation overrides
                    foodItems[foodIdx].nameFr = "Saumon"
                    foodItems[foodIdx].nameEs = "Salmón"
                    foodItems[foodIdx].nameHe = "סלמון"
                    
                    // Also translate the notes if present
                    if let notes = foodItems[foodIdx].notes, notes.isEmpty == false {
                        // Attempt to translate notes for salmon
                        foodItems[foodIdx].notesFr = await TranslationManager.shared.translated(notes, target: "fr")
                        foodItems[foodIdx].notesEs = await TranslationManager.shared.translated(notes, target: "es")
                        foodItems[foodIdx].notesHe = await TranslationManager.shared.translated(notes, target: "he")
                        print("Translated notes for Salmon")
                    }
                    
                    // Print debug info
                    print("Salmon translations set:")
                    print("  French: \(foodItems[foodIdx].nameFr ?? "nil")")
                    print("  Spanish: \(foodItems[foodIdx].nameEs ?? "nil")")
                    print("  Hebrew: \(foodItems[foodIdx].nameHe ?? "nil")")
                    
                    updated = true
                }
            }
        } else {
            print("No exact match for 'Salmon' found, trying contains search")
            
            // 2. Try contains search (case-insensitive)
            let containsSalmon = foodItems.filter { $0.name.lowercased().contains("salmon") }
            if !containsSalmon.isEmpty {
                print("Found partial matches for Salmon: \(containsSalmon.count) items")
                
                for foodIdx in foodItems.indices {
                    if foodItems[foodIdx].name.lowercased().contains("salmon") {
                        print("Found salmon in: \(foodItems[foodIdx].name) (index \(foodIdx))")
                        
                        // Manual translation overrides
                        foodItems[foodIdx].nameFr = "Saumon"
                        foodItems[foodIdx].nameEs = "Salmón"
                        foodItems[foodIdx].nameHe = "סלמון"
                        
                        // Also translate the notes if present
                        if let notes = foodItems[foodIdx].notes, notes.isEmpty == false {
                            // Attempt to translate notes for salmon
                            foodItems[foodIdx].notesFr = await TranslationManager.shared.translated(notes, target: "fr")
                            foodItems[foodIdx].notesEs = await TranslationManager.shared.translated(notes, target: "es")
                            foodItems[foodIdx].notesHe = await TranslationManager.shared.translated(notes, target: "he")
                            print("Translated notes for Salmon")
                        }
                        
                        updated = true
                    }
                }
            } else {
                print("NO SALMON FOUND IN DATABASE!")
            }
        }
        
        print("\n--- Processing other food items ---")
        // Now process other foods
        for foodName in foodsToTranslate where foodName != "Salmon" && foodName != "BLT Sandwich" {
            // Find matching food items
            let matchingFoods = foodItems.filter { 
                $0.name.lowercased() == foodName.lowercased() || 
                $0.name.lowercased().contains(foodName.lowercased()) 
            }
            
            if matchingFoods.isEmpty {
                print("No matching foods found for: \(foodName)")
                continue
            }
            
            print("Found \(matchingFoods.count) matches for \(foodName)")
            
            for idx in foodItems.indices {
                let name = foodItems[idx].name.lowercased()
                if name == foodName.lowercased() || name.contains(foodName.lowercased()) {
                    print("Processing food: \(foodItems[idx].name)")
                    
                    for lang in langCodes {
                        // Use API translation
                        let translatedName = await TranslationManager.shared.translated(foodItems[idx].name, target: lang)
                        print("  Translated to \(lang): '\(translatedName)'")
                        
                        switch lang {
                        case "fr":
                            foodItems[idx].nameFr = translatedName
                            // Also translate notes if present
                            if let notes = foodItems[idx].notes, notes.isEmpty == false {
                                foodItems[idx].notesFr = await TranslationManager.shared.translated(notes, target: lang)
                            }
                        case "es":
                            foodItems[idx].nameEs = translatedName
                            // Also translate notes if present
                            if let notes = foodItems[idx].notes, notes.isEmpty == false {
                                foodItems[idx].notesEs = await TranslationManager.shared.translated(notes, target: lang)
                            }
                        case "he":
                            foodItems[idx].nameHe = translatedName
                            // Also translate notes if present
                            if let notes = foodItems[idx].notes, notes.isEmpty == false {
                                foodItems[idx].notesHe = await TranslationManager.shared.translated(notes, target: lang)
                            }
                        default:
                            break
                        }
                        updated = true
                    }
                }
            }
        }
        
        if updated {
            print("\n--- Saving translated food items ---")
            if let encoded = try? JSONEncoder().encode(foodItems) {
                UserDefaults.standard.set(encoded, forKey: "savedFoods")
                print("Updated food items saved to UserDefaults (savedFoods key)")
                
                // Force reload from UserDefaults to ensure we're using the updated data
                if let savedFoods = UserDefaults.standard.data(forKey: "savedFoods"),
                   let decodedFoods = try? JSONDecoder().decode([FoodItem].self, from: savedFoods) {
                    print("Successfully decoded \(decodedFoods.count) foods from UserDefaults")
                    foodItems = decodedFoods
                    
                    // Double-check translations
                    if let blt = foodItems.first(where: { $0.name == "BLT Sandwich" }) {
                        print("Verification - BLT Sandwich translations after save:")
                        print("  French: \(blt.nameFr ?? "nil")")
                        print("  Spanish: \(blt.nameEs ?? "nil")")
                        print("  Hebrew: \(blt.nameHe ?? "nil")")
                        print("  Notes Hebrew: \(blt.notesHe ?? "nil")")
                    }
                    
                    if let salmon = foodItems.first(where: { $0.name == "Salmon" }) {
                        print("Verification - Salmon translations after save:")
                        print("  French: \(salmon.nameFr ?? "nil")")
                        print("  Spanish: \(salmon.nameEs ?? "nil")")
                        print("  Hebrew: \(salmon.nameHe ?? "nil")")
                    }
                } else {
                    print("WARNING: Failed to decode foods from UserDefaults!")
                }
            } else {
                print("ERROR: Failed to encode food items!")
            }
        } else {
            print("No updates made to food items")
        }
        
        print("=== FOOD TRANSLATION COMPLETED ===\n")
    }
    
    // Add a utility method to ensure specific foods are translated (especially ones in the screenshot)
    @MainActor
    func forceTranslateVisibleFoods() async {
        print("\n=== STARTING FORCE TRANSLATION OF VISIBLE FOODS ===")
        
        let visibleFoods = [
            "Almond Flour Torte",
            "Almond Milk (Unsweetened)",
            "Almonds",
            "Angel Food Cake",
            "Apple",
            "Apple Cake (Apfelkuchen)",
            "Apple Juice"
        ]
        
        var updated = false
        
        // Direct hard-coded translations for these specific foods
        let hebrewTranslations = [
            "Almond Flour Torte": "עוגת קמח שקדים",
            "Almond Milk (Unsweetened)": "חלב שקדים (ללא סוכר)",
            "Almonds": "שקדים",
            "Angel Food Cake": "עוגת מלאכים",
            "Apple": "תפוח",
            "Apple Cake (Apfelkuchen)": "עוגת תפוחים (אפּפלקוכן)",
            "Apple Juice": "מיץ תפוחים"
        ]
        
        // Look through all foods
        for idx in foodItems.indices {
            if visibleFoods.contains(foodItems[idx].name) {
                print("Processing visible food: \(foodItems[idx].name)")
                
                // Apply hard-coded Hebrew translation
                if let heTranslation = hebrewTranslations[foodItems[idx].name] {
                    foodItems[idx].nameHe = heTranslation
                    print("Applied Hebrew translation: \(heTranslation)")
                } else {
                    // Fallback to API translation
                    foodItems[idx].nameHe = await TranslationManager.shared.translated(foodItems[idx].name, target: "he")
                }
                
                // Generate French and Spanish translations
                foodItems[idx].nameFr = await TranslationManager.shared.translated(foodItems[idx].name, target: "fr")
                foodItems[idx].nameEs = await TranslationManager.shared.translated(foodItems[idx].name, target: "es")
                
                // Also translate notes if present
                if let notes = foodItems[idx].notes, notes.isEmpty == false {
                    foodItems[idx].notesHe = await TranslationManager.shared.translated(notes, target: "he")
                    foodItems[idx].notesFr = await TranslationManager.shared.translated(notes, target: "fr") 
                    foodItems[idx].notesEs = await TranslationManager.shared.translated(notes, target: "es")
                }
                
                updated = true
            }
        }
        
        if updated {
            // Save to UserDefaults
            if let encoded = try? JSONEncoder().encode(foodItems) {
                UserDefaults.standard.set(encoded, forKey: "savedFoods")
                print("Saved translated visible foods to UserDefaults")
                
                // Print verification for Hebrew translations
                for food in visibleFoods {
                    if let foundFood = foodItems.first(where: { $0.name == food }) {
                        print("Verification - \(food):")
                        print("  Hebrew: \(foundFood.nameHe ?? "nil")")
                    }
                }
            }
        }
        
        print("=== FORCE TRANSLATION OF VISIBLE FOODS COMPLETED ===\n")
    }
    
    // Special method to address notes translation issues
    @MainActor
    func fixNotesTranslations() async {
        print("\n=== FIXING NOTES TRANSLATIONS ===")
        var updateCount = 0
        
        // Add translations for common foods that might not be properly translated
        // IMPORTANT: Use full, specific translations for food items with descriptors
        let commonFoods: [String: [String: String]] = [
            // Base foods
            "Barley": ["fr": "Orge", "es": "Cebada", "he": "שעורה"],
            "Bean Burrito": ["fr": "Burrito aux haricots", "es": "Burrito de frijoles", "he": "בוריטו שעועית"],
            "Beef Stew": ["fr": "Ragoût de bœuf", "es": "Estofado de carne", "he": "נזיד בקר"],
            "Black Beans": ["fr": "Haricots noirs", "es": "Frijoles negros", "he": "שעועית שחורה"],
            "Blueberries": ["fr": "Myrtilles", "es": "Arándanos", "he": "אוכמניות"],
            "Bread": ["fr": "Pain", "es": "Pan", "he": "לחם"],
            "Brown Rice": ["fr": "Riz brun", "es": "Arroz integral", "he": "אורז חום"],
            "Butter": ["fr": "Beurre", "es": "Mantequilla", "he": "חמאה"],
            "Carrot": ["fr": "Carotte", "es": "Zanahoria", "he": "גזר"],
            
            // Specific cheese varieties - COMPLETE translations
            "Cheese": ["fr": "Fromage", "es": "Queso", "he": "גבינה"],
            "Cheddar Cheese": ["fr": "Fromage Cheddar", "es": "Queso Cheddar", "he": "גבינת צ'דר"],
            "Cottage Cheese": ["fr": "Fromage Cottage", "es": "Queso Cottage", "he": "גבינת קוטג'"],
            "Cream Cheese": ["fr": "Fromage à la Crème", "es": "Queso Crema", "he": "גבינת שמנת"],
            "Mozzarella Cheese": ["fr": "Fromage Mozzarella", "es": "Queso Mozzarella", "he": "גבינת מוצרלה"],
            "Swiss Cheese": ["fr": "Fromage Suisse", "es": "Queso Suizo", "he": "גבינה שוויצרית"],
            "Feta Cheese": ["fr": "Fromage Feta", "es": "Queso Feta", "he": "גבינת פטה"],
            "Blue Cheese": ["fr": "Fromage Bleu", "es": "Queso Azul", "he": "גבינה כחולה"],
            "Gouda Cheese": ["fr": "Fromage Gouda", "es": "Queso Gouda", "he": "גבינת גאודה"],
            "Brie Cheese": ["fr": "Fromage Brie", "es": "Queso Brie", "he": "גבינת ברי"],
            "Ricotta Cheese": ["fr": "Fromage Ricotta", "es": "Queso Ricotta", "he": "גבינת ריקוטה"],
            "Parmesan Cheese": ["fr": "Fromage Parmesan", "es": "Queso Parmesano", "he": "גבינת פרמזן"],
            
            // Other common foods
            "Chicken": ["fr": "Poulet", "es": "Pollo", "he": "עוף"],
            "Eggs": ["fr": "Œufs", "es": "Huevos", "he": "ביצים"],
            "Fish": ["fr": "Poisson", "es": "Pescado", "he": "דג"],
            "Green Beans": ["fr": "Haricots verts", "es": "Judías verdes", "he": "שעועית ירוקה"],
            "Milk": ["fr": "Lait", "es": "Leche", "he": "חלב"],
            "Oatmeal": ["fr": "Flocons d'avoine", "es": "Avena", "he": "דייסת שיבולת שועל"],
            "Olive Oil": ["fr": "Huile d'olive", "es": "Aceite de oliva", "he": "שמן זית"],
            "Pasta": ["fr": "Pâtes", "es": "Pasta", "he": "פסטה"],
            "Peanut Butter": ["fr": "Beurre de cacahuète", "es": "Mantequilla de maní", "he": "חמאת בוטנים"],
            "Rice": ["fr": "Riz", "es": "Arroz", "he": "אורז"],
            "Salmon": ["fr": "Saumon", "es": "Salmón", "he": "סלמון"],
            "Spinach": ["fr": "Épinards", "es": "Espinacas", "he": "תרד"],
            "Steak": ["fr": "Steak", "es": "Bistec", "he": "סטייק"],
            "Tomato": ["fr": "Tomate", "es": "Tomate", "he": "עגבנייה"],
            "Walnuts": ["fr": "Noix", "es": "Nueces", "he": "אגוזי מלך"],
            "Wheat": ["fr": "Blé", "es": "Trigo", "he": "חיטה"],
            "Yogurt": ["fr": "Yaourt", "es": "Yogur", "he": "יוגורט"]
        ]
        
        // Common notes translations
        let notesTranslations: [String: [String: String]] = [
            "Whole grain": ["fr": "Grain entier", "es": "Grano entero", "he": "דגנים מלאים"],
            "Fresh vegetables": ["fr": "Légumes frais", "es": "Verduras frescas", "he": "ירקות טריים"],
            "Raw": ["fr": "Cru", "es": "Crudo", "he": "גולמי"],
            "Cooked": ["fr": "Cuit", "es": "Cocinado", "he": "מבושל"],
            "Baked": ["fr": "Cuit au four", "es": "Horneado", "he": "אפוי"],
            "Grilled": ["fr": "Grillé", "es": "A la parrilla", "he": "צלוי"],
            "Fresh": ["fr": "Frais", "es": "Fresco", "he": "טרי"],
            "Dried": ["fr": "Séché", "es": "Seco", "he": "מיובש"],
            "Frozen": ["fr": "Surgelé", "es": "Congelado", "he": "קפוא"],
            "Canned": ["fr": "En conserve", "es": "Enlatado", "he": "משומר"]
        ]
        
        // Force translate ALL foods, not just the ones visible
        for idx in foodItems.indices {
            // Track if food was updated
            var foodUpdated = false
            
            // 1. First, check if this is a common food with known translations
            if let knownTrans = commonFoods[foodItems[idx].name] {
                foodItems[idx].nameFr = knownTrans["fr"]
                foodItems[idx].nameEs = knownTrans["es"]
                foodItems[idx].nameHe = knownTrans["he"]
                foodUpdated = true
                print("Applied direct translation for: \(foodItems[idx].name)")
            } 
            // 2. Handle compound names like "Something Cheese" if not found in direct matches
            else if foodItems[idx].name.contains("Cheese") && !commonFoods.keys.contains(foodItems[idx].name) {
                // Get the first part of the name (e.g., "Cheddar" from "Cheddar Cheese")
                let parts = foodItems[idx].name.components(separatedBy: " Cheese")
                if parts.count > 0 {
                    let prefix = parts[0] // e.g., "Cheddar"
                    
                    // Create custom translations for this cheese type
                    foodItems[idx].nameFr = "\(prefix) Fromage" 
                    foodItems[idx].nameEs = "Queso \(prefix)"
                    foodItems[idx].nameHe = "גבינת \(prefix)"
                    
                    foodUpdated = true
                    print("Created compound translation for: \(foodItems[idx].name)")
                }
            }
            
            // 3. Process notes if present
            if let notes = foodItems[idx].notes, notes.isEmpty == false {
                var notesUpdated = false
                
                // Try direct matches for notes
                for (key, translations) in notesTranslations {
                    if notes.lowercased().contains(key.lowercased()) {
                        if foodItems[idx].notesFr == nil || foodItems[idx].notesFr?.isEmpty == true {
                            foodItems[idx].notesFr = translations["fr"]
                            notesUpdated = true
                        }
                        if foodItems[idx].notesEs == nil || foodItems[idx].notesEs?.isEmpty == true {
                            foodItems[idx].notesEs = translations["es"]
                            notesUpdated = true
                        }
                        if foodItems[idx].notesHe == nil || foodItems[idx].notesHe?.isEmpty == true {
                            foodItems[idx].notesHe = translations["he"]
                            notesUpdated = true
                        }
                    }
                }
                
                // If no matches found, use API translation
                if !notesUpdated {
                    foodItems[idx].notesFr = await TranslationManager.shared.translated(notes, target: "fr")
                    foodItems[idx].notesEs = await TranslationManager.shared.translated(notes, target: "es")
                    foodItems[idx].notesHe = await TranslationManager.shared.translated(notes, target: "he")
                    notesUpdated = true
                }
                
                if notesUpdated {
                    foodUpdated = true
                }
            }
            
            // 4. If food hasn't been updated via direct translation yet, use API
            if !foodUpdated {
                if foodItems[idx].nameFr == nil || foodItems[idx].nameFr?.isEmpty == true {
                    foodItems[idx].nameFr = await TranslationManager.shared.translated(foodItems[idx].name, target: "fr")
                    foodUpdated = true
                }
                if foodItems[idx].nameEs == nil || foodItems[idx].nameEs?.isEmpty == true {
                    foodItems[idx].nameEs = await TranslationManager.shared.translated(foodItems[idx].name, target: "es")
                    foodUpdated = true
                }
                if foodItems[idx].nameHe == nil || foodItems[idx].nameHe?.isEmpty == true {
                    foodItems[idx].nameHe = await TranslationManager.shared.translated(foodItems[idx].name, target: "he")
                    foodUpdated = true
                }
            }
            
            if foodUpdated {
                updateCount += 1
            }
        }
        
        // Save all changes
        if updateCount > 0 {
            if let encoded = try? JSONEncoder().encode(foodItems) {
                UserDefaults.standard.set(encoded, forKey: "savedFoods")
                print("Saved \(updateCount) foods with updated translations")
            }
        }
        
        print("=== NOTES TRANSLATION FIX COMPLETED ===\n")
    }
    
    @MainActor
    func checkAndTranslateIfNeeded() async {
        let lang = LanguageManager.shared.currentLanguage
        
        // Always check if translations are missing, even if language hasn't changed
        let needsTranslation = lang != "en" && (lastTranslatedLanguage != lang || hasIncompleteTranslations(for: lang))
        
        if needsTranslation {
            print("[FoodDatabaseService] Translating all foods for language: \(lang)")
            
            // First, translate the most common foods immediately for quick UI update
            await translateCommonFoodsFirst(for: lang)
            
            // Then translate all remaining foods
            let _ = await translateAllFoodItems()
            lastTranslatedLanguage = lang
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    // Translate the most common/visible foods first for immediate UI update
    @MainActor
    func translateCommonFoodsFirst(for language: String) async {
        let commonFoods = [
            "Cooked Green Peas", "Broccoli", "Beef Stew", "Oatmeal", "Greek Salad",
            "Apple", "Banana", "Chicken", "Rice", "Pasta", "Bread", "Milk", "Cheese",
            "Salmon", "Tuna", "Yogurt", "Eggs", "Spinach", "Carrot", "Potato"
        ]
        
        let commonTranslations: [String: [String: String]] = [
            "Cooked Green Peas": ["he": "אפונה ירוקה מבושלת", "fr": "Petits pois cuits", "es": "Guisantes verdes cocidos"],
            "Broccoli": ["he": "ברוקולי", "fr": "Brocoli", "es": "Brócoli"],
            "Beef Stew": ["he": "נזיד בקר", "fr": "Ragoût de bœuf", "es": "Estofado de carne"],
            "Oatmeal": ["he": "שיבולת שועל", "fr": "Flocons d'avoine", "es": "Avena"],
            "Greek Salad": ["he": "סלט יווני", "fr": "Salade grecque", "es": "Ensalada griega"],
            "Apple": ["he": "תפוח", "fr": "Pomme", "es": "Manzana"],
            "Banana": ["he": "בננה", "fr": "Banane", "es": "Plátano"],
            "Chicken": ["he": "עוף", "fr": "Poulet", "es": "Pollo"],
            "Rice": ["he": "אורז", "fr": "Riz", "es": "Arroz"],
            "Pasta": ["he": "פסטה", "fr": "Pâtes", "es": "Pasta"],
            "Bread": ["he": "לחם", "fr": "Pain", "es": "Pan"],
            "Milk": ["he": "חלב", "fr": "Lait", "es": "Leche"],
            "Cheese": ["he": "גבינה", "fr": "Fromage", "es": "Queso"],
            "Salmon": ["he": "סלמון", "fr": "Saumon", "es": "Salmón"],
            "Tuna": ["he": "טונה", "fr": "Thon", "es": "Atún"],
            "Yogurt": ["he": "יוגורט", "fr": "Yaourt", "es": "Yogur"],
            "Eggs": ["he": "ביצים", "fr": "Œufs", "es": "Huevos"],
            "Spinach": ["he": "תרד", "fr": "Épinards", "es": "Espinacas"],
            "Carrot": ["he": "גזר", "fr": "Carotte", "es": "Zanahoria"],
            "Potato": ["he": "תפוח אדמה", "fr": "Pomme de terre", "es": "Papa"]
        ]
        
        var updated = false
        
        for idx in foodItems.indices {
            let foodName = foodItems[idx].name
            
            if commonFoods.contains(foodName) {
                if let translations = commonTranslations[foodName] {
                    switch language {
                    case "he":
                        if let heTranslation = translations["he"] {
                            foodItems[idx].nameHe = heTranslation
                            updated = true
                            print("Quick Hebrew translation: \(foodName) -> \(heTranslation)")
                        }
                    case "fr":
                        if let frTranslation = translations["fr"] {
                            foodItems[idx].nameFr = frTranslation
                            updated = true
                            print("Quick French translation: \(foodName) -> \(frTranslation)")
                        }
                    case "es":
                        if let esTranslation = translations["es"] {
                            foodItems[idx].nameEs = esTranslation
                            updated = true
                            print("Quick Spanish translation: \(foodName) -> \(esTranslation)")
                        }
                    default:
                        break
                    }
                }
            }
        }
        
        if updated {
            // Save immediately for quick access
            if let encoded = try? JSONEncoder().encode(foodItems) {
                UserDefaults.standard.set(encoded, forKey: "savedFoods")
                print("Saved quick translations to UserDefaults")
            }
            
            // Force UI update
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    // Check if there are incomplete translations for the given language
    private func hasIncompleteTranslations(for language: String) -> Bool {
        // Check first 10 foods to see if they have translations
        let sampleSize = min(10, foodItems.count)
        let sampleFoods = Array(foodItems.prefix(sampleSize))
        
        for food in sampleFoods {
            switch language {
            case "he":
                if food.nameHe == nil || food.nameHe?.isEmpty == true {
                    print("[FoodDatabaseService] Missing Hebrew translation for: \(food.name)")
                    return true
                }
            case "fr":
                if food.nameFr == nil || food.nameFr?.isEmpty == true {
                    print("[FoodDatabaseService] Missing French translation for: \(food.name)")
                    return true
                }
            case "es":
                if food.nameEs == nil || food.nameEs?.isEmpty == true {
                    print("[FoodDatabaseService] Missing Spanish translation for: \(food.name)")
                    return true
                }
            default:
                break
            }
        }
        
        return false
    }
} 