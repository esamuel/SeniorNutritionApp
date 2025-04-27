import Foundation

struct FruitFoodItems {
    static let foods: [FoodItem] = [
        // Apple
        FoodItem(
            id: UUID(),
            name: "Apple",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 52,
                protein: 0.3,
                carbohydrates: 14,
                fat: 0.2,
                fiber: 2.4,
                sugar: 10.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh apple with skin"
        ),
        
        // Banana
        FoodItem(
            id: UUID(),
            name: "Banana",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 89,
                protein: 1.1,
                carbohydrates: 23,
                fat: 0.3,
                fiber: 2.6,
                sugar: 12.2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw banana"
        ),
        
        // Orange
        FoodItem(
            id: UUID(),
            name: "Orange",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 47,
                protein: 0.9,
                carbohydrates: 12,
                fat: 0.1,
                fiber: 2.4,
                sugar: 9.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh orange"
        ),
        
        // Strawberry
        FoodItem(
            id: UUID(),
            name: "Strawberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 32,
                protein: 0.7,
                carbohydrates: 7.7,
                fat: 0.3,
                fiber: 2.0,
                sugar: 4.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh strawberries"
        ),
        
        // Blueberry
        FoodItem(
            id: UUID(),
            name: "Blueberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 57,
                protein: 0.7,
                carbohydrates: 14.5,
                fat: 0.3,
                fiber: 2.4,
                sugar: 9.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh blueberries"
        ),
        
        // Grapes
        FoodItem(
            id: UUID(),
            name: "Grapes",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 69,
                protein: 0.7,
                carbohydrates: 18,
                fat: 0.2,
                fiber: 0.9,
                sugar: 15.5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh grapes"
        ),
        
        // Pineapple
        FoodItem(
            id: UUID(),
            name: "Pineapple",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 50,
                protein: 0.5,
                carbohydrates: 13,
                fat: 0.1,
                fiber: 1.4,
                sugar: 9.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh pineapple"
        ),
        
        // Mango
        FoodItem(
            id: UUID(),
            name: "Mango",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 60,
                protein: 0.8,
                carbohydrates: 15,
                fat: 0.4,
                fiber: 1.6,
                sugar: 13.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh mango"
        ),
        
        // Watermelon
        FoodItem(
            id: UUID(),
            name: "Watermelon",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 30,
                protein: 0.6,
                carbohydrates: 8,
                fat: 0.2,
                fiber: 0.4,
                sugar: 6.2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh watermelon"
        ),
        
        // Peach
        FoodItem(
            id: UUID(),
            name: "Peach",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 39,
                protein: 0.9,
                carbohydrates: 10,
                fat: 0.3,
                fiber: 1.5,
                sugar: 8.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh peach"
        ),
        
        // Pear
        FoodItem(
            id: UUID(),
            name: "Pear",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 57,
                protein: 0.4,
                carbohydrates: 15,
                fat: 0.1,
                fiber: 3.1,
                sugar: 9.8
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh pear"
        ),
        
        // Cherry
        FoodItem(
            id: UUID(),
            name: "Cherry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 50,
                protein: 1.0,
                carbohydrates: 12,
                fat: 0.3,
                fiber: 1.6,
                sugar: 8.5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh cherries"
        ),
        
        // Kiwi
        FoodItem(
            id: UUID(),
            name: "Kiwi",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 61,
                protein: 1.1,
                carbohydrates: 15,
                fat: 0.5,
                fiber: 3.0,
                sugar: 9.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh kiwi"
        ),
        
        // Plum
        FoodItem(
            id: UUID(),
            name: "Plum",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 46,
                protein: 0.7,
                carbohydrates: 11,
                fat: 0.3,
                fiber: 1.4,
                sugar: 9.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh plum"
        ),
        
        // Raspberry
        FoodItem(
            id: UUID(),
            name: "Raspberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 52,
                protein: 1.2,
                carbohydrates: 12,
                fat: 0.7,
                fiber: 6.5,
                sugar: 4.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh raspberries"
        ),
        
        // Blackberry
        FoodItem(
            id: UUID(),
            name: "Blackberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 43,
                protein: 1.4,
                carbohydrates: 10,
                fat: 0.5,
                fiber: 5.3,
                sugar: 4.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh blackberries"
        ),
        
        // Papaya
        FoodItem(
            id: UUID(),
            name: "Papaya",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 43,
                protein: 0.5,
                carbohydrates: 11,
                fat: 0.3,
                fiber: 1.7,
                sugar: 7.8
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh papaya"
        ),
        
        // Cantaloupe
        FoodItem(
            id: UUID(),
            name: "Cantaloupe",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 34,
                protein: 0.8,
                carbohydrates: 8.2,
                fat: 0.2,
                fiber: 0.9,
                sugar: 7.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh cantaloupe"
        ),
        
        // Apricot
        FoodItem(
            id: UUID(),
            name: "Apricot",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 48,
                protein: 1.4,
                carbohydrates: 11,
                fat: 0.4,
                fiber: 2.0,
                sugar: 3.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh apricot"
        ),
        
        // Pomegranate
        FoodItem(
            id: UUID(),
            name: "Pomegranate",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 83,
                protein: 1.7,
                carbohydrates: 19,
                fat: 1.2,
                fiber: 4.0,
                sugar: 13.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh pomegranate"
        ),
        
        // Lemon
        FoodItem(
            id: UUID(),
            name: "Lemon",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 29,
                protein: 1.1,
                carbohydrates: 9.3,
                fat: 0.3,
                fiber: 2.8,
                sugar: 2.5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh lemon"
        ),
        
        // Lime
        FoodItem(
            id: UUID(),
            name: "Lime",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 30,
                protein: 0.7,
                carbohydrates: 11,
                fat: 0.2,
                fiber: 2.8,
                sugar: 1.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh lime"
        ),
        
        // Coconut
        FoodItem(
            id: UUID(),
            name: "Coconut",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 354,
                protein: 3.3,
                carbohydrates: 15,
                fat: 33.5,
                fiber: 9.0,
                sugar: 6.2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh coconut meat"
        ),
        
        // Fig
        FoodItem(
            id: UUID(),
            name: "Fig",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 74,
                protein: 0.8,
                carbohydrates: 19,
                fat: 0.3,
                fiber: 2.9,
                sugar: 16.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh fig"
        ),
        
        // Guava
        FoodItem(
            id: UUID(),
            name: "Guava",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 68,
                protein: 2.6,
                carbohydrates: 14,
                fat: 0.9,
                fiber: 5.4,
                sugar: 8.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh guava"
        )
    ]
} 