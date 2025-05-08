import SwiftUI

struct PillShapeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var userSettings: UserSettings
    @Binding var selectedShape: PillShape
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Select Pill Shape")
                        .font(.headline)
                        .padding(.top)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 15) {
                        ForEach(PillShape.allCases) { shape in
                            shapeButton(shape: shape)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Pill Shape", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
        }
    }
    
    private func shapeButton(shape: PillShape) -> some View {
        Button {
            selectedShape = shape
        } label: {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                        .frame(height: 80)
                        .shadow(radius: 1)
                        .overlay(
                            Group {
                                switch shape {
                                case .round:
                                    Pill3DView(shape: .round, color: getPillColor(isSelected: selectedShape == shape))
                                        .frame(width: 60, height: 60)
                                case .oval:
                                    Pill3DView(shape: .oval, color: getPillColor(isSelected: selectedShape == shape))
                                        .frame(width: 70, height: 40)
                                case .capsule:
                                    Pill3DView(shape: .capsule, color: getPillColor(isSelected: selectedShape == shape))
                                        .frame(width: 80, height: 30)
                                case .rectangle:
                                    Pill3DView(shape: .rectangle, color: getPillColor(isSelected: selectedShape == shape))
                                        .frame(width: 70, height: 40)
                                case .diamond:
                                    Pill3DView(shape: .diamond, color: getPillColor(isSelected: selectedShape == shape))
                                        .frame(width: 40, height: 40)
                                case .triangle:
                                    Pill3DView(shape: .triangle, color: getPillColor(isSelected: selectedShape == shape))
                                        .frame(width: 40, height: 40)
                                case .other:
                                    Text("?")
                                        .font(.system(size: 40))
                                        .foregroundColor(getPillColor(isSelected: selectedShape == shape))
                                }
                            }
                        )
                    
                    if selectedShape == shape {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                            .position(x: 80, y: 15)
                            .accessibility(label: Text("Selected"))
                    }
                }
                
                Text(shape.rawValue)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(shape.rawValue) pill shape"))
        .accessibilityAddTraits(selectedShape == shape ? [.isSelected] : [])
    }
    
    // Helper function to determine appropriate colors based on settings
    private func getPillColor(isSelected: Bool) -> Color {
        if userSettings.highContrastMode {
            // High contrast mode colors
            return isSelected ? .white : .black
        } else {
            // Regular colors with dark mode support
            if isSelected {
                return .blue
            } else {
                return colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3)
            }
        }
    }
} 