import SwiftUI
import Foundation

struct AddMealView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var foodDatabase = FoodDatabaseService()
    
    @Binding var selectedMealType: MealType
    @State private var mealName: String = ""
    @State private var mealTime = Date()
    @State private var showingVoiceInput = false
    @State private var mealPortion: MealPortion = .medium
    @State private var nutritionalInfo = NutritionalInfo()
    @State private var notes: String = ""
    
    // Food search states
    @State private var searchText = ""
    @State private var selectedFood: FoodItem?
    @State private var showingFoodSearch = false
    
    var onSave: (Meal) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details").font(.system(size: userSettings.textSize.size))) {
                    HStack {
                        Text("Meal Type")
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        Picker("", selection: $selectedMealType) {
                            ForEach(MealType.allCases) { type in
                                HStack {
                                    Image(systemName: type.icon)
                                    Text(type.rawValue)
                                }
                                .tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.system(size: userSettings.textSize.size))
                    }
                    
                    HStack {
                        Text("Name")
                            .font(.system(size: userSettings.textSize.size))
                        
                        TextField("Meal name", text: $mealName)
                            .font(.system(size: userSettings.textSize.size))
                        
                        Button(action: {
                            showingVoiceInput = true
                        }) {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        Text("Time")
                            .font(.system(size: userSettings.textSize.size))
                        
                        Spacer()
                        
                        DatePicker("", selection: $mealTime, displayedComponents: .hourAndMinute)
                            .font(.system(size: userSettings.textSize.size))
                    }
                }
                
                Section(header: Text("Food Selection").font(.system(size: userSettings.textSize.size))) {
                    Button(action: {
                        showingFoodSearch = true
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text(selectedFood == nil ? "Search Food Database" : "Change Food")
                            Spacer()
                            if selectedFood != nil {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    if let food = selectedFood {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(food.name)
                                .font(.system(size: userSettings.textSize.size, weight: .medium))
                            
                            HStack {
                                Text("\(Int(food.nutritionalInfo.calories)) cal")
                                Text("•")
                                Text("\(Int(food.nutritionalInfo.protein))g protein")
                                Text("•")
                                Text("\(Int(food.nutritionalInfo.carbohydrates))g carbs")
                                Text("•")
                                Text("\(Int(food.nutritionalInfo.fat))g fat")
                            }
                            .font(.system(size: userSettings.textSize.size - 2))
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Portion Size").font(.system(size: userSettings.textSize.size))) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Portion Size")
                            .font(.system(size: userSettings.textSize.size))
                        
                        HStack(spacing: 15) {
                            ForEach(MealPortion.allCases) { size in
                                portionSizeButton(size)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                if selectedFood == nil {
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
                }
                
                Section(header: Text("Notes").font(.system(size: userSettings.textSize.size))) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .font(.system(size: userSettings.textSize.size))
                }
                
                Section {
                    Button(action: saveMeal) {
                        Text("Save Meal")
                            .font(.system(size: userSettings.textSize.size))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(mealName.isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
            .sheet(isPresented: $showingFoodSearch) {
                FoodSearchView(foodDatabase: foodDatabase, selectedFood: $selectedFood)
            }
            .onChange(of: selectedFood) { oldValue, newValue in
                if let food = newValue {
                    mealName = food.name
                    nutritionalInfo = food.nutritionalInfo
                }
            }
            .onAppear {
                foodDatabase.loadFoodDatabase()
            }
        }
    }
    
    // Helper for portion size buttons
    private func portionSizeButton(_ size: MealPortion) -> some View {
        Button(action: {
            withAnimation {
                mealPortion = size
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(mealPortion == size ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: size == .small ? 40 : (size == .medium ? 55 : 70),
                               height: size == .small ? 40 : (size == .medium ? 55 : 70))
                    
                    if mealPortion == size {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 15, height: 15)
                    }
                }
                
                Text(size.rawValue)
                    .font(.system(size: userSettings.textSize.size - 2))
                    .foregroundColor(mealPortion == size ? .blue : .primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Save meal
    private func saveMeal() {
        let newMeal = Meal(
            name: mealName,
            type: selectedMealType,
            time: mealTime,
            portion: mealPortion,
            nutritionalInfo: nutritionalInfo,
            notes: notes.isEmpty ? nil : notes
        )
        
        onSave(newMeal)
        presentationMode.wrappedValue.dismiss()
    }
} 