import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ColorPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedColor: Color
    
    // Predefined color options for pills
    private let colorOptions: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink,
        .gray, .brown, .black, .white,
        Color(red: 0.9, green: 0.9, blue: 0.9), // Light gray
        Color(red: 0.8, green: 0.6, blue: 0.4), // Beige/tan
        Color(red: 0.0, green: 0.5, blue: 0.5), // Teal
        Color(red: 0.5, green: 0.0, blue: 0.5), // Dark purple
        Color(red: 0.8, green: 0.2, blue: 0.2)  // Dark red
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Select Pill Color")
                        .font(.headline)
                        .padding(.top)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 15) {
                        ForEach(0..<colorOptions.count, id: \.self) { index in
                            colorButton(color: colorOptions[index])
                        }
                    }
                    .padding()
                    
                    // Custom color picker
                    ColorPicker("Custom Color", selection: $selectedColor)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                }
            }
            .navigationBarTitle("Pill Color", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private func colorButton(color: Color) -> some View {
        Button {
            selectedColor = color
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .overlay(
                    selectedColor.toHexString() == color.toHexString() ?
                    Image(systemName: "checkmark")
                        .foregroundColor(color.isBright() ? .black : .white)
                    : nil
                )
        }
    }
}


struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.blue))
    }
}
