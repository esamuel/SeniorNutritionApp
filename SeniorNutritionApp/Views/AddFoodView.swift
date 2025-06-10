import SwiftUI

struct AddFoodView: View {
    // MARK: - Environment
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Properties
    var onSave: (FoodItem) -> Void
    
    // MARK: - State
    @State private var name = ""
    @State private var selectedCategory: FoodCategory = .fruits
    @State private var servingSize = 100.0
    @State private var servingUnit = "g"
    @State private var notes = ""
    @State private var nutritionalInfo = NutritionalInfo(calories: 0, protein: 0, carbohydrates: 0, fat: 0)
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information").font(.system(size: userSettings.textSize.size))) {
                    TextField("Food Name", text: $name)
                        .font(.system(size: userSettings.textSize.size))
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            Text(category.localizedString).tag(category)
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                    
                    HStack {
                        Text("Serving Size")
                        Spacer()
                        TextField("Size", value: $servingSize, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text(servingUnit)
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Nutritional Information").font(.system(size: userSettings.textSize.size))) {
                    Group {
                        HStack {
                            Text("Calories")
                            Spacer()
                            TextField("Calories", value: $nutritionalInfo.calories, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Protein (g)")
                            Spacer()
                            TextField("Protein", value: $nutritionalInfo.protein, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Carbs (g)")
                            Spacer()
                            TextField("Carbs", value: $nutritionalInfo.carbohydrates, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Fat (g)")
                            Spacer()
                            TextField("Fat", value: $nutritionalInfo.fat, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                
                Section(header: Text("Notes").font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: saveFood) {
                        Text("Save Food")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(name.isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle(NSLocalizedString("Add Food", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
    
    // MARK: - Actions
    private func saveFood() {
        let newFood = FoodItem(
            id: UUID(),
            name: name,
            category: selectedCategory,
            nutritionalInfo: nutritionalInfo,
            servingSize: servingSize,
            servingUnit: servingUnit,
            isCustom: true,
            notes: notes.isEmpty ? nil : notes
        )
        
        onSave(newFood)
        presentationMode.wrappedValue.dismiss()
    }
}
