import Foundation

struct DairyFoodItems {
    static let foods: [FoodItem] = [
        // Whole Milk
        FoodItem(
            id: UUID(),
            name: "Whole Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 61,
                protein: 3.2,
                carbohydrates: 4.8,
                fat: 3.3,
                fiber: 0.0,
                sugar: 5.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Standard whole cow's milk",
            nameFr: "Lait Entier",
            nameEs: "Leche Entera",
            nameHe: "חלב מלא",
            notesFr: "Lait de vache entier standard",
            notesEs: "Leche entera estándar de vaca",
            notesHe: "חלב פרה מלא רגיל"
        ),
        
        // Skim Milk
        FoodItem(
            id: UUID(),
            name: "Skim Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 34,
                protein: 3.4,
                carbohydrates: 5.0,
                fat: 0.1,
                fiber: 0.0,
                sugar: 5.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fat-free cow's milk",
            nameFr: "Lait Écrémé",
            nameEs: "Leche Desnatada",
            nameHe: "חלב דל שומן",
            notesFr: "Lait de vache sans matière grasse",
            notesEs: "Leche de vaca sin grasa",
            notesHe: "חלב פרה נטול שומן"
        ),
        
        // Lactose-Free Milk
        FoodItem(
            id: UUID(),
            name: "Lactose-Free Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 42,
                protein: 3.3,
                carbohydrates: 5.0,
                fat: 1.0,
                fiber: 0.0,
                sugar: 5.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Milk with lactose removed",
            nameFr: "Lait Sans Lactose",
            nameEs: "Leche Sin Lactosa",
            nameHe: "חלב ללא לקטוז",
            notesFr: "Lait dont le lactose a été retiré",
            notesEs: "Leche con lactosa eliminada",
            notesHe: "חלב שהוסר ממנו לקטוז"
        ),
        
        // Greek Yogurt
        FoodItem(
            id: UUID(),
            name: "Greek Yogurt (Nonfat)",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 59,
                protein: 10.0,
                carbohydrates: 3.6,
                fat: 0.4,
                fiber: 0.0,
                sugar: 3.2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Plain nonfat Greek yogurt",
            nameFr: "Yaourt Grec (Sans Matière Grasse)",
            nameEs: "Yogur Griego (Sin Grasa)",
            nameHe: "יוגורט יווני (ללא שומן)",
            notesFr: "Yaourt grec nature sans matière grasse",
            notesEs: "Yogur griego natural sin grasa",
            notesHe: "יוגורט יווני טבעי ללא שומן"
        ),
        
        // Regular Yogurt
        FoodItem(
            id: UUID(),
            name: "Regular Yogurt",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 61,
                protein: 3.5,
                carbohydrates: 4.7,
                fat: 3.3,
                fiber: 0.0,
                sugar: 4.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Plain whole milk yogurt",
            nameFr: "Yaourt Ordinaire",
            nameEs: "Yogur Regular",
            nameHe: "יוגורט רגיל",
            notesFr: "Yaourt nature au lait entier",
            notesEs: "Yogur natural de leche entera",
            notesHe: "יוגורט טבעי מחלב מלא"
        ),
        
        // Cottage Cheese
        FoodItem(
            id: UUID(),
            name: "Cottage Cheese (Low-fat)",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 98,
                protein: 11.1,
                carbohydrates: 3.4,
                fat: 4.3,
                fiber: 0.0,
                sugar: 2.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Low-fat cottage cheese",
            nameFr: "Fromage Cottage (Allégé)",
            nameEs: "Queso Cottage (Bajo en Grasa)",
            nameHe: "גבינת קוטג' (דלת שומן)",
            notesFr: "Fromage cottage allégé",
            notesEs: "Queso cottage bajo en grasa",
            notesHe: "גבינת קוטג' דלת שומן"
        ),
        
        // Cheddar Cheese
        FoodItem(
            id: UUID(),
            name: "Cheddar Cheese",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 402,
                protein: 25.0,
                carbohydrates: 1.3,
                fat: 33.0,
                fiber: 0.0,
                sugar: 0.5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Hard aged cheese",
            nameFr: "Fromage Cheddar",
            nameEs: "Queso Cheddar",
            nameHe: "גבינת צ'דר",
            notesFr: "Fromage dur affiné",
            notesEs: "Queso duro añejado",
            notesHe: "גבינה קשה מיושנת"
        ),
        
        // Mozzarella Cheese
        FoodItem(
            id: UUID(),
            name: "Mozzarella Cheese",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 280,
                protein: 28.0,
                carbohydrates: 3.1,
                fat: 17.0,
                fiber: 0.0,
                sugar: 1.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Part-skim mozzarella",
            nameFr: "Fromage Mozzarella",
            nameEs: "Queso Mozzarella",
            nameHe: "גבינת מוצרלה",
            notesFr: "Mozzarella partiellement écrémée",
            notesEs: "Mozzarella parcialmente descremada",
            notesHe: "מוצרלה דלת שומן"
        ),
        
        // Parmesan Cheese
        FoodItem(
            id: UUID(),
            name: "Parmesan Cheese",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 431,
                protein: 38.0,
                carbohydrates: 4.1,
                fat: 29.0,
                fiber: 0.0,
                sugar: 0.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Grated hard cheese",
            nameFr: "Fromage Parmesan",
            nameEs: "Queso Parmesano",
            nameHe: "גבינת פרמזן",
            notesFr: "Fromage dur râpé",
            notesEs: "Queso duro rallado",
            notesHe: "גבינה קשה מגורדת"
        ),
        
        // Cream Cheese
        FoodItem(
            id: UUID(),
            name: "Cream Cheese",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 342,
                protein: 6.2,
                carbohydrates: 4.1,
                fat: 34.0,
                fiber: 0.0,
                sugar: 2.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Soft spreadable cheese",
            nameFr: "Fromage à la Crème",
            nameEs: "Queso Crema",
            nameHe: "גבינת שמנת",
            notesFr: "Fromage à tartiner mou",
            notesEs: "Queso blando para untar",
            notesHe: "גבינה רכה למריחה"
        ),
        
        // Butter
        FoodItem(
            id: UUID(),
            name: "Butter",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 717,
                protein: 0.9,
                carbohydrates: 0.1,
                fat: 81.0,
                fiber: 0.0,
                sugar: 0.1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Unsalted butter",
            nameFr: "Beurre",
            nameEs: "Mantequilla",
            nameHe: "חמאה",
            notesFr: "Beurre non salé",
            notesEs: "Mantequilla sin sal",
            notesHe: "חמאה ללא מלח"
        ),
        
        // Ghee
        FoodItem(
            id: UUID(),
            name: "Ghee",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 900,
                protein: 0.0,
                carbohydrates: 0.0,
                fat: 100.0,
                fiber: 0.0,
                sugar: 0.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Clarified butter"
        ),
        
        // Sour Cream
        FoodItem(
            id: UUID(),
            name: "Sour Cream",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 193,
                protein: 2.4,
                carbohydrates: 3.4,
                fat: 20.0,
                fiber: 0.0,
                sugar: 3.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Regular sour cream",
            nameFr: "Crème Aigre",
            nameEs: "Crema Agria",
            nameHe: "שמנת חמוצה",
            notesFr: "Crème aigre ordinaire",
            notesEs: "Crema agria regular",
            notesHe: "שמנת חמוצה רגילה"
        ),
        
        // Whipped Cream
        FoodItem(
            id: UUID(),
            name: "Whipped Cream",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 257,
                protein: 2.0,
                carbohydrates: 3.0,
                fat: 27.0,
                fiber: 0.0,
                sugar: 3.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Lightly whipped cream"
        ),
        
        // Heavy Cream
        FoodItem(
            id: UUID(),
            name: "Heavy Cream",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 340,
                protein: 2.0,
                carbohydrates: 3.0,
                fat: 36.0,
                fiber: 0.0,
                sugar: 3.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Also known as heavy whipping cream"
        ),
        
        // Ice Cream
        FoodItem(
            id: UUID(),
            name: "Ice Cream",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 207,
                protein: 3.5,
                carbohydrates: 24.0,
                fat: 11.0,
                fiber: 0.0,
                sugar: 21.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Vanilla ice cream"
        ),
        
        // Kefir
        FoodItem(
            id: UUID(),
            name: "Kefir",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 41,
                protein: 3.3,
                carbohydrates: 4.7,
                fat: 1.0,
                fiber: 0.0,
                sugar: 4.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fermented milk drink"
        ),
        
        // Buttermilk
        FoodItem(
            id: UUID(),
            name: "Buttermilk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 40,
                protein: 3.3,
                carbohydrates: 4.8,
                fat: 0.9,
                fiber: 0.0,
                sugar: 4.8
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cultured low-fat buttermilk"
        ),
        
        // Evaporated Milk
        FoodItem(
            id: UUID(),
            name: "Evaporated Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 134,
                protein: 6.8,
                carbohydrates: 10.0,
                fat: 7.6,
                fiber: 0.0,
                sugar: 10.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Unsweetened condensed milk"
        ),
        
        // Condensed Milk
        FoodItem(
            id: UUID(),
            name: "Condensed Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 321,
                protein: 7.9,
                carbohydrates: 54.4,
                fat: 8.7,
                fiber: 0.0,
                sugar: 54.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Sweetened condensed milk"
        )
    ]
    
    // Helper method to add translations to food items
    static func addTranslations(to foodItem: FoodItem, nameFr: String, nameEs: String, nameHe: String, 
                               notesFr: String? = nil, notesEs: String? = nil, notesHe: String? = nil) -> FoodItem {
        return FoodItem(
            id: foodItem.id,
            name: foodItem.name,
            category: foodItem.category,
            nutritionalInfo: foodItem.nutritionalInfo,
            servingSize: foodItem.servingSize,
            servingUnit: foodItem.servingUnit,
            isCustom: foodItem.isCustom,
            notes: foodItem.notes,
            nameFr: nameFr,
            nameEs: nameEs,
            nameHe: nameHe,
            notesFr: notesFr,
            notesEs: notesEs,
            notesHe: notesHe
        )
    }
} 