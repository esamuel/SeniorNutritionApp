import Foundation

struct SnackFoodItems {
    static let foods: [FoodItem] = [
        // Lay's Classic Potato Chips
        FoodItem(
            id: UUID(),
            name: "Lay's Classic Potato Chips",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 2,
                carbohydrates: 15,
                fat: 10,
                fiber: 1,
                sugar: 0,
                calcium: 10
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Regular potato chips",
            nameFr: "Chips de Pomme de Terre Lay's Classic",
            nameEs: "Papas Fritas Lay's Clásicas",
            nameHe: "צ'יפס תפוחי אדמה קלאסי של ליי'ס",
            notesFr: "Chips de pomme de terre ordinaires",
            notesEs: "Papas fritas regulares",
            notesHe: "צ'יפס תפוחי אדמה רגיל"
        ),
        
        // Doritos Nacho Cheese
        FoodItem(
            id: UUID(),
            name: "Doritos Nacho Cheese",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 2,
                carbohydrates: 18,
                fat: 8,
                fiber: 1,
                sugar: 1
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Flavored tortilla chips",
            nameFr: "Doritos Goût Fromage Nacho",
            nameEs: "Doritos Sabor a Queso Nacho",
            nameHe: "דוריטוס טעם גבינת נאצ'ו",
            notesFr: "Chips de tortilla aromatisées",
            notesEs: "Chips de tortilla con sabor",
            notesHe: "צ'יפס טורטייה בטעמים"
        ),
        
        // Cheetos Crunchy
        FoodItem(
            id: UUID(),
            name: "Cheetos Crunchy",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 2,
                carbohydrates: 13,
                fat: 10,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Cheese-flavored cornmeal snack",
            nameFr: "Cheetos Croustillants",
            nameEs: "Cheetos Crujientes",
            nameHe: "צ'יטוס פריך",
            notesFr: "Snack de semoule de maïs au fromage",
            notesEs: "Snack de harina de maíz con sabor a queso",
            notesHe: "חטיף תירס בטעם גבינה"
        ),
        
        // Ritz Crackers
        FoodItem(
            id: UUID(),
            name: "Ritz Crackers",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 79,
                protein: 1,
                carbohydrates: 10,
                fat: 4,
                fiber: 0,
                sugar: 1
            ),
            servingSize: 15,
            servingUnit: "g",
            isCustom: true,
            notes: "Buttery round crackers",
            nameFr: "Crackers Ritz",
            nameEs: "Galletas Ritz",
            nameHe: "קרקרים ריץ",
            notesFr: "Crackers ronds au beurre",
            notesEs: "Galletas redondas con sabor a mantequilla",
            notesHe: "קרקרים עגולים בטעם חמאה"
        ),
        
        // Goldfish Cheddar Crackers
        FoodItem(
            id: UUID(),
            name: "Goldfish Cheddar Crackers",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 140,
                protein: 3,
                carbohydrates: 20,
                fat: 5,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 30,
            servingUnit: "g",
            isCustom: true,
            notes: "Cheddar-flavored fish-shaped crackers",
            nameFr: "Crackers Goldfish au Cheddar",
            nameEs: "Galletas Goldfish de Queso Cheddar",
            nameHe: "קרקרים גולדפיש בטעם צ'דר",
            notesFr: "Crackers en forme de poisson au goût de cheddar",
            notesEs: "Galletas con forma de pez sabor a queso cheddar",
            notesHe: "קרקרים בצורת דג בטעם גבינת צ'דר"
        ),
        
        // Nature Valley Crunchy Granola Bars
        FoodItem(
            id: UUID(),
            name: "Nature Valley Crunchy Granola Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 190,
                protein: 4,
                carbohydrates: 29,
                fat: 7,
                fiber: 2,
                sugar: 11
            ),
            servingSize: 42,
            servingUnit: "g",
            isCustom: true,
            notes: "Oats and honey flavor",
            nameFr: "Barres de Granola Croustillantes Nature Valley",
            nameEs: "Barras de Granola Crujientes Nature Valley",
            nameHe: "חטיפי גרנולה פריכים של נייצ'ר ואלי",
            notesFr: "Saveur avoine et miel",
            notesEs: "Sabor a avena y miel",
            notesHe: "בטעם שיבולת שועל ודבש"
        ),
        
        // Kind Bars
        FoodItem(
            id: UUID(),
            name: "Kind Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 200,
                protein: 6,
                carbohydrates: 16,
                fat: 14,
                fiber: 7,
                sugar: 5
            ),
            servingSize: 40,
            servingUnit: "g",
            isCustom: true,
            notes: "Nut and fruit bar",
            nameFr: "Barres Kind",
            nameEs: "Barras Kind",
            nameHe: "חטיפי קינד",
            notesFr: "Barre aux noix et fruits",
            notesEs: "Barra de frutos secos y frutas",
            notesHe: "חטיף אגוזים ופירות"
        ),
        
        // Clif Bars
        FoodItem(
            id: UUID(),
            name: "Clif Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 10,
                carbohydrates: 44,
                fat: 6,
                fiber: 4,
                sugar: 20
            ),
            servingSize: 68,
            servingUnit: "g",
            isCustom: true,
            notes: "Energy bar with oats and chocolate chips",
            nameFr: "Barres Clif",
            nameEs: "Barras Clif",
            nameHe: "חטיפי קליף",
            notesFr: "Barre énergétique avec avoine et pépites de chocolat",
            notesEs: "Barra energética con avena y trozos de chocolate",
            notesHe: "חטיף אנרגיה עם שיבולת שועל ושבבי שוקולד"
        ),
        
        // Snickers Bar
        FoodItem(
            id: UUID(),
            name: "Snickers Bar",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 4,
                carbohydrates: 33,
                fat: 12,
                fiber: 1,
                sugar: 27
            ),
            servingSize: 52,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate bar with nougat, caramel, and peanuts",
            nameFr: "Barre Snickers",
            nameEs: "Barra Snickers",
            nameHe: "חטיף סניקרס",
            notesFr: "Barre chocolatée avec nougat, caramel et cacahuètes",
            notesEs: "Barra de chocolate con turrón, caramelo y cacahuetes",
            notesHe: "חטיף שוקולד עם נוגט, קרמל ובוטנים"
        ),
        
        // Reese's Peanut Butter Cups
        FoodItem(
            id: UUID(),
            name: "Reese's Peanut Butter Cups",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 210,
                protein: 5,
                carbohydrates: 24,
                fat: 13,
                fiber: 1,
                sugar: 21
            ),
            servingSize: 42,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate cups filled with peanut butter",
            nameFr: "Coupes au Beurre de Cacahuète Reese's",
            nameEs: "Copas de Mantequilla de Cacahuete Reese's",
            nameHe: "כוסיות חמאת בוטנים של ריסס",
            notesFr: "Coupes en chocolat fourrées à la crème de cacahuète",
            notesEs: "Copas de chocolate rellenas de mantequilla de cacahuete",
            notesHe: "כוסיות שוקולד ממולאות בחמאת בוטנים"
        ),
        
        // M&M's Milk Chocolate
        FoodItem(
            id: UUID(),
            name: "M&M's Milk Chocolate",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 240,
                protein: 2,
                carbohydrates: 34,
                fat: 10,
                fiber: 1,
                sugar: 31
            ),
            servingSize: 47,
            servingUnit: "g",
            isCustom: true,
            notes: "Colorful candy-coated chocolate pieces",
            nameFr: "M&M's au Chocolat au Lait",
            nameEs: "M&M's de Chocolate con Leche",
            nameHe: "אם אנד אמס שוקולד חלב",
            notesFr: "Morceaux de chocolat colorés enrobés de sucre",
            notesEs: "Piezas de chocolate cubiertas de caramelo de colores",
            notesHe: "חתיכות שוקולד מצופות בסוכריות צבעוניות"
        ),
        
        // Twix Bar
        FoodItem(
            id: UUID(),
            name: "Twix Bar",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 250,
                protein: 2,
                carbohydrates: 34,
                fat: 12,
                fiber: 1,
                sugar: 28
            ),
            servingSize: 50,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate-covered caramel and cookie bar",
            nameFr: "Barre Twix",
            nameEs: "Barra Twix",
            nameHe: "חטיף טוויקס",
            notesFr: "Barre de biscuit et caramel enrobée de chocolat",
            notesEs: "Barra de galleta y caramelo cubierta de chocolate",
            notesHe: "חטיף ביסקוויט וקרמל מצופה שוקולד"
        ),
        
        // Oreo Cookies
        FoodItem(
            id: UUID(),
            name: "Oreo Cookies",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 1,
                carbohydrates: 25,
                fat: 7,
                fiber: 1,
                sugar: 14
            ),
            servingSize: 34,
            servingUnit: "g",
            isCustom: true,
            notes: "Chocolate sandwich cookies with cream filling",
            nameFr: "Biscuits Oreo",
            nameEs: "Galletas Oreo",
            nameHe: "עוגיות אוראו",
            notesFr: "Biscuits sandwich au chocolat avec garniture à la crème",
            notesEs: "Galletas sándwich de chocolate con relleno de crema",
            notesHe: "עוגיות שוקולד במילוי קרם"
        ),
        
        // Cheez-It Crackers
        FoodItem(
            id: UUID(),
            name: "Cheez-It Crackers",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 4,
                carbohydrates: 17,
                fat: 8,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 30,
            servingUnit: "g",
            isCustom: true,
            notes: "Cheddar cheese-flavored square crackers",
            nameFr: "Crackers Cheez-It",
            nameEs: "Galletas Cheez-It",
            nameHe: "קרקרים צ'יז-איט",
            notesFr: "Crackers carrés au goût de fromage cheddar",
            notesEs: "Galletas cuadradas con sabor a queso cheddar",
            notesHe: "קרקרים מרובעים בטעם גבינת צ'דר"
        ),
        
        // Pringles Original
        FoodItem(
            id: UUID(),
            name: "Pringles Original",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 150,
                protein: 1,
                carbohydrates: 16,
                fat: 9,
                fiber: 1,
                sugar: 0
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Stackable potato crisps",
            nameFr: "Pringles Original",
            nameEs: "Pringles Original",
            nameHe: "פרינגלס מקורי",
            notesFr: "Chips de pomme de terre empilables",
            notesEs: "Patatas fritas apilables",
            notesHe: "חטיף תפוחי אדמה הניתן לערימה"
        ),
        
        // Pop-Tarts Frosted Strawberry
        FoodItem(
            id: UUID(),
            name: "Pop-Tarts Frosted Strawberry",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 200,
                protein: 2,
                carbohydrates: 38,
                fat: 5,
                fiber: 1,
                sugar: 16
            ),
            servingSize: 52,
            servingUnit: "g",
            isCustom: true,
            notes: "Frosted toaster pastry with strawberry filling",
            nameFr: "Pop-Tarts Glacés à la Fraise",
            nameEs: "Pop-Tarts Glaseados de Fresa",
            nameHe: "פופ-טארטס בציפוי תות",
            notesFr: "Pâtisserie glacée pour grille-pain avec garniture à la fraise",
            notesEs: "Pastelito para tostadora glaseado con relleno de fresa",
            notesHe: "מאפה טוסטר מצופה במילוי תות"
        ),
        
        // Planters Salted Peanuts
        FoodItem(
            id: UUID(),
            name: "Planters Salted Peanuts",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 170,
                protein: 7,
                carbohydrates: 5,
                fat: 14,
                fiber: 2,
                sugar: 1
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Roasted and salted peanuts",
            nameFr: "Cacahuètes Salées Planters",
            nameEs: "Cacahuetes Salados Planters",
            nameHe: "בוטנים מלוחים של פלנטרס",
            notesFr: "Cacahuètes grillées et salées",
            notesEs: "Cacahuetes tostados y salados",
            notesHe: "בוטנים קלויים ומלוחים"
        ),
        
        // Slim Jim Original
        FoodItem(
            id: UUID(),
            name: "Slim Jim Original",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 160,
                protein: 6,
                carbohydrates: 2,
                fat: 14,
                fiber: 0,
                sugar: 1
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Smoked meat stick",
            nameFr: "Slim Jim Original",
            nameEs: "Slim Jim Original",
            nameHe: "סלים ג'ים מקורי",
            notesFr: "Bâtonnet de viande fumée",
            notesEs: "Palito de carne ahumada",
            notesHe: "מקל בשר מעושן"
        ),
        
        // Jack Link's Beef Jerky
        FoodItem(
            id: UUID(),
            name: "Jack Link's Beef Jerky",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 80,
                protein: 11,
                carbohydrates: 6,
                fat: 1,
                fiber: 0,
                sugar: 5
            ),
            servingSize: 28,
            servingUnit: "g",
            isCustom: true,
            notes: "Dried and seasoned beef strips",
            nameFr: "Viande Séchée Jack Link's",
            nameEs: "Carne Seca Jack Link's",
            nameHe: "בשר מיובש של ג'ק לינק",
            notesFr: "Lanières de bœuf séchées et assaisonnées",
            notesEs: "Tiras de carne de res secas y sazonadas",
            notesHe: "רצועות בקר מיובשות ומתובלות"
        ),
        
        // Quaker Chewy Granola Bars
        FoodItem(
            id: UUID(),
            name: "Quaker Chewy Granola Bars",
            category: .snacks,
            nutritionalInfo: NutritionalInfo(
                calories: 100,
                protein: 1,
                carbohydrates: 17,
                fat: 3,
                fiber: 1,
                sugar: 7
            ),
            servingSize: 24,
            servingUnit: "g",
            isCustom: true,
            notes: "Granola bar with chocolate chips",
            nameFr: "Barres de Granola Tendres Quaker",
            nameEs: "Barras de Granola Masticables Quaker",
            nameHe: "חטיפי גרנולה רכים של קווייקר",
            notesFr: "Barre de granola avec pépites de chocolat",
            notesEs: "Barra de granola con trozos de chocolate",
            notesHe: "חטיף גרנולה עם שבבי שוקולד"
        )
    ]
}
