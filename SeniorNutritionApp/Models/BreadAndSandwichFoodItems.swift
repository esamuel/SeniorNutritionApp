import Foundation

struct BreadAndSandwichFoodItems {
    static let foods: [FoodItem] = [
        // Whole Wheat Bread
        FoodItem(
            id: UUID(),
            name: "Whole Wheat Bread",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 247,
                protein: 13,
                carbohydrates: 41,
                fat: 4,
                fiber: 7,
                sugar: 5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Average nutrition per 100 g loaf slice"
        ),
        
        // White Bread
        FoodItem(
            id: UUID(),
            name: "White Bread",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 265,
                protein: 9,
                carbohydrates: 49,
                fat: 3.2,
                fiber: 2.7,
                sugar: 5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Standard enriched white loaf"
        ),
        
        // Sourdough Bread
        FoodItem(
            id: UUID(),
            name: "Sourdough Bread",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 240,
                protein: 8,
                carbohydrates: 47,
                fat: 1.5,
                fiber: 2.9,
                sugar: 2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Naturally leavened wheat loaf"
        ),
        
        // Rye Bread
        FoodItem(
            id: UUID(),
            name: "Rye Bread",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 259,
                protein: 9,
                carbohydrates: 48,
                fat: 3.3,
                fiber: 5.8,
                sugar: 4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Medium‐dark rye"
        ),
        
        // Multigrain Bread
        FoodItem(
            id: UUID(),
            name: "Multigrain Bread",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 12,
                carbohydrates: 42,
                fat: 4.5,
                fiber: 6,
                sugar: 4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Blend of several whole grains"
        ),
        
        // Baguette
        FoodItem(
            id: UUID(),
            name: "Baguette",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 270,
                protein: 9,
                carbohydrates: 57,
                fat: 0.6,
                fiber: 2.5,
                sugar: 1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Classic French white baguette"
        ),
        
        // Ciabatta
        FoodItem(
            id: UUID(),
            name: "Ciabatta",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 265,
                protein: 9.5,
                carbohydrates: 52,
                fat: 4,
                fiber: 2.7,
                sugar: 1.5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Italian crusty loaf"
        ),
        
        // Pita Bread
        FoodItem(
            id: UUID(),
            name: "Pita Bread",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 275,
                protein: 9,
                carbohydrates: 55,
                fat: 1,
                fiber: 6,
                sugar: 1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Standard white pita"
        ),
        
        // Bagel (Plain)
        FoodItem(
            id: UUID(),
            name: "Bagel (Plain)",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 260,
                protein: 10,
                carbohydrates: 51,
                fat: 1.5,
                fiber: 2.5,
                sugar: 7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Boiled-then-baked bagel"
        ),
        
        // English Muffin
        FoodItem(
            id: UUID(),
            name: "English Muffin",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 222,
                protein: 8,
                carbohydrates: 43,
                fat: 1.5,
                fiber: 2,
                sugar: 4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Toasted breakfast muffin"
        ),
        
        // Cornbread
        FoodItem(
            id: UUID(),
            name: "Cornbread",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 330,
                protein: 7,
                carbohydrates: 57,
                fat: 8,
                fiber: 2.5,
                sugar: 15
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Traditional Southern cornbread"
        ),
        
        // Brioche
        FoodItem(
            id: UUID(),
            name: "Brioche",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 330,
                protein: 9,
                carbohydrates: 54,
                fat: 9,
                fiber: 2.5,
                sugar: 10
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Rich egg-and-butter loaf"
        ),
        
        // BLT Sandwich
        FoodItem(
            id: UUID(),
            name: "BLT Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 15,
                carbohydrates: 30,
                fat: 20,
                fiber: 3,
                sugar: 4
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Bacon-lettuce-tomato on toast"
        ),
        
        // Turkey Sandwich
        FoodItem(
            id: UUID(),
            name: "Turkey Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 320,
                protein: 24,
                carbohydrates: 30,
                fat: 10,
                fiber: 3,
                sugar: 4
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Roast turkey, lettuce & mustard"
        ),
        
        // Grilled Cheese Sandwich
        FoodItem(
            id: UUID(),
            name: "Grilled Cheese Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 400,
                protein: 12,
                carbohydrates: 30,
                fat: 26,
                fiber: 2,
                sugar: 4
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Pan-grilled with cheddar"
        ),
        
        // PB&J Sandwich
        FoodItem(
            id: UUID(),
            name: "PB&J Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 430,
                protein: 12,
                carbohydrates: 50,
                fat: 18,
                fiber: 4,
                sugar: 20
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Peanut butter & jam classic"
        ),
        
        // Ham & Cheese Sandwich
        FoodItem(
            id: UUID(),
            name: "Ham & Cheese Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 360,
                protein: 20,
                carbohydrates: 30,
                fat: 18,
                fiber: 2,
                sugar: 4
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Smoked ham and Swiss"
        ),
        
        // Egg Salad Sandwich
        FoodItem(
            id: UUID(),
            name: "Egg Salad Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 370,
                protein: 16,
                carbohydrates: 28,
                fat: 22,
                fiber: 2,
                sugar: 4
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Chopped eggs with mayo"
        ),
        
        // Tuna Salad Sandwich
        FoodItem(
            id: UUID(),
            name: "Tuna Salad Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 22,
                carbohydrates: 29,
                fat: 15,
                fiber: 3,
                sugar: 5
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Albacore tuna with light mayo"
        ),
        
        // Club Sandwich
        FoodItem(
            id: UUID(),
            name: "Club Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 420,
                protein: 26,
                carbohydrates: 32,
                fat: 21,
                fiber: 3,
                sugar: 6
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Triple-layer turkey-ham-bacon"
        ),
        
        // Reuben Sandwich
        FoodItem(
            id: UUID(),
            name: "Reuben Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 500,
                protein: 25,
                carbohydrates: 40,
                fat: 28,
                fiber: 4,
                sugar: 5
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Corned beef, sauerkraut, rye"
        ),
        
        // Chicken Salad Sandwich
        FoodItem(
            id: UUID(),
            name: "Chicken Salad Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 380,
                protein: 24,
                carbohydrates: 30,
                fat: 18,
                fiber: 3,
                sugar: 4
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Diced chicken & light mayo"
        ),
        
        // Veggie Sandwich
        FoodItem(
            id: UUID(),
            name: "Veggie Sandwich",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 300,
                protein: 10,
                carbohydrates: 40,
                fat: 10,
                fiber: 8,
                sugar: 6
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Whole-grain bread, mixed veg"
        ),
        
        // Roast Beef Sandwich
        FoodItem(
            id: UUID(),
            name: "Roast Beef Sandwich",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 370,
                protein: 28,
                carbohydrates: 30,
                fat: 14,
                fiber: 3,
                sugar: 5
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Lean roast beef on roll"
        ),
        
        // Caprese Sandwich
        FoodItem(
            id: UUID(),
            name: "Caprese Sandwich",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 15,
                carbohydrates: 36,
                fat: 16,
                fiber: 3,
                sugar: 4
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Mozzarella, tomato & basil"
        )
    ]
} 