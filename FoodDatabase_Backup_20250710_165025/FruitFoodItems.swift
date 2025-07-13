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
        ),
        
        // NEW FRUITS - 30 Additional Varieties
        
        // Avocado
        FoodItem(
            id: UUID(),
            name: "Avocado",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 2.0,
                carbohydrates: 8.5,
                fat: 14.7,
                fiber: 6.7,
                sugar: 0.7,
                vitaminA: 146,
                vitaminC: 10,
                vitaminE: 2.1,
                vitaminK: 21,
                folate: 81,
                calcium: 12,
                iron: 0.6,
                magnesium: 29,
                potassium: 485
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Rich in healthy monounsaturated fats and fiber",
            nameFr: "Avocat",
            nameEs: "Aguacate",
            nameHe: "אבוקדו",
            notesFr: "Riche en graisses monoinsaturées saines et en fibres",
            notesEs: "Rico en grasas monoinsaturadas saludables y fibra",
            notesHe: "עשיר בשומנים חד-בלתי-רוויים בריאים וסיבים"
        ),
        
        // Grapefruit
        FoodItem(
            id: UUID(),
            name: "Grapefruit",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 42,
                protein: 0.8,
                carbohydrates: 11,
                fat: 0.1,
                fiber: 1.6,
                sugar: 6.9,
                vitaminA: 1150,
                vitaminC: 31.2,
                folate: 13,
                calcium: 22,
                iron: 0.1,
                magnesium: 9,
                potassium: 135
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Citrus fruit high in vitamin C, slightly bitter",
            nameFr: "Pamplemousse",
            nameEs: "Pomelo",
            nameHe: "אשכולית",
            notesFr: "Agrume riche en vitamine C, légèrement amer",
            notesEs: "Cítrico alto en vitamina C, ligeramente amargo",
            notesHe: "פרי הדר עשיר בוויטמין C, מעט מר"
        ),
        
        // Tangerine
        FoodItem(
            id: UUID(),
            name: "Tangerine",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 53,
                protein: 0.8,
                carbohydrates: 13.3,
                fat: 0.3,
                fiber: 1.8,
                sugar: 10.6,
                vitaminA: 681,
                vitaminC: 26.7,
                folate: 16,
                calcium: 37,
                iron: 0.2,
                magnesium: 12,
                potassium: 166
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Sweet citrus fruit, easy to peel",
            nameFr: "Mandarine",
            nameEs: "Mandarina",
            nameHe: "מנדרינה",
            notesFr: "Agrume doux, facile à éplucher",
            notesEs: "Cítrico dulce, fácil de pelar",
            notesHe: "פרי הדר מתוק, קל לקלף"
        ),
        
        // Nectarine
        FoodItem(
            id: UUID(),
            name: "Nectarine",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 44,
                protein: 1.1,
                carbohydrates: 10.6,
                fat: 0.3,
                fiber: 1.7,
                sugar: 7.9,
                vitaminA: 332,
                vitaminC: 5.4,
                folate: 5,
                calcium: 6,
                iron: 0.3,
                magnesium: 9,
                potassium: 201
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Smooth-skinned peach variety, sweet and juicy",
            nameFr: "Nectarine",
            nameEs: "Nectarina",
            nameHe: "נקטרינה",
            notesFr: "Variété de pêche à peau lisse, douce et juteuse",
            notesEs: "Variedad de durazno de piel lisa, dulce y jugoso",
            notesHe: "זן אפרסק בקליפה חלקה, מתוק ועסיסי"
        ),
        
        // Persimmon
        FoodItem(
            id: UUID(),
            name: "Persimmon",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 70,
                protein: 0.6,
                carbohydrates: 18.6,
                fat: 0.2,
                fiber: 3.6,
                sugar: 12.5,
                vitaminA: 1627,
                vitaminC: 7.5,
                folate: 8,
                calcium: 8,
                iron: 0.2,
                magnesium: 9,
                potassium: 161
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Sweet orange fruit, high in beta-carotene",
            nameFr: "Kaki",
            nameEs: "Caqui",
            nameHe: "אפרסמון",
            notesFr: "Fruit orange doux, riche en bêta-carotène",
            notesEs: "Fruta naranja dulce, alta en beta-caroteno",
            notesHe: "פרי כתום מתוק, עשיר בבטא-קרוטן"
        ),
        
        // Passion Fruit
        FoodItem(
            id: UUID(),
            name: "Passion Fruit",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 97,
                protein: 2.2,
                carbohydrates: 23.4,
                fat: 0.7,
                fiber: 10.4,
                sugar: 11.2,
                vitaminA: 1272,
                vitaminC: 30,
                folate: 14,
                calcium: 12,
                iron: 1.6,
                magnesium: 29,
                potassium: 348
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Tropical fruit with edible seeds, very high in fiber",
            nameFr: "Fruit de la passion",
            nameEs: "Fruta de la pasión",
            nameHe: "פרי התשוקה",
            notesFr: "Fruit tropical aux graines comestibles, très riche en fibres",
            notesEs: "Fruta tropical con semillas comestibles, muy alta en fibra",
            notesHe: "פרי טרופי עם זרעים אכילים, עשיר מאוד בסיבים"
        ),
        
        // Dragon Fruit
        FoodItem(
            id: UUID(),
            name: "Dragon Fruit",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 60,
                protein: 1.2,
                carbohydrates: 13,
                fat: 0.4,
                fiber: 3.0,
                sugar: 7.7,
                vitaminA: 0,
                vitaminC: 20.5,
                folate: 6,
                calcium: 8,
                iron: 0.7,
                magnesium: 40,
                potassium: 272
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Exotic cactus fruit with mild, sweet flavor",
            nameFr: "Fruit du dragon",
            nameEs: "Fruta del dragón",
            nameHe: "פרי הדרקון",
            notesFr: "Fruit de cactus exotique au goût doux et sucré",
            notesEs: "Fruta exótica de cactus con sabor suave y dulce",
            notesHe: "פרי צבר אקזוטי בטעם עדין ומתוק"
        ),
        
        // Star Fruit (Carambola)
        FoodItem(
            id: UUID(),
            name: "Star Fruit",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 31,
                protein: 1.0,
                carbohydrates: 6.7,
                fat: 0.3,
                fiber: 2.8,
                sugar: 3.9,
                vitaminA: 61,
                vitaminC: 34.4,
                folate: 12,
                calcium: 3,
                iron: 0.1,
                magnesium: 10,
                potassium: 133
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Star-shaped tropical fruit, eaten with skin",
            nameFr: "Carambole",
            nameEs: "Carambola",
            nameHe: "קרמבולה",
            notesFr: "Fruit tropical en forme d'étoile, se mange avec la peau",
            notesEs: "Fruta tropical en forma de estrella, se come con piel",
            notesHe: "פרי טרופי בצורת כוכב, נאכל עם הקליפה"
        ),
        
        // Lychee
        FoodItem(
            id: UUID(),
            name: "Lychee",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 66,
                protein: 0.8,
                carbohydrates: 16.5,
                fat: 0.4,
                fiber: 1.3,
                sugar: 15.2,
                vitaminA: 0,
                vitaminC: 71.5,
                folate: 14,
                calcium: 5,
                iron: 0.3,
                magnesium: 10,
                potassium: 171
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Sweet tropical fruit with floral flavor",
            nameFr: "Litchi",
            nameEs: "Lichi",
            nameHe: "ליצ'י",
            notesFr: "Fruit tropical sucré au goût floral",
            notesEs: "Fruta tropical dulce con sabor floral",
            notesHe: "פרי טרופי מתוק בטעם פרחוני"
        ),
        
        // Rambutan
        FoodItem(
            id: UUID(),
            name: "Rambutan",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 82,
                protein: 0.7,
                carbohydrates: 20.9,
                fat: 0.2,
                fiber: 0.9,
                sugar: 15.0,
                vitaminA: 0,
                vitaminC: 4.9,
                folate: 8,
                calcium: 22,
                iron: 0.4,
                magnesium: 7,
                potassium: 42
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Hairy tropical fruit similar to lychee",
            nameFr: "Ramboutan",
            nameEs: "Rambután",
            nameHe: "רמבוטן",
            notesFr: "Fruit tropical poilu similaire au litchi",
            notesEs: "Fruta tropical peluda similar al lichi",
            notesHe: "פרי טרופי שעיר דומה לליצ'י"
        ),
        
        // Jackfruit
        FoodItem(
            id: UUID(),
            name: "Jackfruit",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 95,
                protein: 1.7,
                carbohydrates: 23.2,
                fat: 0.6,
                fiber: 1.5,
                sugar: 19.1,
                vitaminA: 110,
                vitaminC: 13.7,
                folate: 24,
                calcium: 24,
                iron: 0.2,
                magnesium: 29,
                potassium: 448
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Large tropical fruit with sweet, unique flavor",
            nameFr: "Jacquier",
            nameEs: "Yaca",
            nameHe: "ג'קפרוט",
            notesFr: "Grand fruit tropical au goût sucré et unique",
            notesEs: "Fruta tropical grande con sabor dulce y único",
            notesHe: "פרי טרופי גדול בטעם מתוק וייחודי"
        ),
        
        // Durian
        FoodItem(
            id: UUID(),
            name: "Durian",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 147,
                protein: 1.5,
                carbohydrates: 27.1,
                fat: 5.3,
                fiber: 3.8,
                sugar: 6.7,
                vitaminA: 44,
                vitaminC: 19.7,
                thiamin: 0.4,
                folate: 36,
                calcium: 6,
                iron: 0.4,
                magnesium: 30,
                potassium: 436
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "King of fruits with strong aroma and creamy texture",
            nameFr: "Durian",
            nameEs: "Durian",
            nameHe: "דוריאן",
            notesFr: "Roi des fruits à l'arôme fort et à la texture crémeuse",
            notesEs: "Rey de las frutas con aroma fuerte y textura cremosa",
            notesHe: "מלך הפירות עם ארומה חזקה ומרקם קרמי"
        ),
        
        // Mangosteen
        FoodItem(
            id: UUID(),
            name: "Mangosteen",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 73,
                protein: 0.4,
                carbohydrates: 17.9,
                fat: 0.6,
                fiber: 1.8,
                sugar: 16.1,
                vitaminA: 35,
                vitaminC: 2.9,
                folate: 31,
                calcium: 12,
                iron: 0.3,
                magnesium: 13,
                potassium: 48
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Queen of fruits with sweet, tangy flavor",
            nameFr: "Mangoustan",
            nameEs: "Mangostán",
            nameHe: "מנגוסטן",
            notesFr: "Reine des fruits au goût sucré et acidulé",
            notesEs: "Reina de las frutas con sabor dulce y ácido",
            notesHe: "מלכת הפירות בטעם מתוק וחמצמץ"
        ),
        
        // Longan
        FoodItem(
            id: UUID(),
            name: "Longan",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 60,
                protein: 1.3,
                carbohydrates: 15.1,
                fat: 0.1,
                fiber: 1.1,
                sugar: 14.0,
                vitaminA: 0,
                vitaminC: 84,
                folate: 0,
                calcium: 1,
                iron: 0.1,
                magnesium: 10,
                potassium: 266
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Small tropical fruit similar to lychee",
            nameFr: "Longan",
            nameEs: "Longan",
            nameHe: "לונגן",
            notesFr: "Petit fruit tropical similaire au litchi",
            notesEs: "Fruta tropical pequeña similar al lichi",
            notesHe: "פרי טרופי קטן דומה לליצ'י"
        ),
        
        // Custard Apple
        FoodItem(
            id: UUID(),
            name: "Custard Apple",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 94,
                protein: 2.1,
                carbohydrates: 23.6,
                fat: 0.3,
                fiber: 4.4,
                sugar: 19.2,
                vitaminA: 33,
                vitaminC: 36.3,
                folate: 14,
                calcium: 24,
                iron: 0.6,
                magnesium: 21,
                potassium: 247
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Creamy tropical fruit with custard-like texture",
            nameFr: "Pomme cannelle",
            nameEs: "Chirimoya",
            nameHe: "תפוח קרם",
            notesFr: "Fruit tropical crémeux à la texture de crème anglaise",
            notesEs: "Fruta tropical cremosa con textura de natilla",
            notesHe: "פרי טרופי קרמי במרקם דמוי קרם"
        ),
        
        // Soursop
        FoodItem(
            id: UUID(),
            name: "Soursop",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 66,
                protein: 1.0,
                carbohydrates: 16.8,
                fat: 0.3,
                fiber: 3.3,
                sugar: 13.5,
                vitaminA: 2,
                vitaminC: 20.6,
                folate: 14,
                calcium: 14,
                iron: 0.6,
                magnesium: 21,
                potassium: 278
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Large tropical fruit with sweet-tart flavor",
            nameFr: "Corossol",
            nameEs: "Guanábana",
            nameHe: "סורסופ",
            notesFr: "Grand fruit tropical au goût sucré-acidulé",
            notesEs: "Fruta tropical grande con sabor dulce-ácido",
            notesHe: "פרי טרופי גדול בטעם מתוק-חמצמץ"
        ),
        
        // Breadfruit
        FoodItem(
            id: UUID(),
            name: "Breadfruit",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 103,
                protein: 1.1,
                carbohydrates: 27.1,
                fat: 0.2,
                fiber: 4.9,
                sugar: 11.0,
                vitaminA: 0,
                vitaminC: 29,
                thiamin: 0.1,
                folate: 14,
                calcium: 17,
                iron: 0.5,
                magnesium: 25,
                potassium: 490
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Starchy tropical fruit, cooked like a vegetable",
            nameFr: "Fruit à pain",
            nameEs: "Fruta del pan",
            nameHe: "פרי הלחם",
            notesFr: "Fruit tropical féculent, cuit comme un légume",
            notesEs: "Fruta tropical con almidón, cocinada como vegetal",
            notesHe: "פרי טרופי עמילני, מבושל כמו ירק"
        ),
        
        // Tamarind
        FoodItem(
            id: UUID(),
            name: "Tamarind",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 239,
                protein: 2.8,
                carbohydrates: 62.5,
                fat: 0.6,
                fiber: 5.1,
                sugar: 57.4,
                vitaminA: 30,
                vitaminC: 3.5,
                thiamin: 0.4,
                folate: 14,
                calcium: 74,
                iron: 2.8,
                magnesium: 92,
                potassium: 628
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Tangy pod fruit used in cooking and beverages",
            nameFr: "Tamarin",
            nameEs: "Tamarindo",
            nameHe: "תמר הודי",
            notesFr: "Fruit de gousse acidulé utilisé en cuisine et boissons",
            notesEs: "Fruta de vaina ácida usada en cocina y bebidas",
            notesHe: "פרי תרמיל חמצמץ המשמש בבישול ובמשקאות"
        ),
        
        // Elderberry
        FoodItem(
            id: UUID(),
            name: "Elderberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 73,
                protein: 0.7,
                carbohydrates: 18.4,
                fat: 0.5,
                fiber: 7.0,
                sugar: 11.4,
                vitaminA: 600,
                vitaminC: 36,
                folate: 6,
                calcium: 38,
                iron: 1.6,
                magnesium: 5,
                potassium: 280
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Dark purple berries, often used in syrups and supplements",
            nameFr: "Sureau",
            nameEs: "Saúco",
            nameHe: "סמבוק",
            notesFr: "Baies violet foncé, souvent utilisées dans les sirops et suppléments",
            notesEs: "Bayas púrpura oscuro, a menudo usadas en jarabes y suplementos",
            notesHe: "פירות יער סגולים כהים, משמשים לעתים קרובות בסירופים ותוספי מזון"
        ),
        
        // Gooseberry
        FoodItem(
            id: UUID(),
            name: "Gooseberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 44,
                protein: 0.9,
                carbohydrates: 10.2,
                fat: 0.6,
                fiber: 4.3,
                sugar: 5.9,
                vitaminA: 290,
                vitaminC: 27.7,
                folate: 6,
                calcium: 25,
                iron: 0.3,
                magnesium: 10,
                potassium: 198
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Tart berry, green or red varieties",
            nameFr: "Groseille à maquereau",
            nameEs: "Grosella espinosa",
            nameHe: "דומדמנית",
            notesFr: "Baie acidulée, variétés vertes ou rouges",
            notesEs: "Baya ácida, variedades verdes o rojas",
            notesHe: "פרי יער חמצמץ, זנים ירוקים או אדומים"
        ),
        
        // Currant
        FoodItem(
            id: UUID(),
            name: "Currant",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 56,
                protein: 1.4,
                carbohydrates: 13.8,
                fat: 0.2,
                fiber: 4.3,
                sugar: 9.5,
                vitaminA: 42,
                vitaminC: 41,
                folate: 8,
                calcium: 55,
                iron: 1.5,
                magnesium: 13,
                potassium: 275
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Small tart berries, red or black varieties",
            nameFr: "Groseille",
            nameEs: "Grosella",
            nameHe: "דומדמנית",
            notesFr: "Petites baies acidulées, variétés rouges ou noires",
            notesEs: "Bayas pequeñas ácidas, variedades rojas o negras",
            notesHe: "פירות יער קטנים וחמצמצים, זנים אדומים או שחורים"
        ),
        
        // Cranberry
        FoodItem(
            id: UUID(),
            name: "Cranberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 46,
                protein: 0.4,
                carbohydrates: 12.2,
                fat: 0.1,
                fiber: 4.6,
                sugar: 4.0,
                vitaminA: 60,
                vitaminC: 13.3,
                vitaminE: 1.2,
                folate: 1,
                calcium: 8,
                iron: 0.2,
                magnesium: 6,
                potassium: 85
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Tart red berries, high in antioxidants",
            nameFr: "Canneberge",
            nameEs: "Arándano rojo",
            nameHe: "חמוצית",
            notesFr: "Baies rouges acidulées, riches en antioxydants",
            notesEs: "Bayas rojas ácidas, altas en antioxidantes",
            notesHe: "פירות יער אדומים וחמצמצים, עשירים בנוגדי חמצון"
        ),
        
        // Mulberry
        FoodItem(
            id: UUID(),
            name: "Mulberry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 43,
                protein: 1.4,
                carbohydrates: 9.8,
                fat: 0.4,
                fiber: 1.7,
                sugar: 8.1,
                vitaminA: 25,
                vitaminC: 36.4,
                folate: 6,
                calcium: 39,
                iron: 1.9,
                magnesium: 18,
                potassium: 194
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Sweet berries from mulberry trees, white or dark varieties",
            nameFr: "Mûre",
            nameEs: "Mora",
            nameHe: "תות עץ",
            notesFr: "Baies sucrées des mûriers, variétés blanches ou foncées",
            notesEs: "Bayas dulces de moreras, variedades blancas o oscuras",
            notesHe: "פירות יער מתוקים מעצי תות, זנים לבנים או כהים"
        ),
        
        // Acai Berry
        FoodItem(
            id: UUID(),
            name: "Acai Berry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 70,
                protein: 1.0,
                carbohydrates: 4.0,
                fat: 5.0,
                fiber: 2.0,
                sugar: 2.0,
                vitaminA: 1002,
                vitaminC: 0,
                calcium: 40,
                iron: 0.8,
                magnesium: 0,
                potassium: 105
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Superfruit berry high in antioxidants and healthy fats",
            nameFr: "Baie d'açaï",
            nameEs: "Baya de açaí",
            nameHe: "פרי אסאי",
            notesFr: "Superfruits riches en antioxydants et graisses saines",
            notesEs: "Superfruta rica en antioxidantes y grasas saludables",
            notesHe: "סופרפרוט עשיר בנוגדי חמצון ושומנים בריאים"
        ),
        
        // Goji Berry
        FoodItem(
            id: UUID(),
            name: "Goji Berry",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 349,
                protein: 14.3,
                carbohydrates: 77.1,
                fat: 0.4,
                fiber: 13.0,
                sugar: 45.6,
                vitaminA: 26822,
                vitaminC: 48.4,
                folate: 0,
                calcium: 190,
                iron: 6.8,
                magnesium: 0,
                potassium: 1132
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Dried superfruit berries, very high in nutrients (values for dried)",
            nameFr: "Baie de goji",
            nameEs: "Baya de goji",
            nameHe: "פרי גוג'י",
            notesFr: "Superfruits séchés, très riches en nutriments (valeurs pour séchés)",
            notesEs: "Superfruta seca, muy alta en nutrientes (valores para seca)",
            notesHe: "סופרפרוט מיובש, עשיר מאוד בחומרי מזון (ערכים למיובש)"
        ),
        
        // Cactus Pear
        FoodItem(
            id: UUID(),
            name: "Cactus Pear",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 41,
                protein: 0.7,
                carbohydrates: 9.6,
                fat: 0.5,
                fiber: 3.6,
                sugar: 5.9,
                vitaminA: 43,
                vitaminC: 14,
                folate: 6,
                calcium: 56,
                iron: 0.3,
                magnesium: 85,
                potassium: 220
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Prickly pear cactus fruit, sweet and refreshing",
            nameFr: "Figue de Barbarie",
            nameEs: "Tuna",
            nameHe: "צבר",
            notesFr: "Fruit de figuier de Barbarie, doux et rafraîchissant",
            notesEs: "Fruta de nopal, dulce y refrescante",
            notesHe: "פרי צבר, מתוק ומרענן"
        ),
        
        // Plantain (Sweet)
        FoodItem(
            id: UUID(),
            name: "Sweet Plantain",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 89,
                protein: 1.3,
                carbohydrates: 22.8,
                fat: 0.4,
                fiber: 2.3,
                sugar: 12.2,
                vitaminA: 1127,
                vitaminC: 18.4,
                vitaminB6: 0.3,
                folate: 22,
                calcium: 3,
                iron: 0.6,
                magnesium: 37,
                potassium: 499
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Ripe plantain, sweet and soft, eaten as fruit",
            nameFr: "Banane plantain douce",
            nameEs: "Plátano dulce",
            nameHe: "בננת בישול מתוקה",
            notesFr: "Banane plantain mûre, douce et molle, mangée comme fruit",
            notesEs: "Plátano maduro, dulce y suave, comido como fruta",
            notesHe: "בננת בישול בשלה, מתוקה ורכה, נאכלת כפרי"
        ),
        
        // Quince
        FoodItem(
            id: UUID(),
            name: "Quince",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 57,
                protein: 0.4,
                carbohydrates: 15.3,
                fat: 0.1,
                fiber: 1.9,
                sugar: 12.5,
                vitaminA: 40,
                vitaminC: 15,
                folate: 3,
                calcium: 11,
                iron: 0.7,
                magnesium: 8,
                potassium: 197
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fragrant fruit, usually cooked due to tartness",
            nameFr: "Coing",
            nameEs: "Membrillo",
            nameHe: "חבוש",
            notesFr: "Fruit parfumé, généralement cuit en raison de son acidité",
            notesEs: "Fruta fragante, generalmente cocinada debido a su acidez",
            notesHe: "פרי ארומטי, בדרך כלל מבושל בשל חמיצותו"
        ),
        
        // Medlar
        FoodItem(
            id: UUID(),
            name: "Medlar",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 45,
                protein: 0.4,
                carbohydrates: 11.2,
                fat: 0.2,
                fiber: 8.6,
                sugar: 2.6,
                vitaminA: 0,
                vitaminC: 0.3,
                folate: 0,
                calcium: 30,
                iron: 0.4,
                magnesium: 0,
                potassium: 250
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Ancient fruit, eaten when very ripe and soft",
            nameFr: "Nèfle",
            nameEs: "Níspero",
            nameHe: "שסק",
            notesFr: "Fruit ancien, mangé quand très mûr et mou",
            notesEs: "Fruta antigua, comida cuando está muy madura y suave",
            notesHe: "פרי עתיק, נאכל כשהוא בשל מאוד ורך"
        ),
        
        // Jujube
        FoodItem(
            id: UUID(),
            name: "Jujube",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 79,
                protein: 1.2,
                carbohydrates: 20.2,
                fat: 0.2,
                fiber: 0.0,
                sugar: 20.2,
                vitaminA: 40,
                vitaminC: 69,
                folate: 0,
                calcium: 21,
                iron: 0.5,
                magnesium: 10,
                potassium: 250
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Small sweet fruit, also called Chinese date",
            nameFr: "Jujube",
            nameEs: "Azufaifo",
            nameHe: "שיזף סיני",
            notesFr: "Petit fruit sucré, aussi appelé datte chinoise",
            notesEs: "Fruta pequeña dulce, también llamada dátil chino",
            notesHe: "פרי קטן ומתוק, נקרא גם תמר סיני"
        )
    ]
} 