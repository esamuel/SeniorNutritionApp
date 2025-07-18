import Foundation

struct MiddleEasternCuisineFoodItems {
    static let foods: [FoodItem] = [
        // Hummus
        FoodItem(
            id: UUID(),
            name: "Hummus",
            category: .protein,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 185,
                protein: 8.5,
                carbohydrates: 18,
                fat: 9.8,
                fiber: 6.2,
                sugar: 3.5,
                vitaminA: 25,
                vitaminC: 12,
                vitaminD: 0,
                vitaminE: 1.8,
                vitaminK: 15,
                thiamin: 0.12,
                riboflavin: 0.08,
                niacin: 1.8,
                vitaminB6: 0.25,
                vitaminB12: 0,
                folate: 85,
                calcium: 85,
                iron: 2.8,
                magnesium: 65,
                phosphorus: 185,
                potassium: 285,
                sodium: 485,
                zinc: 1.8,
                selenium: 8.5,
                omega3: 0.8,
                omega6: 3.8,
                cholesterol: 0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Creamy chickpea dip with tahini, lemon, and garlic",
            nameFr: "Houmous",
            nameEs: "Hummus",
            nameHe: "חומוס",
            notesFr: "Purée de pois chiches crémeuse avec tahini, citron et ail",
            notesEs: "Dip cremoso de garbanzos con tahini, limón y ajo",
            notesHe: "ממרח חומוס קרמי עם טחינה, לימון ושום"
        ),
        
        // Falafel
        FoodItem(
            id: UUID(),
            name: "Falafel",
            category: .protein,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 285,
                protein: 12.8,
                carbohydrates: 28,
                fat: 14.8,
                fiber: 5.8,
                sugar: 4.5,
                vitaminA: 85,
                vitaminC: 15,
                vitaminD: 0,
                vitaminE: 2.8,
                vitaminK: 25,
                thiamin: 0.18,
                riboflavin: 0.12,
                niacin: 2.8,
                vitaminB6: 0.35,
                vitaminB12: 0,
                folate: 125,
                calcium: 125,
                iron: 3.8,
                magnesium: 85,
                phosphorus: 225,
                potassium: 385,
                sodium: 685,
                zinc: 2.8,
                selenium: 12.5,
                omega3: 0.5,
                omega6: 6.8,
                cholesterol: 0
            ),
            servingSize: 120,
            servingUnit: "g",
            isCustom: true,
            notes: "Deep-fried chickpea and herb balls - Middle Eastern staple",
            nameFr: "Falafel",
            nameEs: "Falafel",
            nameHe: "פלאפל",
            notesFr: "Boulettes de pois chiches et herbes frites - base du Moyen-Orient",
            notesEs: "Bolas de garbanzos y hierbas fritas - básico del Medio Oriente",
            notesHe: "כדורי חומוס ועשבי תיבול מטוגנים - בסיס מזרח תיכוני"
        ),
        
        // Shawarma
        FoodItem(
            id: UUID(),
            name: "Shawarma",
            category: .protein,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 385,
                protein: 28.5,
                carbohydrates: 15,
                fat: 24.8,
                fiber: 2.2,
                sugar: 6.5,
                vitaminA: 125,
                vitaminC: 25,
                vitaminD: 0.8,
                vitaminE: 2.2,
                vitaminK: 35,
                thiamin: 0.25,
                riboflavin: 0.28,
                niacin: 9.8,
                vitaminB6: 0.48,
                vitaminB12: 3.2,
                folate: 45,
                calcium: 85,
                iron: 3.8,
                magnesium: 58,
                phosphorus: 285,
                potassium: 485,
                sodium: 885,
                zinc: 4.8,
                selenium: 25.8,
                omega3: 0.3,
                omega6: 4.2,
                cholesterol: 85
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Spiced meat cooked on rotating spit with vegetables and sauce",
            nameFr: "Shawarma",
            nameEs: "Shawarma",
            nameHe: "שווארמה",
            notesFr: "Viande épicée cuite sur broche rotative avec légumes et sauce",
            notesEs: "Carne especiada cocida en asador giratorio con verduras y salsa",
            notesHe: "בשר מתובל מבושל על שיפוד מסתובב עם ירקות ורוטב"
        ),
        
        // Tabbouleh
        FoodItem(
            id: UUID(),
            name: "Tabbouleh",
            category: .vegetables,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 125,
                protein: 4.8,
                carbohydrates: 18,
                fat: 4.8,
                fiber: 3.8,
                sugar: 3.5,
                vitaminA: 285,
                vitaminC: 85,
                vitaminD: 0,
                vitaminE: 2.8,
                vitaminK: 285,
                thiamin: 0.15,
                riboflavin: 0.12,
                niacin: 2.2,
                vitaminB6: 0.28,
                vitaminB12: 0,
                folate: 125,
                calcium: 125,
                iron: 2.8,
                magnesium: 65,
                phosphorus: 85,
                potassium: 485,
                sodium: 285,
                zinc: 1.2,
                selenium: 5.5,
                omega3: 0.5,
                omega6: 1.8,
                cholesterol: 0
            ),
            servingSize: 150,
            servingUnit: "g",
            isCustom: true,
            notes: "Fresh parsley salad with bulgur, tomatoes, mint, and lemon",
            nameFr: "Taboulé",
            nameEs: "Tabulé",
            nameHe: "טבולה",
            notesFr: "Salade de persil frais avec boulgour, tomates, menthe et citron",
            notesEs: "Ensalada de perejil fresco con bulgur, tomates, menta y limón",
            notesHe: "סלט פטרוזיליה טרי עם בורגול, עגבניות, נענע ולימון"
        ),
        
        // Baba Ganoush
        FoodItem(
            id: UUID(),
            name: "Baba Ganoush",
            category: .vegetables,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 145,
                protein: 4.8,
                carbohydrates: 12,
                fat: 9.8,
                fiber: 4.8,
                sugar: 6.5,
                vitaminA: 85,
                vitaminC: 15,
                vitaminD: 0,
                vitaminE: 2.2,
                vitaminK: 25,
                thiamin: 0.08,
                riboflavin: 0.08,
                niacin: 1.8,
                vitaminB6: 0.18,
                vitaminB12: 0,
                folate: 45,
                calcium: 85,
                iron: 1.8,
                magnesium: 45,
                phosphorus: 125,
                potassium: 385,
                sodium: 385,
                zinc: 1.2,
                selenium: 5.5,
                omega3: 0.3,
                omega6: 3.2,
                cholesterol: 0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Smoky roasted eggplant dip with tahini and garlic",
            nameFr: "Baba Ganoush",
            nameEs: "Baba Ganoush",
            nameHe: "באבא גנוש",
            notesFr: "Purée d'aubergine grillée fumée avec tahini et ail",
            notesEs: "Dip de berenjena asada ahumada con tahini y ajo",
            notesHe: "ממרח חציל צלוי מעושן עם טחינה ושום"
        ),
        
        // Kebab
        FoodItem(
            id: UUID(),
            name: "Shish Kebab",
            category: .protein,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 325,
                protein: 26.5,
                carbohydrates: 8,
                fat: 20.8,
                fiber: 1.8,
                sugar: 4.5,
                vitaminA: 125,
                vitaminC: 25,
                vitaminD: 0.8,
                vitaminE: 1.8,
                vitaminK: 25,
                thiamin: 0.22,
                riboflavin: 0.28,
                niacin: 8.8,
                vitaminB6: 0.45,
                vitaminB12: 3.2,
                folate: 25,
                calcium: 65,
                iron: 3.2,
                magnesium: 48,
                phosphorus: 245,
                potassium: 385,
                sodium: 685,
                zinc: 4.8,
                selenium: 22.5,
                omega3: 0.3,
                omega6: 3.2,
                cholesterol: 85
            ),
            servingSize: 150,
            servingUnit: "g",
            isCustom: true,
            notes: "Grilled marinated meat and vegetable skewers",
            nameFr: "Chich Kebab",
            nameEs: "Shish Kebab",
            nameHe: "שיש קבב",
            notesFr: "Brochettes de viande marinée et légumes grillés",
            notesEs: "Brochetas de carne marinada y verduras a la parrilla",
            notesHe: "שיפודי בשר מרינדה וירקות צלויים"
        ),
        
        // Dolma
        FoodItem(
            id: UUID(),
            name: "Dolma",
            category: .grains,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 225,
                protein: 8.8,
                carbohydrates: 35,
                fat: 6.8,
                fiber: 4.2,
                sugar: 5.5,
                vitaminA: 185,
                vitaminC: 35,
                vitaminD: 0,
                vitaminE: 2.2,
                vitaminK: 125,
                thiamin: 0.18,
                riboflavin: 0.12,
                niacin: 3.2,
                vitaminB6: 0.25,
                vitaminB12: 0,
                folate: 85,
                calcium: 125,
                iron: 2.8,
                magnesium: 65,
                phosphorus: 145,
                potassium: 485,
                sodium: 685,
                zinc: 1.8,
                selenium: 8.5,
                omega3: 0.5,
                omega6: 2.8,
                cholesterol: 0
            ),
            servingSize: 150,
            servingUnit: "g",
            isCustom: true,
            notes: "Grape leaves stuffed with rice, herbs, and pine nuts",
            nameFr: "Dolma",
            nameEs: "Dolma",
            nameHe: "דולמה",
            notesFr: "Feuilles de vigne farcies au riz, herbes et pignons",
            notesEs: "Hojas de parra rellenas de arroz, hierbas y piñones",
            notesHe: "עלי גפן ממולאים באורז, עשבי תיבול וצנוברים"
        ),
        
        // Mansaf
        FoodItem(
            id: UUID(),
            name: "Mansaf",
            category: .protein,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 485,
                protein: 32.5,
                carbohydrates: 45,
                fat: 18.8,
                fiber: 2.8,
                sugar: 8.5,
                vitaminA: 125,
                vitaminC: 15,
                vitaminD: 1.8,
                vitaminE: 2.2,
                vitaminK: 25,
                thiamin: 0.28,
                riboflavin: 0.35,
                niacin: 12.8,
                vitaminB6: 0.58,
                vitaminB12: 4.2,
                folate: 45,
                calcium: 285,
                iron: 4.2,
                magnesium: 85,
                phosphorus: 385,
                potassium: 585,
                sodium: 985,
                zinc: 5.8,
                selenium: 28.5,
                omega3: 0.5,
                omega6: 3.8,
                cholesterol: 125
            ),
            servingSize: 300,
            servingUnit: "g",
            isCustom: true,
            notes: "Traditional Jordanian lamb dish with yogurt sauce over rice",
            nameFr: "Mansaf",
            nameEs: "Mansaf",
            nameHe: "מנסף",
            notesFr: "Plat d'agneau jordanien traditionnel avec sauce yaourt sur riz",
            notesEs: "Plato tradicional jordano de cordero con salsa de yogur sobre arroz",
            notesHe: "מנת כבש ירדנית מסורתית עם רוטב יוגורט על אורז"
        ),
        
        // Fattoush
        FoodItem(
            id: UUID(),
            name: "Fattoush",
            category: .vegetables,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 165,
                protein: 5.8,
                carbohydrates: 22,
                fat: 6.8,
                fiber: 4.8,
                sugar: 8.5,
                vitaminA: 285,
                vitaminC: 125,
                vitaminD: 0,
                vitaminE: 3.2,
                vitaminK: 185,
                thiamin: 0.15,
                riboflavin: 0.12,
                niacin: 2.8,
                vitaminB6: 0.28,
                vitaminB12: 0,
                folate: 85,
                calcium: 125,
                iron: 2.2,
                magnesium: 45,
                phosphorus: 85,
                potassium: 485,
                sodium: 485,
                zinc: 1.2,
                selenium: 5.5,
                omega3: 0.8,
                omega6: 2.8,
                cholesterol: 0
            ),
            servingSize: 180,
            servingUnit: "g",
            isCustom: true,
            notes: "Mixed greens salad with crispy pita bread and sumac dressing",
            nameFr: "Fattouch",
            nameEs: "Fattoush",
            nameHe: "פתוש",
            notesFr: "Salade de verdures mélangées avec pain pita croustillant et vinaigrette au sumac",
            notesEs: "Ensalada de verduras mixtas con pan pita crujiente y aderezo de sumac",
            notesHe: "סלט ירקות מעורב עם פיתה פריכה ורוטב סומק"
        ),
        
        // Kibbeh
        FoodItem(
            id: UUID(),
            name: "Kibbeh",
            category: .protein,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 285,
                protein: 16.8,
                carbohydrates: 22,
                fat: 14.8,
                fiber: 3.2,
                sugar: 3.5,
                vitaminA: 85,
                vitaminC: 8,
                vitaminD: 0.5,
                vitaminE: 1.8,
                vitaminK: 15,
                thiamin: 0.22,
                riboflavin: 0.18,
                niacin: 6.8,
                vitaminB6: 0.35,
                vitaminB12: 2.2,
                folate: 65,
                calcium: 85,
                iron: 3.2,
                magnesium: 65,
                phosphorus: 185,
                potassium: 385,
                sodium: 585,
                zinc: 3.2,
                selenium: 18.5,
                omega3: 0.3,
                omega6: 4.8,
                cholesterol: 65
            ),
            servingSize: 120,
            servingUnit: "g",
            isCustom: true,
            notes: "Bulgur and meat croquettes with pine nuts and spices",
            nameFr: "Kibbé",
            nameEs: "Kibbeh",
            nameHe: "כיבה",
            notesFr: "Croquettes de boulgour et viande avec pignons et épices",
            notesEs: "Croquetas de bulgur y carne con piñones y especias",
            notesHe: "קציצות בורגול ובשר עם צנוברים ותבלינים"
        ),
        
        // Mujaddara
        FoodItem(
            id: UUID(),
            name: "Mujaddara",
            category: .grains,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 245,
                protein: 12.8,
                carbohydrates: 42,
                fat: 4.8,
                fiber: 8.2,
                sugar: 5.5,
                vitaminA: 85,
                vitaminC: 15,
                vitaminD: 0,
                vitaminE: 1.8,
                vitaminK: 25,
                thiamin: 0.28,
                riboflavin: 0.15,
                niacin: 3.8,
                vitaminB6: 0.35,
                vitaminB12: 0,
                folate: 185,
                calcium: 85,
                iron: 4.2,
                magnesium: 125,
                phosphorus: 225,
                potassium: 585,
                sodium: 485,
                zinc: 2.8,
                selenium: 12.5,
                omega3: 0.3,
                omega6: 1.8,
                cholesterol: 0
            ),
            servingSize: 200,
            servingUnit: "g",
            isCustom: true,
            notes: "Lentils and rice with caramelized onions - comfort food",
            nameFr: "Mujaddara",
            nameEs: "Mujaddara",
            nameHe: "מג'דרה",
            notesFr: "Lentilles et riz aux oignons caramélisés - plat réconfortant",
            notesEs: "Lentejas y arroz con cebollas caramelizadas - comida reconfortante",
            notesHe: "עדשים ואורז עם בצל מקורמל - אוכל נחמה"
        ),
        
        // Maqluba
        FoodItem(
            id: UUID(),
            name: "Maqluba",
            category: .grains,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 385,
                protein: 22.5,
                carbohydrates: 48,
                fat: 12.8,
                fiber: 4.2,
                sugar: 8.5,
                vitaminA: 185,
                vitaminC: 25,
                vitaminD: 0.8,
                vitaminE: 2.8,
                vitaminK: 85,
                thiamin: 0.32,
                riboflavin: 0.25,
                niacin: 8.8,
                vitaminB6: 0.48,
                vitaminB12: 2.8,
                folate: 85,
                calcium: 125,
                iron: 3.8,
                magnesium: 85,
                phosphorus: 285,
                potassium: 585,
                sodium: 885,
                zinc: 4.2,
                selenium: 22.5,
                omega3: 0.5,
                omega6: 4.2,
                cholesterol: 85
            ),
            servingSize: 250,
            servingUnit: "g",
            isCustom: true,
            notes: "Upside-down rice dish with meat and vegetables",
            nameFr: "Maqluba",
            nameEs: "Maqluba",
            nameHe: "מקלובה",
            notesFr: "Plat de riz renversé avec viande et légumes",
            notesEs: "Plato de arroz al revés con carne y verduras",
            notesHe: "מנת אורז הפוכה עם בשר וירקות"
        ),
        
        // Labneh
        FoodItem(
            id: UUID(),
            name: "Labneh",
            category: .dairy,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 125,
                protein: 8.8,
                carbohydrates: 8,
                fat: 6.8,
                fiber: 0,
                sugar: 8,
                vitaminA: 85,
                vitaminC: 2,
                vitaminD: 0.8,
                vitaminE: 0.5,
                vitaminK: 2,
                thiamin: 0.05,
                riboflavin: 0.28,
                niacin: 0.8,
                vitaminB6: 0.08,
                vitaminB12: 1.2,
                folate: 15,
                calcium: 285,
                iron: 0.5,
                magnesium: 25,
                phosphorus: 185,
                potassium: 185,
                sodium: 285,
                zinc: 1.2,
                selenium: 8.5,
                omega3: 0.2,
                omega6: 0.5,
                cholesterol: 25
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Thick strained yogurt cheese with olive oil and herbs",
            nameFr: "Labneh",
            nameEs: "Labneh",
            nameHe: "לבנה",
            notesFr: "Fromage de yaourt épais égoutté avec huile d'olive et herbes",
            notesEs: "Queso de yogur espeso colado con aceite de oliva y hierbas",
            notesHe: "גבינת יוגורט מסוננת עבה עם שמן זית ועשבי תיבול"
        ),
        
        // Manakish
        FoodItem(
            id: UUID(),
            name: "Manakish",
            category: .grains,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 285,
                protein: 8.8,
                carbohydrates: 42,
                fat: 9.8,
                fiber: 3.2,
                sugar: 4.5,
                vitaminA: 125,
                vitaminC: 15,
                vitaminD: 0,
                vitaminE: 2.8,
                vitaminK: 85,
                thiamin: 0.22,
                riboflavin: 0.15,
                niacin: 4.2,
                vitaminB6: 0.18,
                vitaminB12: 0,
                folate: 65,
                calcium: 185,
                iron: 2.8,
                magnesium: 45,
                phosphorus: 145,
                potassium: 285,
                sodium: 685,
                zinc: 1.8,
                selenium: 12.5,
                omega3: 0.8,
                omega6: 3.2,
                cholesterol: 0
            ),
            servingSize: 150,
            servingUnit: "g",
            isCustom: true,
            notes: "Flatbread topped with za'atar, cheese, or meat",
            nameFr: "Manakish",
            nameEs: "Manakish",
            nameHe: "מנקיש",
            notesFr: "Pain plat garni de za'atar, fromage ou viande",
            notesEs: "Pan plano cubierto con za'atar, queso o carne",
            notesHe: "לחם שטוח עם זעתר, גבינה או בשר"
        ),
        
        // Muhammara
        FoodItem(
            id: UUID(),
            name: "Muhammara",
            category: .vegetables,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 185,
                protein: 5.8,
                carbohydrates: 15,
                fat: 12.8,
                fiber: 4.2,
                sugar: 8.5,
                vitaminA: 285,
                vitaminC: 125,
                vitaminD: 0,
                vitaminE: 4.2,
                vitaminK: 25,
                thiamin: 0.12,
                riboflavin: 0.08,
                niacin: 2.2,
                vitaminB6: 0.35,
                vitaminB12: 0,
                folate: 45,
                calcium: 85,
                iron: 2.2,
                magnesium: 85,
                phosphorus: 125,
                potassium: 485,
                sodium: 385,
                zinc: 1.8,
                selenium: 8.5,
                omega3: 0.8,
                omega6: 4.8,
                cholesterol: 0
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Spicy red pepper and walnut dip with pomegranate molasses",
            nameFr: "Muhammara",
            nameEs: "Muhammara",
            nameHe: "מוחמרה",
            notesFr: "Purée épicée de poivron rouge et noix avec mélasse de grenade",
            notesEs: "Dip picante de pimiento rojo y nueces con melaza de granada",
            notesHe: "ממרח חריף של פלפל אדום ואגוזים עם דבש רימונים"
        ),
        
        // Kofta
        FoodItem(
            id: UUID(),
            name: "Kofta",
            category: .protein,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 325,
                protein: 24.5,
                carbohydrates: 8,
                fat: 22.8,
                fiber: 1.8,
                sugar: 4.5,
                vitaminA: 85,
                vitaminC: 15,
                vitaminD: 0.5,
                vitaminE: 1.8,
                vitaminK: 25,
                thiamin: 0.18,
                riboflavin: 0.22,
                niacin: 8.8,
                vitaminB6: 0.42,
                vitaminB12: 2.8,
                folate: 35,
                calcium: 85,
                iron: 3.8,
                magnesium: 48,
                phosphorus: 225,
                potassium: 385,
                sodium: 685,
                zinc: 4.2,
                selenium: 22.5,
                omega3: 0.3,
                omega6: 4.8,
                cholesterol: 85
            ),
            servingSize: 150,
            servingUnit: "g",
            isCustom: true,
            notes: "Spiced ground meat balls with herbs and onions",
            nameFr: "Kofta",
            nameEs: "Kofta",
            nameHe: "כופתה",
            notesFr: "Boulettes de viande hachée épicée avec herbes et oignons",
            notesEs: "Albóndigas de carne picada especiada con hierbas y cebollas",
            notesHe: "כדורי בשר טחון מתובל עם עשבי תיבול ובצל"
        ),
        
        // Fatteh
        FoodItem(
            id: UUID(),
            name: "Fatteh",
            category: .grains,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 285,
                protein: 14.8,
                carbohydrates: 35,
                fat: 9.8,
                fiber: 5.2,
                sugar: 6.5,
                vitaminA: 125,
                vitaminC: 25,
                vitaminD: 0.8,
                vitaminE: 2.2,
                vitaminK: 45,
                thiamin: 0.22,
                riboflavin: 0.25,
                niacin: 4.2,
                vitaminB6: 0.28,
                vitaminB12: 1.8,
                folate: 125,
                calcium: 285,
                iron: 3.2,
                magnesium: 85,
                phosphorus: 225,
                potassium: 485,
                sodium: 685,
                zinc: 2.8,
                selenium: 15.5,
                omega3: 0.5,
                omega6: 3.8,
                cholesterol: 35
            ),
            servingSize: 200,
            servingUnit: "g",
            isCustom: true,
            notes: "Crispy pita bread with chickpeas, yogurt, and tahini",
            nameFr: "Fatteh",
            nameEs: "Fatteh",
            nameHe: "פתה",
            notesFr: "Pain pita croustillant avec pois chiches, yaourt et tahini",
            notesEs: "Pan pita crujiente con garbanzos, yogur y tahini",
            notesHe: "פיתה פריכה עם חומוס, יוגורט וטחינה"
        ),
        
        // Ouzi
        FoodItem(
            id: UUID(),
            name: "Ouzi",
            category: .grains,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 485,
                protein: 28.5,
                carbohydrates: 52,
                fat: 18.8,
                fiber: 3.8,
                sugar: 8.5,
                vitaminA: 125,
                vitaminC: 15,
                vitaminD: 0.8,
                vitaminE: 2.8,
                vitaminK: 35,
                thiamin: 0.35,
                riboflavin: 0.28,
                niacin: 12.8,
                vitaminB6: 0.58,
                vitaminB12: 3.8,
                folate: 85,
                calcium: 125,
                iron: 4.8,
                magnesium: 125,
                phosphorus: 385,
                potassium: 685,
                sodium: 985,
                zinc: 5.8,
                selenium: 28.5,
                omega3: 0.8,
                omega6: 5.8,
                cholesterol: 125
            ),
            servingSize: 300,
            servingUnit: "g",
            isCustom: true,
            notes: "Spiced rice with lamb, almonds, and raisins in phyllo",
            nameFr: "Ouzi",
            nameEs: "Ouzi",
            nameHe: "אוזי",
            notesFr: "Riz épicé avec agneau, amandes et raisins secs dans la pâte phyllo",
            notesEs: "Arroz especiado con cordero, almendras y pasas en masa filo",
            notesHe: "אורז מתובל עם כבש, שקדים וצימוקים בבצק פילו"
        ),
        
        // Makloubeh
        FoodItem(
            id: UUID(),
            name: "Makloubeh",
            category: .grains,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 385,
                protein: 22.5,
                carbohydrates: 48,
                fat: 12.8,
                fiber: 4.2,
                sugar: 8.5,
                vitaminA: 185,
                vitaminC: 25,
                vitaminD: 0.8,
                vitaminE: 2.8,
                vitaminK: 85,
                thiamin: 0.32,
                riboflavin: 0.25,
                niacin: 8.8,
                vitaminB6: 0.48,
                vitaminB12: 2.8,
                folate: 85,
                calcium: 125,
                iron: 3.8,
                magnesium: 85,
                phosphorus: 285,
                potassium: 585,
                sodium: 885,
                zinc: 4.2,
                selenium: 22.5,
                omega3: 0.5,
                omega6: 4.2,
                cholesterol: 85
            ),
            servingSize: 250,
            servingUnit: "g",
            isCustom: true,
            notes: "Palestinian upside-down rice with chicken and vegetables",
            nameFr: "Makloubeh",
            nameEs: "Makloubeh",
            nameHe: "מקלובה",
            notesFr: "Riz palestinien renversé avec poulet et légumes",
            notesEs: "Arroz palestino al revés con pollo y verduras",
            notesHe: "אורז פלסטיני הפוך עם עוף וירקות"
        ),
        
        // Malfouf
        FoodItem(
            id: UUID(),
            name: "Malfouf",
            category: .vegetables,
            cuisineType: .middleEastern,
            nutritionalInfo: NutritionalInfo(
                calories: 185,
                protein: 12.8,
                carbohydrates: 18,
                fat: 8.8,
                fiber: 4.8,
                sugar: 6.5,
                vitaminA: 185,
                vitaminC: 45,
                vitaminD: 0,
                vitaminE: 1.8,
                vitaminK: 125,
                thiamin: 0.18,
                riboflavin: 0.15,
                niacin: 3.8,
                vitaminB6: 0.28,
                vitaminB12: 0,
                folate: 85,
                calcium: 125,
                iron: 2.8,
                magnesium: 65,
                phosphorus: 145,
                potassium: 485,
                sodium: 585,
                zinc: 2.2,
                selenium: 8.5,
                omega3: 0.3,
                omega6: 3.2,
                cholesterol: 0
            ),
            servingSize: 150,
            servingUnit: "g",
            isCustom: true,
            notes: "Stuffed cabbage rolls with rice, meat, and herbs",
            nameFr: "Malfouf",
            nameEs: "Malfouf",
            nameHe: "מלפוף",
            notesFr: "Rouleaux de chou farcis au riz, viande et herbes",
            notesEs: "Rollos de repollo rellenos de arroz, carne y hierbas",
            notesHe: "גלילי כרוב ממולאים באורז, בשר ועשבי תיבול"
        ),
        
        // Knafeh
        FoodItem(
            id: UUID(),
            name: "Knafeh",
            category: .other,
            nutritionalInfo: NutritionalInfo(
                calories: 385,
                protein: 12.8,
                carbohydrates: 48,
                fat: 16.8,
                fiber: 2.2,
                sugar: 35.5,
                vitaminA: 185,
                vitaminC: 5,
                vitaminD: 1.2,
                vitaminE: 2.2,
                vitaminK: 8,
                thiamin: 0.15,
                riboflavin: 0.35,
                niacin: 2.8,
                vitaminB6: 0.12,
                vitaminB12: 1.8,
                folate: 35,
                calcium: 385,
                iron: 1.8,
                magnesium: 45,
                phosphorus: 285,
                potassium: 285,
                sodium: 485,
                zinc: 1.8,
                selenium: 12.5,
                omega3: 0.2,
                omega6: 4.8,
                cholesterol: 85
            ),
            servingSize: 120,
            servingUnit: "g",
            isCustom: true,
            notes: "Sweet cheese pastry with shredded phyllo and syrup",
            nameFr: "Knafeh",
            nameEs: "Knafeh",
            nameHe: "כנאפה",
            notesFr: "Pâtisserie sucrée au fromage avec pâte phyllo râpée et sirop",
            notesEs: "Pastelería dulce de queso con masa filo rallada y jarabe",
            notesHe: "מאפה מתוק של גבינה עם בצק פילו מגורד וסירופ"
        ),
        
        // Ma'amoul
        FoodItem(
            id: UUID(),
            name: "Ma'amoul",
            category: .other,
            nutritionalInfo: NutritionalInfo(
                calories: 225,
                protein: 5.8,
                carbohydrates: 32,
                fat: 8.8,
                fiber: 2.8,
                sugar: 18.5,
                vitaminA: 85,
                vitaminC: 2,
                vitaminD: 0.5,
                vitaminE: 2.8,
                vitaminK: 5,
                thiamin: 0.12,
                riboflavin: 0.08,
                niacin: 2.2,
                vitaminB6: 0.08,
                vitaminB12: 0.3,
                folate: 25,
                calcium: 85,
                iron: 1.8,
                magnesium: 65,
                phosphorus: 125,
                potassium: 185,
                sodium: 185,
                zinc: 1.2,
                selenium: 8.5,
                omega3: 0.8,
                omega6: 3.2,
                cholesterol: 35
            ),
            servingSize: 80,
            servingUnit: "g",
            isCustom: true,
            notes: "Traditional cookies filled with dates, nuts, or figs",
            nameFr: "Ma'amoul",
            nameEs: "Ma'amoul",
            nameHe: "מעמול",
            notesFr: "Biscuits traditionnels fourrés aux dattes, noix ou figues",
            notesEs: "Galletas tradicionales rellenas de dátiles, nueces o higos",
            notesHe: "עוגיות מסורתיות ממולאות תמרים, אגוזים או תאנים"
        ),
        
        // Qatayef
        FoodItem(
            id: UUID(),
            name: "Qatayef",
            category: .other,
            nutritionalInfo: NutritionalInfo(
                calories: 285,
                protein: 8.8,
                carbohydrates: 42,
                fat: 9.8,
                fiber: 2.8,
                sugar: 25.5,
                vitaminA: 125,
                vitaminC: 5,
                vitaminD: 0.8,
                vitaminE: 2.2,
                vitaminK: 8,
                thiamin: 0.18,
                riboflavin: 0.22,
                niacin: 3.2,
                vitaminB6: 0.12,
                vitaminB12: 1.2,
                folate: 45,
                calcium: 185,
                iron: 2.2,
                magnesium: 45,
                phosphorus: 185,
                potassium: 285,
                sodium: 285,
                zinc: 1.8,
                selenium: 12.5,
                omega3: 0.5,
                omega6: 3.8,
                cholesterol: 65
            ),
            servingSize: 100,
            servingUnit: "g",
            isCustom: true,
            notes: "Stuffed pancakes with nuts or cheese, fried or baked",
            nameFr: "Qatayef",
            nameEs: "Qatayef",
            nameHe: "קטאיף",
            notesFr: "Crêpes farcies aux noix ou fromage, frites ou cuites",
            notesEs: "Panqueques rellenos de nueces o queso, fritos u horneados",
            notesHe: "פנקייקים ממולאים אגוזים או גבינה, מטוגנים או אפויים"
        ),
        
        // Baklava
        FoodItem(
            id: UUID(),
            name: "Baklava",
            category: .other,
            nutritionalInfo: NutritionalInfo(
                calories: 325,
                protein: 6.8,
                carbohydrates: 38,
                fat: 16.8,
                fiber: 2.8,
                sugar: 28.5,
                vitaminA: 85,
                vitaminC: 2,
                vitaminD: 0.5,
                vitaminE: 4.2,
                vitaminK: 8,
                thiamin: 0.12,
                riboflavin: 0.08,
                niacin: 2.2,
                vitaminB6: 0.12,
                vitaminB12: 0.3,
                folate: 25,
                calcium: 125,
                iron: 1.8,
                magnesium: 85,
                phosphorus: 145,
                potassium: 225,
                sodium: 285,
                zinc: 1.8,
                selenium: 8.5,
                omega3: 0.8,
                omega6: 6.8,
                cholesterol: 35
            ),
            servingSize: 80,
            servingUnit: "g",
            isCustom: true,
            notes: "Layered phyllo pastry with nuts and honey syrup",
            nameFr: "Baklava",
            nameEs: "Baklava",
            nameHe: "בקלאווה",
            notesFr: "Pâtisserie phyllo en couches avec noix et sirop de miel",
            notesEs: "Pastelería de masa filo en capas con nueces y jarabe de miel",
            notesHe: "מאפה בצק פילו בשכבות עם אגוזים וסירופ דבש"
        )
    ]
}
