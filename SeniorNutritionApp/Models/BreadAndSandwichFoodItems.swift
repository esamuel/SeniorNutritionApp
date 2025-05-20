import Foundation
import SwiftUI

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
            notes: "Average nutrition per 100 g loaf slice",
            nameFr: "Pain de Blé Complet",
            nameEs: "Pan Integral de Trigo",
            nameHe: "לחם חיטה מלאה",
            notesFr: "Valeur nutritionnelle moyenne pour 100 g de tranche",
            notesEs: "Nutrición promedio por 100 g de rebanada",
            notesHe: "ערך תזונתי ממוצע ל-100 גרם פרוסה"
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
            notes: "Standard enriched white loaf",
            nameFr: "Pain Blanc",
            nameEs: "Pan Blanco",
            nameHe: "לחם לבן",
            notesFr: "Pain blanc enrichi standard",
            notesEs: "Pan blanco enriquecido estándar",
            notesHe: "כיכר לחם לבן מועשר סטנדרטי"
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
            notes: "Naturally leavened wheat loaf",
            nameFr: "Pain au Levain",
            nameEs: "Pan de Masa Madre",
            nameHe: "לחם מחמצת",
            notesFr: "Pain de blé à levain naturel",
            notesEs: "Pan de trigo con levadura natural",
            notesHe: "כיכר חיטה מותססת בטבעיות"
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
            notes: "Medium‐dark rye",
            nameFr: "Pain de Seigle",
            nameEs: "Pan de Centeno",
            nameHe: "לחם שיפון",
            notesFr: "Seigle moyen-foncé",
            notesEs: "Centeno medio-oscuro",
            notesHe: "שיפון בינוני-כהה"
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
            notes: "Blend of several whole grains",
            nameFr: "Pain Multicéréales",
            nameEs: "Pan Multigrano",
            nameHe: "לחם רב-דגנים",
            notesFr: "Mélange de plusieurs céréales complètes",
            notesEs: "Mezcla de varios granos enteros",
            notesHe: "תערובת של מספר דגנים מלאים"
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
            notes: "Classic French white baguette",
            nameFr: "Baguette",
            nameEs: "Baguette",
            nameHe: "באגט",
            notesFr: "Baguette blanche française classique",
            notesEs: "Baguette blanca francesa clásica",
            notesHe: "באגט צרפתי לבן קלאסי"
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
            notes: "Italian crusty loaf",
            nameFr: "Ciabatta",
            nameEs: "Ciabatta",
            nameHe: "צ'אבטה",
            notesFr: "Pain croustillant italien",
            notesEs: "Pan crujiente italiano",
            notesHe: "לחם איטלקי פריך"
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
            notes: "Standard white pita",
            nameFr: "Pain Pita",
            nameEs: "Pan de Pita",
            nameHe: "פיתה",
            notesFr: "Pita blanche standard",
            notesEs: "Pita blanca estándar",
            notesHe: "פיתה לבנה רגילה"
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
            notes: "Boiled-then-baked bagel",
            nameFr: "Bagel (Nature)",
            nameEs: "Bagel (Natural)",
            nameHe: "בייגל (רגיל)",
            notesFr: "Bagel bouilli puis cuit au four",
            notesEs: "Bagel hervido y luego horneado",
            notesHe: "בייגל מבושל ואפוי"
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
            notes: "Toasted breakfast muffin",
            nameFr: "Muffin Anglais",
            nameEs: "Muffin Inglés",
            nameHe: "מאפין אנגלי",
            notesFr: "Muffin de petit-déjeuner grillé",
            notesEs: "Muffin tostado para desayuno",
            notesHe: "מאפין קלוי לארוחת בוקר"
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
            notes: "Traditional Southern cornbread",
            nameFr: "Pain de Maïs",
            nameEs: "Pan de Maíz",
            nameHe: "לחם תירס",
            notesFr: "Pain de maïs traditionnel du Sud américain",
            notesEs: "Pan de maíz tradicional del Sur",
            notesHe: "לחם תירס דרומי מסורתי"
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
            notes: "Rich egg-and-butter loaf",
            nameFr: "Brioche",
            nameEs: "Brioche",
            nameHe: "בריוש",
            notesFr: "Pain riche aux œufs et au beurre",
            notesEs: "Pan rico en huevo y mantequilla",
            notesHe: "לחם עשיר בביצים וחמאה"
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
            notes: "Bacon-lettuce-tomato on toast",
            nameFr: "Sandwich BLT",
            nameEs: "Sándwich BLT",
            nameHe: "סנדוויץ' בייקון-חסה-עגבנייה",
            notesFr: "Bacon-laitue-tomate sur pain grillé",
            notesEs: "Tocino-lechuga-tomate en pan tostado",
            notesHe: "בייקון-חסה-עגבנייה על טוסט"
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
            notes: "Roast turkey, lettuce & mustard",
            nameFr: "Sandwich à la Dinde",
            nameEs: "Sándwich de Pavo",
            nameHe: "סנדוויץ' הודו",
            notesFr: "Dinde rôtie, laitue et moutarde",
            notesEs: "Pavo asado, lechuga y mostaza",
            notesHe: "הודו צלוי, חסה וחרדל"
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
            notes: "Pan-grilled with cheddar",
            nameFr: "Sandwich au Fromage Grillé",
            nameEs: "Sándwich de Queso a la Plancha",
            nameHe: "סנדוויץ' גבינה מטוגן",
            notesFr: "Grillé à la poêle avec du cheddar",
            notesEs: "A la plancha con queso cheddar",
            notesHe: "מטוגן במחבת עם גבינת צ'דר"
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
            notes: "Peanut butter & jam classic",
            nameFr: "Sandwich au Beurre de Cacahuète et Confiture",
            nameEs: "Sándwich de Mantequilla de Cacahuete y Mermelada",
            nameHe: "סנדוויץ' חמאת בוטנים וריבה",
            notesFr: "Classique au beurre de cacahuète et confiture",
            notesEs: "Clásico de mantequilla de cacahuete y mermelada",
            notesHe: "קלאסיקת חמאת בוטנים וריבה"
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
            notes: "Smoked ham and Swiss",
            nameFr: "Sandwich Jambon-Fromage",
            nameEs: "Sándwich de Jamón y Queso",
            nameHe: "סנדוויץ' נקניק וגבינה",
            notesFr: "Jambon fumé et fromage suisse",
            notesEs: "Jamón ahumado y queso suizo",
            notesHe: "נקניק מעושן וגבינה שוויצרית"
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
            notes: "Chopped eggs with mayo",
            nameFr: "Sandwich à la Salade d'Œufs",
            nameEs: "Sándwich de Ensalada de Huevo",
            nameHe: "סנדוויץ' סלט ביצים",
            notesFr: "Œufs hachés avec mayonnaise",
            notesEs: "Huevos picados con mayonesa",
            notesHe: "ביצים קצוצות עם מיונז"
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
            notes: "Albacore tuna with light mayo",
            nameFr: "Sandwich à la Salade de Thon",
            nameEs: "Sándwich de Ensalada de Atún",
            nameHe: "סנדוויץ' סלט טונה",
            notesFr: "Thon blanc avec mayonnaise légère",
            notesEs: "Atún blanco con mayonesa ligera",
            notesHe: "טונה לבנה עם מיונז קל"
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
            notes: "Triple-layer turkey-ham-bacon",
            nameFr: "Sandwich Club",
            nameEs: "Sándwich Club",
            nameHe: "סנדוויץ' קלאב",
            notesFr: "Triple étage dinde-jambon-bacon",
            notesEs: "Triple capa de pavo-jamón-tocino",
            notesHe: "שלוש שכבות של הודו-נקניק-בייקון"
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
            notes: "Corned beef, sauerkraut, rye",
            nameFr: "Sandwich Reuben",
            nameEs: "Sándwich Reuben",
            nameHe: "סנדוויץ' ראובן",
            notesFr: "Bœuf salé, choucroute, pain de seigle",
            notesEs: "Carne en conserva, chucrut, pan de centeno",
            notesHe: "בשר מקורנד, כרוב כבוש, לחם שיפון"
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
            notes: "Diced chicken & light mayo",
            nameFr: "Sandwich à la Salade de Poulet",
            nameEs: "Sándwich de Ensalada de Pollo",
            nameHe: "סנדוויץ' סלט עוף",
            notesFr: "Poulet en dés et mayonnaise légère",
            notesEs: "Pollo en cubitos y mayonesa ligera",
            notesHe: "עוף קצוץ ומיונז קל"
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
            notes: "Whole-grain bread, mixed veg",
            nameFr: "Sandwich aux Légumes",
            nameEs: "Sándwich Vegetariano",
            nameHe: "סנדוויץ' ירקות",
            notesFr: "Pain complet, légumes variés",
            notesEs: "Pan integral, vegetales mixtos",
            notesHe: "לחם מחיטה מלאה, ירקות מעורבים"
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
            notes: "Lean roast beef on roll",
            nameFr: "Sandwich au Rôti de Bœuf",
            nameEs: "Sándwich de Carne Asada",
            nameHe: "סנדוויץ' בשר בקר צלוי",
            notesFr: "Rôti de bœuf maigre sur petit pain",
            notesEs: "Carne asada magra en panecillo",
            notesHe: "בשר בקר רזה צלוי בלחמנייה"
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
            notes: "Mozzarella, tomato & basil",
            nameFr: "Sandwich Caprese",
            nameEs: "Sándwich Caprese",
            nameHe: "סנדוויץ' קפרזה",
            notesFr: "Mozzarella, tomate et basilic",
            notesEs: "Mozzarella, tomate y albahaca",
            notesHe: "מוצרלה, עגבניות וריחן"
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