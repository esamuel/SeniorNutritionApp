import Foundation

struct PastaFoodItems {
    static let foods: [FoodItem] = [
        // Spaghetti with Marinara Sauce
        FoodItem(
            id: UUID(),
            name: "Spaghetti with Marinara Sauce",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 320,
                protein: 12,
                carbohydrates: 64,
                fat: 3,
                fiber: 4,
                sugar: 8,
                vitaminA: 600, // estimated
                vitaminC: 13.5, // 15% of 90mg DV
                vitaminD: 0,
                vitaminE: 1.5, // estimated
                vitaminK: 10, // estimated
                thiamin: 0.2, // estimated
                riboflavin: 0.2, // estimated
                niacin: 2, // estimated
                vitaminB6: 0.2, // estimated
                vitaminB12: 0,
                folate: 40, // estimated
                calcium: 60, // estimated
                iron: 1.2, // 15% of 8mg DV
                magnesium: 40, // estimated
                phosphorus: 100, // estimated
                potassium: 400, // estimated
                sodium: 590,
                zinc: 1, // estimated
                selenium: 10, // estimated
                omega3: 0.1, // estimated
                omega6: 0.2, // estimated
                cholesterol: 0
            ),
            servingSize: 250,
            servingUnit: "g",
            isCustom: false,
            notes: "Low in fat and relatively low in calories. Good source of complex carbohydrates for energy. Tomato sauce provides lycopene, an antioxidant."
        ),
        
        // Fettuccine Alfredo
        FoodItem(
            id: UUID(),
            name: "Fettuccine Alfredo",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 670,
                protein: 19,
                carbohydrates: 50,
                fat: 43,
                fiber: 2,
                sugar: 3,
                vitaminA: 1500, // 30% of 5000 IU DV
                vitaminC: 0,
                vitaminD: 20, // estimated
                vitaminE: 2, // estimated
                vitaminK: 5, // estimated
                thiamin: 0.3, // estimated
                riboflavin: 0.3, // estimated
                niacin: 2, // estimated
                vitaminB6: 0.1, // estimated
                vitaminB12: 0.5, // estimated
                folate: 20, // estimated
                calcium: 300, // 25% of 1200mg DV
                iron: 1, // estimated
                magnesium: 30, // estimated
                phosphorus: 200, // estimated
                potassium: 200, // estimated
                sodium: 950,
                zinc: 1.5, // estimated
                selenium: 15, // estimated
                omega3: 0.2, // estimated
                omega6: 1, // estimated
                cholesterol: 80 // estimated
            ),
            servingSize: 250,
            servingUnit: "g",
            isCustom: false,
            notes: "Good source of calcium from cream and cheese. Very high in calories and saturated fat. Can contribute to elevated cholesterol levels."
        ),
        
        // Whole Wheat Pasta Primavera
        FoodItem(
            id: UUID(),
            name: "Whole Wheat Pasta Primavera",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 14,
                carbohydrates: 60,
                fat: 8,
                fiber: 9,
                sugar: 6,
                vitaminA: 1750, // 35% of 5000 IU DV
                vitaminC: 40.5, // 45% of 90mg DV
                vitaminD: 0,
                vitaminE: 3, // estimated
                vitaminK: 30, // estimated
                thiamin: 0.4, // estimated
                riboflavin: 0.3, // estimated
                niacin: 3, // estimated
                vitaminB6: 0.3, // estimated
                vitaminB12: 0,
                folate: 80, // estimated
                calcium: 100, // estimated
                iron: 1.6, // 20% of 8mg DV
                magnesium: 80, // estimated
                phosphorus: 150, // estimated
                potassium: 500, // estimated
                sodium: 400, // estimated
                zinc: 1.5, // estimated
                selenium: 20, // estimated
                omega3: 0.3, // estimated
                omega6: 1, // estimated
                cholesterol: 0
            ),
            servingSize: 250,
            servingUnit: "g",
            isCustom: false,
            notes: "Rich in fiber from whole wheat pasta and vegetables. Excellent source of vitamins A and C from mixed vegetables. High in antioxidants and phytonutrients."
        ),
        
        // Shrimp Scampi with Linguine
        FoodItem(
            id: UUID(),
            name: "Shrimp Scampi with Linguine",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 440,
                protein: 24,
                carbohydrates: 52,
                fat: 16,
                fiber: 2,
                sugar: 2,
                vitaminA: 300, // estimated
                vitaminC: 5, // estimated
                vitaminD: 40, // estimated
                vitaminE: 2, // estimated
                vitaminK: 5, // estimated
                thiamin: 0.2, // estimated
                riboflavin: 0.2, // estimated
                niacin: 3, // estimated
                vitaminB6: 0.3, // estimated
                vitaminB12: 1.2, // 50% of 2.4mcg DV
                folate: 30, // estimated
                calcium: 80, // estimated
                iron: 1.2, // 15% of 8mg DV
                magnesium: 50, // estimated
                phosphorus: 200, // estimated
                potassium: 300, // estimated
                sodium: 800,
                zinc: 1.5, // estimated
                selenium: 41.25, // 75% of 55mcg DV
                omega3: 0.5, // estimated
                omega6: 0.8, // estimated
                cholesterol: 150 // estimated
            ),
            servingSize: 250,
            servingUnit: "g",
            isCustom: false,
            notes: "Excellent source of lean protein from shrimp. Rich in selenium and vitamin B12. Contains heart-healthy garlic. Good source of omega-3 fatty acids."
        ),
        
        // Pesto Pasta with Pine Nuts
        FoodItem(
            id: UUID(),
            name: "Pesto Pasta with Pine Nuts",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 490,
                protein: 15,
                carbohydrates: 52,
                fat: 25,
                fiber: 3,
                sugar: 3,
                vitaminA: 500, // estimated
                vitaminC: 5, // estimated
                vitaminD: 0,
                vitaminE: 3.75, // 25% of 15mg DV
                vitaminK: 132, // 110% of 120mcg DV
                thiamin: 0.3, // estimated
                riboflavin: 0.2, // estimated
                niacin: 2, // estimated
                vitaminB6: 0.2, // estimated
                vitaminB12: 0.2, // estimated
                folate: 40, // estimated
                calcium: 150, // estimated
                iron: 2, // estimated
                magnesium: 80, // estimated
                phosphorus: 200, // estimated
                potassium: 300, // estimated
                sodium: 600, // estimated
                zinc: 2, // estimated
                selenium: 24.75, // 45% of 55mcg DV
                omega3: 1, // estimated
                omega6: 5, // estimated
                cholesterol: 10 // estimated
            ),
            servingSize: 250,
            servingUnit: "g",
            isCustom: false,
            notes: "Contains healthy fats from olive oil, pine nuts, and sometimes walnuts. Rich in antioxidants from basil and olive oil. Good source of vitamin K for bone health."
        )
    ]
}
