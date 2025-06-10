import SwiftUI

struct IngredientQuantityView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Binding var ingredient: RecipeIngredient
    
    @State private var quantity: String
    @State private var selectedUnit: String
    @State private var showingUnitPicker = false
    
    init(ingredient: Binding<RecipeIngredient>) {
        self._ingredient = ingredient
        self._quantity = State(initialValue: String(format: "%.1f", ingredient.wrappedValue.quantity))
        self._selectedUnit = State(initialValue: ingredient.wrappedValue.unit)
    }
    
    var body: some View {
        HStack {
            Text(ingredient.food.name)
                .font(.system(size: userSettings.textSize.size))
            
            Spacer()
            
            TextField("Qty", text: $quantity)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 60)
                .font(.system(size: userSettings.textSize.size))
                .onChange(of: quantity) { newValue in
                    if let value = Double(newValue) {
                        updateQuantity(value)
                    }
                }
            
            Button(action: {
                showingUnitPicker = true
            }) {
                Text(selectedUnit)
                    .font(.system(size: userSettings.textSize.size))
            }
            .sheet(isPresented: $showingUnitPicker) {
                UnitPickerView(
                    selectedUnit: $selectedUnit,
                    suggestedUnits: UnitConverter.suggestedUnitsFor(foodCategory: ingredient.food.category ?? .other)
                ) { newUnit in
                    updateUnit(newUnit)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func updateQuantity(_ value: Double) {
        ingredient.quantity = value
    }
    
    private func updateUnit(_ newUnit: String) {
        if newUnit != ingredient.unit {
            // Convert the quantity to the new unit
            let baseValue = UnitConverter.toBaseUnit(ingredient.quantity, from: ingredient.unit)
            let newValue = UnitConverter.fromBaseUnit(baseValue, to: newUnit)
            
            ingredient.quantity = newValue
            ingredient.unit = newUnit
            quantity = String(format: "%.1f", newValue)
        }
    }
}

struct UnitPickerView: View {
    @EnvironmentObject private var userSettings: UserSettings
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedUnit: String
    let suggestedUnits: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Suggested Units").font(.system(size: userSettings.textSize.size))) {
                    ForEach(suggestedUnits, id: \.self) { unit in
                        Button(action: {
                            onSelect(unit)
                            selectedUnit = unit
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(unit)
                                    .font(.system(size: userSettings.textSize.size))
                                Spacer()
                                if unit == selectedUnit {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Unit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
            }
        }
    }
}
