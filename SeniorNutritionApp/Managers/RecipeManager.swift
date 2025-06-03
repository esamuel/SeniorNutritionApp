import Foundation

@MainActor
class RecipeManager: ObservableObject {
    static let shared = RecipeManager()
    
    @Published private(set) var recipes: [Recipe] = []
    private let storageKey = "savedRecipes"
    
    private init() {
        loadRecipes()
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes()
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        saveRecipes()
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
            saveRecipes()
        }
    }
    
    private func loadRecipes() {
        Task {
            do {
                if let data = try await PersistentStorage.shared.loadData(forKey: storageKey) as? Data,
                   let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
                    self.recipes = decoded
                }
            } catch {
                print("Error loading recipes: \(error)")
            }
        }
    }
    
    private func saveRecipes() {
        Task {
            do {
                let data = try JSONEncoder().encode(recipes)
                try await PersistentStorage.shared.saveData(data, forKey: storageKey)
            } catch {
                print("Error saving recipes: \(error)")
            }
        }
    }
}
