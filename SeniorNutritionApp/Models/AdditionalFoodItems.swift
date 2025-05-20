import Foundation

struct AdditionalFoodItems {
    static let foods: [FoodItem] = [
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
                sugar: 0.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh avocado",
            nameFr: "Avocat",
            nameEs: "Aguacate",
            nameHe: "אבוקדו",
            notesFr: "Avocat frais",
            notesEs: "Aguacate fresco",
            notesHe: "אבוקדו טרי"
        ),
        
        // Quinoa
        FoodItem(
            id: UUID(),
            name: "Quinoa",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 120,
                protein: 4.4,
                carbohydrates: 21.3,
                fat: 1.9,
                fiber: 2.8,
                sugar: 0.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked quinoa",
            nameFr: "Quinoa",
            nameEs: "Quinoa",
            nameHe: "קינואה",
            notesFr: "Quinoa cuit",
            notesEs: "Quinoa cocida",
            notesHe: "קינואה מבושלת"
        ),
        
        // Chia Seeds
        FoodItem(
            id: UUID(),
            name: "Chia Seeds",
            category: .other,
            nutritionalInfo: NutritionalInfo(
                calories: 138,
                protein: 4.7,
                carbohydrates: 11.9,
                fat: 8.7,
                fiber: 9.8,
                sugar: 0.0
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Dried chia seeds",
            nameFr: "Graines de Chia",
            nameEs: "Semillas de Chía",
            nameHe: "זרעי צ'יה",
            notesFr: "Graines de chia séchées",
            notesEs: "Semillas de chía secas",
            notesHe: "זרעי צ'יה מיובשים"
        ),
        
        // Lentils
        FoodItem(
            id: UUID(),
            name: "Lentils",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 116,
                protein: 9.0,
                carbohydrates: 20.1,
                fat: 0.4,
                fiber: 7.9,
                sugar: 1.8
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked lentils",
            nameFr: "Lentilles",
            nameEs: "Lentejas",
            nameHe: "עדשים",
            notesFr: "Lentilles cuites",
            notesEs: "Lentejas cocidas",
            notesHe: "עדשים מבושלות"
        ),
        
        // Carrots
        FoodItem(
            id: UUID(),
            name: "Carrots",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 41,
                protein: 0.9,
                carbohydrates: 9.6,
                fat: 0.2,
                fiber: 2.8,
                sugar: 4.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw carrots",
            nameFr: "Carottes",
            nameEs: "Zanahorias",
            nameHe: "גזרים",
            notesFr: "Carottes crues",
            notesEs: "Zanahorias crudas",
            notesHe: "גזרים טריים"
        ),
        
        // Apples
        FoodItem(
            id: UUID(),
            name: "Apples",
            category: .fruits,
            nutritionalInfo: NutritionalInfo(
                calories: 52,
                protein: 0.3,
                carbohydrates: 13.8,
                fat: 0.2,
                fiber: 2.4,
                sugar: 10.4
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh apple with skin",
            nameFr: "Pommes",
            nameEs: "Manzanas",
            nameHe: "תפוחים",
            notesFr: "Pomme fraîche avec la peau",
            notesEs: "Manzana fresca con piel",
            notesHe: "תפוח טרי עם הקליפה"
        ),
        
        // Tomatoes
        FoodItem(
            id: UUID(),
            name: "Tomatoes",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 18,
                protein: 0.9,
                carbohydrates: 3.9,
                fat: 0.2,
                fiber: 1.2,
                sugar: 2.6
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw tomatoes",
            nameFr: "Tomates",
            nameEs: "Tomates",
            nameHe: "עגבניות",
            notesFr: "Tomates crues",
            notesEs: "Tomates crudos",
            notesHe: "עגבניות טריות"
        ),
        
        // Peanuts
        FoodItem(
            id: UUID(),
            name: "Peanuts",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 567,
                protein: 25.8,
                carbohydrates: 16.1,
                fat: 49.2,
                fiber: 8.5,
                sugar: 4.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Raw peanuts",
            nameFr: "Cacahuètes",
            nameEs: "Cacahuetes",
            nameHe: "בוטנים",
            notesFr: "Cacahuètes crues",
            notesEs: "Cacahuetes crudos",
            notesHe: "בוטנים טריים"
        ),
        
        // Barley
        FoodItem(
            id: UUID(),
            name: "Barley",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 354,
                protein: 12.5,
                carbohydrates: 73.5,
                fat: 2.3,
                fiber: 17.3,
                sugar: 0.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Uncooked hulled barley",
            nameFr: "Orge",
            nameEs: "Cebada",
            nameHe: "שעורה",
            notesFr: "Orge mondé non cuit",
            notesEs: "Cebada pelada sin cocer",
            notesHe: "שעורה קלופה לא מבושלת"
        ),
        
        // Pumpkin
        FoodItem(
            id: UUID(),
            name: "Pumpkin",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 20,
                protein: 1.0,
                carbohydrates: 4.9,
                fat: 0.1,
                fiber: 1.1,
                sugar: 2.1
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked pumpkin",
            nameFr: "Citrouille",
            nameEs: "Calabaza",
            nameHe: "דלעת",
            notesFr: "Citrouille cuite",
            notesEs: "Calabaza cocida",
            notesHe: "דלעת מבושלת"
        ),
        
        // Whole Wheat Pasta
        FoodItem(
            id: UUID(),
            name: "Whole Wheat Pasta",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 127,
                protein: 5.8,
                carbohydrates: 27.0,
                fat: 0.7,
                fiber: 3.9,
                sugar: 0.9
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked whole wheat pasta",
            nameFr: "Pâtes Complètes",
            nameEs: "Pasta Integral",
            nameHe: "פסטה מחיטה מלאה",
            notesFr: "Pâtes complètes cuites",
            notesEs: "Pasta integral cocida",
            notesHe: "פסטה מחיטה מלאה מבושלת"
        ),
        
        // Hummus
        FoodItem(
            id: UUID(),
            name: "Hummus",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 177,
                protein: 4.9,
                carbohydrates: 20.1,
                fat: 8.6,
                fiber: 6.0,
                sugar: 0.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Prepared hummus",
            nameFr: "Houmous",
            nameEs: "Hummus",
            nameHe: "חומוס",
            notesFr: "Houmous préparé",
            notesEs: "Hummus preparado",
            notesHe: "חומוס מוכן"
        ),
        
        // Granola
        FoodItem(
            id: UUID(),
            name: "Granola",
            category: .grains,
            nutritionalInfo: NutritionalInfo(
                calories: 408,
                protein: 9.2,
                carbohydrates: 72.4,
                fat: 11.0,
                fiber: 7.0,
                sugar: 17.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Plain granola",
            nameFr: "Granola",
            nameEs: "Granola",
            nameHe: "גרנולה",
            notesFr: "Granola nature",
            notesEs: "Granola simple",
            notesHe: "גרנולה רגילה"
        ),
        
        // Black Beans
        FoodItem(
            id: UUID(),
            name: "Black Beans",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 132,
                protein: 8.9,
                carbohydrates: 23.7,
                fat: 0.5,
                fiber: 8.7,
                sugar: 0.3
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Cooked black beans",
            nameFr: "Haricots Noirs",
            nameEs: "Frijoles Negros",
            nameHe: "שעועית שחורה",
            notesFr: "Haricots noirs cuits",
            notesEs: "Frijoles negros cocidos",
            notesHe: "שעועית שחורה מבושלת"
        ),
        
        // Cottage Cheese
        FoodItem(
            id: UUID(),
            name: "Cottage Cheese",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 98,
                protein: 11.1,
                carbohydrates: 3.4,
                fat: 4.3,
                fiber: 0.0,
                sugar: 2.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Low-fat cottage cheese",
            nameFr: "Fromage Cottage",
            nameEs: "Queso Cottage",
            nameHe: "גבינת קוטג'",
            notesFr: "Fromage cottage allégé",
            notesEs: "Queso cottage bajo en grasa",
            notesHe: "גבינת קוטג' דלת שומן"
        ),
        
        // Hard-Boiled Egg
        FoodItem(
            id: UUID(),
            name: "Hard-Boiled Egg",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 78,
                protein: 6.3,
                carbohydrates: 0.6,
                fat: 5.3,
                fiber: 0.0,
                sugar: 0.6
            ),
            servingSize: 50,
            servingUnit: "g",
            isCustom: true,
            notes: "Large hard-boiled egg",
            nameFr: "Œuf Dur",
            nameEs: "Huevo Duro",
            nameHe: "ביצה קשה",
            notesFr: "Gros œuf dur",
            notesEs: "Huevo duro grande",
            notesHe: "ביצה קשה גדולה"
        ),
        
        // Greek Yogurt
        FoodItem(
            id: UUID(),
            name: "Greek Yogurt",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 59,
                protein: 10.0,
                carbohydrates: 3.6,
                fat: 0.4,
                fiber: 0.0,
                sugar: 3.2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Plain Greek yogurt",
            nameFr: "Yaourt Grec",
            nameEs: "Yogur Griego",
            nameHe: "יוגורט יווני",
            notesFr: "Yaourt grec nature",
            notesEs: "Yogur griego natural",
            notesHe: "יוגורט יווני טבעי"
        ),
        
        // Peanut Butter
        FoodItem(
            id: UUID(),
            name: "Peanut Butter",
            category: .fats,
            nutritionalInfo: NutritionalInfo(
                calories: 588,
                protein: 25.0,
                carbohydrates: 20.0,
                fat: 50.0,
                fiber: 6.0,
                sugar: 9.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Unsweetened peanut butter",
            nameFr: "Beurre de Cacahuète",
            nameEs: "Mantequilla de Cacahuete",
            nameHe: "חמאת בוטנים",
            notesFr: "Beurre de cacahuète non sucré",
            notesEs: "Mantequilla de cacahuete sin azúcar",
            notesHe: "חמאת בוטנים ללא סוכר"
        ),
        
        // Canned Tuna
        FoodItem(
            id: UUID(),
            name: "Canned Tuna",
            category: .protein,
            nutritionalInfo: NutritionalInfo(
                calories: 116,
                protein: 26.0,
                carbohydrates: 0.0,
                fat: 1.0,
                fiber: 0.0,
                sugar: 0.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Canned tuna in water",
            nameFr: "Thon en Conserve",
            nameEs: "Atún en Lata",
            nameHe: "טונה בקופסה",
            notesFr: "Thon en conserve au naturel",
            notesEs: "Atún en lata en agua",
            notesHe: "טונה בקופסה במים"
        ),
        
        // Mixed Vegetables
        FoodItem(
            id: UUID(),
            name: "Mixed Vegetables",
            category: .vegetables,
            nutritionalInfo: NutritionalInfo(
                calories: 65,
                protein: 2.5,
                carbohydrates: 11.5,
                fat: 0.5,
                fiber: 3.8,
                sugar: 4.5
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Frozen mixed vegetables",
            nameFr: "Légumes Mixtes",
            nameEs: "Verduras Mixtas",
            nameHe: "ירקות מעורבים",
            notesFr: "Légumes mixtes surgelés",
            notesEs: "Verduras mixtas congeladas",
            notesHe: "ירקות מעורבים קפואים"
        ),
        
        // MARK: - Cake Food Items
        
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
                sugar: 30
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
                sugar: 34
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
        
        // MARK: - Dairy Food Items
        
        // Whole Milk
        FoodItem(
            id: UUID(),
            name: "Whole Milk",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 61,
                protein: 3.2,
                carbohydrates: 4.8,
                fat: 3.3,
                fiber: 0.0,
                sugar: 5.0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Standard whole cow's milk",
            nameFr: "Lait Entier",
            nameEs: "Leche Entera",
            nameHe: "חלב מלא",
            notesFr: "Lait de vache entier standard",
            notesEs: "Leche entera estándar de vaca",
            notesHe: "חלב פרה מלא רגיל"
        ),
        
        // Greek Yogurt
        FoodItem(
            id: UUID(),
            name: "Greek Yogurt (Nonfat)",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 59,
                protein: 10.0,
                carbohydrates: 3.6,
                fat: 0.4,
                fiber: 0.0,
                sugar: 3.2
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Plain nonfat Greek yogurt",
            nameFr: "Yaourt Grec (Sans Matière Grasse)",
            nameEs: "Yogur Griego (Sin Grasa)",
            nameHe: "יוגורט יווני (ללא שומן)",
            notesFr: "Yaourt grec nature sans matière grasse",
            notesEs: "Yogur griego natural sin grasa",
            notesHe: "יוגורט יווני טבעי ללא שומן"
        ),
        
        // Cottage Cheese
        FoodItem(
            id: UUID(),
            name: "Cottage Cheese (Low-fat)",
            category: .dairy,
            nutritionalInfo: NutritionalInfo(
                calories: 98,
                protein: 11.1,
                carbohydrates: 3.4,
                fat: 4.3,
                fiber: 0.0,
                sugar: 2.7
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Low-fat cottage cheese",
            nameFr: "Fromage Cottage",
            nameEs: "Queso Cottage",
            nameHe: "גבינת קוטג'",
            notesFr: "Fromage cottage allégé",
            notesEs: "Queso cottage bajo en grasa",
            notesHe: "גבינת קוטג' דלת שומן"
        ),
        
        // MARK: - Beverage Food Items
        
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
        
        // MARK: - Bread and Sandwich Food Items
        
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
        )
    ]
} 