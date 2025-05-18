import Foundation
import SwiftUI

struct BeverageFoodItems {
    static let foods: [FoodItem] = [
        // Water
        FoodItem(
            id: UUID(),
            name: "Water",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 0,
                protein: 0,
                carbohydrates: 0,
                fat: 0,
                fiber: 0,
                sugar: 0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Plain drinking water",
            nameFr: "Eau",
            nameEs: "Agua",
            nameHe: "מים",
            notesFr: "Eau potable ordinaire",
            notesEs: "Agua potable simple",
            notesHe: "מי שתייה רגילים"
        ),
        
        // Coffee
        FoodItem(
            id: UUID(),
            name: "Coffee",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 2,
                protein: 0.3,
                carbohydrates: 0,
                fat: 0,
                fiber: 0,
                sugar: 0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Black coffee without sugar",
            nameFr: "Café",
            nameEs: "Café",
            nameHe: "קפה",
            notesFr: "Café noir sans sucre",
            notesEs: "Café negro sin azúcar",
            notesHe: "קפה שחור ללא סוכר"
        ),
        
        // Green Tea
        FoodItem(
            id: UUID(),
            name: "Green Tea",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 2,
                protein: 0,
                carbohydrates: 0.5,
                fat: 0,
                fiber: 0,
                sugar: 0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Unsweetened green tea",
            nameFr: "Thé Vert",
            nameEs: "Té Verde",
            nameHe: "תה ירוק",
            notesFr: "Thé vert non sucré",
            notesEs: "Té verde sin azúcar",
            notesHe: "תה ירוק ללא סוכר"
        ),
        
        // Black Tea
        FoodItem(
            id: UUID(),
            name: "Black Tea",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 2,
                protein: 0,
                carbohydrates: 0.5,
                fat: 0,
                fiber: 0,
                sugar: 0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Unsweetened black tea",
            nameFr: "Thé Noir",
            nameEs: "Té Negro",
            nameHe: "תה שחור",
            notesFr: "Thé noir non sucré",
            notesEs: "Té negro sin azúcar",
            notesHe: "תה שחור ללא סוכר"
        ),
        
        // Orange Juice
        FoodItem(
            id: UUID(),
            name: "Orange Juice",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 112,
                protein: 1.7,
                carbohydrates: 25.8,
                fat: 0.5,
                fiber: 0.5,
                sugar: 20.8
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Fresh squeezed orange juice",
            nameFr: "Jus d'Orange",
            nameEs: "Zumo de Naranja",
            nameHe: "מיץ תפוזים",
            notesFr: "Jus d'orange fraîchement pressé",
            notesEs: "Zumo de naranja recién exprimido",
            notesHe: "מיץ תפוזים סחוט טרי"
        ),
        
        // Apple Juice
        FoodItem(
            id: UUID(),
            name: "Apple Juice",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 114,
                protein: 0.2,
                carbohydrates: 28.0,
                fat: 0.3,
                fiber: 0.2,
                sugar: 24.0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Unsweetened apple juice",
            nameFr: "Jus de Pomme",
            nameEs: "Zumo de Manzana",
            nameHe: "מיץ תפוחים",
            notesFr: "Jus de pomme non sucré",
            notesEs: "Zumo de manzana sin azúcar",
            notesHe: "מיץ תפוחים ללא סוכר"
        ),
        
        // Cranberry Juice
        FoodItem(
            id: UUID(),
            name: "Cranberry Juice",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 116,
                protein: 0.4,
                carbohydrates: 31.0,
                fat: 0.1,
                fiber: 0.2,
                sugar: 30.0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Unsweetened cranberry juice"
        ),
        
        // Milk (Whole)
        FoodItem(
            id: UUID(),
            name: "Milk (Whole, 240ml)",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 149,
                protein: 7.7,
                carbohydrates: 12.0,
                fat: 8.0,
                fiber: 0.0,
                sugar: 12.0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Whole cow's milk"
        ),
        
        // Milk (Skim)
        FoodItem(
            id: UUID(),
            name: "Milk (Skim, 240ml)",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 83,
                protein: 8.3,
                carbohydrates: 12.0,
                fat: 0.2,
                fiber: 0.0,
                sugar: 12.0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Skim cow's milk"
        ),
        
        // Almond Milk (Unsweetened)
        FoodItem(
            id: UUID(),
            name: "Almond Milk (Unsweetened)",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 30,
                protein: 1.0,
                carbohydrates: 1.0,
                fat: 2.5,
                fiber: 0.5,
                sugar: 0.0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Unsweetened almond milk"
        ),
        
        // Soy Milk (Unsweetened)
        FoodItem(
            id: UUID(),
            name: "Soy Milk (Unsweetened)",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 80,
                protein: 7.0,
                carbohydrates: 4.0,
                fat: 4.0,
                fiber: 1.0,
                sugar: 1.0
            ),
            servingSize: 240,
            servingUnit: "ml",
            isCustom: true,
            notes: "Unsweetened soy milk"
        ),
        
        // Coca-Cola
        FoodItem(
            id: UUID(),
            name: "Coca-Cola",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 140,
                protein: 0,
                carbohydrates: 39.0,
                fat: 0,
                fiber: 0,
                sugar: 39.0
            ),
            servingSize: 355,
            servingUnit: "ml",
            isCustom: true,
            notes: "Regular Coca-Cola"
        ),
        
        // Pepsi
        FoodItem(
            id: UUID(),
            name: "Pepsi",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 0,
                carbohydrates: 41.0,
                fat: 0,
                fiber: 0,
                sugar: 41.0
            ),
            servingSize: 355,
            servingUnit: "ml",
            isCustom: true,
            notes: "Regular Pepsi"
        ),
        
        // Sprite
        FoodItem(
            id: UUID(),
            name: "Sprite",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 140,
                protein: 0,
                carbohydrates: 38.0,
                fat: 0,
                fiber: 0,
                sugar: 38.0
            ),
            servingSize: 355,
            servingUnit: "ml",
            isCustom: true,
            notes: "Lemon-lime flavored soda"
        ),
        
        // Dr Pepper
        FoodItem(
            id: UUID(),
            name: "Dr Pepper",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 0,
                carbohydrates: 40.0,
                fat: 0,
                fiber: 0,
                sugar: 40.0
            ),
            servingSize: 355,
            servingUnit: "ml",
            isCustom: true,
            notes: "Unique blend of 23 flavors"
        ),
        
        // Mountain Dew
        FoodItem(
            id: UUID(),
            name: "Mountain Dew",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 170,
                protein: 0,
                carbohydrates: 46.0,
                fat: 0,
                fiber: 0,
                sugar: 46.0
            ),
            servingSize: 355,
            servingUnit: "ml",
            isCustom: true,
            notes: "Citrus-flavored soda"
        ),
        
        // Gatorade (Orange)
        FoodItem(
            id: UUID(),
            name: "Gatorade (Orange)",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 80,
                protein: 0,
                carbohydrates: 21.0,
                fat: 0,
                fiber: 0,
                sugar: 21.0
            ),
            servingSize: 355,
            servingUnit: "ml",
            isCustom: true,
            notes: "Electrolyte sports drink"
        ),
        
        // Red Bull
        FoodItem(
            id: UUID(),
            name: "Red Bull",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 110,
                protein: 1.0,
                carbohydrates: 28.0,
                fat: 0,
                fiber: 0,
                sugar: 27.0
            ),
            servingSize: 250,
            servingUnit: "ml",
            isCustom: true,
            notes: "Energy drink with caffeine"
        ),
        
        // Monster Energy
        FoodItem(
            id: UUID(),
            name: "Monster Energy",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 210,
                protein: 0,
                carbohydrates: 54.0,
                fat: 0,
                fiber: 0,
                sugar: 54.0
            ),
            servingSize: 473,
            servingUnit: "ml",
            isCustom: true,
            notes: "High-caffeine energy drink"
        ),
        
        // LaCroix (Lime)
        FoodItem(
            id: UUID(),
            name: "LaCroix (Lime)",
            category: .beverages,
            nutritionalInfo: NutritionalInfo(
                calories: 0,
                protein: 0,
                carbohydrates: 0,
                fat: 0,
                fiber: 0,
                sugar: 0
            ),
            servingSize: 355,
            servingUnit: "ml",
            isCustom: true,
            notes: "Flavored sparkling water without sweeteners"
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