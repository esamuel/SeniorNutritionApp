import Foundation

struct SnackFoodItems {
    static let foods: [FoodItem] = [
        // Lay's Classic Potato Chips
        FoodItem(
            id: UUID(),
            name: "Lay's Classic Potato Chips",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 2,
                carbohydrates: 15,
                fat: 10,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Regular potato chips"
        ),
        
        // Doritos Nacho Cheese
        FoodItem(
            id: UUID(),
            name: "Doritos Nacho Cheese",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 2,
                carbohydrates: 18,
                fat: 8,
                fiber: 1,
                sugar: 1
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Flavored tortilla chips"
        ),
        
        // Cheetos Crunchy
        FoodItem(
            id: UUID(),
            name: "Cheetos Crunchy",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 2,
                carbohydrates: 13,
                fat: 10,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Cheese-flavored cornmeal snack"
        ),
        
        // Ritz Crackers
        FoodItem(
            id: UUID(),
            name: "Ritz Crackers",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 79,
                protein: 1,
                carbohydrates: 10,
                fat: 4,
                fiber: 0,
                sugar: 1
            ),
            servingSize: 15,
            servingUnit: "g",
            isCustom: true,
            notes: "Buttery round crackers"
        ),
        
        // Goldfish Cheddar Crackers
        FoodItem(
            id: UUID(),
            name: "Goldfish Cheddar Crackers",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 140,
                protein: 3,
                carbohydrates: 20,
                fat: 5,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 30,
            servingUnit: "g",
            isCustom: true,
            notes: "Cheddar-flavored fish-shaped crackers"
        ),
        
        // Nature Valley Crunchy Granola Bars
        FoodItem(
            id: UUID(),
            name: "Nature Valley Crunchy Granola Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 190,
                protein: 4,
                carbohydrates: 29,
                fat: 7,
                fiber: 2,
                sugar: 11
            ),
            servingSize: 42,
            servingUnit: "g",
            isCustom: true,
            notes: "Oats and honey flavor"
        ),
        
        // Kind Bars
        FoodItem(
            id: UUID(),
            name: "Kind Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 200,
                protein: 6,
                carbohydrates: 16,
                fat: 14,
                fiber: 7,
                sugar: 5
            ),
            servingSize: 40,
            servingUnit: "g",
            isCustom: true,
            notes: "Nut and fruit bar"
        ),
        
        // Clif Bars
        FoodItem(
            id: UUID(),
            name: "Clif Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 10,
                carbohydrates: 44,
                fat: 6,
                fiber: 4,
                sugar: 20
            ),
            servingSize: 68,
            servingUnit: "g",
            isCustom: true,
            notes: "Energy bar with oats and chocolate chips"
        ),
        
        // Snickers Bar
        FoodItem(
            id: UUID(),
            name: "Snickers Bar",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 4,
                carbohydrates: 33,
                fat: 12,
                fiber: 1,
                sugar: 27
            ),
            servingSize: 52,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate bar with nougat, caramel, and peanuts"
        ),
        
        // Reese's Peanut Butter Cups
        FoodItem(
            id: UUID(),
            name: "Reese's Peanut Butter Cups",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 210,
                protein: 5,
                carbohydrates: 24,
                fat: 13,
                fiber: 1,
                sugar: 21
            ),
            servingSize: 42,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate cups filled with peanut butter"
        ),
        
        // M&M's Milk Chocolate
        FoodItem(
            id: UUID(),
            name: "M&M's Milk Chocolate",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 240,
                protein: 2,
                carbohydrates: 34,
                fat: 10,
                fiber: 1,
                sugar: 31
            ),
            servingSize: 47,
            servingUnit: "g",
            isCustom: true,
            notes: "Colorful candy-coated chocolate pieces"
        ),
        
        // Twix Bar
        FoodItem(
            id: UUID(),
            name: "Twix Bar",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 2,
                carbohydrates: 34,
                fat: 12,
                fiber: 1,
                sugar: 28
            ),
            servingSize: 50,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate-covered caramel and cookie bar"
        ),
        
        // Oreo Cookies
        FoodItem(
            id: UUID(),
            name: "Oreo Cookies",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 1,
                carbohydrates: 25,
                fat: 7,
                fiber: 1,
                sugar: 14
            ),
            servingSize: 34,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate sandwich cookies with cream filling"
        ),
        
        // Cheez-It Crackers
        FoodItem(
            id: UUID(),
            name: "Cheez-It Crackers",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 4,
                carbohydrates: 17,
                fat: 8,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 30,
            servingUnit: "g",
            isCustom: true,
            notes: "Cheddar cheese-flavored square crackers"
        ),
        
        // Pringles Original
        FoodItem(
            id: UUID(),
            name: "Pringles Original",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 1,
                carbohydrates: 16,
                fat: 9,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Stackable potato crisps"
        ),
        
        // Pop-Tarts Frosted Strawberry
        FoodItem(
            id: UUID(),
            name: "Pop-Tarts Frosted Strawberry",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 200,
                protein: 2,
                carbohydrates: 38,
                fat: 5,
                fiber: 1,
                sugar: 16
            ),
            servingSize: 52,
            servingUnit: "g",
            isCustom: true,
            notes: "Frosted toaster pastry with strawberry filling"
        ),
        
        // Planters Salted Peanuts
        FoodItem(
            id: UUID(),
            name: "Planters Salted Peanuts",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 170,
                protein: 7,
                carbohydrates: 5,
                fat: 14,
                fiber: 2,
                sugar: 1
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Roasted and salted peanuts"
        ),
        
        // Slim Jim Original
        FoodItem(
            id: UUID(),
            name: "Slim Jim Original",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 6,
                carbohydrates: 2,
                fat: 14,
                fiber: 0,
                sugar: 1
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Smoked meat stick"
        ),
        
        // Jack Link's Beef Jerky
        FoodItem(
            id: UUID(),
            name: "Jack Link's Beef Jerky",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 80,
                protein: 11,
                carbohydrates: 6,
                fat: 1,
                fiber: 0,
                sugar: 5
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Dried and seasoned beef strips"
        ),
        
        // Quaker Chewy Granola Bars
        FoodItem(
            id: UUID(),
            name: "Quaker Chewy Granola Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 100,
                protein: 1,
                carbohydrates: 17,
                fat: 3,
                fiber: 1,
                sugar: 7
            ),
            servingSize: 24,
            servingUnit: "g",
            isCustom: true,
            notes: "Granola bar with chocolate chips"
        )
    ]
} 