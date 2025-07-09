import SwiftUI

/// This view is used solely for testing/triggering the translation of all food items
struct TranslateAllFoodsView: View {
    @StateObject private var foodDatabase = FoodDatabaseService()
    @State private var isTranslating = false
    @State private var message = "Press button to translate all foods"
    @State private var isShowingLanguageSelector = false
    @State private var selectedLanguage = "Current"
    @State private var progress = 0.0
    @State private var translatedCount = 0
    @State private var totalFoodCount = 0
    @State private var showingProgressDetails = false
    
    let languages = ["Current", "English", "French", "Spanish", "Hebrew"]
    let languageCodes = ["", "en", "fr", "es", "he"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Food Translation Utility")
                .font(.title)
                .padding()
            
            Text(message)
                .padding()
                .multilineTextAlignment(.center)
            
            // Language selector for testing
            VStack {
                Text("Test translation in:")
                    .fontWeight(.bold)
                
                HStack(spacing: 15) {
                    ForEach(Array(zip(languages, languageCodes).enumerated()), id: \.offset) { index, language in
                        Button(action: {
                            selectedLanguage = language.0
                            if !language.1.isEmpty {
                                LanguageManager.shared.setLanguage(language.1)
                            }
                        }) {
                            VStack(spacing: 5) {
                                Text(getFlagEmoji(for: language.1))
                                    .font(.title2)
                                Text(language.0)
                                    .font(.caption)
                                    .foregroundColor(selectedLanguage == language.0 ? .blue : .primary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(selectedLanguage == language.0 ? Color.blue.opacity(0.1) : Color.clear)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.bottom)
            }
            
            if isTranslating {
                VStack(spacing: 10) {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 10)
                        .padding(.horizontal)
                    
                    Text("\(translatedCount) of \(totalFoodCount) foods translated")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ProgressView()
                        .padding()
                    
                    Text("This may take a few minutes...")
                        .foregroundColor(.secondary)
                }
            } else {
                Button(action: {
                    translateAllFoods()
                }) {
                    Text("Translate ALL Foods")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    translateVisibleFoods()
                }) {
                    Text("Translate Visible Foods")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    testSpecificTranslations()
                }) {
                    Text("Translate Common Foods")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    fixNotesTranslations()
                }) {
                    Text("Fix Notes Translations")
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            if showingProgressDetails {
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Translation Progress Details:")
                            .font(.headline)
                            .padding(.top)
                        
                        Text("Successfully translated \(translatedCount) food items.")
                            .padding(.vertical, 2)
                        
                        Text("Food translations are stored in your device and will be available in all languages.")
                            .padding(.vertical, 2)
                        
                        Text("Any new foods you add will be automatically translated.")
                            .padding(.vertical, 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .frame(height: 150)
            }
            
            Spacer()
            
            // Debug information
            VStack(alignment: .leading, spacing: 5) {
                Text("Debug Information:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                Text("Current language: \(LanguageManager.shared.currentLanguage)")
                    .font(.caption)
                
                if let food = foodDatabase.foodItems.first(where: { $0.name == "Almond Flour Torte" }) {
                    Text("Sample translations for 'Almond Flour Torte':")
                        .font(.caption)
                    Text("French: \(food.nameFr ?? "not set")")
                        .font(.caption)
                    Text("Spanish: \(food.nameEs ?? "not set")")
                        .font(.caption)
                    Text("Hebrew: \(food.nameHe ?? "not set")")
                        .font(.caption)
                    
                    if let notes = food.notes {
                        Text("Original notes: \(notes)")
                            .font(.caption)
                        Text("Notes FR: \(food.notesFr ?? "not set")")
                            .font(.caption)
                        Text("Notes ES: \(food.notesEs ?? "not set")")
                            .font(.caption)
                        Text("Notes HE: \(food.notesHe ?? "not set")")
                            .font(.caption)
                        Text("localizedNotes(): \(food.localizedNotes() ?? "nil")")
                            .font(.caption)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
        }
        .padding()
        .onAppear {
            // Load the food database
            foodDatabase.loadFoodDatabase()
            
            // Count total foods
            totalFoodCount = foodDatabase.foodItems.count
        }
    }
    
    private func translateAllFoods() {
        isTranslating = true
        message = "Translating ALL foods in the database...\nThis may take several minutes"
        progress = 0.0
        translatedCount = 0
        showingProgressDetails = false
        
        // Start the comprehensive translation process
        Task {
            // Get initial count
            let startCount = foodDatabase.foodItems.count
            totalFoodCount = startCount
            
            // Start translation process
            let count = await foodDatabase.translateAllFoodItems()
            
            // Update UI
            DispatchQueue.main.async {
                isTranslating = false
                translatedCount = count
                progress = 1.0
                message = "Translation complete!\n\nAll \(count) food items have been translated to French, Spanish, and Hebrew."
                showingProgressDetails = true
            }
        }
    }
    
    private func translateVisibleFoods() {
        isTranslating = true
        message = "Translating visible foods...\nThis may take a moment"
        progress = 0.0
        showingProgressDetails = false
        
        Task {
            // Use the dedicated method for visible foods
            await foodDatabase.forceTranslateVisibleFoods()
            
            // Update UI
            DispatchQueue.main.async {
                isTranslating = false
                progress = 1.0
                message = "All visible foods have been translated to Hebrew, French, and Spanish!"
                showingProgressDetails = true
            }
        }
    }
    
    private func testSpecificTranslations() {
        isTranslating = true
        message = "Translating common food items...\nThis may take a minute"
        progress = 0.0
        showingProgressDetails = false
        
        Task {
            await foodDatabase.translateSpecificFoodItems()
            
            // Return to main thread
            DispatchQueue.main.async {
                isTranslating = false
                progress = 1.0
                message = "Common food items have been translated!\n\nItems like Salmon, BLT Sandwich, etc. now have translations in French, Spanish, and Hebrew."
                showingProgressDetails = true
            }
        }
    }
    
    private func fixNotesTranslations() {
        isTranslating = true
        message = "Fixing notes translations...\nThis may take a minute"
        progress = 0.0
        showingProgressDetails = false
        
        Task {
            await foodDatabase.fixNotesTranslations()
            
            // Return to main thread
            DispatchQueue.main.async {
                isTranslating = false
                progress = 1.0
                message = "Notes translations have been fixed!"
                showingProgressDetails = true
            }
        }
    }
    
    // Helper function to get flag emoji for language code
    private func getFlagEmoji(for code: String) -> String {
        switch code {
        case "en":
            return "🇺🇸"
        case "he":
            return "🇮🇱"
        case "es":
            return "🇪🇸"
        case "fr":
            return "🇫🇷"
        default:
            return "🏳️"
        }
    }
}

// Preview provider
struct TranslateAllFoodsView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateAllFoodsView()
    }
} 