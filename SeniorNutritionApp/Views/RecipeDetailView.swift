import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var recipeManager = RecipeManager.shared
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isEditing = false
    @State private var showingDeleteConfirmation = false
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recipe Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.system(size: userSettings.textSize.size + 6, weight: .bold))
                    
                    Text("\(recipe.ingredients.count) ingredients • \(recipe.servings) servings")
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                }
                
                // Nutritional Information
                nutritionalInfoCard
                
                // Ingredients
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingredients")
                        .font(.system(size: userSettings.textSize.size + 2, weight: .semibold))
                    
                    ForEach(recipe.ingredients) { ingredient in
                        HStack {
                            Text("•")
                            Text("\(ingredient.food.name)")
                            Spacer()
                            Text("\(String(format: "%.1f", ingredient.quantity))\(ingredient.unit)")
                                .foregroundColor(.secondary)
                        }
                        .font(.system(size: userSettings.textSize.size))
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Notes
                if let notes = recipe.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .semibold))
                        Text(notes)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        isEditing = true
                    }) {
                        Label("Edit Recipe", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        showingDeleteConfirmation = true
                    }) {
                        Label("Delete Recipe", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            RecipeBuilderView(existingRecipe: recipe) { updatedRecipe in
                recipeManager.updateRecipe(updatedRecipe)
            }
        }
        .alert("Delete Recipe", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                recipeManager.deleteRecipe(recipe)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this recipe? This action cannot be undone.")
        }
    }
    
    private var nutritionalInfoCard: some View {
        VStack(spacing: 16) {
            Text("Nutrition Per Serving")
                .font(.system(size: userSettings.textSize.size + 2, weight: .semibold))
            
            HStack(spacing: 20) {
                NutrientBox(
                    label: "Calories",
                    value: Int(recipe.totalNutritionalInfo.calories / Double(recipe.servings)),
                    unit: ""
                )
                
                NutrientBox(
                    label: "Protein",
                    value: Int(recipe.totalNutritionalInfo.protein / Double(recipe.servings)),
                    unit: "g"
                )
                
                NutrientBox(
                    label: "Carbs",
                    value: Int(recipe.totalNutritionalInfo.carbohydrates / Double(recipe.servings)),
                    unit: "g"
                )
                
                NutrientBox(
                    label: "Fat",
                    value: Int(recipe.totalNutritionalInfo.fat / Double(recipe.servings)),
                    unit: "g"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct NutrientBox: View {
    @EnvironmentObject private var userSettings: UserSettings
    let label: String
    let value: Int
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
            
            Text("\(value)\(unit)")
                .font(.system(size: userSettings.textSize.size, weight: .semibold))
        }
    }
}
