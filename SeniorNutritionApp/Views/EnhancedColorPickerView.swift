import SwiftUI

struct EnhancedColorPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userSettings: UserSettings
    @Binding var selectedColor: Color
    
    // Comprehensive pharmaceutical color palette
    private let pharmaceuticalColors: [(name: String, color: Color)] = [
        ("White", Color(red: 0.98, green: 0.98, blue: 0.98)),
        ("Cream", Color(red: 0.96, green: 0.93, blue: 0.86)),
        ("Ivory", Color(red: 0.94, green: 0.94, blue: 0.88)),
        ("Beige", Color(red: 0.92, green: 0.88, blue: 0.78)),
        ("Light Yellow", Color(red: 0.99, green: 0.95, blue: 0.7)),
        ("Yellow", Color(red: 0.97, green: 0.85, blue: 0.3)),
        ("Gold", Color(red: 0.95, green: 0.75, blue: 0.1)),
        ("Light Orange", Color(red: 0.99, green: 0.8, blue: 0.6)),
        ("Orange", Color(red: 0.98, green: 0.6, blue: 0.3)),
        ("Peach", Color(red: 0.99, green: 0.75, blue: 0.65)),
        ("Light Pink", Color(red: 0.99, green: 0.85, blue: 0.9)),
        ("Pink", Color(red: 0.99, green: 0.75, blue: 0.8)),
        ("Rose", Color(red: 0.95, green: 0.65, blue: 0.7)),
        ("Light Red", Color(red: 0.99, green: 0.6, blue: 0.6)),
        ("Red", Color(red: 0.95, green: 0.3, blue: 0.25)),
        ("Dark Red", Color(red: 0.75, green: 0.2, blue: 0.15)),
        ("Lavender", Color(red: 0.85, green: 0.8, blue: 0.95)),
        ("Light Purple", Color(red: 0.8, green: 0.6, blue: 0.9)),
        ("Purple", Color(red: 0.6, green: 0.4, blue: 0.8)),
        ("Dark Purple", Color(red: 0.45, green: 0.25, blue: 0.65)),
        ("Light Blue", Color(red: 0.7, green: 0.85, blue: 0.98)),
        ("Sky Blue", Color(red: 0.5, green: 0.75, blue: 0.95)),
        ("Blue", Color(red: 0.35, green: 0.55, blue: 0.85)),
        ("Dark Blue", Color(red: 0.2, green: 0.35, blue: 0.7)),
        ("Navy", Color(red: 0.15, green: 0.25, blue: 0.55)),
        ("Teal", Color(red: 0.3, green: 0.7, blue: 0.7)),
        ("Mint", Color(red: 0.75, green: 0.95, blue: 0.8)),
        ("Light Green", Color(red: 0.7, green: 0.9, blue: 0.7)),
        ("Green", Color(red: 0.3, green: 0.75, blue: 0.4)),
        ("Dark Green", Color(red: 0.2, green: 0.55, blue: 0.25)),
        ("Tan", Color(red: 0.85, green: 0.7, blue: 0.5)),
        ("Light Brown", Color(red: 0.8, green: 0.6, blue: 0.4)),
        ("Brown", Color(red: 0.65, green: 0.45, blue: 0.25)),
        ("Dark Brown", Color(red: 0.45, green: 0.3, blue: 0.15)),
        ("Light Gray", Color(red: 0.9, green: 0.9, blue: 0.9)),
        ("Gray", Color(red: 0.75, green: 0.75, blue: 0.75)),
        ("Dark Gray", Color(red: 0.5, green: 0.5, blue: 0.5)),
        ("Charcoal", Color(red: 0.35, green: 0.35, blue: 0.35)),
        ("Black", Color(red: 0.25, green: 0.25, blue: 0.25))
    ]
    
    @State private var searchText = ""
    @State private var customColor: Color = .blue
    
    private var filteredColors: [(name: String, color: Color)] {
        if searchText.isEmpty {
            return pharmaceuticalColors
        } else {
            return pharmaceuticalColors.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Current selection preview
                    currentSelectionPreview
                    
                    // Search bar
                    searchBar
                    
                    // Color grid
                    colorGrid
                    
                    // Custom color picker section
                    customColorSection
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Select Pill Color", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Done", comment: "")) {
                        dismiss()
                    }
                    .font(.system(size: userSettings.textSize.size, weight: .semibold))
                }
            }
        }
    }
    
    private var currentSelectionPreview: some View {
        VStack(spacing: 12) {
            Text(NSLocalizedString("Current Selection", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                .foregroundColor(.secondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(height: 100)
                
                Enhanced3DPill(shape: .capsule, color: selectedColor)
                    .scaleEffect(1.3)
            }
            
            Text(colorName(for: selectedColor))
                .font(.system(size: userSettings.textSize.size))
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(NSLocalizedString("Search colors...", comment: ""), text: $searchText)
                .font(.system(size: userSettings.textSize.size))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var colorGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
            ForEach(filteredColors, id: \.name) { colorInfo in
                colorButton(color: colorInfo.color, name: colorInfo.name)
            }
        }
    }
    
    private var customColorSection: some View {
        VStack(spacing: 15) {
            Divider()
            
            Text(NSLocalizedString("Custom Color", comment: ""))
                .font(.system(size: userSettings.textSize.size, weight: .semibold))
                .foregroundColor(.secondary)
            
            ColorPicker(NSLocalizedString("Choose any color", comment: ""), selection: $customColor)
                .font(.system(size: userSettings.textSize.size))
                .onChange(of: customColor) { _, newColor in
                    selectedColor = newColor
                }
            
            Button(action: {
                selectedColor = customColor
            }) {
                HStack {
                    Circle()
                        .fill(customColor)
                        .frame(width: 24, height: 24)
                    
                    Text(NSLocalizedString("Use Custom Color", comment: ""))
                        .font(.system(size: userSettings.textSize.size))
                }
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(20)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    private func colorButton(color: Color, name: String) -> some View {
        Button(action: {
            selectedColor = color
        }) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                    
                    if selectedColor.toHexString() == color.toHexString() {
                        Circle()
                            .strokeBorder(Color.blue, lineWidth: 3)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(color.isBright() ? .black : .white)
                    }
                }
                
                Text(name)
                    .font(.system(size: userSettings.textSize.size - 4))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(height: 28)
            }
        }
    }
    
    private func colorName(for color: Color) -> String {
        let colorHex = color.toHexString()
        
        for colorInfo in pharmaceuticalColors {
            if colorInfo.color.toHexString() == colorHex {
                return colorInfo.name
            }
        }
        
        return NSLocalizedString("Custom Color", comment: "")
    }
}


struct EnhancedColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedColorPickerView(selectedColor: .constant(.blue))
            .environmentObject(UserSettings())
    }
}