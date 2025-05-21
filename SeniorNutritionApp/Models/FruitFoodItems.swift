import Foundation

struct FruitFoodItems {
    static let foods: [FoodItem] = [
        // Apple
        FoodItem(
            id: UUID(),
            name: "Apple",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 52,
                protein: 0.3,
                carbohydrates: 14,
                fat: 0.2,
                fiber: 2.4,
                sugar: 10.4,
                calcium: 6
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh apple with skin",
            nameFr: "Pomme",
            nameEs: "Manzana",
            nameHe: "תפוח",
            notesFr: "Pomme fraîche avec la peau",
            notesEs: "Manzana fresca con piel",
            notesHe: "תפוח טרי עם הקליפה"
        ),
        
        // Banana
        FoodItem(
            id: UUID(),
            name: "Banana",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 89,
                protein: 1.1,
                carbohydrates: 23,
                fat: 0.3,
                fiber: 2.6,
                sugar: 12.2,
                calcium: 5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw banana",
            nameFr: "Banane",
            nameEs: "Plátano",
            nameHe: "בננה",
            notesFr: "Banane crue",
            notesEs: "Plátano crudo",
            notesHe: "בננה טרייה"
        ),
        
        // Orange
        FoodItem(
            id: UUID(),
            name: "Orange",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 47,
                protein: 0.9,
                carbohydrates: 12,
                fat: 0.1,
                fiber: 2.4,
                sugar: 9.4,
                calcium: 40
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh orange",
            nameFr: "Orange",
            nameEs: "Naranja",
            nameHe: "תפוז",
            notesFr: "Orange fraîche",
            notesEs: "Naranja fresca",
            notesHe: "תפוז טרי"
        ),
        
        // Strawberry
        FoodItem(
            id: UUID(),
            name: "Strawberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 32,
                protein: 0.7,
                carbohydrates: 7.7,
                fat: 0.3,
                fiber: 2.0,
                sugar: 4.9,
                calcium: 16
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh strawberries",
            nameFr: "Fraise",
            nameEs: "Fresa",
            nameHe: "תות שדה",
            notesFr: "Fraises fraîches",
            notesEs: "Fresas frescas",
            notesHe: "תותי שדה טריים"
        ),
        
        // Blueberry
        FoodItem(
            id: UUID(),
            name: "Blueberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 57,
                protein: 0.7,
                carbohydrates: 14.5,
                fat: 0.3,
                fiber: 2.4,
                sugar: 9.7,
                calcium: 10 // Low calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh blueberries",
            nameFr: "Myrtille",
            nameEs: "Arándano",
            nameHe: "אוכמנית",
            notesFr: "Myrtilles fraîches",
            notesEs: "Arándanos frescos",
            notesHe: "אוכמניות טריות"
        ),
        
        // Grapes
        FoodItem(
            id: UUID(),
            name: "Grapes",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 69,
                protein: 0.7,
                carbohydrates: 18,
                fat: 0.2,
                fiber: 0.9,
                sugar: 15.5,
                calcium: 15 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh grapes",
            nameFr: "Raisins",
            nameEs: "Uvas",
            nameHe: "ענבים",
            notesFr: "Raisins frais",
            notesEs: "Uvas frescas",
            notesHe: "ענבים טריים"
        ),
        
        // Pineapple
        FoodItem(
            id: UUID(),
            name: "Pineapple",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 50,
                protein: 0.5,
                carbohydrates: 13,
                fat: 0.1,
                fiber: 1.4,
                sugar: 9.9,
                calcium: 20 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh pineapple",
            nameFr: "Ananas",
            nameEs: "Piña",
            nameHe: "אננס",
            notesFr: "Ananas frais",
            notesEs: "Piña fresca",
            notesHe: "אננס טרי"
        ),
        
        // Mango
        FoodItem(
            id: UUID(),
            name: "Mango",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 60,
                protein: 0.8,
                carbohydrates: 15,
                fat: 0.4,
                fiber: 1.6,
                sugar: 13.7,
                calcium: 20 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh mango",
            nameFr: "Mangue",
            nameEs: "Mango",
            nameHe: "מנגו",
            notesFr: "Mangue fraîche",
            notesEs: "Mango fresco",
            notesHe: "מנגו טרי"
        ),
        
        // Watermelon
        FoodItem(
            id: UUID(),
            name: "Watermelon",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 30,
                protein: 0.6,
                carbohydrates: 8,
                fat: 0.2,
                fiber: 0.4,
                sugar: 6.2,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh watermelon",
            nameFr: "Pastèque",
            nameEs: "Sandía",
            nameHe: "אבטיח",
            notesFr: "Pastèque fraîche",
            notesEs: "Sandía fresca",
            notesHe: "אבטיח טרי"
        ),
        
        // Peach
        FoodItem(
            id: UUID(),
            name: "Peach",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 39,
                protein: 0.9,
                carbohydrates: 10,
                fat: 0.3,
                fiber: 1.5,
                sugar: 8.4,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh peach",
            nameFr: "Pêche",
            nameEs: "Melocotón",
            nameHe: "אפרסק",
            notesFr: "Pêche fraîche",
            notesEs: "Melocotón fresco",
            notesHe: "אפרסק טרי"
        ),
        
        // Pear
        FoodItem(
            id: UUID(),
            name: "Pear",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 57,
                protein: 0.4,
                carbohydrates: 15,
                fat: 0.1,
                fiber: 3.1,
                sugar: 9.8,
                calcium: 15 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh pear",
            nameFr: "Poire",
            nameEs: "Pera",
            nameHe: "אגס",
            notesFr: "Poire fraîche",
            notesEs: "Pera fresca",
            notesHe: "אגס טרי"
        ),
        
        // Cherry
        FoodItem(
            id: UUID(),
            name: "Cherry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 50,
                protein: 1.0,
                carbohydrates: 12,
                fat: 0.3,
                fiber: 1.6,
                sugar: 8.5,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh cherries",
            nameFr: "Cerise",
            nameEs: "Cereza",
            nameHe: "דובדבן",
            notesFr: "Cerises fraîches",
            notesEs: "Cerezas frescas",
            notesHe: "דובדבנים טריים"
        ),
        
        // Kiwi
        FoodItem(
            id: UUID(),
            name: "Kiwi",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 61,
                protein: 1.1,
                carbohydrates: 15,
                fat: 0.5,
                fiber: 3.0,
                sugar: 9.0,
                calcium: 15 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh kiwi",
            nameFr: "Kiwi",
            nameEs: "Kiwi",
            nameHe: "קיווי",
            notesFr: "Kiwi frais",
            notesEs: "Kiwi fresco",
            notesHe: "קיווי טרי"
        ),
        
        // MARK: - Additional Food Items
        
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
                sugar: 35,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau au Citron Glacé",
            nameEs: "Bizcocho de Limón",
            nameHe: "עוגת לימון מזוגגת",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
                sugar: 28,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau aux Pommes (Apfelkuchen)",
            nameEs: "Pastel de Manzana (Apfelkuchen)",
            nameHe: "עוגת תפוחים (אפלקוכן)",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
        ),
        
        // Skim Milk
        FoodItem(
            id: UUID(),
            name: "Skim Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 34,
                protein: 3.4,
                carbohydrates: 5.0,
                fat: 0.1,
                fiber: 0.0,
                sugar: 5.0,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fat-free cow's milk",
            nameFr: "Lait Écrémé",
            nameEs: "Leche Desnatada",
            nameHe: "חלב דל שומן",
            notesFr: "Lait de vache sans matière grasse",
            notesEs: "Leche de vaca sin grasa",
            notesHe: "חלב פרה נטול שומן"
        ),
        
        // Lactose-Free Milk
        FoodItem(
            id: UUID(),
            name: "Lactose-Free Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 42,
                protein: 3.3,
                carbohydrates: 5.0,
                fat: 1.0,
                fiber: 0.0,
                sugar: 5.0,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Milk with lactose removed",
            nameFr: "Lait Sans Lactose",
            nameEs: "Leche Sin Lactosa",
            nameHe: "חלב ללא לקטוז",
            notesFr: "Lait dont le lactose a été retiré",
            notesEs: "Leche con lactosa eliminada",
            notesHe: "חלב שהוסר ממנו לקטוז"
        ),
        
        // Regular Yogurt
        FoodItem(
            id: UUID(),
            name: "Regular Yogurt",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 61,
                protein: 3.5,
                carbohydrates: 4.7,
                fat: 3.3,
                fiber: 0.0,
                sugar: 4.7,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Plain whole milk yogurt",
            nameFr: "Yaourt Ordinaire",
            nameEs: "Yogur Regular",
            nameHe: "יוגורט רגיל",
            notesFr: "Yaourt nature au lait entier",
            notesEs: "Yogur natural de leche entera",
            notesHe: "יוגורט טבעי מחלב מלא"
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
                sugar: 0,
                calcium: 0
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
                sugar: 0,
                calcium: 0
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
                sugar: 20.8,
                calcium: 20 // Moderate calcium content
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
        
        // Plum
        FoodItem(
            id: UUID(),
            name: "Plum",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 46,
                protein: 0.7,
                carbohydrates: 11,
                fat: 0.3,
                fiber: 1.4,
                sugar: 9.9,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh plum",
            nameFr: "Prune",
            nameEs: "Ciruela",
            nameHe: "שזיף",
            notesFr: "Prune fraîche",
            notesEs: "Ciruela fresca",
            notesHe: "שזיף טרי"
        ),
        
        // Raspberry
        FoodItem(
            id: UUID(),
            name: "Raspberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 52,
                protein: 1.2,
                carbohydrates: 12,
                fat: 0.7,
                fiber: 6.5,
                sugar: 4.4,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh raspberries",
            nameFr: "Framboise",
            nameEs: "Frambuesa",
            nameHe: "פטל",
            notesFr: "Framboises fraîches",
            notesEs: "Frambuesas frescas",
            notesHe: "פטל טרי"
        ),
        
        // Blackberry
        FoodItem(
            id: UUID(),
            name: "Blackberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 43,
                protein: 1.4,
                carbohydrates: 10,
                fat: 0.5,
                fiber: 5.3,
                sugar: 4.9,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh blackberries",
            nameFr: "Mûre",
            nameEs: "Mora",
            nameHe: "פטל שחור",
            notesFr: "Mûres fraîches",
            notesEs: "Moras frescas",
            notesHe: "פטל שחור טרי"
        ),
        
        // Papaya
        FoodItem(
            id: UUID(),
            name: "Papaya",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 43,
                protein: 0.5,
                carbohydrates: 11,
                fat: 0.3,
                fiber: 1.7,
                sugar: 7.8,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh papaya",
            nameFr: "Papaye",
            nameEs: "Papaya",
            nameHe: "פפאיה",
            notesFr: "Papaye fraîche",
            notesEs: "Papaya fresca",
            notesHe: "פפאיה טרייה"
        ),
        
        // Cantaloupe
        FoodItem(
            id: UUID(),
            name: "Cantaloupe",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 34,
                protein: 0.8,
                carbohydrates: 8.2,
                fat: 0.2,
                fiber: 0.9,
                sugar: 7.9,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh cantaloupe",
            nameFr: "Cantaloup",
            nameEs: "Melón Cantalupo",
            nameHe: "מלון כתום",
            notesFr: "Cantaloup frais",
            notesEs: "Melón cantalupo fresco",
            notesHe: "מלון כתום טרי"
        ),
        
        // Apricot
        FoodItem(
            id: UUID(),
            name: "Apricot",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 48,
                protein: 1.4,
                carbohydrates: 11,
                fat: 0.4,
                fiber: 2.0,
                sugar: 3.9,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh apricot",
            nameFr: "Abricot",
            nameEs: "Albaricoque",
            nameHe: "משמש",
            notesFr: "Abricot frais",
            notesEs: "Albaricoque fresco",
            notesHe: "משמש טרי"
        ),
        
        // Pomegranate
        FoodItem(
            id: UUID(),
            name: "Pomegranate",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 83,
                protein: 1.7,
                carbohydrates: 19,
                fat: 1.2,
                fiber: 4.0,
                sugar: 13.7,
                calcium: 20 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh pomegranate",
            nameFr: "Grenade",
            nameEs: "Granada",
            nameHe: "רימון",
            notesFr: "Grenade fraîche",
            notesEs: "Granada fresca",
            notesHe: "רימון טרי"
        ),
        
        // Lemon
        FoodItem(
            id: UUID(),
            name: "Lemon",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 29,
                protein: 1.1,
                carbohydrates: 9.3,
                fat: 0.3,
                fiber: 2.8,
                sugar: 2.5,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh lemon",
            nameFr: "Citron",
            nameEs: "Limón",
            nameHe: "לימון",
            notesFr: "Citron frais",
            notesEs: "Limón fresco",
            notesHe: "לימון טרי"
        ),
        
        // Lime
        FoodItem(
            id: UUID(),
            name: "Lime",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 30,
                protein: 0.7,
                carbohydrates: 11,
                fat: 0.2,
                fiber: 2.8,
                sugar: 1.7,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh lime",
            nameFr: "Citron Vert",
            nameEs: "Lima",
            nameHe: "ליים",
            notesFr: "Citron vert frais",
            notesEs: "Lima fresca",
            notesHe: "ליים טרי"
        ),
        
        // Coconut
        FoodItem(
            id: UUID(),
            name: "Coconut",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 354,
                protein: 3.3,
                carbohydrates: 15,
                fat: 33.5,
                fiber: 9.0,
                sugar: 6.2,
                calcium: 20 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh coconut meat",
            nameFr: "Noix de Coco",
            nameEs: "Coco",
            nameHe: "קוקוס",
            notesFr: "Chair de noix de coco fraîche",
            notesEs: "Pulpa de coco fresco",
            notesHe: "בשר קוקוס טרי"
        ),
        
        // Fig
        FoodItem(
            id: UUID(),
            name: "Fig",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 74,
                protein: 0.8,
                carbohydrates: 19,
                fat: 0.3,
                fiber: 2.9,
                sugar: 16.3,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh fig",
            nameFr: "Figue",
            nameEs: "Higo",
            nameHe: "תאנה",
            notesFr: "Figue fraîche",
            notesEs: "Higo fresco",
            notesHe: "תאנה טרייה"
        ),
        
        // Guava
        FoodItem(
            id: UUID(),
            name: "Guava",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 68,
                protein: 2.6,
                carbohydrates: 14,
                fat: 0.9,
                fiber: 5.4,
                sugar: 8.9,
                calcium: 10 // Moderate calcium content
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh guava",
            nameFr: "Goyave",
            nameEs: "Guayaba",
            nameHe: "גויאבה",
            notesFr: "Goyave fraîche",
            notesEs: "Guayaba fresca",
            notesHe: "גויאבה טרייה"
        )
    ]
} 