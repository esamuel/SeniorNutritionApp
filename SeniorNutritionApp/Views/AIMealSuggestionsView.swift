import SwiftUI

struct AIMealSuggestionsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var aiService = AIMealSuggestionService.shared
    
    @State private var selectedMealType: MealType = .breakfast
    @State private var showingUpgradeSheet = false
    @State private var selectedSuggestion: MealSuggestion?
    @State private var showingMealDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Premium Feature Header
                if !premiumManager.hasFullAccess {
                    premiumHeader
                }
                
                if premiumManager.hasFullAccess {
                    VStack(spacing: 0) {
                        // Meal Type Selector
                        mealTypeSelector
                        
                        // Content
                        if aiService.isGenerating {
                            loadingView
                        } else {
                            suggestionsContent
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .navigationTitle("AI Meal Suggestions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .onAppear {
                if premiumManager.hasFullAccess {
                    generateSuggestions()
                }
            }
            .sheet(isPresented: $showingUpgradeSheet) {
                PremiumFeaturesView()
            }
            .sheet(isPresented: $showingMealDetail) {
                if let suggestion = selectedSuggestion {
                    MealDetailView(suggestion: suggestion)
                }
            }
        }
    }
    
    private var premiumHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.purple)
                    .font(.title2)
                
                Text("Premium Feature")
                    .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                    .foregroundColor(.purple)
            }
            
            VStack(spacing: 8) {
                Text("AI-Driven Meal Suggestions")
                    .font(.system(size: userSettings.textSize.size + 4, weight: .bold))
                
                Text("Get personalized meal recommendations based on your health profile, dietary restrictions, and nutritional goals")
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 4) {
                    FeatureBullet(text: "Personalized based on your health conditions")
                    FeatureBullet(text: "Adapted to your dietary restrictions")
                    FeatureBullet(text: "Optimized for senior nutrition needs")
                    FeatureBullet(text: "Updated daily with new suggestions")
                }
            }
            
            Button(action: {
                showingUpgradeSheet = true
            }) {
                Text("Upgrade to Premium")
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
    }
    
    private var mealTypeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    MealTypeCard(
                        mealType: mealType,
                        isSelected: selectedMealType == mealType,
                        onSelect: {
                            selectedMealType = mealType
                            generateSuggestions()
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Generating personalized meal suggestions...")
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
            
            Text("Analyzing your profile, health goals, and dietary preferences")
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private var suggestionsContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                let filteredSuggestions = aiService.suggestedMeals.filter { $0.mealType == selectedMealType }
                
                if filteredSuggestions.isEmpty {
                    EmptyStateView(mealType: selectedMealType)
                } else {
                    ForEach(filteredSuggestions) { suggestion in
                        MealSuggestionCard(
                            suggestion: suggestion,
                            onTap: {
                                selectedSuggestion = suggestion
                                showingMealDetail = true
                            }
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    private func generateSuggestions() {
        aiService.generateMealSuggestions(
            for: userSettings.userProfile,
            healthGoals: userSettings.userHealthGoals,
            dietaryRestrictions: userSettings.userDietaryRestrictions
        )
    }
}

struct FeatureBullet: View {
    @EnvironmentObject private var userSettings: UserSettings
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: userSettings.textSize.size - 2))
            
            Text(text)
                .font(.system(size: userSettings.textSize.size - 2))
                .foregroundColor(.secondary)
        }
    }
}

struct MealTypeCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let mealType: MealType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Image(systemName: mealType.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : mealType.color)
                
                Text(mealType.displayName)
                    .font(.system(size: userSettings.textSize.size - 2, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? mealType.color : Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(mealType.color, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct MealSuggestionCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let suggestion: MealSuggestion
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(suggestion.name)
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        if let reason = suggestion.personalizedReason {
                            Text(reason)
                                .font(.system(size: userSettings.textSize.size - 2))
                                .foregroundColor(suggestion.mealType.color)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(suggestion.mealType.color.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(suggestion.estimatedCalories) cal")
                            .font(.system(size: userSettings.textSize.size, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("\(suggestion.prepTime) min")
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Description
                Text(suggestion.description)
                    .font(.system(size: userSettings.textSize.size))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                // Benefits
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(suggestion.benefits.prefix(3)), id: \.self) { benefit in
                            Text(benefit)
                                .font(.system(size: userSettings.textSize.size - 3))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.1))
                                .foregroundColor(.green)
                                .cornerRadius(6)
                        }
                    }
                }
                
                // Health indicators
                HStack(spacing: 16) {
                    if suggestion.isHeartHealthy {
                        HealthIndicator(icon: "heart.fill", label: "Heart Healthy", color: .red)
                    }
                    if suggestion.isLowGlycemic {
                        HealthIndicator(icon: "drop.fill", label: "Low Glycemic", color: .blue)
                    }
                    if suggestion.isLowCalorie {
                        HealthIndicator(icon: "leaf.fill", label: "Low Calorie", color: .green)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct HealthIndicator: View {
    @EnvironmentObject private var userSettings: UserSettings
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: userSettings.textSize.size - 4))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: userSettings.textSize.size - 4))
                .foregroundColor(color)
        }
    }
}

struct EmptyStateView: View {
    @EnvironmentObject private var userSettings: UserSettings
    let mealType: MealType
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: mealType.icon)
                .font(.system(size: 48))
                .foregroundColor(mealType.color)
            
            Text("No suggestions for \(mealType.displayName.lowercased())")
                .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
            
            Text("Try adjusting your dietary restrictions or check back later for new suggestions")
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct MealDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    let suggestion: MealSuggestion
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(suggestion.name)
                            .font(.system(size: userSettings.textSize.size + 6, weight: .bold))
                        
                        HStack {
                            Text("\(suggestion.estimatedCalories) calories")
                                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                                .foregroundColor(suggestion.mealType.color)
                            
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text("\(suggestion.prepTime) minutes")
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(.secondary)
                        }
                        
                        if let reason = suggestion.personalizedReason {
                            Text(reason)
                                .font(.system(size: userSettings.textSize.size))
                                .foregroundColor(suggestion.mealType.color)
                                .padding()
                                .background(suggestion.mealType.color.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        Text(suggestion.description)
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.secondary)
                    }
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        ForEach(suggestion.ingredients, id: \.self) { ingredient in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 4))
                                    .foregroundColor(.secondary)
                                
                                Text(ingredient)
                                    .font(.system(size: userSettings.textSize.size))
                            }
                        }
                    }
                    
                    // Health Benefits
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Health Benefits")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        ForEach(suggestion.benefits, id: \.self) { benefit in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                
                                Text(benefit)
                                    .font(.system(size: userSettings.textSize.size))
                            }
                        }
                    }
                    
                    // Health Indicators
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nutritional Profile")
                            .font(.system(size: userSettings.textSize.size + 2, weight: .bold))
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            if suggestion.isHeartHealthy {
                                NutritionCard(icon: "heart.fill", title: "Heart Healthy", color: .red)
                            }
                            if suggestion.isLowGlycemic {
                                NutritionCard(icon: "drop.fill", title: "Low Glycemic", color: .blue)
                            }
                            if suggestion.isLowCalorie {
                                NutritionCard(icon: "leaf.fill", title: "Low Calorie", color: .green)
                            }
                            if suggestion.isLowSodium {
                                NutritionCard(icon: "minus.circle.fill", title: "Low Sodium", color: .orange)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(suggestion.mealType.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
}

struct NutritionCard: View {
    @EnvironmentObject private var userSettings: UserSettings
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.system(size: userSettings.textSize.size - 1))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    AIMealSuggestionsView()
        .environmentObject(UserSettings())
}