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
                sugar: 30,
                calcium: 70 // Moderate calcium from eggs and milk
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice",
            nameFr: "Cake aux Quatre-Quarts",
            nameEs: "Bizcocho Libra",
            nameHe: "עוגת חמאה",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
                sugar: 35,
                calcium: 60 // Low-moderate calcium content
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
                sugar: 34,
                calcium: 95 // Good calcium from cream cheese frosting
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau aux Carottes",
            nameEs: "Pastel de Zanahoria",
            nameHe: "עוגת גזר",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau au Café (Streusel)",
            nameEs: "Pastel de Café (Streusel)",
            nameHe: "עוגת קפה (שטרויזל)",
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
                sugar: 28
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau Marbré",
            nameEs: "Bizcocho Marmoleado",
            nameHe: "עוגת שיש",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau des Anges",
            nameEs: "Bizcocho Ángel",
            nameHe: "עוגת מלאך",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau Victoria",
            nameEs: "Bizcocho Victoria",
            nameHe: "עוגת ספוג ויקטוריה",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Cake aux Fruits / Gâteau de Dundee",
            nameEs: "Pastel de Frutas / Pastel Dundee",
            nameHe: "עוגת פירות / עוגת דנדי",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau Bundt (Citron)",
            nameEs: "Bizcocho Bundt (Limón)",
            nameHe: "עוגת בונדט (לימון)",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Sachertorte",
            nameEs: "Sachertorte",
            nameHe: "זאכר טורטה",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Génoise aux Baies",
            nameEs: "Bizcocho Genovés con Bayas",
            nameHe: "ג'נואז עם פירות יער",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Cheesecake à la Ricotta",
            nameEs: "Tarta de Queso Ricotta",
            nameHe: "עוגת גבינת ריקוטה",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau Tres Leches",
            nameEs: "Pastel Tres Leches",
            nameHe: "עוגת שלושת החלבים",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau à la Noix de Coco",
            nameEs: "Pastel de Coco",
            nameHe: "עוגת קוקוס",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau au Miel (Medovik)",
            nameEs: "Pastel de Miel (Medovik)",
            nameHe: "עוגת דבש (מדוביק)",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Forêt-Noire",
            nameEs: "Pastel Selva Negra",
            nameHe: "עוגת יער שחור",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau au Yaourt Français",
            nameEs: "Bizcocho de Yogur Francés",
            nameHe: "עוגת יוגורט צרפתית",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau Suédois Toscakaka",
            nameEs: "Pastel Sueco Toscakaka",
            nameHe: "עוגת טוסקאקאקה שוודית",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Pain aux Bananes (Cake)",
            nameEs: "Pan de Plátano (Bizcocho)",
            nameHe: "לחם בננות (עוגה)",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau aux Épices",
            nameEs: "Pastel de Especias",
            nameHe: "עוגת תבלינים",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau Semoule-Orange",
            nameEs: "Pastel de Sémola y Naranja",
            nameHe: "עוגת סולת ותפוזים",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Tarte à la Farine d'Amande",
            nameEs: "Torta de Harina de Almendra",
            nameHe: "טורט קמח שקדים",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Gâteau Boston Cream Pie",
            nameEs: "Pastel Boston Cream Pie",
            nameHe: "עוגת בוסטון קרם פאי",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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
            notes: "Approx. values per 100 g slice",
            nameFr: "Kougelhopf (Kouglof)",
            nameEs: "Kugelhopf (Gugelhupf)",
            nameHe: "קוגלהופף (גוגלהופף)",
            notesFr: "Valeurs approx. pour une tranche de 100 g",
            notesEs: "Valores aprox. por porción de 100 g",
            notesHe: "ערכים משוערים ל-100 גרם פרוסה"
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