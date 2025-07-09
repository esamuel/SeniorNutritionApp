import Foundation
import Combine
#if canImport(Translate)
import Translate
#endif

@MainActor
final class TranslationManager: ObservableObject {
    static let shared = TranslationManager()
    @Published var cache: [String: String] = [:] // key: "enText_langCode"
    @Published var isTranslating = false
    @Published var lastTranslationError: String?
    
    private init() {}
    
    func translated(_ text: String, target language: String) async -> String {
        guard language != "en" else { return text }
        let key = "\(text)_\(language)"
        if let cached = cache[key] {
            return cached
        }
        
        print("🔄 Translating '\(text)' to \(language)")
        
        // First try Apple's Translate framework
        #if canImport(Translate)
        if #available(iOS 15.0, *) {
            do {
                let from = Locale.Language(identifier: "en")
                let to = Locale.Language(identifier: language)
                let translator = Translator(from: from, to: to)
                try await translator.downloadIfNeeded()
                let output = try await translator.translate(text)
                cache[key] = output
                print("✅ Apple Translate: '\(text)' -> '\(output)'")
                return output
            } catch {
                print("❌ Apple Translate failed: \(error.localizedDescription)")
                lastTranslationError = error.localizedDescription
            }
        }
        #endif
        
        // Fallback to hardcoded translations for common food items
        let fallbackTranslation = getFallbackTranslation(text: text, language: language)
        if fallbackTranslation != text {
            cache[key] = fallbackTranslation
            print("✅ Fallback translation: '\(text)' -> '\(fallbackTranslation)'")
            return fallbackTranslation
        }
        
        // Try smart pattern matching for complex food names
        let smartTranslation = getSmartTranslation(text: text, language: language)
        if smartTranslation != text {
            cache[key] = smartTranslation
            print("✅ Smart translation: '\(text)' -> '\(smartTranslation)'")
            return smartTranslation
        }
        
        print("⚠️ No translation available for '\(text)' in \(language)")
        return text
    }
    
    private func getFallbackTranslation(text: String, language: String) -> String {
        let translations: [String: [String: String]] = [
            // Common foods
            "Apple": ["fr": "Pomme", "es": "Manzana", "he": "תפוח"],
            "Banana": ["fr": "Banane", "es": "Plátano", "he": "בננה"],
            "Bread": ["fr": "Pain", "es": "Pan", "he": "לחם"],
            "Butter": ["fr": "Beurre", "es": "Mantequilla", "he": "חמאה"],
            "Cheese": ["fr": "Fromage", "es": "Queso", "he": "גבינה"],
            "Chicken": ["fr": "Poulet", "es": "Pollo", "he": "עוף"],
            "Eggs": ["fr": "Œufs", "es": "Huevos", "he": "ביצים"],
            "Fish": ["fr": "Poisson", "es": "Pescado", "he": "דג"],
            "Milk": ["fr": "Lait", "es": "Leche", "he": "חלב"],
            "Rice": ["fr": "Riz", "es": "Arroz", "he": "אורז"],
            "Salmon": ["fr": "Saumon", "es": "Salmón", "he": "סלמון"],
            "Tuna": ["fr": "Thon", "es": "Atún", "he": "טונה"],
            "Yogurt": ["fr": "Yaourt", "es": "Yogur", "he": "יוגורט"],
            "Water": ["fr": "Eau", "es": "Agua", "he": "מים"],
            "Pasta": ["fr": "Pâtes", "es": "Pasta", "he": "פסטה"],
            "Potato": ["fr": "Pomme de terre", "es": "Papa", "he": "תפוח אדמה"],
            "Tomato": ["fr": "Tomate", "es": "Tomate", "he": "עגבניה"],
            "Carrot": ["fr": "Carotte", "es": "Zanahoria", "he": "גזר"],
            "Onion": ["fr": "Oignon", "es": "Cebolla", "he": "בצל"],
            "Garlic": ["fr": "Ail", "es": "Ajo", "he": "שום"],
            "Beef": ["fr": "Bœuf", "es": "Carne de res", "he": "בקר"],
            "Pork": ["fr": "Porc", "es": "Cerdo", "he": "חזיר"],
            "Spinach": ["fr": "Épinards", "es": "Espinacas", "he": "תרד"],
            "Broccoli": ["fr": "Brocoli", "es": "Brócoli", "he": "ברוקולי"],
            "Lettuce": ["fr": "Laitue", "es": "Lechuga", "he": "חסה"],
            "Orange": ["fr": "Orange", "es": "Naranja", "he": "תפוז"],
            "Grapes": ["fr": "Raisins", "es": "Uvas", "he": "ענבים"],
            "Strawberry": ["fr": "Fraise", "es": "Fresa", "he": "תות"],
            "Blueberry": ["fr": "Myrtille", "es": "Arándano", "he": "אוכמנית"],
            "Avocado": ["fr": "Avocat", "es": "Aguacate", "he": "אבוקדו"],
            "Cucumber": ["fr": "Concombre", "es": "Pepino", "he": "מלפפון"],
                         "Bell Pepper": ["fr": "Poivron", "es": "Pimiento", "he": "פלפל"],
            "Mushroom": ["fr": "Champignon", "es": "Champiñón", "he": "פטרייה"],
            "Olive": ["fr": "Olive", "es": "Aceituna", "he": "זית"],
            "Lemon": ["fr": "Citron", "es": "Limón", "he": "לימון"],
            "Lime": ["fr": "Citron vert", "es": "Lima", "he": "ליים"],
            "Nuts": ["fr": "Noix", "es": "Nueces", "he": "אגוזים"],
            "Almonds": ["fr": "Amandes", "es": "Almendras", "he": "שקדים"],
            "Walnuts": ["fr": "Noix", "es": "Nueces", "he": "אגוזי מלך"],
            "Peanuts": ["fr": "Cacahuètes", "es": "Cacahuetes", "he": "בוטנים"],
            "Beans": ["fr": "Haricots", "es": "Frijoles", "he": "שעועית"],
            "Lentils": ["fr": "Lentilles", "es": "Lentejas", "he": "עדשים"],
            "Chickpeas": ["fr": "Pois chiches", "es": "Garbanzos", "he": "חומוס"],
            "Oats": ["fr": "Avoine", "es": "Avena", "he": "שיבולת שועל"],
            "Quinoa": ["fr": "Quinoa", "es": "Quinua", "he": "קינואה"],
            "Barley": ["fr": "Orge", "es": "Cebada", "he": "שעורה"],
            "Wheat": ["fr": "Blé", "es": "Trigo", "he": "חיטה"],
            "Corn": ["fr": "Maïs", "es": "Maíz", "he": "תירס"],
            "Turkey": ["fr": "Dinde", "es": "Pavo", "he": "הודו"],
            "Duck": ["fr": "Canard", "es": "Pato", "he": "ברווז"],
            "Lamb": ["fr": "Agneau", "es": "Cordero", "he": "כבש"],
            "Shrimp": ["fr": "Crevette", "es": "Camarón", "he": "שרימפס"],
            "Lobster": ["fr": "Homard", "es": "Langosta", "he": "לובסטר"],
            "Crab": ["fr": "Crabe", "es": "Cangrejo", "he": "סרטן"],
            "Cod": ["fr": "Morue", "es": "Bacalao", "he": "קוד"],
            "Sardines": ["fr": "Sardines", "es": "Sardinas", "he": "סרדינים"],
            "Mackerel": ["fr": "Maquereau", "es": "Caballa", "he": "מקרל"],
            "Herring": ["fr": "Hareng", "es": "Arenque", "he": "הרינג"],
            "Anchovies": ["fr": "Anchois", "es": "Anchoas", "he": "אנשובי"],
            "Honey": ["fr": "Miel", "es": "Miel", "he": "דבש"],
            "Sugar": ["fr": "Sucre", "es": "Azúcar", "he": "סוכר"],
            "Salt": ["fr": "Sel", "es": "Sal", "he": "מלח"],
            "Pepper": ["fr": "Poivre", "es": "Pimienta", "he": "פלפל שחור"],
            "Oregano": ["fr": "Origan", "es": "Orégano", "he": "אורגנו"],
            "Basil": ["fr": "Basilic", "es": "Albahaca", "he": "ריחן"],
            "Parsley": ["fr": "Persil", "es": "Perejil", "he": "פטרוזיליה"],
            "Cilantro": ["fr": "Coriandre", "es": "Cilantro", "he": "כוסברה"],
            "Dill": ["fr": "Aneth", "es": "Eneldo", "he": "שמיר"],
            "Rosemary": ["fr": "Romarin", "es": "Romero", "he": "רוזמרין"],
            "Thyme": ["fr": "Thym", "es": "Tomillo", "he": "טימין"],
            "Sage": ["fr": "Sauge", "es": "Salvia", "he": "מרווה"],
            "Mint": ["fr": "Menthe", "es": "Menta", "he": "נענע"],
            "Ginger": ["fr": "Gingembre", "es": "Jengibre", "he": "זנגביל"],
            "Turmeric": ["fr": "Curcuma", "es": "Cúrcuma", "he": "כורכום"],
            "Cinnamon": ["fr": "Cannelle", "es": "Canela", "he": "קינמון"],
            "Vanilla": ["fr": "Vanille", "es": "Vainilla", "he": "וניל"],
            "Chocolate": ["fr": "Chocolat", "es": "Chocolate", "he": "שוקולד"],
            "Coffee": ["fr": "Café", "es": "Café", "he": "קפה"],
            "Tea": ["fr": "Thé", "es": "Té", "he": "תה"],
            "Juice": ["fr": "Jus", "es": "Jugo", "he": "מיץ"],
            "Wine": ["fr": "Vin", "es": "Vino", "he": "יין"],
            "Beer": ["fr": "Bière", "es": "Cerveza", "he": "בירה"],
            "Soda": ["fr": "Soda", "es": "Refresco", "he": "סודה"],
            "Smoothie": ["fr": "Smoothie", "es": "Batido", "he": "שייק"],
            "Soup": ["fr": "Soupe", "es": "Sopa", "he": "מרק"],
            "Salad": ["fr": "Salade", "es": "Ensalada", "he": "סלט"],
            "Sandwich": ["fr": "Sandwich", "es": "Sándwich", "he": "סנדוויץ'"],
            "Pizza": ["fr": "Pizza", "es": "Pizza", "he": "פיצה"],
            "Burger": ["fr": "Hamburger", "es": "Hamburguesa", "he": "המבורגר"],
            "Steak": ["fr": "Steak", "es": "Bistec", "he": "סטייק"],
            "Sushi": ["fr": "Sushi", "es": "Sushi", "he": "סושי"],
            "Noodles": ["fr": "Nouilles", "es": "Fideos", "he": "אטריות"],
            "Cake": ["fr": "Gâteau", "es": "Pastel", "he": "עוגה"],
            "Cookie": ["fr": "Biscuit", "es": "Galleta", "he": "עוגיה"],
            "Ice Cream": ["fr": "Glace", "es": "Helado", "he": "גלידה"],
            "Pie": ["fr": "Tarte", "es": "Pastel", "he": "פאי"],
            "Pancake": ["fr": "Crêpe", "es": "Panqueque", "he": "פנקייק"],
            "Waffle": ["fr": "Gaufre", "es": "Waffle", "he": "וופל"],
            "Cereal": ["fr": "Céréales", "es": "Cereal", "he": "דגני בוקר"],
            "Muffin": ["fr": "Muffin", "es": "Magdalena", "he": "מאפין"],
            "Bagel": ["fr": "Bagel", "es": "Bagel", "he": "בייגל"],
            "Croissant": ["fr": "Croissant", "es": "Croissant", "he": "קרואסון"],
            "Donut": ["fr": "Beignet", "es": "Dona", "he": "סופגניה"],
            "Pretzel": ["fr": "Bretzel", "es": "Pretzel", "he": "ברצל"],
            "Popcorn": ["fr": "Pop-corn", "es": "Palomitas", "he": "פופקורן"],
            "Chips": ["fr": "Chips", "es": "Papas fritas", "he": "צ'יפס"],
            "Crackers": ["fr": "Crackers", "es": "Galletas saladas", "he": "קרקרים"],
            "Pickles": ["fr": "Cornichons", "es": "Pepinillos", "he": "חמוצים"],
            "Jam": ["fr": "Confiture", "es": "Mermelada", "he": "ריבה"],
            "Peanut Butter": ["fr": "Beurre de cacahuète", "es": "Mantequilla de maní", "he": "חמאת בוטנים"],
            "Ketchup": ["fr": "Ketchup", "es": "Ketchup", "he": "קטשופ"],
            "Mustard": ["fr": "Moutarde", "es": "Mostaza", "he": "חרדל"],
            "Mayonnaise": ["fr": "Mayonnaise", "es": "Mayonesa", "he": "מיונז"],
            "Vinegar": ["fr": "Vinaigre", "es": "Vinagre", "he": "חומץ"],
            "Oil": ["fr": "Huile", "es": "Aceite", "he": "שמן"],
            "Olive Oil": ["fr": "Huile d'olive", "es": "Aceite de oliva", "he": "שמן זית"],
            "Soy Sauce": ["fr": "Sauce soja", "es": "Salsa de soja", "he": "רוטב סויה"],
            "Hot Sauce": ["fr": "Sauce piquante", "es": "Salsa picante", "he": "רוטב חריף"],
            "Barbecue Sauce": ["fr": "Sauce barbecue", "es": "Salsa barbacoa", "he": "רוטב ברביקיו"],
            "Ranch Dressing": ["fr": "Sauce ranch", "es": "Aderezo ranch", "he": "רוטב רנץ'"],
            "Caesar Dressing": ["fr": "Sauce césar", "es": "Aderezo césar", "he": "רוטב קיסר"],
            "Italian Dressing": ["fr": "Sauce italienne", "es": "Aderezo italiano", "he": "רוטב איטלקי"],
            "Balsamic Vinegar": ["fr": "Vinaigre balsamique", "es": "Vinagre balsámico", "he": "חומץ בלסמי"],
            "Lemon Juice": ["fr": "Jus de citron", "es": "Jugo de limón", "he": "מיץ לימון"],
            "Lime Juice": ["fr": "Jus de citron vert", "es": "Jugo de lima", "he": "מיץ ליים"],
            "Orange Juice": ["fr": "Jus d'orange", "es": "Jugo de naranja", "he": "מיץ תפוזים"],
            "Apple Juice": ["fr": "Jus de pomme", "es": "Jugo de manzana", "he": "מיץ תפוחים"],
            "Grape Juice": ["fr": "Jus de raisin", "es": "Jugo de uva", "he": "מיץ ענבים"],
            "Cranberry Juice": ["fr": "Jus de canneberge", "es": "Jugo de arándano", "he": "מיץ חמוציות"],
            "Tomato Juice": ["fr": "Jus de tomate", "es": "Jugo de tomate", "he": "מיץ עגבניות"],
            "Vegetable Juice": ["fr": "Jus de légumes", "es": "Jugo de verduras", "he": "מיץ ירקות"],
            "Energy Drink": ["fr": "Boisson énergisante", "es": "Bebida energética", "he": "משקה אנרגיה"],
            "Sports Drink": ["fr": "Boisson sportive", "es": "Bebida deportiva", "he": "משקה ספורט"],
            "Protein Shake": ["fr": "Shake protéiné", "es": "Batido de proteínas", "he": "שייק חלבון"],
            "Milkshake": ["fr": "Milkshake", "es": "Batido de leche", "he": "מילקשייק"],
            "Hot Chocolate": ["fr": "Chocolat chaud", "es": "Chocolate caliente", "he": "שוקו חם"],
            "Iced Tea": ["fr": "Thé glacé", "es": "Té helado", "he": "תה קר"],
            "Lemonade": ["fr": "Limonade", "es": "Limonada", "he": "לימונדה"],
            "Coconut Water": ["fr": "Eau de coco", "es": "Agua de coco", "he": "מי קוקוס"],
            "Almond Milk": ["fr": "Lait d'amande", "es": "Leche de almendra", "he": "חלב שקדים"],
            "Soy Milk": ["fr": "Lait de soja", "es": "Leche de soja", "he": "חלב סויה"],
            "Oat Milk": ["fr": "Lait d'avoine", "es": "Leche de avena", "he": "חלב שיבולת שועל"],
            
            // Russian and Eastern European dishes
            "Medovik (Honey Cake)": ["fr": "Medovik (Gâteau au Miel)", "es": "Medovik (Pastel de Miel)", "he": "מדוביק (עוגת דבש)"],
            "Borscht": ["fr": "Bortsch", "es": "Borscht", "he": "בורשט"],
            "Beef Stroganoff": ["fr": "Bœuf Stroganoff", "es": "Stroganoff de Carne", "he": "בקר סטרוגנוף"],
            "Pelmeni": ["fr": "Pelmeni", "es": "Pelmeni", "he": "פלמני"],
            "Blini": ["fr": "Blinis", "es": "Blinis", "he": "בליני"],
            "Varenya": ["fr": "Confiture russe", "es": "Mermelada rusa", "he": "ריבה רוסית"],
            "Syrniki": ["fr": "Syrniki", "es": "Syrniki", "he": "סירניקי"],
            "Olivier Salad": ["fr": "Salade Olivier", "es": "Ensalada Olivier", "he": "סלט אוליבייה"],
            "Cabbage Rolls": ["fr": "Choux farcis", "es": "Rollos de repollo", "he": "עלי כרוב ממולאים"],
            "Beef Stew": ["fr": "Ragoût de bœuf", "es": "Estofado de carne", "he": "נזיד בקר"],
            "Greek Salad": ["fr": "Salade grecque", "es": "Ensalada griega", "he": "סלט יווני"],
            "Cooked Green Peas": ["fr": "Petits pois cuits", "es": "Guisantes verdes cocidos", "he": "אפונה ירוקה מבושלת"],
            "Oatmeal": ["fr": "Flocons d'avoine", "es": "Avena", "he": "שיבולת שועל"],
            
            // Common prepared dishes
            "Chicken Soup": ["fr": "Soupe de poulet", "es": "Sopa de pollo", "he": "מרק עוף"],
            "Vegetable Soup": ["fr": "Soupe de légumes", "es": "Sopa de verduras", "he": "מרק ירקות"],
            "Tomato Soup": ["fr": "Soupe de tomate", "es": "Sopa de tomate", "he": "מרק עגבניות"],
            "Mushroom Soup": ["fr": "Soupe aux champignons", "es": "Sopa de champiñones", "he": "מרק פטריות"],
            "Chicken Salad": ["fr": "Salade de poulet", "es": "Ensalada de pollo", "he": "סלט עוף"],
            "Tuna Salad": ["fr": "Salade de thon", "es": "Ensalada de atún", "he": "סלט טונה"],
            "Egg Salad": ["fr": "Salade d'œufs", "es": "Ensalada de huevo", "he": "סלט ביצים"],
            "Potato Salad": ["fr": "Salade de pommes de terre", "es": "Ensalada de papa", "he": "סלט תפוחי אדמה"],
            "Coleslaw": ["fr": "Salade de chou", "es": "Ensalada de repollo", "he": "סלט כרוב"],
            "Caesar Salad": ["fr": "Salade César", "es": "Ensalada César", "he": "סלט קיסר"],
            "Cobb Salad": ["fr": "Salade Cobb", "es": "Ensalada Cobb", "he": "סלט קוב"],
            "Waldorf Salad": ["fr": "Salade Waldorf", "es": "Ensalada Waldorf", "he": "סלט וולדורף"],
            
            // International dishes
            "Spaghetti Bolognese": ["fr": "Spaghetti Bolognaise", "es": "Espaguetis Boloñesa", "he": "ספגטי בולונז"],
            "Chicken Parmesan": ["fr": "Poulet Parmesan", "es": "Pollo Parmesano", "he": "עוף פרמזן"],
            "Fish and Chips": ["fr": "Poisson-frites", "es": "Pescado con papas fritas", "he": "דג וצ'יפס"],
            "Shepherd's Pie": ["fr": "Hachis Parmentier", "es": "Pastel de pastor", "he": "פאי רועה"],
            "Beef Tacos": ["fr": "Tacos au bœuf", "es": "Tacos de carne", "he": "טאקו בקר"],
            "Chicken Fajitas": ["fr": "Fajitas au poulet", "es": "Fajitas de pollo", "he": "פחיטות עוף"],
            "Pad Thai": ["fr": "Pad Thaï", "es": "Pad Thai", "he": "פאד תאי"],
            "Fried Rice": ["fr": "Riz frit", "es": "Arroz frito", "he": "אורז מטוגן"],
            "Chicken Teriyaki": ["fr": "Poulet Teriyaki", "es": "Pollo Teriyaki", "he": "עוף טריאקי"],
            "Beef and Broccoli": ["fr": "Bœuf aux brocolis", "es": "Carne con brócoli", "he": "בקר וברוקולי"],
            "Rice Milk": ["fr": "Lait de riz", "es": "Leche de arroz", "he": "חלב אורז"],
            "Coconut Milk": ["fr": "Lait de coco", "es": "Leche de coco", "he": "חלב קוקוס"],
            
            // Common cooking terms
            "Fresh": ["fr": "Frais", "es": "Fresco", "he": "טרי"],
            "Frozen": ["fr": "Surgelé", "es": "Congelado", "he": "קפוא"],
            "Canned": ["fr": "En conserve", "es": "Enlatado", "he": "משומר"],
            "Dried": ["fr": "Séché", "es": "Seco", "he": "מיובש"],
            "Raw": ["fr": "Cru", "es": "Crudo", "he": "גולמי"],
            "Cooked": ["fr": "Cuit", "es": "Cocinado", "he": "מבושל"],
            "Baked": ["fr": "Cuit au four", "es": "Horneado", "he": "אפוי"],
            "Grilled": ["fr": "Grillé", "es": "A la parrilla", "he": "צלוי"],
            "Fried": ["fr": "Frit", "es": "Frito", "he": "מטוגן"],
            "Boiled": ["fr": "Bouilli", "es": "Hervido", "he": "מבושל במים"],
            "Steamed": ["fr": "Vapeur", "es": "Al vapor", "he": "מבושל בקיטור"],
            "Roasted": ["fr": "Rôti", "es": "Asado", "he": "צלוי בתנור"],
            "Sautéed": ["fr": "Sauté", "es": "Salteado", "he": "מוקפץ"],
            "Braised": ["fr": "Braisé", "es": "Estofado", "he": "מבושל לאט"],
            "Poached": ["fr": "Poché", "es": "Escalfado", "he": "מבושל בנוזל"],
            "Smoked": ["fr": "Fumé", "es": "Ahumado", "he": "מעושן"],
            "Marinated": ["fr": "Mariné", "es": "Marinado", "he": "מוחלט"],
            "Seasoned": ["fr": "Assaisonné", "es": "Sazonado", "he": "מתובל"],
            "Spiced": ["fr": "Épicé", "es": "Especiado", "he": "מתובל בתבלינים"],
            "Organic": ["fr": "Biologique", "es": "Orgánico", "he": "אורגני"],
            "Natural": ["fr": "Naturel", "es": "Natural", "he": "טבעי"],
            "Whole grain": ["fr": "Grain entier", "es": "Grano entero", "he": "דגנים מלאים"],
            "Low fat": ["fr": "Faible en gras", "es": "Bajo en grasa", "he": "דל שומן"],
            "Fat free": ["fr": "Sans gras", "es": "Sin grasa", "he": "ללא שומן"],
            "Sugar free": ["fr": "Sans sucre", "es": "Sin azúcar", "he": "ללא סוכר"],
            "Gluten free": ["fr": "Sans gluten", "es": "Sin gluten", "he": "ללא גלוטן"],
            "Dairy free": ["fr": "Sans lactose", "es": "Sin lácteos", "he": "ללא חלב"],
            "Vegan": ["fr": "Végétalien", "es": "Vegano", "he": "טבעוני"],
            "Vegetarian": ["fr": "Végétarien", "es": "Vegetariano", "he": "צמחוני"],
            "Kosher": ["fr": "Casher", "es": "Kosher", "he": "כשר"],
            "Halal": ["fr": "Halal", "es": "Halal", "he": "חלאל"]
        ]
        
        return translations[text]?[language] ?? text
    }
    
    // Clear cache when needed
    func clearCache() {
        cache.removeAll()
        print("🗑️ Translation cache cleared")
    }
    
    // Get translation statistics
    func getTranslationStats() -> (cached: Int, languages: [String]) {
        let languages = Set(cache.keys.compactMap { $0.components(separatedBy: "_").last }).sorted()
        return (cached: cache.count, languages: Array(languages))
    }
    
    // Smart translation for complex food names
    private func getSmartTranslation(text: String, language: String) -> String {
        // Handle patterns like "X (Y)" where X is the main name and Y is description
        if text.contains("(") && text.contains(")") {
            let components = text.components(separatedBy: "(")
            if components.count == 2 {
                let mainName = components[0].trimmingCharacters(in: .whitespaces)
                let description = components[1].replacingOccurrences(of: ")", with: "").trimmingCharacters(in: .whitespaces)
                
                // Try to translate both parts
                let translatedMain = getFallbackTranslation(text: mainName, language: language)
                let translatedDesc = getFallbackTranslation(text: description, language: language)
                
                // If we got translations for either part, combine them
                if translatedMain != mainName || translatedDesc != description {
                    return "\(translatedMain) (\(translatedDesc))"
                }
                
                // Special handling for cake patterns
                if description.lowercased().contains("cake") {
                    let cakeTranslation = getFallbackTranslation(text: "Cake", language: language)
                    if cakeTranslation != "Cake" {
                        return "\(mainName) (\(cakeTranslation))"
                    }
                }
                
                // Special handling for honey patterns
                if description.lowercased().contains("honey") {
                    let honeyTranslation = getFallbackTranslation(text: "Honey", language: language)
                    if honeyTranslation != "Honey" {
                        let cakeTranslation = getFallbackTranslation(text: "Cake", language: language)
                        if cakeTranslation != "Cake" {
                            return "\(mainName) (\(honeyTranslation) \(cakeTranslation))"
                        }
                    }
                }
            }
        }
        
        // Handle food names with cooking methods (e.g., "Cooked Green Peas")
        let cookingMethods = ["Cooked", "Grilled", "Baked", "Fried", "Steamed", "Roasted", "Fresh", "Raw", "Frozen", "Canned", "Dried"]
        for method in cookingMethods {
            if text.hasPrefix(method + " ") {
                let foodName = String(text.dropFirst(method.count + 1))
                let translatedMethod = getFallbackTranslation(text: method, language: language)
                let translatedFood = getFallbackTranslation(text: foodName, language: language)
                
                if translatedMethod != method || translatedFood != foodName {
                    return "\(translatedMethod) \(translatedFood)"
                }
            }
        }
        
        // Handle compound foods (e.g., "Beef Stew", "Chicken Soup")
        let words = text.components(separatedBy: " ")
        if words.count == 2 {
            let firstWord = words[0]
            let secondWord = words[1]
            
            let translatedFirst = getFallbackTranslation(text: firstWord, language: language)
            let translatedSecond = getFallbackTranslation(text: secondWord, language: language)
            
            if translatedFirst != firstWord || translatedSecond != secondWord {
                // For some languages like French, we might need to reverse order
                if language == "fr" && (secondWord.lowercased() == "soup" || secondWord.lowercased() == "salad" || secondWord.lowercased() == "juice") {
                    return "\(translatedSecond) de \(translatedFirst.lowercased())"
                } else {
                    return "\(translatedFirst) \(translatedSecond)"
                }
            }
        }
        
        // If no smart translation found, return original
        return text
    }
} 