import Foundation
import SwiftUI

struct StuffedDishFoodItems {
    static let foods: [FoodItem] = [
        // Stuffed Bell Pepper
        FoodItem(
            id: UUID(),
            name: "Stuffed Bell Pepper",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 140,
                protein: 7,
                carbohydrates: 15,
                fat: 6,
                fiber: 3,
                sugar: 5,
                calcium: 46 // Low-moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Peppers filled with beef and rice",
            nameFr: "Poivron Farci",
            nameEs: "Pimiento Relleno",
            nameHe: "פלפל ממולא",
            notesFr: "Poivrons farcis avec du bœuf et du riz",
            notesEs: "Pimientos rellenos con carne y arroz",
            notesHe: "פלפלים ממולאים בבשר בקר ואורז"
        ),
        
        // Stuffed Cabbage Roll
        FoodItem(
            id: UUID(),
            name: "Stuffed Cabbage Roll",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 120,
                protein: 6,
                carbohydrates: 14,
                fat: 5,
                fiber: 2,
                sugar: 4,
                calcium: 40 // Low-moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cabbage leaves stuffed with meat & rice",
            nameFr: "Chou Farci",
            nameEs: "Rollo de Repollo Relleno",
            nameHe: "כרוב ממולא",
            notesFr: "Feuilles de chou farcies de viande et de riz",
            notesEs: "Hojas de repollo rellenas de carne y arroz",
            notesHe: "עלי כרוב ממולאים בבשר ואורז"
        ),
        
        // Stuffed Zucchini
        FoodItem(
            id: UUID(),
            name: "Stuffed Zucchini",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 110,
                protein: 5,
                carbohydrates: 10,
                fat: 6,
                fiber: 2,
                sugar: 4,
                calcium: 35 // Low calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Zucchini boats with ground turkey & herbs",
            nameFr: "Courgette Farcie",
            nameEs: "Calabacín Relleno",
            nameHe: "קישואים ממולאים",
            notesFr: "Courgettes en barque farcies de dinde hachée et d'herbes",
            notesEs: "Calabacines rellenos con pavo molido y hierbas",
            notesHe: "סירות קישואים עם בשר הודו טחון ועשבי תיבול"
        ),
        
        // Stuffed Eggplant
        FoodItem(
            id: UUID(),
            name: "Stuffed Eggplant",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 130,
                protein: 4,
                carbohydrates: 14,
                fat: 7,
                fiber: 4,
                sugar: 6,
                calcium: 30 // Low calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Mediterranean eggplant with veggies & lamb",
            nameFr: "Aubergine Farcie",
            nameEs: "Berenjena Rellena",
            nameHe: "חציל ממולא",
            notesFr: "Aubergine méditerranéenne avec légumes et agneau",
            notesEs: "Berenjena mediterránea con verduras y cordero",
            notesHe: "חציל ים תיכוני עם ירקות וכבש"
        ),
        
        // Stuffed Grape Leaves (Dolmas)
        FoodItem(
            id: UUID(),
            name: "Stuffed Grape Leaves (Dolmas)",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 4,
                carbohydrates: 20,
                fat: 6,
                fiber: 3,
                sugar: 2,
                calcium: 52 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Vine leaves stuffed with herbed rice",
            nameFr: "Feuilles de Vigne Farcies (Dolmas)",
            nameEs: "Hojas de Parra Rellenas (Dolmas)",
            nameHe: "עלי גפן ממולאים (דולמה)",
            notesFr: "Feuilles de vigne farcies au riz aux herbes",
            notesEs: "Hojas de parra rellenas con arroz a las hierbas",
            notesHe: "עלי גפן ממולאים באורז מתובל"
        ),
        
        // Stuffed Portobello Mushroom
        FoodItem(
            id: UUID(),
            name: "Stuffed Portobello Mushroom",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 120,
                protein: 7,
                carbohydrates: 8,
                fat: 7,
                fiber: 2,
                sugar: 2,
                calcium: 135 // Good calcium content from cheese
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Portobello filled with spinach & cheese",
            nameFr: "Champignon Portobello Farci",
            nameEs: "Champiñón Portobello Relleno",
            nameHe: "פטריית פורטובלו ממולאת",
            notesFr: "Portobello farci aux épinards et fromage",
            notesEs: "Portobello relleno con espinacas y queso",
            notesHe: "פורטובלו ממולא בתרד וגבינה"
        ),
        
        // Stuffed Chicken Breast
        FoodItem(
            id: UUID(),
            name: "Stuffed Chicken Breast",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 18,
                carbohydrates: 3,
                fat: 9,
                fiber: 1,
                sugar: 1,
                calcium: 145 // Good calcium content from feta cheese
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Chicken breast filled with spinach-feta",
            nameFr: "Blanc de Poulet Farci",
            nameEs: "Pechuga de Pollo Rellena",
            nameHe: "חזה עוף ממולא",
            notesFr: "Blanc de poulet farci aux épinards et à la feta",
            notesEs: "Pechuga de pollo rellena con espinacas y queso feta",
            notesHe: "חזה עוף ממולא בתרד ופטה"
        ),
        
        // Stuffed Turkey Breast
        FoodItem(
            id: UUID(),
            name: "Stuffed Turkey Breast",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 17,
                carbohydrates: 5,
                fat: 6,
                fiber: 1,
                sugar: 3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Turkey breast rolled with cranberry stuffing",
            nameFr: "Blanc de Dinde Farci",
            nameEs: "Pechuga de Pavo Rellena",
            nameHe: "חזה הודו ממולא",
            notesFr: "Blanc de dinde roulé avec farce aux canneberges",
            notesEs: "Pechuga de pavo enrollada con relleno de arándanos",
            notesHe: "חזה הודו מגולגל עם מילוי חמוציות"
        ),
        
        // Stuffed Pork Loin
        FoodItem(
            id: UUID(),
            name: "Stuffed Pork Loin",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 180,
                protein: 17,
                carbohydrates: 6,
                fat: 10,
                fiber: 1,
                sugar: 3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Pork loin stuffed with apple & herbs",
            nameFr: "Longe de Porc Farcie",
            nameEs: "Lomo de Cerdo Relleno",
            nameHe: "פילה חזיר ממולא",
            notesFr: "Longe de porc farcie aux pommes et aux herbes",
            notesEs: "Lomo de cerdo relleno con manzana y hierbas",
            notesHe: "פילה חזיר ממולא בתפוח ועשבי תיבול"
        ),
        
        // Stuffed Acorn Squash
        FoodItem(
            id: UUID(),
            name: "Stuffed Acorn Squash",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 130,
                protein: 4,
                carbohydrates: 24,
                fat: 2,
                fiber: 4,
                sugar: 6
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Squash halves filled with quinoa-cranberry",
            nameFr: "Courge Poivrée Farcie",
            nameEs: "Calabaza Bellota Rellena",
            nameHe: "דלעת אייקורן ממולאת",
            notesFr: "Moitiés de courge farcies de quinoa et canneberges",
            notesEs: "Mitades de calabaza rellenas con quinoa y arándanos",
            notesHe: "חצאי דלעת ממולאים בקינואה וחמוציות"
        ),
        
        // Stuffed Tomato (Tuna)
        FoodItem(
            id: UUID(),
            name: "Stuffed Tomato (Tuna)",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 110,
                protein: 8,
                carbohydrates: 6,
                fat: 5,
                fiber: 2,
                sugar: 4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh tomato filled with tuna salad",
            nameFr: "Tomate Farcie (Thon)",
            nameEs: "Tomate Relleno (Atún)",
            nameHe: "עגבנייה ממולאת (טונה)",
            notesFr: "Tomate fraîche farcie de salade de thon",
            notesEs: "Tomate fresco relleno con ensalada de atún",
            notesHe: "עגבנייה טרייה ממולאת בסלט טונה"
        ),
        
        // Stuffed Potato Skins
        FoodItem(
            id: UUID(),
            name: "Stuffed Potato Skins",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 200,
                protein: 6,
                carbohydrates: 22,
                fat: 10,
                fiber: 3,
                sugar: 1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Baked skins with cheddar & bacon",
            nameFr: "Peaux de Pommes de Terre Farcies",
            nameEs: "Pieles de Patata Rellenas",
            nameHe: "קליפות תפוחי אדמה ממולאות",
            notesFr: "Peaux cuites au four avec cheddar et bacon",
            notesEs: "Pieles horneadas con cheddar y tocino",
            notesHe: "קליפות אפויות עם צ'דר ובייקון"
        ),
        
        // Stuffed Jalapeños
        FoodItem(
            id: UUID(),
            name: "Stuffed Jalapeños",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 180,
                protein: 5,
                carbohydrates: 10,
                fat: 14,
                fiber: 2,
                sugar: 2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Hot peppers filled with cream cheese",
            nameFr: "Jalapeños Farcis",
            nameEs: "Jalapeños Rellenos",
            nameHe: "חלפיניו ממולא",
            notesFr: "Piments forts farcis au fromage à la crème",
            notesEs: "Pimientos picantes rellenos con queso crema",
            notesHe: "פלפלים חריפים ממולאים בגבינת שמנת"
        ),
        
        // Stuffed Shells (Ricotta)
        FoodItem(
            id: UUID(),
            name: "Stuffed Shells (Ricotta)",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 170,
                protein: 8,
                carbohydrates: 20,
                fat: 7,
                fiber: 2,
                sugar: 2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Jumbo pasta shells with ricotta-spinach",
            nameFr: "Conchiglioni Farcis (Ricotta)",
            nameEs: "Conchas Rellenas (Ricotta)",
            nameHe: "פסטה ממולאת (ריקוטה)",
            notesFr: "Grosses coquilles de pâtes farcies à la ricotta et aux épinards",
            notesEs: "Conchas de pasta grandes con ricotta y espinacas",
            notesHe: "פסטה גדולה ממולאת בריקוטה ותרד"
        ),
        
        // Stuffed Manicotti
        FoodItem(
            id: UUID(),
            name: "Stuffed Manicotti",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 7,
                carbohydrates: 19,
                fat: 6,
                fiber: 2,
                sugar: 2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Manicotti tubes stuffed with ricotta",
            nameFr: "Manicotti Farcis",
            nameEs: "Manicotti Rellenos",
            nameHe: "מניקוטי ממולא",
            notesFr: "Tubes de manicotti farcis à la ricotta",
            notesEs: "Tubos de manicotti rellenos con ricotta",
            notesHe: "צינורות מניקוטי ממולאים בריקוטה"
        ),
        
        // Stuffed Cornish Hen
        FoodItem(
            id: UUID(),
            name: "Stuffed Cornish Hen",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 190,
                protein: 15,
                carbohydrates: 8,
                fat: 10,
                fiber: 1,
                sugar: 1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Hen filled with wild-rice stuffing",
            nameFr: "Poularde de Cornouailles Farcie",
            nameEs: "Gallina de Cornualles Rellena",
            nameHe: "תרנגולת קורניש ממולאת",
            notesFr: "Poularde farcie de riz sauvage",
            notesEs: "Gallina rellena con stuffing de arroz salvaje",
            notesHe: "תרנגולת ממולאת במילוי אורז בר"
        ),
        
        // Stuffed Meatballs (Mozzarella)
        FoodItem(
            id: UUID(),
            name: "Stuffed Meatballs (Mozzarella)",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 220,
                protein: 18,
                carbohydrates: 4,
                fat: 15,
                fiber: 1,
                sugar: 1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Beef meatballs with mozzarella centers",
            nameFr: "Boulettes de Viande Farcies (Mozzarella)",
            nameEs: "Albóndigas Rellenas (Mozzarella)",
            nameHe: "קציצות בשר ממולאות (מוצרלה)",
            notesFr: "Boulettes de bœuf avec cœurs de mozzarella",
            notesEs: "Albóndigas de carne con centros de mozzarella",
            notesHe: "קציצות בקר עם מרכזי מוצרלה"
        ),
        
        // Stuffed French Toast
        FoodItem(
            id: UUID(),
            name: "Stuffed French Toast",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 260,
                protein: 7,
                carbohydrates: 35,
                fat: 10,
                fiber: 1,
                sugar: 12
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Brioche slices filled with cream cheese & fruit",
            nameFr: "Pain Perdu Farci",
            nameEs: "Tostada Francesa Rellena",
            nameHe: "פרנץ' טוסט ממולא",
            notesFr: "Tranches de brioche farcies au fromage à la crème et aux fruits",
            notesEs: "Rebanadas de brioche rellenas con queso crema y fruta",
            notesHe: "פרוסות בריוש ממולאות בגבינת שמנת ופירות"
        ),
        
        // Stuffed Paratha (Aloo)
        FoodItem(
            id: UUID(),
            name: "Stuffed Paratha (Aloo)",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 240,
                protein: 5,
                carbohydrates: 34,
                fat: 10,
                fiber: 3,
                sugar: 2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Indian flatbread stuffed with spiced potato",
            nameFr: "Paratha Farci (Aloo)",
            nameEs: "Paratha Relleno (Aloo)",
            nameHe: "פאראטה ממולאת (אלו)",
            notesFr: "Pain plat indien farci de pommes de terre épicées",
            notesEs: "Pan plano indio relleno con patata especiada",
            notesHe: "לחם שטוח הודי ממולא בתפוחי אדמה מתובלים"
        ),
        
        // Stuffed Artichoke
        FoodItem(
            id: UUID(),
            name: "Stuffed Artichoke",
            category: .stuffedDishes,
            nutritionalInfo: NutritionalInfo(
                calories: 140,
                protein: 5,
                carbohydrates: 18,
                fat: 6,
                fiber: 5,
                sugar: 2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Artichoke stuffed with breadcrumbs & herbs",
            nameFr: "Artichaut Farci",
            nameEs: "Alcachofa Rellena",
            nameHe: "ארטישוק ממולא",
            notesFr: "Artichaut farci de chapelure et d'herbes",
            notesEs: "Alcachofa rellena con pan rallado y hierbas",
            notesHe: "ארטישוק ממולא בפירורי לחם ועשבי תיבול"
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