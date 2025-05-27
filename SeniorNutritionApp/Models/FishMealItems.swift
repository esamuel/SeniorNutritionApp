import Foundation

struct FishMealItems {
    static let foods: [FoodItem] = [
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_grilled_salmon_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 206,
                protein: 22,
                carbohydrates: 0,
                fat: 13,
                fiber: 0,
                sugar: 0,
                calcium: 15
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_grilled_salmon_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_baked_cod_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 105,
                protein: 23,
                carbohydrates: 0,
                fat: 1,
                fiber: 0,
                sugar: 0,
                calcium: 16
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_baked_cod_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_tuna_steak_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 132,
                protein: 28,
                carbohydrates: 0,
                fat: 1,
                fiber: 0,
                sugar: 0,
                calcium: 12
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_tuna_steak_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_baked_trout_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 148,
                protein: 21,
                carbohydrates: 0,
                fat: 7,
                fiber: 0,
                sugar: 0,
                calcium: 13
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_baked_trout_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_mackerel_fillet_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 205,
                protein: 19,
                carbohydrates: 0,
                fat: 13,
                fiber: 0,
                sugar: 0,
                calcium: 15
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_mackerel_fillet_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_sardines_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 208,
                protein: 25,
                carbohydrates: 0,
                fat: 12,
                fiber: 0,
                sugar: 0,
                calcium: 382
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_sardines_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_fish_tacos_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 220,
                protein: 17,
                carbohydrates: 25,
                fat: 7,
                fiber: 2,
                sugar: 2,
                calcium: 50
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_fish_tacos_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_salmon_patties_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 180,
                protein: 19,
                carbohydrates: 7,
                fat: 8,
                fiber: 1,
                sugar: 0,
                calcium: 20
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_salmon_patties_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_haddock_bake_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 130,
                protein: 24,
                carbohydrates: 1,
                fat: 3,
                fiber: 0,
                sugar: 0,
                calcium: 18
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_haddock_bake_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_mediterranean_bream_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 190,
                protein: 20,
                carbohydrates: 3,
                fat: 9,
                fiber: 0,
                sugar: 1,
                calcium: 25
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_mediterranean_bream_note", comment: "")
        ),
        FoodItem(
            id: UUID(),
            name: NSLocalizedString("meal_miso_glazed_cod_name", comment: ""),
            category: .fishMeals,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 21,
                carbohydrates: 5,
                fat: 5,
                fiber: 0,
                sugar: 3,
                calcium: 18
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: NSLocalizedString("meal_miso_glazed_cod_note", comment: "")
        )
    ]
} 