#if canImport(UIKit)
import UIKit
#endif

import SwiftUI

struct NutritionView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject private var mealManager: MealManager
    @EnvironmentObject private var userCommonMeals: UserCommonMeals
    @State private var showingAddMeal = false
    @State private var selectedMealType: MealType = .breakfast
    @State private var selectedTab = 0
    @State private var mealToEdit: Meal?
    @State private var showingDeleteAlert = false
    @State private var mealToDelete: Meal?
    @State private var showingCommonMealAdded = false
    @State private var commonMealAddedName = ""
    @State private var showingPersonalizedTips = false
    @State private var showingFoodDatabase = false
    @State private var showingCommonMealDeleteAlert = false
    @State private var commonMealToDelete: Meal?
    @State private var showingNutritionGoals = false

    var body: some View {
        NavigationView {
            VStack {
                Picker(NSLocalizedString("View", comment: ""), selection: $selectedTab) {
                    Text(NSLocalizedString("Dashboard", comment: "")).tag(0)
                    Text(NSLocalizedString("Meals", comment: "")).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    NutritionalDashboardView(mealManager: mealManager)
                } else {
                    mealsView
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("Nutrition", comment: ""))
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .multilineTextAlignment(.center)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: { showingNutritionGoals = true }) {
                            Image(systemName: "target")
                        }
                        Button(action: { showingAddMeal = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView(selectedMealType: $selectedMealType) { newMeal in
                    print("DEBUG: AddMealView closure called with meal: \(newMeal.name) at \(newMeal.time)")
                    mealManager.addMeal(newMeal)
                    
                    // Force reload and verify meals
                    print("DEBUG: Reloading meals after adding...")
                    mealManager.loadMeals()
                    
                    let todayMeals = mealManager.mealsForDate(Date())
                    print("DEBUG: After adding, today's meals: \(todayMeals.count)")
                    for meal in todayMeals {
                        print("DEBUG: - \(meal.name) at \(meal.time)")
                    }
                }
            }
            .sheet(item: $mealToEdit) { meal in
                EditMealView(meal: meal) { updatedMeal in
                    mealManager.updateMeal(updatedMeal)
                    mealManager.loadMeals()
                    if let index = userCommonMeals.userMeals.firstIndex(where: { $0.id == updatedMeal.id }) {
                        userCommonMeals.userMeals[index] = updatedMeal
                    }
                }
            }
            .alert("Delete Meal", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let meal = mealToDelete {
                        print("DEBUG: Deleting meal: \(meal.name) at \(meal.time)")
                        mealManager.removeMeal(meal)
                        
                        // Force reload and verify meals
                        print("DEBUG: Reloading meals after deletion...")
                        mealManager.loadMeals()
                        
                        let todayMeals = mealManager.mealsForDate(Date()) 
                        print("DEBUG: After deletion, today's meals: \(todayMeals.count)")
                        for meal in todayMeals {
                            print("DEBUG: - \(meal.name) at \(meal.time)")
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this meal?")
            }
            .alert(NSLocalizedString("Delete Common Meal", comment: ""), isPresented: $showingCommonMealDeleteAlert) {
                Button(NSLocalizedString("Delete", comment: ""), role: .destructive) {
                    if let meal = commonMealToDelete {
                        userCommonMeals.removeCommonMeal(meal)
                    }
                }
                Button(NSLocalizedString("Cancel", comment: ""), role: .cancel) {}
            } message: {
                Text(NSLocalizedString("Are you sure you want to remove this meal from your common meals? This action cannot be undone.", comment: ""))
            }
            .alert("Added to Common Meals", isPresented: $showingCommonMealAdded) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("\(commonMealAddedName) has been added to your common meals.")
            }
            .sheet(isPresented: $showingPersonalizedTips) {
                PersonalizedNutritionTipsView()
                    .environmentObject(userSettings)
            }
            .sheet(isPresented: $showingFoodDatabase) {
                FoodDatabaseBrowserView()
                    .environmentObject(userSettings)
            }
            .onAppear {
                print("DEBUG: NutritionView appeared - reloading meals")
                mealManager.loadMeals()
                
                let todayMeals = mealManager.mealsForDate(Date())
                print("DEBUG: Today's meals count: \(todayMeals.count)")
                if todayMeals.isEmpty {
                    print("DEBUG: Warning: No meals found for today!")
                } else {
                    print("DEBUG: Today's meals:")
                    for meal in todayMeals {
                        print("DEBUG: - \(meal.name) at \(meal.time)")
                    }
                }
                
                print("DEBUG: Total meals in manager: \(mealManager.meals.count)")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var mealsView: some View {
        ScrollView {
            VStack(spacing: 25) {
                nutritionGoalsSection
                todayMealsSection
                commonMealsSection
                nutritionTipsSection
                foodDatabaseSection
            }
            .padding()
        }
    }

    private var nutritionGoalsSection: some View {
        Button(action: { showingNutritionGoals = true }) {
            HStack {
                Image(systemName: "target")
                    .font(.system(size: 28))
                    .foregroundColor(.purple)
                    .padding(.trailing, 8)
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("nutrition_goals_title", comment: ""))
                        .font(.system(size: userSettings.textSize.size, weight: .bold))
                        .foregroundColor(.primary)
                    Text(NSLocalizedString("set_calorie_goal", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .shadow(radius: 1)
        }
        .sheet(isPresented: $showingNutritionGoals) {
            NutritionGoalsView()
                .environmentObject(userSettings)
        }
    }

    private var todayMealsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(NSLocalizedString("Today's Meals", comment: ""))
                    .font(.system(size: userSettings.textSize.size, weight: .bold))
                Spacer()
                Button(action: { showingAddMeal = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text(NSLocalizedString("Add", comment: ""))
                            .font(.system(size: userSettings.textSize.size - 2))
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            if mealManager.mealsForDate(Date()).isEmpty {
                emptyMealsView
            } else {
                todayMealsListView
            }
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }

    private var todayMealsListView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(mealManager.mealsForDate(Date()), id: \.id) { meal in
                    mealRow(meal: meal)
                        .contextMenu {
                            Button {
                                mealToEdit = meal
                            } label: {
                                Label(NSLocalizedString("Edit Meal", comment: ""), systemImage: "pencil")
                            }
                            
                            Button {
                                userCommonMeals.addCommonMeal(meal)
                                commonMealAddedName = meal.localizedName()
                                showingCommonMealAdded = true
                            } label: {
                                Label(NSLocalizedString("Add to Common Meals", comment: ""), systemImage: "star")
                            }
                            
                            Button(role: .destructive) {
                                mealToDelete = meal
                                showingDeleteAlert = true
                            } label: {
                                Label(NSLocalizedString("Delete Meal", comment: ""), systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyMealsView: some View {
        VStack(spacing: 10) {
            Image(systemName: "fork.knife")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            Text(NSLocalizedString("No meals logged today", comment: ""))
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button(action: { showingAddMeal = true }) {
                Text(NSLocalizedString("Add First Meal", comment: ""))
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 10)
        }
        .padding()
    }

    private func mealRow(meal: Meal) -> some View {
        HStack(spacing: 15) {
            Image(systemName: meal.type.icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(meal.type.color)
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 5) {
                Text(meal.localizedName())
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.primary)
                HStack {
                    Text(meal.type.rawValue)
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                    Text("•")
                        .foregroundColor(.secondary)
                    Text(timeFormatter.string(from: meal.time))
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(meal.adjustedNutritionalInfo.calories))")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.primary)
                Text(NSLocalizedString("calories", comment: ""))
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onTapGesture {
            mealToEdit = meal
        }
    }

    private var commonMealsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Common Meals", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(userCommonMeals.userMeals) { meal in
                        commonMealCard(meal: meal)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }

    private func commonMealCard(meal: Meal) -> some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                var newMeal = meal
                let calendar = Calendar.current
                let now = Date()
                var components = calendar.dateComponents([.year, .month, .day], from: now)
                components.hour = 12
                components.minute = 0
                components.second = 0
                newMeal.time = calendar.date(from: components) ?? now
                mealManager.addMeal(newMeal)
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: meal.type.icon)
                        .font(.system(size: 30))
                        .foregroundColor(meal.type.color)
                        .frame(width: 50, height: 50)
                        .background(meal.type.color.opacity(0.2))
                        .cornerRadius(10)
                    Text(meal.localizedName())
                        .font(.system(size: userSettings.textSize.size))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Text("\(Int(meal.adjustedNutritionalInfo.calories)) calories")
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.secondary)
                    Text(NSLocalizedString("Tap to add", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 4))
                        .foregroundColor(.blue)
                }
                .frame(width: 140, height: 170)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
            }
            
            // Delete button outside the main button to avoid event conflicts
            Button(action: {
                commonMealToDelete = meal
                showingCommonMealDeleteAlert = true
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.red)
                    .background(Color.white.clipShape(Circle()))
            }
            .padding(10)
            .accessibilityLabel(NSLocalizedString("Delete common meal", comment: ""))
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                commonMealToDelete = meal
                showingCommonMealDeleteAlert = true
            } label: {
                Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
            }
            Button {
                mealToEdit = meal
            } label: {
                Label(NSLocalizedString("Edit", comment: ""), systemImage: "pencil")
            }
            .tint(.blue)
        }
    }

    private var nutritionTipsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Nutrition Tips for Seniors", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            nutritionTip(
                icon: "leaf.fill",
                title: NSLocalizedString("Protein is Important", comment: ""),
                description: NSLocalizedString("Try to include protein with every meal to maintain muscle mass.", comment: "")
            )
            nutritionTip(
                icon: "drop.fill",
                title: NSLocalizedString("Stay Hydrated", comment: ""),
                description: NSLocalizedString("Drink water regularly, even when not fasting.", comment: "")
            )
            nutritionTip(
                icon: "heart.fill",
                title: NSLocalizedString("Healthy Fats", comment: ""),
                description: NSLocalizedString("Include sources of healthy fats like olive oil, avocados, and nuts.", comment: "")
            )
            Button(action: {
                showingPersonalizedTips = true
            }) {
                Text(NSLocalizedString("View More Tips", comment: ""))
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }

    private func nutritionTip(icon: String, title: String, description: String) -> some View {
        TipRowView(icon: icon, title: title, description: description, textSize: userSettings.textSize.size, iconColor: .green)
    }

    private var foodDatabaseSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(NSLocalizedString("Food Database", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .bold))
            
            HStack(spacing: 15) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(NSLocalizedString("Browse All Food Items", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                    
                    Text(NSLocalizedString("View detailed nutrition information for all foods, including pasta dishes and more", comment: ""))
                        .font(.system(size: userSettings.textSize.size - 2))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .onTapGesture {
                showingFoodDatabase = true
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}