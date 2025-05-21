import Foundation
import SwiftUI

struct CondimentFoodItems {
    static let foods: [FoodItem] = [
        // Peanut Butter
        FoodItem(
            id: UUID(),
            name: "Peanut Butter",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 588,
                protein: 25,
                carbohydrates: 20,
                fat: 50,
                fiber: 6,
                sugar: 9,
                calcium: 49
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Unsweetened roasted peanuts ground to a paste",
            nameFr: "Beurre de Cacahuète",
            nameEs: "Mantequilla de Maní",
            nameHe: "חמאת בוטנים",
            notesFr: "Cacahuètes grillées non sucrées réduites en pâte",
            notesEs: "Pasta de maní tostado sin azúcar",
            notesHe: "בוטנים קלויים ללא סוכר טחונים למחית"
        ),
        
        // Almond Butter
        FoodItem(
            id: UUID(),
            name: "Almond Butter",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 614,
                protein: 21,
                carbohydrates: 20,
                fat: 55,
                fiber: 12,
                sugar: 5,
                calcium: 347
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Roasted almonds ground to a smooth butter",
            nameFr: "Beurre d'Amande",
            nameEs: "Mantequilla de Almendra",
            nameHe: "חמאת שקדים",
            notesFr: "Amandes grillées réduites en beurre onctueux",
            notesEs: "Almendras tostadas molidas hasta obtener una mantequilla suave",
            notesHe: "שקדים קלויים טחונים לחמאה חלקה"
        ),
        
        // Cashew Butter
        FoodItem(
            id: UUID(),
            name: "Cashew Butter",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 587,
                protein: 18,
                carbohydrates: 30,
                fat: 49,
                fiber: 3,
                sugar: 5,
                calcium: 45
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Creamy spread made from cashews",
            nameFr: "Beurre de Cajou",
            nameEs: "Mantequilla de Anacardo",
            nameHe: "חמאת קשיו",
            notesFr: "Tartinade crémeuse à base de noix de cajou",
            notesEs: "Crema para untar hecha de anacardos",
            notesHe: "ממרח קרמי עשוי מאגוזי קשיו"
        ),
        
        // Sunflower Seed Butter
        FoodItem(
            id: UUID(),
            name: "Sunflower Seed Butter",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 617,
                protein: 21,
                carbohydrates: 22,
                fat: 55,
                fiber: 9,
                sugar: 3,
                calcium: 78
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Allergy‑friendly seed butter",
            nameFr: "Beurre de Graines de Tournesol",
            nameEs: "Mantequilla de Semillas de Girasol",
            nameHe: "חמאת גרעיני חמנייה",
            notesFr: "Beurre de graines adapté aux allergies",
            notesEs: "Mantequilla de semillas apta para alérgicos",
            notesHe: "חמאת זרעים ידידותית לאלרגיות"
        ),
        
        // Hazelnut Butter
        FoodItem(
            id: UUID(),
            name: "Hazelnut Butter",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 628,
                protein: 15,
                carbohydrates: 17,
                fat: 61,
                fiber: 10,
                sugar: 4,
                calcium: 114
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "100 % hazelnuts (no sugar)",
            nameFr: "Beurre de Noisette",
            nameEs: "Mantequilla de Avellana",
            nameHe: "חמאת אגוזי לוז",
            notesFr: "100 % noisettes (sans sucre)",
            notesEs: "100 % avellanas (sin azúcar)",
            notesHe: "100% אגוזי לוז (ללא סוכר)"
        ),
        
        // Chocolate Hazelnut Spread
        FoodItem(
            id: UUID(),
            name: "Chocolate Hazelnut Spread",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 539,
                protein: 6,
                carbohydrates: 58,
                fat: 31,
                fiber: 3,
                sugar: 56,
                calcium: 95
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "\"Nutella‑style\" sweet spread",
            nameFr: "Pâte à Tartiner Chocolat-Noisette",
            nameEs: "Crema de Avellanas y Chocolate",
            nameHe: "ממרח אגוזי לוז ושוקולד",
            notesFr: "Tartinade sucrée \"style Nutella\"",
            notesEs: "Crema dulce \"estilo Nutella\"",
            notesHe: "ממרח מתוק \"סגנון נוטלה\""
        ),
        
        // Basil Pesto
        FoodItem(
            id: UUID(),
            name: "Basil Pesto",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 460,
                protein: 5,
                carbohydrates: 8,
                fat: 47,
                fiber: 2,
                sugar: 2,
                calcium: 213
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Olive‑oil, basil, pine nuts & cheese sauce",
            nameFr: "Pesto au Basilic",
            nameEs: "Pesto de Albahaca",
            nameHe: "פסטו בזיליקום",
            notesFr: "Sauce à l'huile d'olive, basilic, pignons et fromage",
            notesEs: "Salsa de aceite de oliva, albahaca, piñones y queso",
            notesHe: "רוטב שמן זית, בזיליקום, צנוברים וגבינה"
        ),
        
        // Classic Hummus
        FoodItem(
            id: UUID(),
            name: "Classic Hummus",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 177,
                protein: 5,
                carbohydrates: 20,
                fat: 9,
                fiber: 6,
                sugar: 0.3,
                calcium: 49
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Chickpea‑tahini dip",
            nameFr: "Houmous Classique",
            nameEs: "Hummus Clásico",
            nameHe: "חומוס קלאסי",
            notesFr: "Trempette de pois chiches au tahini",
            notesEs: "Dip de garbanzos y tahini",
            notesHe: "ממרח חומוס-טחינה"
        ),
        
        // Guacamole
        FoodItem(
            id: UUID(),
            name: "Guacamole",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 2,
                carbohydrates: 9,
                fat: 15,
                fiber: 6,
                sugar: 0.7,
                calcium: 18
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Mashed avocado dip with lime & cilantro",
            nameFr: "Guacamole",
            nameEs: "Guacamole",
            nameHe: "גוואקמולי",
            notesFr: "Trempette d'avocat écrasé avec citron vert et coriandre",
            notesEs: "Dip de aguacate machacado con lima y cilantro",
            notesHe: "ממרח אבוקדו מעוך עם ליים וכוסברה"
        ),
        
        // Olive Tapenade
        FoodItem(
            id: UUID(),
            name: "Olive Tapenade",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 2,
                carbohydrates: 4,
                fat: 24,
                fiber: 3,
                sugar: 1,
                calcium: 85
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Finely chopped olives, capers & olive oil",
            nameFr: "Tapenade d'Olives",
            nameEs: "Tapenade de Aceitunas",
            nameHe: "טפנד זיתים",
            notesFr: "Olives finement hachées, câpres et huile d'olive",
            notesEs: "Aceitunas finamente picadas, alcaparras y aceite de oliva",
            notesHe: "זיתים קצוצים דק, צלפים ושמן זית"
        ),
        
        // Mayonnaise
        FoodItem(
            id: UUID(),
            name: "Mayonnaise",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 680,
                protein: 0,
                carbohydrates: 0,
                fat: 75,
                fiber: 0,
                sugar: 0,
                calcium: 12
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Classic egg‑oil emulsion",
            nameFr: "Mayonnaise",
            nameEs: "Mayonesa",
            nameHe: "מיונז",
            notesFr: "Émulsion classique d'œuf et d'huile",
            notesEs: "Emulsión clásica de huevo y aceite",
            notesHe: "תחליב קלאסי של ביצה ושמן"
        ),
        
        // Yellow Mustard
        FoodItem(
            id: UUID(),
            name: "Yellow Mustard",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 66,
                protein: 4,
                carbohydrates: 5,
                fat: 4,
                fiber: 3,
                sugar: 0,
                calcium: 120
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Prepared mustard condiment",
            nameFr: "Moutarde Jaune",
            nameEs: "Mostaza Amarilla",
            nameHe: "חרדל צהוב",
            notesFr: "Condiment de moutarde préparée",
            notesEs: "Condimento de mostaza preparada",
            notesHe: "תבלין חרדל מוכן"
        ),
        
        // Tomato Ketchup
        FoodItem(
            id: UUID(),
            name: "Tomato Ketchup",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 112,
                protein: 2,
                carbohydrates: 27,
                fat: 0.3,
                fiber: 0.3,
                sugar: 23,
                calcium: 20
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Sweet tomato sauce",
            nameFr: "Ketchup de Tomate",
            nameEs: "Kétchup de Tomate",
            nameHe: "קטשופ עגבניות",
            notesFr: "Sauce tomate sucrée",
            notesEs: "Salsa dulce de tomate",
            notesHe: "רוטב עגבניות מתוק"
        ),
        
        // Barbecue Sauce
        FoodItem(
            id: UUID(),
            name: "Barbecue Sauce",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 165,
                protein: 1.5,
                carbohydrates: 40,
                fat: 0.3,
                fiber: 0.7,
                sugar: 37,
                calcium: 34
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Smoky‑sweet tomato‑based sauce",
            nameFr: "Sauce Barbecue",
            nameEs: "Salsa Barbacoa",
            nameHe: "רוטב ברביקיו",
            notesFr: "Sauce fumée-sucrée à base de tomate",
            notesEs: "Salsa agridulce ahumada a base de tomate",
            notesHe: "רוטב מתוק-מעושן על בסיס עגבניות"
        ),
        
        // Fresh Tomato Salsa
        FoodItem(
            id: UUID(),
            name: "Fresh Tomato Salsa",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 36,
                protein: 1.5,
                carbohydrates: 7,
                fat: 0.3,
                fiber: 1.5,
                sugar: 4,
                calcium: 24
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Chunky pico de gallo",
            nameFr: "Salsa Fraîche de Tomate",
            nameEs: "Salsa Fresca de Tomate",
            nameHe: "סלסה עגבניות טרייה",
            notesFr: "Pico de gallo en morceaux",
            notesEs: "Pico de gallo con trozos",
            notesHe: "פיקו דה גאיו גס"
        ),
        
        // Ranch Dressing
        FoodItem(
            id: UUID(),
            name: "Ranch Dressing",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 430,
                protein: 1.5,
                carbohydrates: 7,
                fat: 45,
                fiber: 0.5,
                sugar: 4,
                calcium: 84
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Buttermilk‑herb salad dressing",
            nameFr: "Sauce Ranch",
            nameEs: "Aderezo Ranch",
            nameHe: "רוטב ראנץ'",
            notesFr: "Vinaigrette à base de babeurre et d'herbes",
            notesEs: "Aderezo para ensalada de suero de leche y hierbas",
            notesHe: "רוטב סלט מחלב חמוץ ועשבי תיבול"
        ),
        
        // Honey
        FoodItem(
            id: UUID(),
            name: "Honey",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 304,
                protein: 0.3,
                carbohydrates: 82,
                fat: 0,
                fiber: 0,
                sugar: 82,
                calcium: 6
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw clover honey",
            nameFr: "Miel",
            nameEs: "Miel",
            nameHe: "דבש",
            notesFr: "Miel de trèfle cru",
            notesEs: "Miel cruda de trébol",
            notesHe: "דבש תלתן גולמי"
        ),
        
        // Maple Syrup
        FoodItem(
            id: UUID(),
            name: "Maple Syrup",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 260,
                protein: 0,
                carbohydrates: 67,
                fat: 0,
                fiber: 0,
                sugar: 60,
                calcium: 102
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "100 % pure maple tree syrup",
            nameFr: "Sirop d'Érable",
            nameEs: "Sirope de Arce",
            nameHe: "סירופ מייפל",
            notesFr: "Sirop d'érable pur à 100 %",
            notesEs: "Sirope de arce 100 % puro",
            notesHe: "סירופ מייפל טהור 100%"
        ),
        
        // Ghee (Spread)
        FoodItem(
            id: UUID(),
            name: "Ghee (Spread)",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 900,
                protein: 0,
                carbohydrates: 0,
                fat: 100,
                fiber: 0,
                sugar: 0,
                calcium: 4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Clarified butter, shelf‑stable",
            nameFr: "Ghee (à tartiner)",
            nameEs: "Ghee (Para Untar)",
            nameHe: "גהי (ממרח)",
            notesFr: "Beurre clarifié, se conserve longtemps",
            notesEs: "Mantequilla clarificada, estable en estante",
            notesHe: "חמאה מזוקקת, יציבה במדף"
        ),
        
        // Coconut Butter
        FoodItem(
            id: UUID(),
            name: "Coconut Butter",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 650,
                protein: 6,
                carbohydrates: 24,
                fat: 60,
                fiber: 15,
                sugar: 10,
                calcium: 14
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Pureed coconut flesh",
            nameFr: "Beurre de Coco",
            nameEs: "Mantequilla de Coco",
            nameHe: "חמאת קוקוס",
            notesFr: "Chair de coco en purée",
            notesEs: "Pulpa de coco en puré",
            notesHe: "בשר קוקוס טחון"
        ),
        
        // Orange Marmalade
        FoodItem(
            id: UUID(),
            name: "Orange Marmalade",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 0,
                carbohydrates: 65,
                fat: 0,
                fiber: 1,
                sugar: 52,
                calcium: 40
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Citrus peel jam",
            nameFr: "Marmelade d'Orange",
            nameEs: "Mermelada de Naranja",
            nameHe: "מרמלדת תפוזים",
            notesFr: "Confiture d'écorces d'agrumes",
            notesEs: "Mermelada de cáscara de cítricos",
            notesHe: "ריבת קליפות הדרים"
        ),
        
        // Strawberry Jam
        FoodItem(
            id: UUID(),
            name: "Strawberry Jam",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 0,
                carbohydrates: 65,
                fat: 0,
                fiber: 1,
                sugar: 52,
                calcium: 15
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Traditional fruit preserve",
            nameFr: "Confiture de Fraises",
            nameEs: "Mermelada de Fresa",
            nameHe: "ריבת תות",
            notesFr: "Conserve traditionnelle de fruits",
            notesEs: "Conserva tradicional de frutas",
            notesHe: "שימורי פירות מסורתיים"
        ),
        
        // Apple Butter
        FoodItem(
            id: UUID(),
            name: "Apple Butter",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 220,
                protein: 0,
                carbohydrates: 55,
                fat: 0.5,
                fiber: 3,
                sugar: 49,
                calcium: 15
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Slow‑cooked spiced apple spread",
            nameFr: "Beurre de Pomme",
            nameEs: "Mantequilla de Manzana",
            nameHe: "חמאת תפוחים",
            notesFr: "Tartinade de pommes épicées cuites lentement",
            notesEs: "Pasta de manzana especiada cocida a fuego lento",
            notesHe: "ממרח תפוחים מתובל בבישול איטי"
        ),
        
        // Tahini (Sesame Paste)
        FoodItem(
            id: UUID(),
            name: "Tahini (Sesame Paste)",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 595,
                protein: 17,
                carbohydrates: 22,
                fat: 53,
                fiber: 9,
                sugar: 0.5,
                calcium: 950
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Ground hulled sesame paste",
            nameFr: "Tahini (Pâte de Sésame)",
            nameEs: "Tahini (Pasta de Sésamo)",
            nameHe: "טחינה (ממרח שומשום)",
            notesFr: "Pâte de graines de sésame décortiquées moulues",
            notesEs: "Pasta de semillas de sésamo peladas y molidas",
            notesHe: "ממרח שומשום קלוף טחון"
        ),
        
        // Tzatziki Dip
        FoodItem(
            id: UUID(),
            name: "Tzatziki Dip",
            category: .condiments,
            nutritionalInfo: NutritionalInfo(
                calories: 60,
                protein: 3,
                carbohydrates: 3,
                fat: 4,
                fiber: 0.3,
                sugar: 2,
                calcium: 80
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Greek yogurt, cucumber & garlic sauce",
            nameFr: "Sauce Tzatziki",
            nameEs: "Salsa Tzatziki",
            nameHe: "מטבל צזיקי",
            notesFr: "Sauce au yaourt grec, concombre et ail",
            notesEs: "Salsa de yogur griego, pepino y ajo",
            notesHe: "רוטב יוגורט יווני, מלפפון ושום"
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