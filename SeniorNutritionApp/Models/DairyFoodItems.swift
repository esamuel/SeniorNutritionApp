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
            notes: "Standard whole cow's milk"
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
            notes: "Fat-free cow's milk"
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
            notes: "Milk with lactose removed"
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
            notes: "Plain nonfat Greek yogurt"
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
            notes: "Plain whole milk yogurt"
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
            notes: "Low-fat cottage cheese"
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
            notes: "Hard aged cheese"
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
            notes: "Part-skim mozzarella"
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
            notes: "Grated hard cheese"
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
            notes: "Soft spreadable cheese"
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
            notes: "Unsalted butter"
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
            notes: "Regular sour cream"
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
} 