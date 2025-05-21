import Foundation
import SwiftUI

struct SeedFoodItems {
    static let foods: [FoodItem] = [
        // Chia Seeds
        FoodItem(
            id: UUID(),
            name: "Chia Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 486,
                protein: 16.5,
                carbohydrates: 42.1,
                fat: 30.7,
                fiber: 34.4,
                sugar: 0.7,
                calcium: 631 // High in calcium
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw whole seeds",
            nameFr: "Graines de Chia",
            nameEs: "Semillas de Chía",
            nameHe: "זרעי צ'יה",
            notesFr: "Graines entières crues",
            notesEs: "Semillas enteras crudas",
            notesHe: "זרעים שלמים לא מעובדים"
        ),
        
        // Flax Seeds
        FoodItem(
            id: UUID(),
            name: "Flax Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 534,
                protein: 18.3,
                carbohydrates: 28.9,
                fat: 42.2,
                fiber: 27.3,
                sugar: 1.6,
                calcium: 255 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw whole seeds",
            nameFr: "Graines de Lin",
            nameEs: "Semillas de Lino",
            nameHe: "זרעי פשתן",
            notesFr: "Graines entières crues",
            notesEs: "Semillas enteras crudas",
            notesHe: "זרעים שלמים לא מעובדים"
        ),
        
        // Pumpkin Seeds (Pepitas)
        FoodItem(
            id: UUID(),
            name: "Pumpkin Seeds (Pepitas)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 559,
                protein: 30.2,
                carbohydrates: 10.7,
                fat: 49.0,
                fiber: 6.0,
                sugar: 1.4,
                calcium: 46 // Lower calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Hulled raw kernels",
            nameFr: "Graines de Citrouille (Pepitas)",
            nameEs: "Semillas de Calabaza (Pepitas)",
            nameHe: "גרעיני דלעת (פפיטס)",
            notesFr: "Graines décortiquées crues",
            notesEs: "Semillas peladas crudas",
            notesHe: "גרעינים קלופים לא מעובדים"
        ),
        
        // Sunflower Seeds
        FoodItem(
            id: UUID(),
            name: "Sunflower Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 584,
                protein: 20.8,
                carbohydrates: 20.0,
                fat: 51.5,
                fiber: 8.6,
                sugar: 2.6,
                calcium: 78 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw kernels",
            nameFr: "Graines de Tournesol",
            nameEs: "Semillas de Girasol",
            nameHe: "גרעיני חמנייה",
            notesFr: "Graines crues",
            notesEs: "Semillas crudas",
            notesHe: "גרעינים לא מעובדים"
        ),
        
        // Sesame Seeds (White)
        FoodItem(
            id: UUID(),
            name: "Sesame Seeds (White)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 573,
                protein: 17.7,
                carbohydrates: 23.4,
                fat: 49.7,
                fiber: 11.8,
                sugar: 0.3,
                calcium: 975 // Very high in calcium
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Hulled raw seeds",
            nameFr: "Graines de Sésame (Blanches)",
            nameEs: "Semillas de Sésamo (Blancas)",
            nameHe: "שומשום (לבן)",
            notesFr: "Graines décortiquées crues",
            notesEs: "Semillas peladas crudas",
            notesHe: "זרעים קלופים לא מעובדים"
        ),
        
        // Black Sesame Seeds
        FoodItem(
            id: UUID(),
            name: "Black Sesame Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 565,
                protein: 18.0,
                carbohydrates: 25.0,
                fat: 50.0,
                fiber: 12.0,
                sugar: 0.3,
                calcium: 1160 // Extremely high calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Un‑hulled raw seeds",
            nameFr: "Graines de Sésame Noir",
            nameEs: "Semillas de Sésamo Negro",
            nameHe: "שומשום שחור",
            notesFr: "Graines non décortiquées crues",
            notesEs: "Semillas sin pelar crudas",
            notesHe: "זרעים לא קלופים לא מעובדים"
        ),
        
        // Hemp Seeds (Hulled)
        FoodItem(
            id: UUID(),
            name: "Hemp Seeds (Hulled)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 553,
                protein: 31.6,
                carbohydrates: 8.7,
                fat: 48.8,
                fiber: 4.0,
                sugar: 1.5,
                calcium: 70 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Also called hemp hearts",
            nameFr: "Graines de Chanvre (Décortiquées)",
            nameEs: "Semillas de Cáñamo (Peladas)",
            nameHe: "זרעי המפ (קלופים)",
            notesFr: "Aussi appelées cœurs de chanvre",
            notesEs: "También llamadas corazones de cáñamo",
            notesHe: "נקראים גם לבבות המפ"
        ),
        
        // Poppy Seeds
        FoodItem(
            id: UUID(),
            name: "Poppy Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 525,
                protein: 17.9,
                carbohydrates: 28.1,
                fat: 41.6,
                fiber: 19.5,
                sugar: 2.8,
                calcium: 1438 // Extremely high calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw blue poppy seeds",
            nameFr: "Graines de Pavot",
            nameEs: "Semillas de Amapola",
            nameHe: "זרעי פרג",
            notesFr: "Graines de pavot bleues crues",
            notesEs: "Semillas de amapola azules crudas",
            notesHe: "זרעי פרג כחולים לא מעובדים"
        ),
        
        // Mustard Seeds (Yellow)
        FoodItem(
            id: UUID(),
            name: "Mustard Seeds (Yellow)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 508,
                protein: 26.1,
                carbohydrates: 28.1,
                fat: 36.2,
                fiber: 12.2,
                sugar: 6.1,
                calcium: 266 // Good calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Whole dried seeds",
            nameFr: "Graines de Moutarde (Jaunes)",
            nameEs: "Semillas de Mostaza (Amarillas)",
            nameHe: "זרעי חרדל (צהוב)",
            notesFr: "Graines entières séchées",
            notesEs: "Semillas enteras secas",
            notesHe: "זרעים שלמים מיובשים"
        ),
        
        // Cumin Seeds
        FoodItem(
            id: UUID(),
            name: "Cumin Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 375,
                protein: 17.8,
                carbohydrates: 44.2,
                fat: 22.3,
                fiber: 10.5,
                sugar: 2.3,
                calcium: 931 // High calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Whole dried seeds",
            nameFr: "Graines de Cumin",
            nameEs: "Semillas de Comino",
            nameHe: "זרעי כמון",
            notesFr: "Graines entières séchées",
            notesEs: "Semillas enteras secas",
            notesHe: "זרעים שלמים מיובשים"
        ),
        
        // Coriander Seeds
        FoodItem(
            id: UUID(),
            name: "Coriander Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 298,
                protein: 12.4,
                carbohydrates: 54.0,
                fat: 17.8,
                fiber: 41.9,
                sugar: 0.0,
                calcium: 709 // High calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Whole dried seeds",
            nameFr: "Graines de Coriandre",
            nameEs: "Semillas de Cilantro",
            nameHe: "זרעי כוסברה",
            notesFr: "Graines entières séchées",
            notesEs: "Semillas enteras secas",
            notesHe: "זרעים שלמים מיובשים"
        ),
        
        // Fennel Seeds
        FoodItem(
            id: UUID(),
            name: "Fennel Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 345,
                protein: 15.8,
                carbohydrates: 52.3,
                fat: 14.9,
                fiber: 39.8,
                sugar: 0.0,
                calcium: 1196 // Very high calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Whole dried seeds",
            nameFr: "Graines de Fenouil",
            nameEs: "Semillas de Hinojo",
            nameHe: "זרעי שומר",
            notesFr: "Graines entières séchées",
            notesEs: "Semillas enteras secas",
            notesHe: "זרעים שלמים מיובשים"
        ),
        
        // Fenugreek Seeds
        FoodItem(
            id: UUID(),
            name: "Fenugreek Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 323,
                protein: 23.0,
                carbohydrates: 58.4,
                fat: 6.4,
                fiber: 24.6,
                sugar: 0.0,
                calcium: 176 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Whole dried seeds",
            nameFr: "Graines de Fenugrec",
            nameEs: "Semillas de Fenogreco",
            nameHe: "זרעי חילבה",
            notesFr: "Graines entières séchées",
            notesEs: "Semillas enteras secas",
            notesHe: "זרעים שלמים מיובשים"
        ),
        
        // Nigella Seeds (Black Cumin)
        FoodItem(
            id: UUID(),
            name: "Nigella Seeds (Black Cumin)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 345,
                protein: 16.1,
                carbohydrates: 44.2,
                fat: 22.3,
                fiber: 10.5,
                sugar: 0.0,
                calcium: 570 // Good calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Whole dried seeds",
            nameFr: "Graines de Nigelle (Cumin Noir)",
            nameEs: "Semillas de Nigella (Comino Negro)",
            nameHe: "זרעי קצח (כמון שחור)",
            notesFr: "Graines entières séchées",
            notesEs: "Semillas enteras secas",
            notesHe: "זרעים שלמים מיובשים"
        ),
        
        // Quinoa (Dry Seed)
        FoodItem(
            id: UUID(),
            name: "Quinoa (Dry Seed)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 368,
                protein: 14.1,
                carbohydrates: 64.2,
                fat: 6.1,
                fiber: 7.0,
                sugar: 0.0,
                calcium: 47 // Lower calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Uncooked quinoa grain",
            nameFr: "Quinoa (Graines Sèches)",
            nameEs: "Quinoa (Semilla Seca)",
            nameHe: "קינואה (זרעים יבשים)",
            notesFr: "Grains de quinoa non cuits",
            notesEs: "Granos de quinoa sin cocer",
            notesHe: "גרגירי קינואה לא מבושלים"
        ),
        
        // Amaranth (Raw)
        FoodItem(
            id: UUID(),
            name: "Amaranth (Raw)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 371,
                protein: 13.6,
                carbohydrates: 65.3,
                fat: 7.0,
                fiber: 6.7,
                sugar: 1.7,
                calcium: 159 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Uncooked amaranth grain",
            nameFr: "Amarante (Crue)",
            nameEs: "Amaranto (Crudo)",
            nameHe: "אמרנט (לא מבושל)",
            notesFr: "Grains d'amarante non cuits",
            notesEs: "Granos de amaranto sin cocer",
            notesHe: "גרגירי אמרנט לא מבושלים"
        ),
        
        // Buckwheat Groats (Raw)
        FoodItem(
            id: UUID(),
            name: "Buckwheat Groats (Raw)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 343,
                protein: 13.3,
                carbohydrates: 71.5,
                fat: 3.4,
                fiber: 10.0,
                sugar: 0.9,
                calcium: 18 // Low calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Uncooked hulled groats",
            nameFr: "Gruau de Sarrasin (Cru)",
            nameEs: "Grano de Alforfón (Crudo)",
            nameHe: "כוסמת (לא מבושלת)",
            notesFr: "Gruaux décortiqués non cuits",
            notesEs: "Granos pelados sin cocer",
            notesHe: "גרגירי כוסמת קלופים לא מבושלים"
        ),
        
        // Millet (Raw)
        FoodItem(
            id: UUID(),
            name: "Millet (Raw)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 378,
                protein: 11.0,
                carbohydrates: 72.9,
                fat: 4.2,
                fiber: 8.5,
                sugar: 0.0,
                calcium: 8 // Low calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Uncooked millet grain",
            nameFr: "Millet (Cru)",
            nameEs: "Mijo (Crudo)",
            nameHe: "דוחן (לא מבושל)",
            notesFr: "Grains de millet non cuits",
            notesEs: "Granos de mijo sin cocer",
            notesHe: "גרגירי דוחן לא מבושלים"
        ),
        
        // Perilla Seeds
        FoodItem(
            id: UUID(),
            name: "Perilla Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 517,
                protein: 20.0,
                carbohydrates: 12.3,
                fat: 43.8,
                fiber: 11.2,
                sugar: 0.6,
                calcium: 1071 // Very high calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Also called shiso seeds",
            nameFr: "Graines de Périlla",
            nameEs: "Semillas de Perilla",
            nameHe: "זרעי פרילה",
            notesFr: "Aussi appelées graines de shiso",
            notesEs: "También llamadas semillas de shiso",
            notesHe: "נקראים גם זרעי שיסו"
        ),
        
        // Basil Seeds (Sabja)
        FoodItem(
            id: UUID(),
            name: "Basil Seeds (Sabja)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 480,
                protein: 14.8,
                carbohydrates: 42.6,
                fat: 33.0,
                fiber: 22.6,
                sugar: 0.0,
                calcium: 2130 // Extremely high calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw whole seeds",
            nameFr: "Graines de Basilic (Sabja)",
            nameEs: "Semillas de Albahaca (Sabja)",
            nameHe: "זרעי בזיליקום (סבג'ה)",
            notesFr: "Graines entières crues",
            notesEs: "Semillas enteras crudas",
            notesHe: "זרעים שלמים לא מעובדים"
        ),
        
        // Watermelon Seeds (Roasted)
        FoodItem(
            id: UUID(),
            name: "Watermelon Seeds (Roasted)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 557,
                protein: 28.3,
                carbohydrates: 15.3,
                fat: 47.4,
                fiber: 4.0,
                sugar: 0.2,
                calcium: 108 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Roasted, shelled kernels",
            nameFr: "Graines de Pastèque (Grillées)",
            nameEs: "Semillas de Sandía (Tostadas)",
            nameHe: "גרעיני אבטיח (קלויים)",
            notesFr: "Graines grillées et décortiquées",
            notesEs: "Semillas tostadas y peladas",
            notesHe: "גרעינים קלויים וקלופים"
        ),
        
        // Pine Nuts
        FoodItem(
            id: UUID(),
            name: "Pine Nuts",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 673,
                protein: 13.7,
                carbohydrates: 13.1,
                fat: 68.4,
                fiber: 3.7,
                sugar: 3.6,
                calcium: 16 // Low calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw pinyon seeds",
            nameFr: "Pignons de Pin",
            nameEs: "Piñones",
            nameHe: "צנוברים",
            notesFr: "Graines de pin crues",
            notesEs: "Semillas de pino crudas",
            notesHe: "זרעי אורן לא מעובדים"
        ),
        
        // Sacha Inchi Seeds
        FoodItem(
            id: UUID(),
            name: "Sacha Inchi Seeds",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 533,
                protein: 27.0,
                carbohydrates: 13.0,
                fat: 49.0,
                fiber: 6.0,
                sugar: 3.0,
                calcium: 120 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw Inca peanut seeds",
            nameFr: "Graines de Sacha Inchi",
            nameEs: "Semillas de Sacha Inchi",
            nameHe: "זרעי סאצ'ה אינצ'י",
            notesFr: "Graines d'arachide inca crues",
            notesEs: "Semillas crudas de maní inca",
            notesHe: "זרעי בוטן אינקה לא מעובדים"
        ),
        
        // Teff (Raw)
        FoodItem(
            id: UUID(),
            name: "Teff (Raw)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 367,
                protein: 13.3,
                carbohydrates: 73.1,
                fat: 2.4,
                fiber: 8.0,
                sugar: 1.5,
                calcium: 180 // Good calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Uncooked teff grain",
            nameFr: "Teff (Cru)",
            nameEs: "Teff (Crudo)",
            nameHe: "טף (לא מבושל)",
            notesFr: "Grains de teff non cuits",
            notesEs: "Granos de teff sin cocer",
            notesHe: "גרגירי טף לא מבושלים"
        ),
        
        // Lotus Seeds (Makhana)
        FoodItem(
            id: UUID(),
            name: "Lotus Seeds (Makhana)",
            category: .seeds,
            nutritionalInfo: NutritionalInfo(
                calories: 350,
                protein: 15.0,
                carbohydrates: 65.0,
                fat: 3.0,
                fiber: 7.0,
                sugar: 0.0,
                calcium: 38 // Lower calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Dried fox‑nut seeds",
            nameFr: "Graines de Lotus (Makhana)",
            nameEs: "Semillas de Loto (Makhana)",
            nameHe: "זרעי לוטוס (מאכאנה)",
            notesFr: "Graines de noix d'eau séchées",
            notesEs: "Semillas secas de nuez de zorro",
            notesHe: "זרעי פוקס-נאט מיובשים"
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