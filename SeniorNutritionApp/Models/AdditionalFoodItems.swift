import Foundation

struct AdditionalFoodItems {
    static let foods: [FoodItem] = [
        // Avocado
        FoodItem(
            id: UUID(),
            name: "Avocado",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 2.0,
                carbohydrates: 8.5,
                fat: 14.7,
                fiber: 6.7,
                sugar: 0.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh avocado"
        ),
        
        // Quinoa
        FoodItem(
            id: UUID(),
            name: "Quinoa",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 120,
                protein: 4.4,
                carbohydrates: 21.3,
                fat: 1.9,
                fiber: 2.8,
                sugar: 0.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked quinoa"
        ),
        
        // Chia Seeds
        FoodItem(
            id: UUID(),
            name: "Chia Seeds",
            category: .other,
            nutritionalInfo: NutritionalInfo(
                calories: 138,
                protein: 4.7,
                carbohydrates: 11.9,
                fat: 8.7,
                fiber: 9.8,
                sugar: 0.0
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Dried chia seeds"
        ),
        
        // Lentils
        FoodItem(
            id: UUID(),
            name: "Lentils",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 116,
                protein: 9.0,
                carbohydrates: 20.1,
                fat: 0.4,
                fiber: 7.9,
                sugar: 1.8
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked lentils"
        ),
        
        // Carrots
        FoodItem(
            id: UUID(),
            name: "Carrots",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 41,
                protein: 0.9,
                carbohydrates: 9.6,
                fat: 0.2,
                fiber: 2.8,
                sugar: 4.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw carrots"
        ),
        
        // Apples
        FoodItem(
            id: UUID(),
            name: "Apples",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 52,
                protein: 0.3,
                carbohydrates: 13.8,
                fat: 0.2,
                fiber: 2.4,
                sugar: 10.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh apple with skin"
        ),
        
        // Tomatoes
        FoodItem(
            id: UUID(),
            name: "Tomatoes",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 18,
                protein: 0.9,
                carbohydrates: 3.9,
                fat: 0.2,
                fiber: 1.2,
                sugar: 2.6
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw tomatoes"
        ),
        
        // Peanuts
        FoodItem(
            id: UUID(),
            name: "Peanuts",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 567,
                protein: 25.8,
                carbohydrates: 16.1,
                fat: 49.2,
                fiber: 8.5,
                sugar: 4.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw peanuts"
        ),
        
        // Barley
        FoodItem(
            id: UUID(),
            name: "Barley",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 354,
                protein: 12.5,
                carbohydrates: 73.5,
                fat: 2.3,
                fiber: 17.3,
                sugar: 0.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Uncooked hulled barley"
        ),
        
        // Pumpkin
        FoodItem(
            id: UUID(),
            name: "Pumpkin",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 20,
                protein: 1.0,
                carbohydrates: 4.9,
                fat: 0.1,
                fiber: 1.1,
                sugar: 2.1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked pumpkin"
        ),
        
        // Whole Wheat Pasta
        FoodItem(
            id: UUID(),
            name: "Whole Wheat Pasta",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 127,
                protein: 5.8,
                carbohydrates: 27.0,
                fat: 0.7,
                fiber: 3.9,
                sugar: 0.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked whole wheat pasta"
        ),
        
        // Hummus
        FoodItem(
            id: UUID(),
            name: "Hummus",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 177,
                protein: 4.9,
                carbohydrates: 20.1,
                fat: 8.6,
                fiber: 6.0,
                sugar: 0.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Prepared hummus"
        ),
        
        // Granola
        FoodItem(
            id: UUID(),
            name: "Granola",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 408,
                protein: 9.2,
                carbohydrates: 72.4,
                fat: 11.0,
                fiber: 7.0,
                sugar: 17.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Plain granola"
        ),
        
        // Black Beans
        FoodItem(
            id: UUID(),
            name: "Black Beans",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 132,
                protein: 8.9,
                carbohydrates: 23.7,
                fat: 0.5,
                fiber: 8.7,
                sugar: 0.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked black beans"
        ),
        
        // Cottage Cheese
        FoodItem(
            id: UUID(),
            name: "Cottage Cheese",
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
        
        // Hard-Boiled Egg
        FoodItem(
            id: UUID(),
            name: "Hard-Boiled Egg",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 78,
                protein: 6.3,
                carbohydrates: 0.6,
                fat: 5.3,
                fiber: 0.0,
                sugar: 0.6
            ),
            servingSize: 50,
            servingUnit: "g",
            isCustom: true,
            notes: "Large hard-boiled egg"
        ),
        
        // Greek Yogurt
        FoodItem(
            id: UUID(),
            name: "Greek Yogurt",
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
            notes: "Plain Greek yogurt"
        ),
        
        // Peanut Butter
        FoodItem(
            id: UUID(),
            name: "Peanut Butter",
            category: .fats,
            nutritionalInfo: NutritionalInfo(
                calories: 588,
                protein: 25.0,
                carbohydrates: 20.0,
                fat: 50.0,
                fiber: 6.0,
                sugar: 9.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Unsweetened peanut butter"
        ),
        
        // Canned Tuna
        FoodItem(
            id: UUID(),
            name: "Canned Tuna",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 116,
                protein: 26.0,
                carbohydrates: 0.0,
                fat: 1.0,
                fiber: 0.0,
                sugar: 0.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Canned tuna in water"
        ),
        
        // Mixed Vegetables
        FoodItem(
            id: UUID(),
            name: "Mixed Vegetables",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 65,
                protein: 2.5,
                carbohydrates: 11.5,
                fat: 0.5,
                fiber: 3.8,
                sugar: 4.5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Frozen mixed vegetables"
        )
    ]
} 