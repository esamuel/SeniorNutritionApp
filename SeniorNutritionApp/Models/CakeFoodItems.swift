import Foundation

struct CakeFoodItems {
    static let foods: [FoodItem] = [
        // Pound Cake
        FoodItem(
            id: UUID(),
            name: "Pound Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 420,
                protein: 5,
                carbohydrates: 50,
                fat: 22,
                fiber: 0.6,
                sugar: 30
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Lemon Drizzle Cake
        FoodItem(
            id: UUID(),
            name: "Lemon Drizzle Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 380,
                protein: 4,
                carbohydrates: 57,
                fat: 15,
                fiber: 0.7,
                sugar: 35
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Carrot Cake
        FoodItem(
            id: UUID(),
            name: "Carrot Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 410,
                protein: 5,
                carbohydrates: 50,
                fat: 22,
                fiber: 1.5,
                sugar: 34
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Coffee Cake (Streusel)
        FoodItem(
            id: UUID(),
            name: "Coffee Cake (Streusel)",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 390,
                protein: 4,
                carbohydrates: 55,
                fat: 17,
                fiber: 0.8,
                sugar: 32
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Apple Cake (Apfelkuchen)
        FoodItem(
            id: UUID(),
            name: "Apple Cake (Apfelkuchen)",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 300,
                protein: 3,
                carbohydrates: 45,
                fat: 11,
                fiber: 1.5,
                sugar: 28
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Marble Cake
        FoodItem(
            id: UUID(),
            name: "Marble Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 400,
                protein: 5,
                carbohydrates: 52,
                fat: 20,
                fiber: 0.7,
                sugar: 30
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Angel Food Cake
        FoodItem(
            id: UUID(),
            name: "Angel Food Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 260,
                protein: 9,
                carbohydrates: 57,
                fat: 0,
                fiber: 0,
                sugar: 42
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Victoria Sponge
        FoodItem(
            id: UUID(),
            name: "Victoria Sponge",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 4,
                carbohydrates: 48,
                fat: 15,
                fiber: 0.6,
                sugar: 30
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Fruitcake / Dundee Cake
        FoodItem(
            id: UUID(),
            name: "Fruitcake / Dundee Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 4,
                carbohydrates: 60,
                fat: 9,
                fiber: 3,
                sugar: 45
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Bundt Cake (Lemon)
        FoodItem(
            id: UUID(),
            name: "Bundt Cake (Lemon)",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 380,
                protein: 4,
                carbohydrates: 52,
                fat: 17,
                fiber: 0.7,
                sugar: 33
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Sachertorte
        FoodItem(
            id: UUID(),
            name: "Sachertorte",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 360,
                protein: 5,
                carbohydrates: 52,
                fat: 13,
                fiber: 2,
                sugar: 37
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Genoise with Berries
        FoodItem(
            id: UUID(),
            name: "Genoise with Berries",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 290,
                protein: 6,
                carbohydrates: 45,
                fat: 8,
                fiber: 1,
                sugar: 28
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Ricotta Cheesecake
        FoodItem(
            id: UUID(),
            name: "Ricotta Cheesecake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 330,
                protein: 8,
                carbohydrates: 30,
                fat: 20,
                fiber: 0.3,
                sugar: 22
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Tres Leches Cake
        FoodItem(
            id: UUID(),
            name: "Tres Leches Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 6,
                carbohydrates: 45,
                fat: 14,
                fiber: 0.2,
                sugar: 35
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Coconut Cake
        FoodItem(
            id: UUID(),
            name: "Coconut Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 415,
                protein: 5,
                carbohydrates: 52,
                fat: 20,
                fiber: 2,
                sugar: 34
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Honey Cake (Medovik)
        FoodItem(
            id: UUID(),
            name: "Honey Cake (Medovik)",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 360,
                protein: 4,
                carbohydrates: 57,
                fat: 12,
                fiber: 0.9,
                sugar: 39
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Black Forest Cake
        FoodItem(
            id: UUID(),
            name: "Black Forest Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 340,
                protein: 4,
                carbohydrates: 46,
                fat: 15,
                fiber: 2,
                sugar: 32
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // French Yogurt Cake
        FoodItem(
            id: UUID(),
            name: "French Yogurt Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 295,
                protein: 5,
                carbohydrates: 40,
                fat: 12,
                fiber: 0.6,
                sugar: 25
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Swedish Toscakaka
        FoodItem(
            id: UUID(),
            name: "Swedish Toscakaka",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 410,
                protein: 6,
                carbohydrates: 44,
                fat: 22,
                fiber: 1,
                sugar: 32
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Banana Bread (Loaf Cake)
        FoodItem(
            id: UUID(),
            name: "Banana Bread (Loaf Cake)",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 330,
                protein: 4,
                carbohydrates: 54,
                fat: 11,
                fiber: 2,
                sugar: 32
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Spice Cake
        FoodItem(
            id: UUID(),
            name: "Spice Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 4,
                carbohydrates: 55,
                fat: 12,
                fiber: 1.2,
                sugar: 34
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Semolina-Orange Cake
        FoodItem(
            id: UUID(),
            name: "Semolina-Orange Cake",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 330,
                protein: 4,
                carbohydrates: 52,
                fat: 11,
                fiber: 1,
                sugar: 33
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Almond Flour Torte
        FoodItem(
            id: UUID(),
            name: "Almond Flour Torte",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 420,
                protein: 9,
                carbohydrates: 30,
                fat: 28,
                fiber: 3,
                sugar: 25
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Boston Cream Pie (Cake)
        FoodItem(
            id: UUID(),
            name: "Boston Cream Pie (Cake)",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 330,
                protein: 5,
                carbohydrates: 45,
                fat: 12,
                fiber: 0.5,
                sugar: 30
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        ),
        
        // Kugelhopf (Gugelhupf)
        FoodItem(
            id: UUID(),
            name: "Kugelhopf (Gugelhupf)",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 360,
                protein: 6,
                carbohydrates: 55,
                fat: 12,
                fiber: 1,
                sugar: 28
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice"
        )
    ]
} 